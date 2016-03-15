//
//  UITableViewCell+Extends.m
//  VoiceRecorder
//
//  Created by 朱佳伟 on 14/11/25.
//  Copyright (c) 2014年 朱佳伟. All rights reserved.
//

#import "UITableViewCell+Extends.h"
#import "ZJDeviceInfo.h"

@implementation UITableViewCell (Extends)

- (void)noneSelectedStyle
{
	UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
	selectedBackgroundView.backgroundColor = [UIColor clearColor];
	self.selectedBackgroundView = selectedBackgroundView;
}

- (void)separatorLeft:(CGFloat)left right:(CGFloat)right
{
	if (IS_IOS7)
	{
		self.separatorInset = UIEdgeInsetsMake(0, left, 0, right);
	}
}
@end
