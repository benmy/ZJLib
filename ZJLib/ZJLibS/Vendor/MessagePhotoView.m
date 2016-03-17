//
//  ZBShareMenuView.m
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-13.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "MessagePhotoView.h"
#import "ZJUtil.h"
#import "MWPhotoBrowser.h"
#import "TapImageView.h"
#import "ImgScrollView.h"
#import <mach/mach_time.h>

#define ItemStartX 10
#define ItemStartY 10
#define ItemSpace 5

@interface MessagePhotoView ()<MWPhotoBrowserDelegate, ImgScrollViewDelegate, TapImageViewDelegate>
{
    NSMutableArray* photos;
    
    ImgScrollView *myScrollView;
    
    UIView *markView;
    UIImageView *bigImage;
    TapImageView *scrollImageView;
    CGRect imgRect;
    UIImage* headImageDownload;
}
@property (strong, nonatomic) ZJCircularProgressView *progressView;

@end

@implementation MessagePhotoView
@synthesize photoMenuItems;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame WithType:(SetPhotoType)type{
    self = [super initWithFrame:frame];
    if (self) {
        _setPhotoType = type;
        [self setup];
        if (type != SetPhotoTypeNotification && type != SetPhotoTypeClassAlbum) {
            return [self initWithFrame:frame WithType:type WithMaxNumber:1];
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame WithType:(SetPhotoType)type WithMaxNumber:(int)maxNumber{
    self = [super initWithFrame:frame];
    if (self) {
        _setPhotoType = type;
        _maxNumber = maxNumber;
        if (type != SetPhotoTypeNotification && type != SetPhotoTypeClassAlbum) {
            UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMenu)];
            t.delegate = self;
            [self addGestureRecognizer:t];
            _maxNumber = 1;
        }else{
            [self setup];
        }
    }
    return self;
}

- (void)photoItemButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectePhotoMenuItem:atIndex:)]) {
        NSInteger index = sender.tag;
        if (index < self.photoMenuItems.count) {
            [self.delegate didSelectePhotoMenuItem:[self.photoMenuItems objectAtIndex:index] atIndex:index];
        }
    }
}

- (void)setup{
    _files = [NSMutableArray array];
    _deleteAttachs = [NSMutableArray array];
    photoMenuItems = [[NSMutableArray alloc]init];
    _ossFiles = [NSMutableArray array];
    _ossTempFiles = [NSMutableArray array];
    _tempFiles = [NSMutableArray arrayWithArray:_files];
    _tempPhotoMenuItems = [NSMutableArray arrayWithArray:photoMenuItems];
    if (_maxNumber == 0) {
        _maxNumber = 4;
    }
    
    if (_widthOfImage == 0) {
        _widthOfImage = ([UIScreen mainScreen].bounds.size.width - 35)/4;
    }
    if (_heightOfImage == 0) {
        _heightOfImage = ([UIScreen mainScreen].bounds.size.width - 35)/4;
    }
    
    if (_setPhotoType == SetPhotoTypeHeadImage) {
//        [self initHeadImage:[MCDataMgr shared].userInfo.headPortrait];
    }else if (_setPhotoType != SetPhotoTypeNotification && _setPhotoType != SetPhotoTypeClassAlbum) {
        [self initHeadImage:[UIImage imageNamed:@"icon_defaultavatar_square"]];
    }else{
        [self initlizerView:self.photoMenuItems];
    }
}

- (void)setPhotoMenuItems:(NSMutableArray *)photoItems{
    photoMenuItems = photoItems;
    _tempPhotoMenuItems = [NSMutableArray arrayWithArray:photoMenuItems];
}

- (void)setFiles:(NSMutableArray *)files {
    _files = files;
    _tempFiles = [NSMutableArray arrayWithArray:_files];
}

- (void)setOssFiles:(NSMutableArray *)files {
    _ossFiles = files;
    _ossTempFiles = [NSMutableArray arrayWithArray:_ossFiles];
}

