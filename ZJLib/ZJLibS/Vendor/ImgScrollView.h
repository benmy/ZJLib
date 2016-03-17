//
//  ImgScrollView.h
//  TestLayerImage
//
//  Created by lcc on 14-8-1.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImgScrollViewDelegate <NSObject>

@optional

- (void) tapImageViewTappedWithObject:(id) sender;
- (void) longTapImageViewTappedWithObject:(id) sender;

@end

@interface ImgScrollView : UIScrollView

@property (weak) id<ImgScrollViewDelegate> i_delegate;

- (void) setContentWithFrame:(CGRect) rect;
- (void) setImage:(UIImage *) image;
- (void)setAnimationRect;
- (void) initRect;

@end
