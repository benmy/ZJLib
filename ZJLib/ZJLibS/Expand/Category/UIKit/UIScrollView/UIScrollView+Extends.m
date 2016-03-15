//
//  UIScrollView+Extends.m
//  MyClass3
//
//  Created by 朱佳伟 on 16/1/11.
//  Copyright © 2016年 朱佳伟. All rights reserved.
//

#import "UIScrollView+Extends.h"

@implementation UIScrollView (Extends)

- (void)scrollsToBottomAnimated:(BOOL)animated
{
    CGFloat offset = self.contentSize.height - self.bounds.size.height;
    if (offset > 0)
    {
        [self setContentOffset:CGPointMake(0, offset) animated:animated];
    }
}

@end
