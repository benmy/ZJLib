//
//  UIViewController+Extends.h
//  VoiceRecorder
//
//  Created by 朱佳伟 on 14/11/25.
//  Copyright (c) 2014年 朱佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extends)

/**
 *   Display another view controller as a modal child. Uses a vertical sheet transition if animated.
 *
 *  @param viewController:view controller as a modal child
 *  @param bAnimated
 */
- (void)presentViewController:(UIViewController *)viewController animated:(BOOL)bAnimated;

/**
 *   Display another view controller as a modal child. Uses a vertical sheet transition if animated.
 *
 *  @param viewController:view controller as a modal child
 *  @param bAnimated
 *  @param statusBarStyle
 */
- (void)presentViewController:(UIViewController *)viewController animated:(BOOL)bAnimated statusBarStyle:(UIStatusBarStyle)statusBarStyle;

/**
 *  关闭自己打开的模式框
 */
- (void)dismissViewController;

/**
 *  关闭作为模式框的自己
 */
- (void)dismissMe;

/**
 *  navcontroller pop至父Controller
 */
- (void)popBackMe;
@end
