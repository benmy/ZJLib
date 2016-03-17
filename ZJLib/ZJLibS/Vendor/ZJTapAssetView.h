//
//  ZJTapAssetView.h
//  ZJUtils
//
//  Created by 朱佳伟 on 15/3/13.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZJTapAssetViewDelegate <NSObject>

-(void)touchSelect:(BOOL)select;
-(BOOL)shouldTap:(BOOL)select;

@end

@interface ZJTapAssetView : UIView

@property(nonatomic,retain)UIImageView *selectView;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL disabled;
@property (nonatomic, weak) id<ZJTapAssetViewDelegate> delegate;

@end