- (void)initHeadImage:(id)head{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    MessagePhotoMenuItem *photoItem = [[MessagePhotoMenuItem alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.height - 20, self.frame.size.height - 20)];
    if (_setPhotoType == SetPhotoTypeHeadImage) {
        [photoItem setFrameLeft:self.frame.size.width - self.frame.size.height - 20];
        imgRect = CGRectMake(photoItem.frame.origin.x, 89, photoItem.frame.size.width, photoItem.frame.size.height);
    }else if(_setPhotoType == SetPhotoTypeChildHeadImage){
        [photoItem setFrameSize:CGSizeMake(60, 60)];
        [photoItem setFrameTop:(self.frame.size.height - photoItem.frame.size.height) / 2];
        [photoItem setFrameLeft:self.frame.size.width - 90];
        imgRect = CGRectMake(self.frame.size.width - 100, (self.frame.size.height - photoItem.frame.size.height) / 2 + 64 + 15, 60, 60);
    }else if(_setPhotoType == SetPhotoTypeClassHeadImage){
        [photoItem setFrameSize:CGSizeMake(photoItem.frame.size.width, photoItem.frame.size.height)];
        [photoItem setFrameTop:(self.frame.size.height - photoItem.frame.size.height) / 2];
//        [photoItem setFrameLeft:0];
        imgRect = CGRectMake(self.frame.size.width - photoItem.frame.size.width, (self.frame.size.height - photoItem.frame.size.height) / 2 + 64 + 15, photoItem.frame.size.width, photoItem.frame.size.height);
    }
    [photoItem roundedViewWithRadius:5];
    if ([head isKindOfClass:[NSString class]]) {
        if (_setPhotoType == SetPhotoTypeClassHeadImage) {
            [photoItem setContentImage:[UIImage imageNamed:@"icon_DefaultClass"] andHImage:nil];
        }else{
            [photoItem setContentImage:[UIImage imageNamed:@"icon_defaultavatar_square"] andHImage:nil];
        }
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:head options:SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image) {
                [photoItem setContentImage:[image squareThumbnailWithSize:CGSizeMake(self.frame.size.height, self.frame.size.height)] andHImage:nil];
//                [self.photoMenuItems replaceObjectAtIndex:0 withObject:head];
                headImageDownload = image;
            }
        }]; // 将需要缓存的图片加载进来
    }else if(!head) {
        [photoItem setContentImage:[UIImage imageNamed:@"btn_portrait_nor"] andHImage:[UIImage imageNamed:@"btn_portrait_click"]];
    }else{
        [photoItem setContentImage:head andHImage:nil];
        if (self.photoMenuItems.count > 0) {
            [self.photoMenuItems replaceObjectAtIndex:0 withObject:head];
        }else{
            [self.photoMenuItems addObject:head];
        }
        headImageDownload = head;
    }
    if (_setPhotoType == SetPhotoTypeHeadImageFirst) {
        [photoItem roundedViewWithRadius:self.frame.size.height / 2 - 10];
    }
    photoItem.delegate = self;
    [self addSubview:photoItem];
}

#pragma mark -
#pragma mark - custom delegate
- (void) tappedWithObject:(id)sender
{
    bigImage.alpha = 1.0;
    markView.alpha = 1.0;
    [self bringSubviewToFront:myScrollView];
    
    [self setAnimation];
}

- (void) tapImageViewTappedWithObject:(id)sender
{
    [myScrollView removeFromSuperview];
//    myScrollView.zoomScale = 1.0;
//    
//    //        [self.view addSubview:scrollImageView];
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        markView.alpha = 0;
//        bigImage.alpha = 0;
//    }];
//    
//    //    [UIView animateWithDuration:0.3 animations:^{
//    bigImage.frame = imgRect;
//    //    } completion:^(BOOL finished) {
//    //
//    //    }];
//    [self sendSubviewToBack:myScrollView];
}

- (void) setAnimation
{
    UIImage *image = bigImage.image;
    
    float tmpFlab = image.size.width/[UIScreen mainScreen].bounds.size.width;
    
    float tmpHeight = image.size.height/tmpFlab;
    
    myScrollView.maximumZoomScale = [UIScreen mainScreen].bounds.size.height/tmpHeight;
    
    CGRect rect = CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2 - tmpHeight/2, [UIScreen mainScreen].bounds.size.width, tmpHeight);
    [UIView animateWithDuration:0.3 animations:^{
        bigImage.frame = rect;
    }];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return bigImage;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = bigImage.frame;
    CGSize contentSize = scrollView.contentSize;
    
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    
    // center horizontally
    if (imgFrame.size.width <= boundsSize.width)
    {
        centerPoint.x = boundsSize.width/2;
    }
    
    // center vertically
    if (imgFrame.size.height <= boundsSize.height)
    {
        centerPoint.y = boundsSize.height/2;
    }
    
    bigImage.center = centerPoint;
    
}

