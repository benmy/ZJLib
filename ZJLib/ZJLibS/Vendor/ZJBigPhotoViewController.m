//
//  ZJBigPhotoViewController.m
//  MyClass2
//
//  Created by 朱佳伟 on 14/12/3.
//  Copyright (c) 2014年 朱佳伟. All rights reserved.
//

#import "ZJBigPhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZJ.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface ZJBigPhotoViewController ()

@end

@implementation ZJBigPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.title = [NSString stringWithFormat:@"%d/%d",(int)_index + 1, (int)_images.count];
    self.navigationItem.leftBarButtonItem = [ZJUtil barBackBtnWithTarget:self action:@selector(popBack)];
    self.navigationItem.rightBarButtonItem = [ZJUtil barBtnWithImage:@"button_delete" target:self action:@selector(openMenu) WithRedPoint:NO];
    
    //设置透明
    [self.navigationController.navigationBar setTranslucent:YES];
    //    为什么要加这个呢，shadowImage 是在ios6.0以后才可用的。但是发现5.0也可以用。不过如果你不判断有没有这个方法，
//    //    而直接去调用可能会crash，所以判断下。作用：如果你设置了上面那句话，你会发现是透明了。但是会有一个阴影在，下面的方法就是去阴影
    if ([self.navigationController.navigationBar respondsToSelector:@selector(shadowImage)])
    {
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    
    
#ifdef __IPHONE_8_0
    if (IS_IOS8) {
        //设置滑动和点击隐藏navbar
//        self.navigationController.hidesBarsOnSwipe = YES;
        self.navigationController.hidesBarsOnTap = YES;
    }else{
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
        [self.view addGestureRecognizer:tapGesture];
    }
#else
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
    [self.view addGestureRecognizer:tapGesture];
#endif
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.pagingEnabled = YES;
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * _index, 0) animated:NO];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * _images.count, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = YES;
    _scrollView.minimumZoomScale = 0.3;
    _scrollView.maximumZoomScale = 3.0;
    _scrollView.delegate = self;
    
    [self.view addSubview:_scrollView];
    [self reload];
}

- (void)tapped{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2];
    self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
    [UIView commitAnimations];
}

- (void)popBack{
    [self.navigationController.navigationBar setTranslucent:NO];
#ifdef __IPHONE_8_0
    if (IS_IOS8) {
        //设置滑动和点击隐藏navbar
        self.navigationController.hidesBarsOnSwipe = NO;
        self.navigationController.hidesBarsOnTap = NO;
        self.navigationController.navigationBarHidden = NO;
    }else{
        self.navigationController.navigationBarHidden = NO;
    }
#else
    self.navigationController.navigationBarHidden = NO;
#endif
    [self popBackMe];
}

- (void)reload{
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * _index, 0) animated:NO];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * _images.count, 0);
    for (NSUInteger i = 0; i < _images.count; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"big_photo_placeholder"]];
        if ([_images[i] isKindOfClass:[NSString class]]) {
//            [imageView sd_setImageWithURL:[NSURL URLWithString:_images[i]] placeholderImage:[UIImage imageNamed:@"big_photo_placeholder"]];
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            CGSize mainSize = [UIScreen mainScreen].bounds.size;
            ZJCircularProgressView* progressView = [[ZJCircularProgressView alloc] initWithFrame:CGRectMake((mainSize.width - 50) / 2, (mainSize.height - 50) / 2, 50.0f, 50.0f)];
            [imageView addSubview:progressView];
            progressView.progress = 0.01;
            
            [manager downloadImageWithURL:[NSURL URLWithString:_images[i]] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                //NSLog(@"%ld %ld",receivedSize,expectedSize);
                progressView.progress = (float)receivedSize / expectedSize;
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                [progressView setHidden:YES];
                [progressView removeFromSuperview];
                if (image) {
                    imageView.image = image;
                    [self setImageViewFrame:imageView];
                }
            }]; // 将需要缓存的图片加载进来
            self.navigationItem.rightBarButtonItem = [ZJUtil barBtnWithImage:@"save_to_album" target:self action:@selector(saveToAlbum) WithRedPoint:NO];
        }else{
            UIImage* image;
            
            ALAsset *asset = _images[i];
            if ([asset respondsToSelector:@selector(defaultRepresentation)]) {
                image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            }else{
                image = _images[i];
            }
            
            imageView.image = image;
        }
        imageView.tag = i;
        [self setImageViewFrame:imageView];
        [_scrollView addSubview:imageView];
    }
}

- (void)setImageViewFrame:(UIImageView*)imageView{
    CGSize iRect = imageView.image.size;
    CGSize fRect = self.view.frame.size;
    if (iRect.height / iRect.width >= fRect.height / fRect.width) {
        [imageView setFrameLeft:(fRect.width - iRect.width * fRect.height/ iRect.height) / 2];
        [imageView setFrameTop:0];
        [imageView setFrameWidth:iRect.width * fRect.height/ iRect.height];
        [imageView setFrameHeight:fRect.height];
    }else{
        [imageView setFrameLeft:0];
        [imageView setFrameTop:(fRect.height - iRect.height * fRect.width/ iRect.width) / 2];
        [imageView setFrameWidth:fRect.width];
        [imageView setFrameHeight:iRect.height * fRect.width/ iRect.width];
    }
}

//保存至相册
- (void)saveToAlbum{
    for (UIView* view in _scrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]] && view.tag == _index) {
            UIImageView* imageView = (UIImageView*)view;
            UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Handle the end of the image write process
    if (!error){
//        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"save_suc", nil)];
    }
    else{
//        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"save_wrong", nil)];
        NSLog(@"Error writing to photo album: %@", [error localizedDescription]);
    }
}

- (void)openMenu{
    //在这里呼出下方菜单按钮项
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles:@"删除", nil];
    //刚才少写了这一句
    [actionSheet showInView:self.view];
}

//下拉菜单的点击响应事件
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            [self deletePhoto];
            break;
        case 1:
            break;
        default:
            break;
    }
}

- (void)deletePhoto{
    [_images removeObjectAtIndex:_index];
    if([self.delegate respondsToSelector:@selector(didDeleteButtonAtIndex:)]){
        [self.delegate didDeleteButtonAtIndex:_index];
    }
    if (_images.count == 0) {
        [self popBack];
        return;
    }
    for (UIView* view in _scrollView.subviews)//把所有子页面删除掉
    {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    if (_index != 0) {
        _index --;
    }
    self.navigationItem.title = [NSString stringWithFormat:@"%d/%d",(int)_index + 1, (int)_images.count];
    [self reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //获取当前视图的宽度
    CGFloat pageWith = scrollView.frame.size.width;
    //根据scrolView的左右滑动,对pageCotrol的当前指示器进行切换(设置currentPage)
    int page = floor((_scrollView.contentOffset.x - pageWith/2)/pageWith) + 1;
    //切换改变页码，小圆点
    _index = page;
    self.navigationItem.title = [NSString stringWithFormat:@"%d/%d", (int)_index + 1, (int)_images.count];
//#ifdef __IPHONE_8_0
//    if (IS_IOS8) {
//        
//    }else{
//        self.navigationController.navigationBarHidden = YES;
//    }
//#else
//    self.navigationController.navigationBarHidden = YES;
//#endif
}
@end
