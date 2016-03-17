//
//  ZJAssetView.h
//  ZJUtils
//
//  Created by 朱佳伟 on 15/3/13.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZJVideoTitleView.h"
#import "ZJTapAssetView.h"

@protocol ZJAssetViewDelegate <NSObject>

-(BOOL)shouldSelectAsset:(ALAsset*)asset with:(BOOL)select;
-(void)tapSelectHandle:(BOOL)select asset:(ALAsset*)asset;

@end

@interface ZJAssetView : UIView<ZJTapAssetViewDelegate>

@property (nonatomic, strong) ALAsset *asset;

@property (nonatomic, weak) id<ZJAssetViewDelegate> delegate;

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) ZJVideoTitleView *videoTitle;
@property (nonatomic, retain) ZJTapAssetView *tapAssetView;

- (void)bind:(ALAsset *)asset selectionFilter:(NSPredicate*)selectionFilter isSeleced:(BOOL)isSeleced;

@end
