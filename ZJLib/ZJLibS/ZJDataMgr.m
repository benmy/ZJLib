//
//  ZJDataMgr.m
//  Yxt
//
//  Created by 朱佳伟 on 16/3/17.
//  Copyright © 2016年 朱佳伟. All rights reserved.
//

#import "ZJDataMgr.h"

@implementation ZJDataMgr

+ (ZJDataMgr *)sharedInstance
{
    static ZJDataMgr *s_instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [[ZJDataMgr alloc] init];
    });
    
    return s_instance;
}
@end
