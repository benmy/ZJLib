//
//  ZJUtil.h
//  ZJUtils
//
//  Created by 朱佳伟 on 15/3/12.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJUtil : NSObject

/**
 *  注册推送通知
 */
+ (void)registerNotification;

/**
 *  获取推送通知开关
 *
 *  @return
 */
+ (BOOL)getStatusOfRemoteNotification;

@end
