//
//  ZJAssetGroupViewCell.h
//  ZJUtils
//
//  Created by 朱佳伟 on 15/3/13.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ZJAssetGroupViewCell : UITableViewCell

- (void)bind:(ALAssetsGroup *)assetsGroup;

@end
