//
//  ZJDeviceInfo.m
//  ZJUtils
//
//  Created by 朱佳伟 on 15/3/12.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import "ZJDeviceInfo.h"
#import "ARCMacros.h"
#import "UIDevice+Extends.h"
#import <objc/runtime.h>

static NSInteger s_appVer = -1;
static NSString *s_language = nil;

@implementation ZJDeviceInfo

+ (BOOL)isDebugMode
{
#ifndef __OPTIMIZE__
    return YES;
#else
    return NO;
#endif
}

+ (NSString *)preferredLanguage
{
    if (s_language == nil)
    {
        s_language = @"";
        
        NSArray *languages = [NSLocale preferredLanguages];
        if ([languages count] > 0)
        {
            s_language = [[languages objectAtIndex:0] copy];
        }
    }
    
    return s_language;
}

+ (BOOL)isEnLanguage
{
    NSString *lang = [ZJDeviceInfo preferredLanguage];
    if ([lang isEqualToString:@"en"])
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isCnLanguage
{
    NSString *lang = [ZJDeviceInfo preferredLanguage];
    if ([lang isEqualToString:@"zh-Hans"])
    {
        return YES;
    }
    return NO;
}

+ (NSInteger)verStrToInt:(NSString *)strVer
{
    NSInteger nVer = 0;
    if (strVer != nil)
    {
        NSArray *array = [strVer componentsSeparatedByString:@"."];
        
        // 1 000 001
        if (array.count > 0)
        {
            nVer = [[array objectAtIndex:0] integerValue] * 1000000;
            if (array.count > 1)
            {
                nVer += [[array objectAtIndex:1] integerValue] * 1000;
                if (array.count > 2)
                {
                    nVer += [[array objectAtIndex:2] integerValue];
                }
            }
        }
    }
    
    return nVer;
}

+ (NSInteger)iosVer
{
    if (s_appVer >= 0)
        return s_appVer;
    
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    s_appVer = [ZJDeviceInfo verStrToInt:ver];
    
    return s_appVer;
}

+ (NSInteger)appVer
{
    if (s_appVer >= 0)
        return s_appVer;
    
    NSString *ver = [ZJDeviceInfo bundleVersion];
    s_appVer = [ZJDeviceInfo verStrToInt:ver];
    
    return s_appVer;
}

+ (NSString*)iphoneDeviceType{
    return [[UIDevice currentDevice] machine];
}

+ (void)clearApplicationIconBadgeNumber
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

+ (void)setApplicationIconBadgeNumber
{
    [UIApplication sharedApplication].applicationIconBadgeNumber--;
}

+ (BOOL)isNil:(id)value
{
    if (value == nil)
    {
        return YES;
    }
    
    if (value == [NSNull null])
    {
        return YES;
    }
    
    return NO;
}

+ (id<NSCoding>)objectWithSerializedObject:(id<NSCoding>)aSerializedObject
{
    id<NSCoding> newObj = nil;
    
    NSMutableData* saveData = [[NSMutableData alloc] init];
    {
        NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:saveData];
        {
            [archiver encodeRootObject:aSerializedObject];
            [archiver finishEncoding];
            
            NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:saveData];
            newObj = [unArchiver decodeObject];
            SAFE_ARC_RELEASE(unArchiver);
        }
        SAFE_ARC_RELEASE(archiver);
    }
    SAFE_ARC_RELEASE(saveData);
    
    return newObj;
}

+ (id)loadObjectFromNibName:(NSString *)aNibName class:(Class)aClass
{
    NSArray* objects = [[NSBundle mainBundle] loadNibNamed:aNibName owner:nil options:nil];
    for (id object in objects)
    {
        if ([object isKindOfClass:aClass])
        {
            return object;
        }
    }
    return nil;
}

+ (NSString *)fullVersion
{
    return [NSString stringWithFormat:@"%@", [ZJDeviceInfo bundleVersion]];
}

+ (NSString *)bundleVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)bundleBuild
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)bundleIdentifier
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

+ (NSString *)bundleDisplayName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+ (NSString *)bundleName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

+ (NSString *)className:(Class)cls
{
    const char *pName = class_getName(cls);
    return [NSString stringWithCString:pName encoding:NSASCIIStringEncoding];
}

+ (NSString *)selectorName:(SEL)aSelector
{
    const char *pName = sel_getName(aSelector);
    return [NSString stringWithCString:pName encoding:NSASCIIStringEncoding];
}

+ (NSString *)toStringWithJsonValue:(id)value
{
    if (value == nil || value == [NSNull null])
    {
        return @"";
    }
    
    if ([value isKindOfClass:[NSString class]])
    {
        return value;
    }
    
    if ([value isKindOfClass:[NSNumber class]])
    {
        return  [value stringValue];
    }
    
    return @"";
}

+ (NSInteger)toIntegerWithJsonValue:(id)value
{
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
    {
        return [value integerValue];
    }
    
    return 0;
}

+ (int64_t)toInt64WithJsonValue:(id)value
{
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
    {
        return [value longLongValue];
    }
    
    return 0;
}

+ (short)toShortWithJsonValue:(id)value
{
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
    {
        return [value shortValue];
    }
    
    return 0;
}

+ (float)toFloatWithJsonValue:(id)value
{
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
    {
        return [value floatValue];
    }
    
    return 0;
}

+ (double)toDoubleWithJsonValue:(id)value
{
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
    {
        return [value doubleValue];
    }
    
    return 0;
}

+ (id)toArrayWithJsonValue:(id)value
{
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    
    if ([value isKindOfClass:[NSArray class]])
    {
        return value;
    }
    
    return nil;
}

+ (id)toDictionaryWithJsonValue:(id)value
{
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    
    if ([value isKindOfClass:[NSDictionary class]])
    {
        return value;
    }
    
    return nil;
}
+ (NSString *)getUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef uuid = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge_transfer NSString *)(uuid);
}

+ (NSString *)getUUIDNoSeparator
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    
    NSString *str = [(__bridge NSString *)string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(string);
    return str;
}

@end