- (void)initlizerView:(NSArray *)imgList{
//    uint64_t begin = mach_absolute_time();
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for(int i = 0;i < imgList.count; i++){
        MessagePhotoMenuItem *photoItem = [[MessagePhotoMenuItem alloc]initWithFrame:CGRectMake(ItemStartX + (i % 4) * (_widthOfImage + ItemSpace), i / 4 * (_heightOfImage + ItemSpace), _widthOfImage, _heightOfImage)];
        photoItem.delegate = self;
        photoItem.index = i;
        [photoItem setContentImage:[[UIImage imageNamed:@"notice_default"] squareThumbnailWithSize:CGSizeMake(_widthOfImage, _widthOfImage)] andHImage:nil];

        if ([imgList[i] respondsToSelector:@selector(defaultRepresentation)]) {
            ALAsset *asset = imgList[i];
            UIImage *tempImg = [UIImage imageWithCGImage:asset.thumbnail];
            if (IS_IOS9) {
                tempImg = [[UIImage imageWithCGImage:asset.aspectRatioThumbnail] squareThumbnailWithSize:CGSizeMake(_widthOfImage, _widthOfImage)];
            }
            [photoItem setContentImage:tempImg andHImage:nil];
//        }else if ([imgList[i] isKindOfClass:[MCAttach class]]) {
//            MCAttach* attach = imgList[i];
//            SDWebImageManager *manager = [SDWebImageManager sharedManager];
//            [manager downloadImageWithURL:[NSURL URLWithString:attach.thumbnail] options:SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                if (image) {
//                    [photoItem setContentImage:[ZJUtil squareImageFromImage:image scaledToSize:_widthOfImage * 4] andHImage:nil];
//                }
//            }]; // 将需要缓存的图片加载进来
        }else{
            [photoItem setContentImage:[imgList[i] squareThumbnailWithSize:CGSizeMake(_widthOfImage, _widthOfImage)] andHImage:nil];
        }
        
        [self addSubview:photoItem];
    }
//    uint64_t end = mach_absolute_time();
//    NSLog(@"总耗时 %f 毫秒", MachTimeToSecs(end - begin) * 1000);
    if(imgList.count < _maxNumber && imgList.count > 0){
        UIButton *btnphoto =[ UIButton buttonWithType:UIButtonTypeCustom];
        [btnphoto setFrame:CGRectMake(ItemStartX + (_widthOfImage + ItemSpace) * (imgList.count % 4), imgList.count / 4 * (_heightOfImage + ItemSpace), _widthOfImage, _widthOfImage)];
        [btnphoto setBackgroundImage:[UIImage imageNamed:@"btn_addpic_nor"] forState:UIControlStateNormal];
        [btnphoto setBackgroundImage:[UIImage imageNamed:@"btn_addpic_click"] forState:UIControlStateHighlighted];
        //给添加按钮加点击事件
        [btnphoto addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnphoto];
    }
    [self setFrameHeight:imgList.count / 4 * (_heightOfImage + ItemSpace) + _heightOfImage];
}

//double MachTimeToSecs(uint64_t time)
//{
//    mach_timebase_info_data_t timebase;
//    mach_timebase_info(&timebase);
//    return (double)time * (double)timebase.numer /  (double)timebase.denom / 1e9;
//}

- (void)openMenu{
    if ([self.delegate respondsToSelector:@selector(removeInputResponser)]) {
        [self.delegate removeInputResponser];
    }
    //在这里呼出下方菜单按钮项
    myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles:@"拍照",@"从手机相册获取", nil];
    //刚才少写了这一句
    [myActionSheet showInView:self.window];
}

//下拉菜单的点击响应事件
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == myActionSheet.cancelButtonIndex){
        //NSLog(@"取消");
    }
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self localPhoto];
            break;
        default:
            break;
    }
}

//开始拍照
- (void)takePhoto{
    //判断相机是否能够使用
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(status == AVAuthorizationStatusAuthorized) {
        // authorized
        [self loadImagePickerController];
    } else if(status == AVAuthorizationStatusDenied){
        // denied
        [self CameraDeniedTip];
        return ;
    } else if(status == AVAuthorizationStatusRestricted){
        [self CameraDeniedTip];
        return;
        // restricted
    } else if(status == AVAuthorizationStatusNotDetermined){
        // not determined
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                [self loadImagePickerController];
            } else {
                return;
            }
        }];
    }
}

