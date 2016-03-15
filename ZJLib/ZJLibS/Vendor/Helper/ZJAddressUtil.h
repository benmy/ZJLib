//
//  ZJAddressUtil.h
//  MyClass3
//
//  Created by 朱佳伟 on 15/8/10.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface ZJAddressUtil : NSObject

@property (nonatomic, strong) NSMutableDictionary* dicRoot;

/**
 *  获取单例
 *
 *  @return
 */
+ (ZJAddressUtil *)shared;

/**
 *  获取手机通讯录，先授权再导入
 */
- (void)getAddressBook;

/**
 *  根据通讯录全名首字母排序
 *
 *  @param addressBook
 */
- (void)arrayRootForDic:(ABAddressBookRef)addressBook;

/**
 *  通过key查询通讯录
 *
 *  @param key
 *
 *  @return 
 */
- (NSArray*)searchContact:(NSString*)key;
@end
