//
//  NSString+UUID.m
//  ZJLib
//
//  Created by 朱佳伟 on 16/2/16.
//  Copyright © 2016年 朱佳伟. All rights reserved.
//

#import "NSString+UUID.h"
#import <UIKit/UIKit.h>

@implementation NSString(UUID)

/**
 *  @brief  获取随机 UUID 例如 E621E1F8-C36C-495A-93FC-0C247A3E6E5F
 *
 *  @return 随机 UUID
 */
+ (NSString *)UUID
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] > 6.0)
    {
        return  [[NSUUID UUID] UUIDString];
    }
    else
    {
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef uuid = CFUUIDCreateString(NULL, uuidRef);
        CFRelease(uuidRef);
        return (__bridge_transfer NSString *)uuid;
    }
}
@end
