//
//  ZJUtil.m
//  ZJUtils
//
//  Created by 朱佳伟 on 15/3/12.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import "ZJUtil.h"
#import "ZJDeviceInfo.h"
#import "UIButton+UIKit.h"

@implementation ZJUtil

//注册推送通知
+ (void)registerNotification{
#ifdef __IPHONE_8_0
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert |
      UIRemoteNotificationTypeBadge |
      UIRemoteNotificationTypeSound)];
#endif
}

+ (BOOL)getStatusOfRemoteNotification{
    UIUserNotificationSettings *mySet =
    [[UIApplication sharedApplication] currentUserNotificationSettings];
    UIUserNotificationType type = mySet.types;
    
    if (type == 0) {
        return NO;
    }else{
        return YES;
    }
}
@end
