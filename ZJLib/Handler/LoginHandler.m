//
//  RegisterHandler.m
//  Yxt
//
//  Created by 朱佳伟 on 16/3/15.
//  Copyright © 2016年 朱佳伟. All rights reserved.
//

#import "LoginRequest.h"
#import "Loginhandler.h"

@implementation LoginHandler

- (void)loginWithUserName:(NSString *)username password:(NSString *)password{
    if (username.length > 0 && password.length > 0) {
        LoginRequest *api = [[LoginRequest alloc] initWithUsername:username password:password];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            // 你可以直接在这里使用 self
            NSLog(@"succeed");
            [self dealWithResponse:request success:YES];
        } failure:^(YTKBaseRequest *request) {
            // 你可以直接在这里使用 self
            NSLog(@"failed");
            [self dealWithResponse:request success:NO];
        }];
    }
}

- (void)dealWithResponse:(YTKBaseRequest*)request success:(BOOL)success{
    //TODO
    //处理返回数据
    if (success) {
        if ([self.delegate respondsToSelector:@selector(requestDidSucceed:)]) {
            [self.delegate requestDidSucceed:request.responseString];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(requestDidFailed:)]) {
            [self.delegate requestDidFailed:request.responseString];
        }
    }
}

@end