- (void)loadImagePickerController{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        //        picker.modalPresentationStyle = UIModalPresentationCurrentContext;
        //        picker.sourceType = sourceType;
        //        picker.delegate = self;
        picker.delegate = self;
        picker.sourceType = sourceType;
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        picker.showsCameraControls = YES;
        picker.cameraViewTransform = CGAffineTransformMakeRotation(M_PI * 45 / 180);
        picker.cameraViewTransform = CGAffineTransformMakeScale(1.5, 1.5);
        if (_setPhotoType != SetPhotoTypeNotification && _setPhotoType != SetPhotoTypeClassAlbum) {
            picker.allowsEditing = YES;
        }
        
        [self.delegate addUIImagePicker:picker];
    }else{
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

- (void)CameraDeniedTip{
    ZJCustomAlertView *alert = [[ZJCustomAlertView alloc]initWithTitle:NSLocalizedString(@"note", nil) contentText:@[NSLocalizedString(@"camera_denied", nil)] leftButtonTitle:NSLocalizedString(@"ok", nil) rightButtonTitle:nil withAlertViewType:ZJCustomAlertViewNormal];
    [alert show];
}

/*
    新加的另外的方法
 */

//打开相册，可以多选
- (void)localPhoto{
    if (_setPhotoType != SetPhotoTypeNotification && _setPhotoType != SetPhotoTypeClassAlbum) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            picker.sourceType = sourceType;
            picker.delegate = self;
            picker.allowsEditing = YES;
            
            [self.delegate addUIImagePicker:picker];
        }else{
            //NSLog(@"模拟其中无法打开照相机,请在真机中使用");
        }
    }else{
        ZJAssetPickerController *picker = [[ZJAssetPickerController alloc]init];
        
        picker.maximumNumberOfSelection = _maxNumber;
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups = NO;
        picker.delegate = self;
        picker.indexPathsForSelectedItems = self.photoMenuItems;
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject,NSDictionary *bindings){
            if ([[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyType]isEqual:ALAssetTypeVideo]) {
                NSTimeInterval duration = [[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyDuration]doubleValue];
                return duration >= 5;
            }else{
                return  YES;
            }
        }];
        
        [self.delegate addPicker:picker];
    }
}

#pragma mark - ZYQAssetPickerController Delegate
/*
 得到选中的图片
 */
- (void)assetPickerController:(ZJAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
//    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    _files = _tempFiles;
    _ossFiles = _ossTempFiles;
    photoMenuItems = _tempPhotoMenuItems;
    if (_setPhotoType == SetPhotoTypeNotification || _setPhotoType == SetPhotoTypeClassAlbum) {
        [self initlizerView:self.photoMenuItems];
        if ([self.delegate respondsToSelector:@selector(didFinishChooseAssets)]) {
            [self.delegate didFinishChooseAssets];
        }
    }
}

