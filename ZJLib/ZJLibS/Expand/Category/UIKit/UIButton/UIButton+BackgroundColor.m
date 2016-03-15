//
//  UIButton+BackgroundColor.m
//  ZJLib
//
//  Created by 朱佳伟 on 16/2/18.
//  Copyright © 2016年 朱佳伟. All rights reserved.
//

#import "UIButton+BackgroundColor.h"
#import "UIImage+Color.h"

@implementation UIButton(BackgroundColor)

/**
 *  @brief  使用颜色设置按钮背景
 *
 *  @param backgroundColor 背景颜色
 *  @param state           按钮状态
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    [self setBackgroundImage:[UIImage imageWithColor:backgroundColor] forState:state];
}
@end
