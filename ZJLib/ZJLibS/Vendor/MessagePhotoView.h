//
//  ZBShareMenuView.h
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-13.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>
#import "MessagePhotoMenuItem.h"
#import "ZJAssetPickerController.h"
#import "ZJBigPhotoViewController.h"
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger, SetPhotoType)
{
    SetPhotoTypeHeadImage = 0,
    SetPhotoTypeChildHeadImage = 1,
    SetPhotoTypeNotification = 2,
    SetPhotoTypeClassAlbum = 3,
    SetPhotoTypeHeadImageFirst = 4,
    SetPhotoTypeClassHeadImage = 5,
};


@protocol MessagePhotoViewDelegate <NSObject>

@optional
- (void)didSelectePhotoMenuItem:(MessagePhotoMenuItem *)shareMenuItem atIndex:(NSInteger)index;

- (void)didFinishChooseAssets;
- (void)setHeadCompleted:(NSDictionary*)file;

- (void)removeInputResponser;
- (void)addPicker:(ZJAssetPickerController *)picker;          //UIImagePickerController
- (void)addUIImagePicker:(UIImagePickerController *)picker;
- (void)addBigController:(UIViewController *)ctrl;
- (void)deleteAllPhotoes;
- (void)deletePhotoAtIndex:(NSInteger)index;
- (void)reloadPhotoes:(NSArray*)photoes;

@end

@interface MessagePhotoView : UIView<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,MessagePhotoItemDelegate,ZJAssetPickerControllerDelegate, ZJBigPhotoViewControllerDelegate, UIGestureRecognizerDelegate>{
    //下拉菜单
    UIActionSheet *myActionSheet;
}

@property (nonatomic, strong) NSMutableArray *photoMenuItems;
@property (nonatomic, strong) NSMutableArray *tempPhotoMenuItems;

@property (nonatomic, strong) NSMutableArray *files;
@property (nonatomic, strong) NSMutableArray *tempFiles;

@property (nonatomic, strong) NSMutableArray *ossFiles;
@property (nonatomic, strong) NSMutableArray *ossTempFiles;

@property (nonatomic, strong) NSMutableArray *deleteAttachs;

@property (nonatomic, strong) UIImage* headImage;
@property (nonatomic, strong) NSString *deletes;

@property (nonatomic, assign) SetPhotoType setPhotoType;

@property (nonatomic, assign, readonly) NSInteger maxNumber;

@property (nonatomic, assign) float widthOfImage;

@property (nonatomic, assign) float heightOfImage;

@property (nonatomic, assign) id <MessagePhotoViewDelegate> delegate;

//-(void)reloadDataWithImage:(UIImage *)image;

- (id)initWithFrame:(CGRect)frame WithType:(SetPhotoType)type;
- (id)initWithFrame:(CGRect)frame WithType:(SetPhotoType)type WithMaxNumber:(int)maxNumber;
- (void)initlizerView:(NSArray *)imgList;
- (void)initHeadImage:(id)head;

//弹出ActionSheet
- (void)openMenu;

//拍照
- (void)takePhoto;

//相册
- (void)localPhoto;

- (NSDictionary*)addFile:(id)data withIndex:(NSInteger)index;

@end
