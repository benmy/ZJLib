//
//  ZJAssetGroupViewCell.m
//  ZJUtils
//
//  Created by 朱佳伟 on 15/3/13.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import "ZJAssetGroupViewCell.h"

#define kThumbnailLength     78

@interface ZJAssetGroupViewCell ()

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

@end

@implementation ZJAssetGroupViewCell

- (void)bind:(ALAssetsGroup *)assetsGroup
{
    self.assetsGroup           = assetsGroup;

    CGImageRef posterImage     = assetsGroup.posterImage;
    size_t height              = CGImageGetHeight(posterImage);
    float scale                = height / kThumbnailLength;

    UIImage* image = [UIImage imageWithCGImage:posterImage scale:scale orientation:UIImageOrientationUp];
    self.imageView.image       = [ZJUtil squareImageFromImage:image scaledToSize:kThumbnailLength];
    self.textLabel.text        = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.detailTextLabel.text  = [NSString stringWithFormat:@"%ld", (long)[assetsGroup numberOfAssets]];
    UIView* accessView         = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, self.frame.size.height)];
    UIImageView* accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_enter"]];
    [accessoryView setFrameTop:(self.frame.size.height - 18) / 2];
    [accessoryView setFrameLeft:40];
    [accessView addSubview:accessoryView];
    self.accessoryView         = accessView;
}

- (NSString *)accessibilityLabel
{
    NSString *label = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    return [label stringByAppendingFormat:NSLocalizedString(@"%ld 张照片", nil), (long)[self.assetsGroup numberOfAssets]];
}

@end
