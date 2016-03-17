//
//  ZJAssetViewCell.m
//  ZJUtils
//
//  Created by 朱佳伟 on 15/3/13.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import "ZJAssetViewCell.h"
#import "ZJAssetViewController.h"

#define kThumbnailLength    ([UIScreen mainScreen].bounds.size.width - 8) / 4
#define kThumbnailSize      CGSizeMake(kThumbnailLength, kThumbnailLength)
@implementation ZJAssetViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)bind:(NSArray *)assets selectionFilter:(NSPredicate*)selectionFilter minimumInteritemSpacing:(float)minimumInteritemSpacing minimumLineSpacing:(float)minimumLineSpacing columns:(int)columns assetViewX:(float)assetViewX{
    
    if (self.contentView.subviews.count<assets.count) {
        for (int i=0; i<assets.count; i++) {
            if (i>((NSInteger)self.contentView.subviews.count-1)) {
                ZJAssetView *assetView = [[ZJAssetView alloc] initWithFrame:CGRectMake(assetViewX+(kThumbnailSize.width+minimumInteritemSpacing)*i, minimumLineSpacing-1, kThumbnailSize.width, kThumbnailSize.height)];
                [assetView bind:assets[i] selectionFilter:selectionFilter isSeleced:[self isAssetSelected:assets[i]]];
//                 [((ZJAssetViewController*)_delegate).indexPathsForSelectedItems containsObject:assets[i]]];
                assetView.delegate = self;
                [self.contentView addSubview:assetView];
            }
            else{
                ((ZJAssetView*)self.contentView.subviews[i]).frame=CGRectMake(assetViewX+(kThumbnailSize.width+minimumInteritemSpacing)*(i), minimumLineSpacing-1, kThumbnailSize.width, kThumbnailSize.height);
                [(ZJAssetView*)self.contentView.subviews[i] bind:assets[i] selectionFilter:selectionFilter isSeleced:[self isAssetSelected:assets[i]]];
            }
            
        }
        
    }
    else{
        for (int i = (int)self.contentView.subviews.count; i>0; i--) {
            if (i>assets.count) {
                [((ZJAssetView*)self.contentView.subviews[i-1]) removeFromSuperview];
            }
            else{
                ((ZJAssetView*)self.contentView.subviews[i-1]).frame=CGRectMake(assetViewX+(kThumbnailSize.width+minimumInteritemSpacing)*(i-1), minimumLineSpacing-1, kThumbnailSize.width, kThumbnailSize.height);
//                NSLog(@"asset:%@",assets[i-1]);
                [(ZJAssetView*)self.contentView.subviews[i-1] bind:assets[i-1] selectionFilter:selectionFilter isSeleced:[((ZJAssetViewController*)_delegate).indexPathsForSelectedItems containsObject:assets[i-1]]];
                [(ZJAssetView*)self.contentView.subviews[i-1] bind:assets[i-1] selectionFilter:selectionFilter isSeleced:[self isAssetSelected:assets[i-1]]];
            }
        }
    }
}

- (BOOL)isAssetSelected:(ALAsset*)asset{
    for (ALAsset* sAsset in ((ZJAssetViewController*)_delegate).indexPathsForSelectedItems) {
        if ([sAsset.description isEqualToString:asset.description]) {
            return YES;
        }
    }
    return NO;
}
#pragma mark - ZAssetView Delegate

- (BOOL)shouldSelectAsset:(ALAsset *)asset with:(BOOL)select{
    if (_delegate!=nil&&[_delegate respondsToSelector:@selector(shouldSelectAsset:with:)]) {
        return [_delegate shouldSelectAsset:asset with:select];
    }
    return YES;
}

- (void)tapSelectHandle:(BOOL)select asset:(ALAsset *)asset{
    if (select) {
        if (_delegate!=nil&&[_delegate respondsToSelector:@selector(didSelectAsset:)]) {
            [_delegate didSelectAsset:asset];
        }
    }
    else{
        if (_delegate!=nil&&[_delegate respondsToSelector:@selector(didDeselectAsset:)]) {
            [_delegate didDeselectAsset:asset];
        }
    }
}
@end
