//
//  ZJDataMgr.h
//  Yxt
//
//  Created by 朱佳伟 on 16/3/17.
//  Copyright © 2016年 朱佳伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJDataMgr : NSObject

@property (nonatomic, assign) int64_t countDownButtonProgress;

/**
 *  单例
 *
 *  @return 
 */
+ (ZJDataMgr *)sharedInstance;

@end
