//
//  MessagePhotoMenuItem.h
//  testKeywordDemo
//
//  Created by mei on 14-7-26.
//  Copyright (c) 2014年 Bluewave. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>
#import "ZJCircularProgressView.h"

@class MessagePhotoMenuItem;
@protocol MessagePhotoItemDelegate <NSObject>

- (void)showBig:(NSInteger)index;

@end

@interface MessagePhotoMenuItem : UIView

@property (nonatomic,weak)id<MessagePhotoItemDelegate> delegate;
@property (strong, nonatomic) ZJCircularProgressView *progressView;
@property (strong, nonatomic) UIButton* thumb;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong,readonly) UIImage *contentImage;

- (void)setContentImage:(UIImage *)contentImage andHImage:(UIImage *)hImage;
@end
