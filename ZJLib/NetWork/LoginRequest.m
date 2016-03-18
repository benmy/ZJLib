//
//  RegisterRequest.m
//  Yxt
//
//  Created by 朱佳伟 on 16/3/15.
//  Copyright © 2016年 朱佳伟. All rights reserved.
//

#import "LoginRequest.h"

@implementation LoginRequest{
    NSString *_username;
    NSString *_password;
}

- (id)initWithUsername:(NSString *)username password:(NSString *)password {
    self = [super init];
    if (self) {
        _username = username;
        _password = password;
    }
    return self;
}

- (NSString *)requestUrl {
    return kRegister;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (id)requestArgument {
    return @{
             @"username": _username,
             @"password": _password
             };
}
//
//- (id)jsonValidator {
//    return @{
//             @"username": [NSString class],
//             @"password": [NSString class]
//             };
//}

- (NSInteger)cacheTimeInSeconds {
    // cache 3 minutes, which is 60 * 3 = 180 seconds
    return 60 * 3;
}
@end