//取消
- (void)assetPickerControllerDidCancel:(ZJAssetPickerController *)picker{
//    [_tempPhotoMenuItems removeAllObjects];
//    [_tempFiles removeAllObjects];
//    [_ossTempFiles removeAllObjects];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//选择照片
- (void)assetPickerController:(ZJAssetPickerController *)picker didSelectAsset:(ALAsset *)asset{
    NSDictionary* file = [self addFile:asset withIndex:_files.count];
    [_tempFiles addObject:file];
    
    ZJFileHelper* fileh = [[ZJFileHelper alloc]init];
    NSString* filePath = [ZJFileHelper fileNameWithType:kDirectoryAlbum andExtension:kFileTypeJPG];
    if (_setPhotoType == SetPhotoTypeNotification) {
        filePath = [ZJFileHelper fileNameWithType:kDirectoryNotice andExtension:kFileTypeJPG];
    }
    fileh.filePath = filePath;
    fileh.fileData = [file objectForKey:@"fileData"];
    [_ossTempFiles addObject:fileh];
    
    if (_tempPhotoMenuItems && _tempPhotoMenuItems.count > 0) {
        [_tempPhotoMenuItems addObject:asset];
    }else{
        _tempPhotoMenuItems = [NSMutableArray arrayWithObjects:asset, nil];
    }
}

//取消选择照片
- (void)assetPickerController:(ZJAssetPickerController *)picker didDeselectAsset:(ALAsset *)asset{
    for (int i = 0; i < self.tempPhotoMenuItems.count; i++) {
        ALAsset* asset0 = (ALAsset*)self.tempPhotoMenuItems[i];
        if ([asset0.description isEqualToString:asset.description]) {
            NSInteger index = i - self.tempPhotoMenuItems.count + _tempFiles.count;
            [_tempFiles removeObjectAtIndex:index];
            [_ossTempFiles removeObjectAtIndex:index];
            [self.tempPhotoMenuItems removeObject:asset0];
            break;
        }
    }
}

//最多可以选择
- (void)assetPickerControllerDidMaximum:(ZJAssetPickerController *)picker{
    ZJCustomAlertView *alert = [[ZJCustomAlertView alloc]initWithTitle:NSLocalizedString(@"note", nil) contentText:@[[NSString stringWithFormat:@"最多选择%d张图片",(int)_maxNumber]] leftButtonTitle:NSLocalizedString(@"ok", @"") rightButtonTitle:nil withAlertViewType:ZJCustomAlertViewNormal];
    [alert show];
}

#pragma mark - UIImagePickerController Delegate
//选择拍照照片之后
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if([type isEqualToString:@"public.image"]){
        // Recover the snapped image
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        
        if (_setPhotoType != SetPhotoTypeNotification && _setPhotoType != SetPhotoTypeClassAlbum) {
            image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        }
        
        if (_setPhotoType == SetPhotoTypeNotification || _setPhotoType == SetPhotoTypeClassAlbum) {
            if (self.photoMenuItems.count != 0) {
                [self.photoMenuItems addObject:image];
            }else{
                self.photoMenuItems = [[NSMutableArray alloc]initWithObjects:image, nil];
            }
            [self initlizerView:self.photoMenuItems];
            NSDictionary* file = [self addFile:image withIndex:self.photoMenuItems.count - 1];
            [_files addObject:file];
            
            ZJFileHelper* fileh = [[ZJFileHelper alloc]init];
            NSString* filePath = [ZJFileHelper fileNameWithType:kDirectoryAlbum andExtension:kFileTypeJPG];
            if (_setPhotoType == SetPhotoTypeNotification) {
                filePath = [ZJFileHelper fileNameWithType:kDirectoryNotice andExtension:kFileTypeJPG];
            }
            fileh.filePath = filePath;
            fileh.fileData = [file objectForKey:@"fileData"];
            [_ossFiles addObject:fileh];
            
            if ([self.delegate respondsToSelector:@selector(didFinishChooseAssets)]) {
                [self.delegate didFinishChooseAssets];
            }
        }else if (_setPhotoType == SetPhotoTypeHeadImage){
//            [self initHeadImage:[ZJUtil squareImageFromImage:image scaledToSize:self.frame.size.height]];
            [self uploadHead:image];
        }else{
            _headImage = image;
            [self initHeadImage:[_headImage squareThumbnailWithSize:CGSizeMake(self.frame.size.height, self.frame.size.height)]];
            if ([self.delegate respondsToSelector:@selector(setHeadCompleted:)]) {
                [self.delegate setHeadCompleted:[self setHead:_headImage]];
            }
        }
    }
}

