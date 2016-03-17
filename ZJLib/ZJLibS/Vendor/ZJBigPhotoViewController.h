//
//  ZJBigPhotoViewController.h
//  MyClass2
//
//  Created by 朱佳伟 on 14/12/3.
//  Copyright (c) 2014年 朱佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJCircularProgressView.h"

@protocol ZJBigPhotoViewControllerDelegate <NSObject>

- (void)didDeleteButtonAtIndex:(NSInteger)index;

@end
@interface ZJBigPhotoViewController :UIViewController<UIScrollViewDelegate, UIActionSheetDelegate>

@property (nonatomic, assign) id <ZJBigPhotoViewControllerDelegate> delegate;

@property (nonatomic, strong) UIScrollView * scrollView;
@property (strong, nonatomic) ZJCircularProgressView *progressView;
@property (nonatomic, strong) NSMutableArray* images;
@property (nonatomic, assign) NSInteger index;
@end
