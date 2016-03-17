//
//  ZJAssetViewCell.h
//  ZJUtils
//
//  Created by 朱佳伟 on 15/3/13.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJAssetView.h"

@protocol ZJAssetViewCellDelegate;

@interface ZJAssetViewCell : UITableViewCell<ZJAssetViewDelegate>

@property(nonatomic,weak) id<ZJAssetViewCellDelegate> delegate;

- (void)bind:(NSArray *)assets selectionFilter:(NSPredicate*)selectionFilter minimumInteritemSpacing:(float)minimumInteritemSpacing minimumLineSpacing:(float)minimumLineSpacing columns:(int)columns assetViewX:(float)assetViewX;

@end

@protocol ZJAssetViewCellDelegate <NSObject>

- (BOOL)shouldSelectAsset:(ALAsset*)asset with:(BOOL)select;
- (void)didSelectAsset:(ALAsset*)asset;
- (void)didDeselectAsset:(ALAsset*)asset;

@end
