//
//  ZJCircularProgressView.h
//  ZJUtils
//
//  Created by 朱佳伟 on 15/3/13.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

//类似微博大图片的进度条
#import <UIKit/UIKit.h>

@interface ZJCircularProgressView : UIView

/**
 *  进度条圆形内部的背景色
 */
@property(nonatomic, strong) UIColor *backTintColor;

/**
 *  进度条圆形的背景色
 */
@property(nonatomic, strong) UIColor *trackTintColor;

/**
 *  进度条圆形的颜色
 */
@property(nonatomic, strong) UIColor *progressTintColor;

/**
 *  进度
 */
@property (nonatomic) float progress;

@end
