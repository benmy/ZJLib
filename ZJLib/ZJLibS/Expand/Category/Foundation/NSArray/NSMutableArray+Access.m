//
//  NSMutableArray+Access.m
//  ZJLib
//
//  Created by 朱佳伟 on 16/2/16.
//  Copyright © 2016年 朱佳伟. All rights reserved.
//

#import "NSMutableArray+Access.h"

@implementation NSMutableArray (Access)

- (void)addObj:(id)i{
    if (i != nil) {
        [self addObject:i];
    }
}

- (void)addString:(NSString*)i
{
    if (i != nil) {
        [self addObject:i];
    }
}

- (void)addBool:(BOOL)i
{
    [self addObject:@(i)];
}

- (void)addInt:(int)i
{
    [self addObject:@(i)];
}

- (void)addInteger:(NSInteger)i
{
    [self addObject:@(i)];
}

- (void)addUnsignedInteger:(NSUInteger)i
{
    [self addObject:@(i)];
}

- (void)addCGFloat:(CGFloat)f
{
    [self addObject:@(f)];
}

- (void)addChar:(char)c
{
    [self addObject:@(c)];
}

- (void)addFloat:(float)i
{
    [self addObject:@(i)];
}

- (void)addPoint:(CGPoint)o
{
    [self addObject:NSStringFromCGPoint(o)];
}

- (void)addSize:(CGSize)o
{
    [self addObject:NSStringFromCGSize(o)];
}

- (void)addRect:(CGRect)o
{
    [self addObject:NSStringFromCGRect(o)];
}
@end
