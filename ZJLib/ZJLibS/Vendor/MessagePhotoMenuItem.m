//
//  MessagePhotoMenuItem.m
//  testKeywordDemo
//
//  Created by mei on 14-7-26.
//  Copyright (c) 2014年 Bluewave. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "MessagePhotoMenuItem.h"

@implementation MessagePhotoMenuItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _thumb = [UIButton buttonWithType:UIButtonTypeCustom];
        _thumb.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [_thumb setEnlargeEdgeWithTop:150 right:150 bottom:80 left:80];
        [_thumb addTarget:self action:@selector(showBig:) forControlEvents:UIControlEventTouchUpInside];
        [_thumb setContentMode:UIViewContentModeScaleAspectFill];
        [_thumb setClipsToBounds:YES];
        [self addSubview:_thumb];
//        _progressView = [[ZJCircularProgressView alloc] initWithFrame:CGRectMake((self.frame.size.width - 50) / 2, (self.frame.size.height - 50) / 2, 50.0f, 50.0f)];
//        _progressView.trackTintColor = [UIColor grayColor];
//        _progressView.progressTintColor = [UIColor lightGrayColor];
//        [self addSubview:_progressView];
//        [_progressView setHidden:YES];
    }
    return self;
}

- (void)setFrameSize:(CGSize)size{
    [super setFrameSize:size];
    [_thumb setFrameSize:size];
}

- (void)setContentImage:(UIImage *)contentImage andHImage:(UIImage *)hImage{
    [_thumb setImage:contentImage forState:UIControlStateNormal];
    if (hImage) {
        [_thumb setImage:hImage forState:UIControlStateNormal];
    }
}

/*
    预览
 */
- (void)showBig:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(showBig:)]){
        [self.delegate showBig:_index];
    }
}
@end
