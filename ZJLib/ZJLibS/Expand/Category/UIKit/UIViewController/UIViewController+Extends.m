//
//  UIViewController+Extends.m
//  VoiceRecorder
//
//  Created by 朱佳伟 on 14/11/25.
//  Copyright (c) 2014年 朱佳伟. All rights reserved.
//

#import "UIViewController+Extends.h"

@implementation UIViewController (Extends)

- (void)presentViewController:(UIViewController *)viewController animated:(BOOL)bAnimated
{
	[self presentViewController:viewController animated:bAnimated completion:^(){}];
}

- (void)presentViewController:(UIViewController *)viewController animated:(BOOL)bAnimated statusBarStyle:(UIStatusBarStyle)statusBarStyle
{
	[UIApplication sharedApplication].statusBarHidden = NO;
	[UIApplication sharedApplication].statusBarStyle = statusBarStyle;
	[self presentViewController:viewController animated:bAnimated completion:^(){}];
}

- (void)dismissViewController
{
	[self dismissViewControllerAnimated:YES completion:^(){
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
	}];
}

- (void)dismissMe
{
	[self.presentingViewController dismissViewControllerAnimated:YES completion:^(){
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
	}];
}

- (void)popBackMe
{
	[self.navigationController popViewControllerAnimated:YES];
}
@end
