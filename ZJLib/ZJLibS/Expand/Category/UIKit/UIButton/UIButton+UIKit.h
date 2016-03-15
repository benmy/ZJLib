//
//  UIButton+UIKit.h
//  ZJUtils
//
//  Created by 朱佳伟 on 15/3/13.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIButton (UIKit)

/**
 *  设置按钮title，所有状态
 *
 *  @param title
 */
- (void)setTitleForAllState:(NSString *)title;

/**
 *  设置按钮背景图
 *
 *  @param bgImg 正常状态下图片
 *  @param clImg 高亮状态下图片
 */
- (void)setBgImg:(UIImage *)bgImg clImg:(UIImage *)clImg;

/**
 *  设置按钮背景图
 *
 *  @param bgImg 正常状态下图片
 *  @param clImg 高亮状态下图片
 *  @param slImg 不可用状态下图片
 */
- (void)setBgImg:(UIImage *)bgImg clImg:(UIImage *)clImg slImg:(UIImage *)slImg;

- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end
