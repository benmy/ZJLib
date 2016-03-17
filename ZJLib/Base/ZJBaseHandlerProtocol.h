//
//  ZJBaseHandlerProtocol.h
//  Yxt
//
//  Created by 朱佳伟 on 16/3/15.
//  Copyright © 2016年 朱佳伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZJBaseHandlerProtocol <NSObject>

/**
 *  Handler处理成功后调用
 *
 *  @param response 返回结果
 */
- (void)requestDidSucceed:(id)response;

/**
 *  Handler处理失败后调用
 *
 *  @param errorMsg 错误信息
 */
- (void)requestDidFailed:(NSString*)errorMsg;

@end
