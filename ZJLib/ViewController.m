//
//  ViewController.m
//  ZJLib
//
//  Created by 朱佳伟 on 16/3/14.
//  Copyright © 2016年 朱佳伟. All rights reserved.
//

#import "ViewController.h"
#import "ZJLib.h"
#import "LoginHandler.h"

@interface ViewController ()<ZJBaseHandlerProtocol>{
    UIView* tview;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    LoginHandler* loginHandler = [[LoginHandler alloc]init];
    loginHandler.delegate = self;
    [loginHandler loginWithUserName:@"zhujiawei" password:@"11111"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestDidSucceed:(id)response{
    NSLog(@"responseString:%@",response);
}

- (void)requestDidFailed:(NSString *)errorMsg{
    NSLog(@"errorMsg:%@", errorMsg);
}
@end
