//
//  LoginHandler.h
//  Yxt
//
//  Created by 朱佳伟 on 16/3/15.
//  Copyright © 2016年 朱佳伟. All rights reserved.
//

#import "ZJBaseHandlerProtocol.h"
#import <Foundation/Foundation.h>

@interface LoginHandler : NSObject

@property (nonatomic, weak) id<ZJBaseHandlerProtocol> delegate;

/**
 *  调用登录请求
 *
 *  @param username
 *  @param password 
 */
- (void)loginWithUserName:(NSString *)username password:(NSString *)password;

@end
