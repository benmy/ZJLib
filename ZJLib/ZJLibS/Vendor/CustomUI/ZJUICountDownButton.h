//
//  ZJUICountDownButton.h
//  MyClass_v3
//
//  Created by 朱佳伟 on 15/3/30.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HalfProgressBlock)();

@interface ZJUICountDownButton : UIButton

/**
 *  进度到一半时调用
 */
@property (nonatomic, copy) HalfProgressBlock halfProgressBlock;

- (void)setNormalTitle:(NSString*)title;

- (void)setCountDownTitle:(NSString*)title format:(NSString*)format;

/**
 *  设置按钮状态
 *
 *  @param enabled
 */
- (void)setEnabled:(BOOL)enabled;

- (void)waitOfProgress:(NSInteger)full;

@end