- (void)uploadHead:(UIImage*)image{
//    [SVProgressHUD showWithStatus:NSLocalizedString(@"setHeading", @"") maskType:SVProgressHUDMaskTypeGradient];
//    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:[MCDataMgr shared].userInfo.sessionid, @"sessionid", nil];
//    NSDictionary* file = [self setHead:image];
//    [ZJAFNRequest accessAPI:kSetHead withFiles:@[file] withParams:dic success:^(NSDictionary *result) {
//        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"set_head_suc", @"")];
//        [self.photoMenuItems removeAllObjects];
//        [self.photoMenuItems addObject:image];
//        [self initHeadImage:[ZJUtil squareImageFromImage:[self.photoMenuItems objectAtIndex:0] scaledToSize:self.frame.size.height]];
//        [[MCDataMgr shared].userInfoDict setObject:[result objectForKey:@"headPortrait"] forKey:@"headPortrait"];
//        [[MCDataMgr shared]saveUserInfoDict];
//        [[MCDataMgr shared]loadUserInfoDict];
//        SDWebImageManager *manager = [SDWebImageManager sharedManager];
//        [manager.imageCache storeImage:image recalculateFromImage:NO imageData:UIImageJPEGRepresentation(image, 1) forKey:[result objectForKey:@"headPortrait"] toDisk:YES];
//        [[NSNotificationCenter defaultCenter]postNotificationName:kUserHeadSet object:nil];
//        headImageDownload = image;
//    } failure:^(NSString *errorHead, NSString *errorMsg, NSString *code) {
//        //NSLog(@"errorMsg:%@",errorMsg);
//        [SVProgressHUD showErrorWithStatus:errorMsg];
//        if ([NSString isEmpty:[MCDataMgr shared].userInfo.headPortrait]) {
//            [self initHeadImage:[UIImage imageNamed:@"icon_defaultavatar_square"]];
//        }else{
//            [self initHeadImage:[MCDataMgr shared].userInfo.headPortrait];
//        }
//    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Handle the end of the image write process
    if (!error){
        
    }
    else{
//        [[[RFAlertView alloc] initWithTitle:NSLocalizedString(@"note", @"") message:NSLocalizedString(@"save_photo_wrong", @"") buttonTitles:@[NSLocalizedString(@"ok", @"")] clickBlock:nil] show];
        //NSLog(@"Error writing to photo album: %@",[error localizedDescription]);
    }
}
/*
- (NSMutableArray*)setFiles{
    if (self.photoMenuItems.count == 0) {
        return nil;
    }
    //设置文件
    NSMutableArray *files = [NSMutableArray array];
    for (int i = 0; i < self.photoMenuItems.count; i++) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        UIImage* image;
        if ([[self.photoMenuItems objectAtIndex:i] respondsToSelector:@selector(defaultRepresentation)]) {
            ALAsset *asset = [self.photoMenuItems objectAtIndex:i];
            image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            [dic setValue:[NSString stringWithFormat:@"file%d.jpg",i] forKey:@"filename"];
        }else if([[self.photoMenuItems objectAtIndex:i] isKindOfClass:[UIImage class]]){
            image = [self.photoMenuItems objectAtIndex:i];
            [dic setValue:[NSString stringWithFormat:@"file%d.jpg",i] forKey:@"filename"];
        }else{
            continue;
        }
        
        //        //对图片大小进行压缩--
//        image = [ZJUtil thumbnailWithImage:image size:[UIScreen mainScreen].bounds.size];
        double q = 0.4;
        NSData *imageData = UIImageJPEGRepresentation(image, q);
        while (imageData.length / (1024*1024) >= 1 && q >= 0)  {
            q = q - 0.1;
            imageData = UIImageJPEGRepresentation(image, q);
        }
        [dic setValue:[NSString stringWithFormat:@"file%d", i+1] forKey:@"name"];
        [dic setValue:imageData forKey:@"fileData"];
        [dic setValue:@"image/jpeg" forKey:@"type"];
        
        [files addObject:dic];
    }
    return files;
}
*/

- (NSDictionary*)addFile:(id)data withIndex:(NSInteger)index{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    UIImage* image;
    if ([data respondsToSelector:@selector(defaultRepresentation)]) {
        ALAsset *asset = data;
        image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [dic setValue:[NSString stringWithFormat:@"file%ld.jpg",(long)index] forKey:@"filename"];
    }else if([data isKindOfClass:[UIImage class]]){
        image = data;
        [dic setValue:[NSString stringWithFormat:@"file%ld.jpg",(long)index] forKey:@"filename"];
//    } else if ([data isKindOfClass:[MCAttach class]]) {
//        MCAttach *attach = data;
//        NSURL *url = [NSURL URLWithString:attach.thumbnail];
//        NSData *urlData = [NSData dataWithContentsOfURL:url];
//        image = [UIImage imageWithData:urlData];
//        
//        [dic setValue:[NSString stringWithFormat:@"file%ld.jpg",(long)index] forKey:@"filename"];
    }
    
    //        //对图片大小进行压缩--
//    image = [ZJUtil thumbnailWithImage:image size:CGSizeMake([UIScreen mainScreen].bounds.size.width * 2, [UIScreen mainScreen].bounds.size.height * 2)];
    double q = 0.6;
    NSData *imageData = UIImageJPEGRepresentation(image, q);
    while (imageData.length / (1024*1024) >= 1 && q >= 0)  {
        q = q - 0.1;
        imageData = UIImageJPEGRepresentation(image, q);
    }
    [dic setValue:[NSString stringWithFormat:@"file%ld", (long)index + 1] forKey:@"name"];
    [dic setValue:imageData forKey:@"fileData"];
    [dic setValue:@"image/jpeg" forKey:@"type"];
    return dic;
}

