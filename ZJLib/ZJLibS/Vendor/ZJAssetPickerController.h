//
//  ZJAssetPickerController.h
//  ZJUtils
//
//  Created by 朱佳伟 on 15/3/13.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

//类似系统相册的图片选择，支持多选
//需要AssetsLibrary.Frameworks
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#pragma mark - ZJAssetPickerController

@protocol ZJAssetPickerControllerDelegate;

@interface ZJAssetPickerController : UINavigationController

@property (nonatomic, weak) id <UINavigationControllerDelegate, ZJAssetPickerControllerDelegate> delegate;

@property (nonatomic, strong) ALAssetsFilter *assetsFilter;

@property (nonatomic, copy) NSArray *indexPathsForSelectedItems;

@property (nonatomic, assign) NSInteger maximumNumberOfSelection;
@property (nonatomic, assign) NSInteger minimumNumberOfSelection;

@property (nonatomic, strong) NSPredicate *selectionFilter;

@property (nonatomic, assign) BOOL showCancelButton;

@property (nonatomic, assign) BOOL showEmptyGroups;

@property (nonatomic, assign) BOOL isFinishDismissViewController;

@end

@protocol ZJAssetPickerControllerDelegate <NSObject>

//Called after the user finish the selection.
- (void)assetPickerController:(ZJAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets;

@optional

- (void)assetPickerControllerDidCancel:(ZJAssetPickerController *)picker;

// Selection
// Called after the user changes the selection.
- (void)assetPickerController:(ZJAssetPickerController *)picker didSelectAsset:(ALAsset*)asset;
- (void)assetPickerController:(ZJAssetPickerController *)picker didDeselectAsset:(ALAsset*)asset;
- (void)assetPickerControllerDidMaximum:(ZJAssetPickerController *)picker;
- (void)assetPickerControllerDidMinimum:(ZJAssetPickerController *)picker;

@end
