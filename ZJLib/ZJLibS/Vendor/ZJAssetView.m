//
//  ZJAssetView.m
//  ZJUtils
//
//  Created by 朱佳伟 on 15/3/13.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import "ZJAssetView.h"
#import "NSDate+Extends.h"

#define kThumbnailLength    ([UIScreen mainScreen].bounds.size.width - 8) / 4
#define kThumbnailSize      CGSizeMake(kThumbnailLength, kThumbnailLength)

@implementation ZJAssetView

static UIFont *titleFont = nil;

static CGFloat titleHeight;
static UIColor *titleColor;

+ (void)initialize
{
    titleFont       = [UIFont systemFontOfSize:12];
    titleHeight     = 20.0f;
    titleColor      = [UIColor whiteColor];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.opaque                     = YES;
        self.isAccessibilityElement     = YES;
        self.accessibilityTraits        = UIAccessibilityTraitImage;
        
        _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kThumbnailSize.width, kThumbnailSize.height)];
        [self addSubview:_imageView];
        
        _videoTitle=[[ZJVideoTitleView alloc] initWithFrame:CGRectMake(0, kThumbnailSize.height-20, kThumbnailSize.width, titleHeight)];
        _videoTitle.hidden=YES;
        _videoTitle.font=titleFont;
        _videoTitle.textColor=titleColor;
        _videoTitle.textAlignment=NSTextAlignmentRight;
        _videoTitle.backgroundColor=[UIColor clearColor];
        [self addSubview:_videoTitle];
        
        _tapAssetView=[[ZJTapAssetView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _tapAssetView.delegate=self;
        [self addSubview:_tapAssetView];
    }
    
    return self;
}

- (void)bind:(ALAsset *)asset selectionFilter:(NSPredicate*)selectionFilter isSeleced:(BOOL)isSeleced
{
    self.asset = asset;
//    [_imageView setImage:[ZJUtil squareImageFromImage:[UIImage imageWithCGImage:asset.aspectRatioThumbnail] scaledToSize:_imageView.frame.size.width]];
    [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    [_imageView setClipsToBounds:YES];
    [_imageView setImage:[UIImage imageWithCGImage:asset.aspectRatioThumbnail]];
    
    if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
        _videoTitle.hidden=NO;
        _videoTitle.text=[NSDate timeDescriptionOfTimeInterval:[[asset valueForProperty:ALAssetPropertyDuration] doubleValue]];
    }
    else{
        _videoTitle.hidden=YES;
    }
    
    _tapAssetView.disabled = ![selectionFilter evaluateWithObject:asset];
    
    _tapAssetView.selected = isSeleced;
}

#pragma mark - ZTapAssetView Delegate

- (BOOL)shouldTap:(BOOL)select{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(shouldSelectAsset:with:)]) {
        return [_delegate shouldSelectAsset:_asset with:select];
    }
    return YES;
}

- (void)touchSelect:(BOOL)select{
    if (_delegate!=nil&&[_delegate respondsToSelector:@selector(tapSelectHandle:asset:)]) {
        [_delegate tapSelectHandle:select asset:_asset];
    }
}
@end
