//
//  NSDictionary+URL.m
//  ZJLib
//
//  Created by 朱佳伟 on 16/2/16.
//  Copyright © 2016年 朱佳伟. All rights reserved.
//

#import "NSDictionary+URL.h"
#import <UIKit/UIKit.h>

@implementation NSDictionary(URL)

/**
 *  @brief  将url参数转换成NSDictionary
 *
 *  @param query url参数
 *
 *  @return NSDictionary
 */
+ (NSDictionary *)dictionaryWithURLQuery:(NSString *)query
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *parameters = [query componentsSeparatedByString:@"&"];
    for(NSString *parameter in parameters) {
        NSArray *contents = [parameter componentsSeparatedByString:@"="];
        if([contents count] == 2) {
            NSString *key = [contents objectAtIndex:0];
            NSString *value = [contents objectAtIndex:1];
        #ifdef __IPHONE_9_0
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)  {
                value = [value stringByRemovingPercentEncoding];
            }else{
                value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
        #else
            value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        #endif
            if (key && value) {
                [dict setObject:value forKey:key];
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:dict];
}
/**
 *  @brief  将NSDictionary转换成url 参数字符串
 *
 *  @return url 参数字符串
 */
- (NSString *)URLQueryString
{
    NSMutableString *string = [NSMutableString string];
    for (NSString *key in [self allKeys]) {
        if ([string length]) {
            [string appendString:@"&"];
        }
        
        CFStringRef escaped;
#ifdef __IPHONE_9_0
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)  {
            escaped = (__bridge CFStringRef)([string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]);
        }else{
            escaped = CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)[[self objectForKey:key] description],
                                                              NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8);        }
#else
        escaped = CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)[[self objectForKey:key] description],
                                                          NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                          kCFStringEncodingUTF8);
#endif
        [string appendFormat:@"%@=%@", key, escaped];
        CFRelease(escaped);
    }
    return string;
}
@end
