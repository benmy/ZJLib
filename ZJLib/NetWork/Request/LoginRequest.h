//
//  LoginRequest.h
//  Yxt
//
//  Created by 朱佳伟 on 16/3/15.
//  Copyright © 2016年 朱佳伟. All rights reserved.
//

@interface LoginRequest : YTKRequest

/**
 *  登录请求
 *
 *  @param username
 *  @param password
 *
 *  @return 请求对象
 */
- (id)initWithUsername:(NSString *)username password:(NSString *)password;

@end