- (NSDictionary*)setHead:(UIImage*)image{
    if (image) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:@"file.jpg" forKey:@"filename"];
        //        //对图片大小进行压缩--
        double q = 0.4;
//        image = [ZJUtil thumbnailWithImage:image size:CGSizeMake(80.0, 80.0)];
        NSData *imageData = UIImageJPEGRepresentation(image, q);
        while (imageData.length / (1024*1024) >= 1 && q >= 0)  {
            q = q - 0.1;
            imageData = UIImageJPEGRepresentation(image, q);
        }
        [dic setValue:@"file" forKey:@"name"];
        [dic setValue:imageData forKey:@"fileData"];
        [dic setValue:@"image/jpeg" forKey:@"type"];
        return dic;
    }
    return nil;
}

#pragma mark - MessagePhotoItemDelegate

- (void)showBig:(NSInteger)index{
    if ((_setPhotoType == SetPhotoTypeHeadImage || _setPhotoType == SetPhotoTypeChildHeadImage) && headImageDownload) {
        myScrollView = [[ImgScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        myScrollView.i_delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:myScrollView];
        //    imgScrollView.backgroundColor = [UIColor clearColor];
        //    imgScrollView.bouncesZoom = YES;
        //    imgScrollView.minimumZoomScale = 1.0;
        //    imgScrollView.delegate = self;
        //    imgScrollView.contentSize = imgScrollView.frame.size;
        
        markView = [[UIView alloc] initWithFrame:myScrollView.bounds];
        markView.backgroundColor = [UIColor blackColor];
        [myScrollView addSubview:markView];
        
        bigImage = [[UIImageView alloc] initWithFrame:imgRect];
        bigImage.image = headImageDownload;
        bigImage.contentMode = UIViewContentModeScaleAspectFill;
        bigImage.clipsToBounds = YES;
        [myScrollView addSubview:bigImage];
        
        [self setAnimation];
        return;
    }
    
    if (_setPhotoType == SetPhotoTypeClassHeadImage) {
        [self openMenu];
        return;
    }
    
//    [[UIApplication sharedApplication].keyWindow sendSubviewToBack:myScrollView];
//    //跳转到显示大图的页面
//    ZJBigPhotoViewController *big = [[ZJBigPhotoViewController alloc]init];
//    
//    big.images = [NSMutableArray arrayWithArray:self.photoMenuItems];
//    big.index = index;
//    big.delegate = self;
//
    photos = [NSMutableArray array];
    for (int i = 0; i < self.photoMenuItems.count; i++) {
        UIImage *tempImg;
        if ([[self.photoMenuItems objectAtIndex:i] respondsToSelector:@selector(defaultRepresentation)]) {
            ALAsset *asset = [self.photoMenuItems objectAtIndex:i];
            tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            [photos addObject:[MWPhoto photoWithImage:tempImg]];
//        }else if([[self.photoMenuItems objectAtIndex:i] isKindOfClass:[MCAttach class]]){
//            MCAttach* attach = [self.photoMenuItems objectAtIndex:i];
//            [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:attach.file]]];
        }else if([[self.photoMenuItems objectAtIndex:i] isKindOfClass:[NSString class]]){
            NSString* url = [self.photoMenuItems objectAtIndex:i];
            [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:url]]];
        }else{
            [photos addObject:[MWPhoto photoWithImage:[self.photoMenuItems objectAtIndex:i]]];
        }
    }

    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    browser.displayDeleteButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = NO; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    //    browser.wantsFullScreenLayout = YES; // iOS 5 & 6 only: Decide if you want the photo browser full screen, i.e. whether the status bar is affected (defaults to YES)
    
    // Optionally set the current visible photo before displaying
    [browser setCurrentPhotoIndex:index];
    
    if ([self.delegate respondsToSelector:@selector(addBigController:)]) {
        [self.delegate addBigController:browser];
    }else{
        [self openMenu];
    }
}
#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < photos.count)
        return [photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < photos.count)
        return [photos objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser deleteButtonPressedForPhotoAtIndex:(NSUInteger)index{
//    if ([[self.photoMenuItems objectAtIndex:index] isKindOfClass:[MCAttach class]]) {
//        MCAttach* attach = [self.photoMenuItems objectAtIndex:index];
//        [_deleteAttachs addObject:[NSString stringWithLongLong:[attach.attachid longLongValue]]];
//        [[MCDataMgr shared].db removeAttach:[attach.attachid longLongValue] withType:0];
//        [[MCDataMgr shared].db save];
//    } else {
        NSInteger newIndex = index;
        if (self.photoMenuItems.count > _files.count) {
            NSInteger oldIndex = self.photoMenuItems.count - _files.count;
            newIndex = oldIndex - index;
        }
        if (_files.count > newIndex) {
            [_files removeObjectAtIndex:newIndex];
            if (_tempFiles.count != _files.count) {
                [_tempFiles removeObjectAtIndex:newIndex];
            }
        }
        
        if (_ossFiles.count > newIndex) {
            [_ossFiles removeObjectAtIndex:newIndex];
            if (_ossTempFiles.count != _files.count) {
                [_ossTempFiles removeObjectAtIndex:newIndex];
            }
        }
//    }
    
    NSMutableString* deletes = [[NSMutableString alloc]initWithString:@""];
    if (_deleteAttachs.count > 1) {
        for (int i = 0; i < _deleteAttachs.count - 1; i++) {
            [deletes appendFormat:@"%@,",[_deleteAttachs objectAtIndex:i]];
        }
        [deletes appendString:[_deleteAttachs lastObject]];
    }else{
        for (int i = 0; i < _deleteAttachs.count; i++) {
            [deletes appendString:[_deleteAttachs objectAtIndex:i]];
        }
    }
    _deletes = deletes;
    [self.photoMenuItems removeObjectAtIndex:index];
    if (self.photoMenuItems.count != _tempPhotoMenuItems.count && _tempPhotoMenuItems.count > 0) {
        [_tempPhotoMenuItems removeObjectAtIndex:index];
    }
    [photos removeObjectAtIndex:index];
    [photoBrowser reloadData];
    [self initlizerView:self.photoMenuItems];
    if (self.photoMenuItems.count == 0) {
        [self setFrameHeight:10];
        if ([self.delegate respondsToSelector:@selector(deleteAllPhotoes)]) {
            [self.delegate deleteAllPhotoes];
        }
        [photoBrowser popBackMe];
    }
    if ([self.delegate respondsToSelector:@selector(reloadPhotoes:)]) {
        [self.delegate reloadPhotoes:self.photoMenuItems];
    }
    if ([self.delegate respondsToSelector:@selector(deletePhotoAtIndex:)]) {
        [self.delegate deletePhotoAtIndex:index];
    }
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        _files = [NSMutableArray arrayWithArray:[self setFiles]];
//    });
}
//#pragma mark - MCBigPhotoViewControllerDelegate
//
- (void)didDeleteButtonAtIndex:(NSInteger)index{
//    if ([[self.photoMenuItems objectAtIndex:index] isKindOfClass:[MCAttach class]]) {
//        MCAttach* attach = [self.photoMenuItems objectAtIndex:index];
//        [_deleteAttachs addObject:[NSString stringWithLongLong:[attach.attachid longLongValue]]];
//        [[MCDataMgr shared].db removeAttach:[attach.attachid longLongValue] withType:3];
//        [[MCDataMgr shared].db save];
//    }
//    NSMutableString* deletes = [[NSMutableString alloc]initWithString:@""];
//    if (_deleteAttachs.count > 1) {
//        for (int i = 0; i < _deleteAttachs.count - 1; i++) {
//            [deletes appendFormat:@"%@,",[_deleteAttachs objectAtIndex:i]];
//        }
//        [deletes appendString:[_deleteAttachs lastObject]];
//    }else{
//        for (int i = 0; i < _deleteAttachs.count; i++) {
//            [deletes appendString:[_deleteAttachs objectAtIndex:i]];
//        }
//    }
//    _deletes = deletes;
//    [self.photoMenuItems removeObjectAtIndex:index];
//    if (self.photoMenuItems.count == 0) {
//        [self setFrameHeight:10];
//        if ([self.delegate respondsToSelector:@selector(deleteAllPhotoes)]) {
//            [self.delegate deleteAllPhotoes];
//        }
//    }else{
//        [self initlizerView:self.photoMenuItems];
//    }
////    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
////    dispatch_async(queue, ^{
////        _files = [NSMutableArray arrayWithArray:[self setFiles]];
////    });
}
@end
