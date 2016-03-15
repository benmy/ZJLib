//
//  ViewController.m
//  ZJLib
//
//  Created by 朱佳伟 on 16/3/14.
//  Copyright © 2016年 朱佳伟. All rights reserved.
//

#import "ViewController.h"
#import "ZJLib.h"

@interface ViewController (){
    UIView* tview;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    label.text = @"test";
    [self.view addSubview:label];
    
    //测试
    NSString* encryptedS = [@"zhujiawei" encryptedWith3DESUsingKey:@"benmy22222" andIV:nil];
    NSLog(@"%@", encryptedS);
    NSString* decryptedS = [encryptedS decryptedWith3DESUsingKey:@"benmy22222" andIV:nil];
    NSLog(@"%@", decryptedS);
    
    NSLog(@"%@", [@"zhujiawei" md5String]);
    
    tview = [[UIView alloc]initWithFrame:CGRectMake(100, 200, 100, 100)];
    [tview setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:tview];
    
    [self performAfter:1 block:^{
        [self animationTest];
    }];
}

- (void)animationTest{
    [tview shake];
    //    TestController *ctrl = [[TestController alloc]init];
    //    [self.navigationController pushViewController:ctrl animated:YES];
    //    [CoreAnimationBasicEffect animationCameraOpen:tview];
    //    [CoreAnimationBasicEffect animationCurlUp:tview];
    //    [CoreAnimationBasicEffect animationMoveUp:tview duration:1];
    //    [CoreAnimationBasicEffect animationRotateAndScaleEffects:tview];
    //    [CoreAnimationBasicEffect animationFlipFromLeft:tview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
