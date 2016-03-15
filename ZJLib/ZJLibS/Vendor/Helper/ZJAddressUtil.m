//
//  ZJAddressUtil.m
//  MyClass3
//
//  Created by 朱佳伟 on 15/8/10.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import "ZJAddressUtil.h"
#import "pinyin.h"

#define kRefreshContact @"refreshContact"

@implementation ZJAddressUtil

+ (ZJAddressUtil *)shared
{
    static ZJAddressUtil *_addressUtil = nil;
    static dispatch_once_t oncePredicateContactUtil;
    dispatch_once(&oncePredicateContactUtil, ^{
        _addressUtil = [[self alloc] init];
    });
    return _addressUtil;
}

- (id) init
{
    self = [super init];
    if (self) {
        _dicRoot = [[NSMutableDictionary alloc]initWithCapacity:30];
        for(char c = 'a'; c <= 'z'; c++)
            [_dicRoot setValue:[[NSMutableArray alloc]init] forKey:[NSString stringWithFormat:@"%c",c]];
        [_dicRoot setValue:[[NSMutableArray alloc]init] forKey:@"#"];
        [self getAddressBook];
    }
    return self;
}

- (void)getAddressBook
{
    //取得授权状态
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    CFErrorRef error;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (authStatus != kABAuthorizationStatusAuthorized)
    {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (error)
                     NSLog(@"Error: %@", (__bridge NSError *)error);
                 else
                 {
                     [self arrayRootForDic:addressBook];
                 }
             });
         });
    }else{
        [self arrayRootForDic:addressBook];
    }
//    CFRelease(addressBook);
}

- (void)arrayRootForDic:(ABAddressBookRef)addressBook
{
    CFArrayRef results;
    //查询所有
    results = ABAddressBookCopyArrayOfAllPeople(addressBook);
    for(int i = 0; i < CFArrayGetCount(results); i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        NSString* fullName = [self fullName:person];
        
        [dic setValue:fullName forKey:@"name"];
        [dic setValue:[self phoneArr:person] forKey:@"phoneArr"];
        
        NSString* firstStrPro;
        if (fullName == nil||[fullName isEqual:@""]) {
            firstStrPro = @"#";
        }else {
            firstStrPro = [NSString stringWithFormat:@"%c", pinyinFirstLetter([fullName characterAtIndex:0])];
            if ([firstStrPro isEqualToString:@"#"]) {
                NSString* regex = @"[a-zA-Z]";
                NSPredicate* test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                if([test evaluateWithObject:[NSString stringWithFormat:@"%c", [fullName characterAtIndex:0]]]){
                    firstStrPro = [NSString stringWithFormat:@"%c", [fullName characterAtIndex:0]];
                }
            }
        }
        
        NSMutableArray* arrayPro = [_dicRoot objectForKey:firstStrPro];
        [arrayPro addObject:dic];
        
    }
    CFRelease(results);
    CFRelease(addressBook);
    [[NSNotificationCenter defaultCenter]postNotificationName:kRefreshContact object:nil];
}

- (NSArray*)searchContact:(NSString*)key{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    CFArrayRef results;
    CFStringRef cfSearchText = (CFStringRef)CFBridgingRetain(key);
    results = ABAddressBookCopyPeopleWithName(addressBook, cfSearchText);
    NSMutableArray* arrayPro = [[NSMutableArray alloc]init];
    for(int i = 0; i < CFArrayGetCount(results); i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        NSString* fullName = [self fullName:person];
        
        [dic setValue:fullName forKey:@"name"];
        [dic setValue:[self phoneArr:person] forKey:@"phoneArr"];
        
        [arrayPro addObject:dic];
    }
    CFRelease(cfSearchText);
    CFRelease(results);
    CFRelease(addressBook);
    return arrayPro;
}

- (NSString*)fullName:(ABRecordRef)person{
    NSString* fullName = [[NSString alloc]init];
    
    NSString *lastname = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    if(lastname != nil)
        fullName = [fullName stringByAppendingFormat:@"%@",lastname];
    lastname = nil;
    
    NSString *personName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if(personName != nil)
        fullName = [fullName stringByAppendingFormat:@"%@",personName];
    
    NSString *middlename = (__bridge NSString*)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
    if(middlename != nil)
        fullName = [fullName stringByAppendingFormat:@"%@",middlename];
    
    NSString *prefix = (__bridge NSString*)ABRecordCopyValue(person, kABPersonPrefixProperty);
    if(prefix != nil)
        fullName = [fullName stringByAppendingFormat:@"%@",prefix];
    
    NSString *suffix = (__bridge NSString*)ABRecordCopyValue(person, kABPersonSuffixProperty);
    if(suffix != nil)
        fullName = [fullName stringByAppendingFormat:@"%@",suffix];
    
    NSString *nickname = (__bridge NSString*)ABRecordCopyValue(person, kABPersonNicknameProperty);
    if(nickname != nil)
        fullName = [fullName stringByAppendingFormat:@"%@",nickname];

    return fullName;
}

- (NSArray*)phoneArr:(ABRecordRef)person
{
    NSMutableArray* phoneArr =[[NSMutableArray alloc]init];
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    for (int k = 0; k < ABMultiValueGetCount(phone); k++)
    {
        //获取該Label下的电话值
        NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
        [phoneArr addObject:personPhone];
    }
    return phoneArr;
}

- (BOOL)isEqualPhoneForUtil:(NSString*)phoneOut person:(ABRecordRef)person
{
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    for (int k = 0; k < ABMultiValueGetCount(phone); k++)
    {
        //获取該Label下的电话值
        NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
        personPhone= [personPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        if ([personPhone isEqual:phoneOut] || [personPhone isEqual:[NSString stringWithFormat:@"+86 %@",phoneOut]]) {
            return YES;
        }
        
    }
    return NO;
}

- (NSString*)phoneName:(NSString*)phoneOut
{
    NSString* fullName = nil;
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    if (addressBook == nil) {
        return nil;
    }
    for(int i = 0; i < CFArrayGetCount(results); i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
        
        if ([self isEqualPhoneForUtil:phoneOut person:person]) {
            fullName = [self fullName:person];
            break;
        }
    }
    
    CFRelease(results);
    CFRelease(addressBook);
    return fullName;
}

- (ABRecordRef)personByNumber:(NSString*)phoneNumber
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    ABRecordRef result = NULL;
    
    for(int i = 0; i < CFArrayGetCount(results); i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
        
        if ([self isEqualPhoneForUtil:phoneNumber person:person]) {
            result = CFRetain(person);
            break;
        }
    }
    
    CFRelease(results);
    CFRelease(addressBook);
    
    return result;
}
@end
