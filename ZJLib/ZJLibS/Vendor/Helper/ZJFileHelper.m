//
//  ZJFileHelper.m
//  MyClass3
//
//  Created by 朱佳伟 on 15/11/27.
//  Copyright © 2015年 朱佳伟. All rights reserved.
//

#import "ZJFileHelper.h"

@implementation ZJFileHelper

+ (NSString*)fileNameWithType:(NSString*)type andExtension:(NSString*)extension{
    NSInteger rand = (arc4random() % 90000) + 10000;
    int64_t nowStamp = [NSDate millisecondSince1970];
    NSInteger hour = [NSDate hourOfDate:[NSDate date]];
    NSString* dayString = [[NSDate date] dateStringWithFormatString:@"yyyyMMdd"];
    NSString* filePath = [NSString stringWithFormat:@"%@/%@/%ld/%lld%ld.%@", type, dayString, hour, nowStamp, rand, extension];
//    NSLog(@"filePath:%@", filePath);
    return filePath;
}

+ (NSString*)filePathWithType:(NSString*)type AndName:(NSString*)name{
    NSArray* filename = [name componentsSeparatedByString:@"/"];
    NSInteger hour = [NSDate hourOfDate:[NSDate date]];
    NSString* dayString = [[NSDate date] dateStringWithFormatString:@"yyyyMMdd"];
    NSString* filePath = [NSString stringWithFormat:@"%@/%@/%ld/%@", type, dayString, hour, [filename lastObject]];
    //    NSLog(@"filePath:%@", filePath);
    return filePath;
}

@end
