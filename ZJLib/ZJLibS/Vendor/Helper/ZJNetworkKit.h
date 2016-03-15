//
//  ZJNetworkKit.h
//  ZJUtils
//
//  Created by 朱佳伟 on 15/3/12.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ARCMacros.h"
#import "Reachability.h"

@class ZJNetworkKit;

@protocol ZJNetworkStatusChangeDelegate <NSObject>

/**
 *  network status changed
 *
 *  @param aKit
 */
- (void)onNetworkStatusChanged:(ZJNetworkKit *)aKit;
@end

@interface ZJNetworkKit : NSObject
{
    BOOL canUse3G;
    BOOL canUseWifi;
    BOOL has3G;
    BOOL hasWifi;
    BOOL isOnlyUseOnWifi;
    NetworkStatus lastNetworkStatus;
}

@property (nonatomic, SAFE_ARC_WEAK) id<ZJNetworkStatusChangeDelegate> delegate;

+ (ZJNetworkKit *)shared;

// 注册检查网络
- (void)startCheck;

// 是否连接网络(isOnlyUseOnWifi参与影响)
- (BOOL)isConnect;

// 是否脱机
- (BOOL)isOffline;

// 上一次联网状态
- (NetworkStatus)lastNetworkStatus;

//	设置程序内是否允许通过3G访问网络
- (void)use3G:(BOOL)bUse;

//	若3G访问网络允许，返回YES;否则返回NO
- (BOOL)canUse3G;

//	设置程序内是否允许通过wifi访问网络
- (void)useWifi:(BOOL)bUse;

//	若wifi访问网络允许，返回YES;否则返回NO
- (BOOL)canUseWifi;

// 实际在线网络状态
- (BOOL)hasNetWork;
- (BOOL)has3G;
- (BOOL)hasWifi;

//只在wifi下使用
- (void)setIsOnlyUseOnWifi:(BOOL)bValue;
- (BOOL)isOnlyUseOnWifi;
@end
