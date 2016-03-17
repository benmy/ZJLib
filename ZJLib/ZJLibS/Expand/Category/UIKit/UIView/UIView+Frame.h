//
//  UIView+Frame.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

// shortcuts for positions
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

//以下方法用来设置view的frame
- (void)setFrameLeft:(CGFloat)left;
- (void)setFrameTop:(CGFloat)top;
- (void)setFrameOrigin:(CGFloat)left top:(CGFloat)top;
- (void)setFrameHeight:(CGFloat)height;
- (void)setFrameWidth:(CGFloat)width;
- (void)setFrameSize:(CGFloat)height width:(CGFloat)width;
- (void)setFrameSize:(CGSize)size;

@end
