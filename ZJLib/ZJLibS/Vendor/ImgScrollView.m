//
//  ImgScrollView.m
//  TestLayerImage
//
//  Created by lcc on 14-8-1.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "ImgScrollView.h"

@interface ImgScrollView()<UIScrollViewDelegate, UIActionSheetDelegate>
{
    //记录自己的位置
    CGRect scaleOriginRect;
    
    //图片的大小
    CGSize imgSize;
    
    //缩放前大小
    CGRect initRect;
    
    UIImageView *imgView;
    
    UIActionSheet* myActionSheet;
}

@end

@implementation ImgScrollView

- (void)dealloc
{
    _i_delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
//        self.bouncesZoom = YES;
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 3.0;
        
        imgView = [[UIImageView alloc] init];
        imgView.clipsToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imgView];

        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signalTap)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [self addGestureRecognizer:singleRecognizer];
        
        UITapGestureRecognizer* doubleTapRecognizer;
        doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTapRecognizer.numberOfTapsRequired = 2; // 单击
        [self addGestureRecognizer:doubleTapRecognizer];
        
        UILongPressGestureRecognizer *longpressGesutre = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongpressGesture:)];
        //长按时间为1秒
        longpressGesutre.minimumPressDuration = 0.5;
        //所需触摸1次
        longpressGesutre.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:longpressGesutre];
        
        [singleRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
        [doubleTapRecognizer requireGestureRecognizerToFail:longpressGesutre];
        [singleRecognizer requireGestureRecognizerToFail:longpressGesutre];
    }
    return self;
}

- (void)setContentWithFrame:(CGRect) rect
{
    imgView.frame = rect;
    initRect = CGRectMake(imgView.frame.origin.x + 10, imgView.frame.origin.y + 10, rect.size.width - 20, rect.size.height - 20);
}

- (void)setAnimationRect
{
    if (scaleOriginRect.size.height > 0 && scaleOriginRect.size.width > 0) {
        [UIView animateWithDuration:0.3 animations:^{
            imgView.frame = scaleOriginRect;
        }];
    }
}

- (void)initRect{
    self.zoomScale = 1;
    if (initRect.size.height > 0 && initRect.size.width > 0) {
        [UIView animateWithDuration:0.3 animations:^{
            imgView.frame = initRect;
        }];
    }
}

- (void)setImage:(UIImage *) image
{
    if (image)
    {
        imgView.image = image;
        imgSize = image.size;
        
        //判断首先缩放的值
        float scaleX = self.frame.size.width/imgSize.width;
        float scaleY = self.frame.size.height/imgSize.height;
        
        //倍数小的，先到边缘
        
        if (scaleX > scaleY)
        {
            //Y方向先到边缘
            float imgViewWidth = imgSize.width*scaleY;
            
            scaleOriginRect = (CGRect){self.frame.size.width/2-imgViewWidth/2,0,imgViewWidth,self.frame.size.height};
        }
        else
        {
            //X先到边缘
            float imgViewHeight = imgSize.height*scaleX;
            
            scaleOriginRect = (CGRect){0,self.frame.size.height/2-imgViewHeight/2,self.frame.size.width,imgViewHeight};
        }
    }
}

//下拉菜单的点击响应事件
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    [actionSheet removeFromSuperview];
    if(buttonIndex == myActionSheet.cancelButtonIndex){
        
    }
    switch (buttonIndex) {
        case 0:
            UIImageWriteToSavedPhotosAlbum(imgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            break;
        default:
            break;
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [SVProgressHUD showSuccessWithStatus:@"已保存"];
}

#pragma mark -
#pragma mark - scroll delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = imgView.frame;
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
    
    imgView.center = centerPoint;
}


#pragma mark - 单击处理
- (void)signalTap{
    if ([self.i_delegate respondsToSelector:@selector(tapImageViewTappedWithObject:)])
    {
        [self.i_delegate tapImageViewTappedWithObject:self];
    }
}

#pragma mark - 双击处理
- (void)doubleTap:(UIGestureRecognizer*)gesture{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    if (self.zoomScale == self.minimumZoomScale) {
        self.zoomScale = 2;
    }else{
        self.zoomScale = self.minimumZoomScale;
    }
    [UIView commitAnimations];
}

#pragma mark - 长按处理
- (void) handleLongpressGesture:(id) sender{
    UILongPressGestureRecognizer * longPress = (UILongPressGestureRecognizer*)sender;
    if (longPress.state == UIGestureRecognizerStateBegan) {
        //在这里呼出下方菜单按钮项
        myActionSheet = [[UIActionSheet alloc]
                         initWithTitle:nil
                         delegate:self
                         cancelButtonTitle:@"取消"
                         destructiveButtonTitle:nil
                         otherButtonTitles:@"保存图片", nil];
        //刚才少写了这一句
        [myActionSheet showInView:self];
    }
}
//- (void)handleLongpressGesture:(id)sender{
//    UILongPressGestureRecognizer * longPress = (UILongPressGestureRecognizer*)sender;
//    if (longPress.state == UIGestureRecognizerStateBegan) {
//        if ([self.i_delegate respondsToSelector:@selector(longTapImageViewTappedWithObject:)])
//        {
//            [self.i_delegate longTapImageViewTappedWithObject:self];
//        }
//    }
//}
@end
