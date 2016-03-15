//
//  UITableViewCell+Extends.h
//  VoiceRecorder
//
//  Created by 朱佳伟 on 14/11/25.
//  Copyright (c) 2014年 朱佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Extends)

/**
 *  取消点击效果
 */
- (void)noneSelectedStyle;

/**
 *  设置分割线的缩进
 *
 *  @param left
 *  @param right 
 */
- (void)separatorLeft:(CGFloat)left right:(CGFloat)right;
@end
