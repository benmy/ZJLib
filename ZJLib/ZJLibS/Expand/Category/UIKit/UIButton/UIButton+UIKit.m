//
//  UIButton+UIKit.m
//  ZJUtils
//
//  Created by 朱佳伟 on 15/3/13.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import "UIButton+UIKit.h"
#import <objc/runtime.h>

@implementation UIButton (UIKit)

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

- (void)setTitleForAllState:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateSelected];
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitle:title forState:UIControlStateDisabled];
}

- (void)setBgImg:(UIImage *)bgImg clImg:(UIImage *)clImg
{
    if (bgImg != nil)
    {
        [self setBackgroundImage:bgImg forState:UIControlStateNormal];
    }
    if (clImg != nil)
    {
        [self setBackgroundImage:clImg forState:UIControlStateHighlighted];
    }
}

- (void)setBgImg:(UIImage *)bgImg clImg:(UIImage *)clImg slImg:(UIImage *)slImg
{
    if (bgImg != nil)
    {
        [self setBackgroundImage:bgImg forState:UIControlStateNormal];
    }
    if (clImg != nil)
    {
        [self setBackgroundImage:clImg forState:UIControlStateHighlighted];
    }
    if (slImg != nil)
    {
        [self setBackgroundImage:slImg forState:UIControlStateSelected];
    }
}

- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect) enlargedRect
{
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge)
    {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    else
    {
        return self.bounds;
    }
}

- (UIView*) hitTest:(CGPoint) point withEvent:(UIEvent*) event
{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}

@end
