//
//  ZJCircularProgressView.m
//  ZJUtils
//
//  Created by 朱佳伟 on 15/3/13.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import "ZJCircularProgressView.h"

#define DEGREES_2_RADIANS(x) (0.0174532925 * (x))

@implementation ZJCircularProgressView

- (id)init
{
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 50.0f)];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //背景圆形
    CGContextAddEllipseInRect(context, self.frame);
    CGContextSetFillColorWithColor(context, self.backTintColor.CGColor);
    CGContextFillPath(context);
    
    rect = CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 10);
    CGPoint centerPoint = CGPointMake(rect.size.height / 2 + 5, rect.size.width / 2 + 5);
    CGFloat radius = MIN(rect.size.height, rect.size.width) / 2;
    
    CGFloat pathWidth = radius * 0.3f;
    
    CGFloat radians = DEGREES_2_RADIANS((self.progress * 359.9) - 90);
    CGFloat xOffset = radius*(1 + 0.85 * cosf(radians));
    CGFloat yOffset = radius*(1 + 0.85 * sinf(radians));
    CGPoint endPoint = CGPointMake(xOffset, yOffset);
    
    //进度条进度背景色
    [self.trackTintColor setFill];
    CGContextAddEllipseInRect(context, CGRectMake(centerPoint.x - radius, centerPoint.y - radius, radius*2, radius*2));
    CGContextFillPath(context);
    
    //进度条进度
    [self.progressTintColor setFill];
    CGMutablePathRef progressPath = CGPathCreateMutable();
    CGPathMoveToPoint(progressPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius, DEGREES_2_RADIANS(270), radians, NO);
    CGPathCloseSubpath(progressPath);
    CGContextAddPath(context, progressPath);
    CGContextFillPath(context);
    CGPathRelease(progressPath);
    
    //进度条头尾两个圆形
    CGContextAddEllipseInRect(context, CGRectMake(centerPoint.x - pathWidth/2, 5, pathWidth, pathWidth));
    //    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextFillPath(context);
    
    CGContextAddEllipseInRect(context, CGRectMake(endPoint.x - pathWidth/2 + 5, endPoint.y - pathWidth/2 + 5, pathWidth, pathWidth));
    //    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextFillPath(context);
    
    //    CGContextSetBlendMode(context, kCGBlendModeClear);
    //内部圆形
    [self.backTintColor setFill];
    CGFloat innerRadius = radius * 0.7;
    CGPoint newCenterPoint = CGPointMake(centerPoint.x - innerRadius, centerPoint.y - innerRadius);
    CGContextAddEllipseInRect(context, CGRectMake(newCenterPoint.x, newCenterPoint.y, innerRadius*2, innerRadius*2));
    CGContextFillPath(context);
}

#pragma mark - Property Methods

- (UIColor *)backTintColor
{
    if (!_backTintColor)
    {
        _backTintColor = [UIColor darkGrayColor];
    }
    return _backTintColor;
}

- (UIColor *)trackTintColor
{
    if (!_trackTintColor)
    {
        _trackTintColor = [UIColor blackColor];
    }
    return _trackTintColor;
}

- (UIColor *)progressTintColor
{
    if (!_progressTintColor)
    {
        _progressTintColor = [UIColor whiteColor];
    }
    return _progressTintColor;
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}

@end
