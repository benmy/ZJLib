//
//  UIImage+Capture.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "UIImage+Capture.h"
#import <QuartzCore/QuartzCore.h>
#import "Macros.h"

@implementation UIImage (Capture)
/**
 *  @brief  截图指定view成图片
 *
 *  @param view 一个view
 *
 *  @return 图片
 */
+ (UIImage *)captureWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [UIScreen mainScreen].scale);
    // IOS7及其后续版本
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    } else { // IOS7之前的版本
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

/**
 *  @author Jakey
 *
 *  @brief  截图一个view中所有视图 包括旋转缩放效果
 *
 *  @param aView    指定的view
 *  @param maxWidth 宽的大小 0为view默认大小
 *
 *  @return 截图
 */
+ (UIImage *)screenshotWithView:(UIView *)aView limitWidth:(CGFloat)maxWidth{
    CGAffineTransform oldTransform = aView.transform;
    
    CGAffineTransform scaleTransform = CGAffineTransformIdentity;
    if (!isnan(maxWidth) && maxWidth>0) {
        CGFloat maxScale = maxWidth/CGRectGetWidth(aView.frame);
        CGAffineTransform transformScale = CGAffineTransformMakeScale(maxScale, maxScale);
        scaleTransform = CGAffineTransformConcat(oldTransform, transformScale);
    
    }
    if(!CGAffineTransformEqualToTransform(scaleTransform, CGAffineTransformIdentity)){
        aView.transform = scaleTransform;
    }
    
    CGRect actureFrame = aView.frame; //已经变换过后的frame
    CGRect actureBounds= aView.bounds;//CGRectApplyAffineTransform();
    
    //begin
    UIGraphicsBeginImageContextWithOptions(actureFrame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    //    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1, -1);
    CGContextTranslateCTM(context,actureFrame.size.width/2, actureFrame.size.height/2);
    CGContextConcatCTM(context, aView.transform);
    CGPoint anchorPoint = aView.layer.anchorPoint;
    CGContextTranslateCTM(context,
                          -actureBounds.size.width * anchorPoint.x,
                          -actureBounds.size.height * anchorPoint.y);
    if([aView respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
    {
        [aView drawViewHierarchyInRect:aView.bounds afterScreenUpdates:NO];
    }
    else
    {
        [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //end
    aView.transform = oldTransform;
    
    return screenshot;
}

- (UIImage *)getImageWithSize:(CGRect)myImageRect
{
    //定义myImageRect，截图的区域
    CGImageRef imageRef = self.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size;
    size.width = CGRectGetWidth(myImageRect);
    size.height = CGRectGetHeight(myImageRect);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    return smallImage;
}

- (UIImage *)imageScaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)captureWithSize:(CGSize)size
{
    CGFloat imgWidth = CGImageGetWidth(self.CGImage);
    CGFloat imgHeight = CGImageGetHeight(self.CGImage);
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat adjustImgWidth = 0;
    CGFloat adjustImgHeight = 0;
    UIImage *img_capture = nil;
    
    // 截取
    if ((imgHeight/height)>(imgWidth/width))
    {
        adjustImgWidth = imgWidth;
        adjustImgHeight = (imgWidth/width)*height;
        CGRect rect = CGRectMake(0, (imgHeight-adjustImgHeight)/2, adjustImgWidth, adjustImgHeight);
        CGImageRef imgRef = CGImageCreateWithImageInRect(self.CGImage, rect);
        img_capture=[UIImage imageWithCGImage:imgRef];
        CGImageRelease(imgRef);
    }
    else
    {
        adjustImgHeight = imgHeight;
        adjustImgWidth = (imgHeight/height)*width;
        CGRect rect = CGRectMake((imgWidth-adjustImgWidth)/2, 0, adjustImgWidth, adjustImgHeight);
        CGImageRef imgRef = CGImageCreateWithImageInRect(self.CGImage, rect);
        img_capture = [UIImage imageWithCGImage:imgRef];
        CGImageRelease(imgRef);
    }
    
    // 缩放
    UIImage* ret = [img_capture imageScaleToSize:CGSizeMake(width, height)];
    return [UIImage imageWithCGImage:ret.CGImage scale:1 orientation:self.imageOrientation];
}

/**
 *  从图片截取中间的一部分显示在指定asize中
 *
 *  @param image
 *  @param asize
 *
 *  @return
 */
- (UIImage *)squareThumbnailWithSize:(CGSize)asize
{
    CGAffineTransform scaleTransform;
    CGPoint origin;
    UIImage *newimage;
    if (nil == self) {
        newimage = nil;
    }else{
        CGSize oldsize = self.size;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            //image原始高度为200，缩放image的高度为400pixels，所以缩放比率为2
            CGFloat scaleRatio = asize.width / oldsize.width;
            scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
            //设置绘制原始图片的画笔坐标为CGPoint(-100, 0)pixels
            origin = CGPointMake(0, (asize.height/asize.width*oldsize.width - oldsize.height) / 2);
        }else{
            CGFloat scaleRatio = asize.height / oldsize.height;
            scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
            origin = CGPointMake((asize.width/asize.height*oldsize.height - oldsize.height) / 2, 0);
        }
        //创建画板为(400x400)pixels
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            UIGraphicsBeginImageContextWithOptions(asize, YES, 0);
        } else {
            UIGraphicsBeginImageContext(asize);
        }
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));
        
        //将image原始图片(400x200)pixels缩放为(800x400)pixels
        CGContextConcatCTM(context, scaleTransform);
        //origin也会从原始(-100, 0)缩放到(-200, 0)
        [self drawAtPoint:origin];
        
        //获取缩放后剪切的image图片
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    return newimage;
}

- (UIImage *)originImg
{
#ifdef __IPHONE_7_0
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
#else
    
    return self;
#endif
}

- (UIImage *)imageStretchWithLeft:(NSInteger)left top:(NSInteger)top
{
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, top, left) resizingMode:UIImageResizingModeStretch];
}

+ (NSData*)imageData:(UIImage*)image maxSize:(NSInteger)maxSize{
    CGSize iRect = image.size;
    CGSize fRect = CGSizeMake(Main_Screen_Width * Main_Screen_Scale, Main_Screen_Height * Main_Screen_Scale);
    CGSize newSize;;
    if (iRect.height / iRect.width >= fRect.height / fRect.width) {
        newSize = CGSizeMake(iRect.width * fRect.height/ iRect.height, fRect.height);
    }else{
        newSize = CGSizeMake(fRect.width, iRect.height * fRect.width/ iRect.width);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    double q = 1;
    NSData *imageData = UIImageJPEGRepresentation(newImage, q);
    while (imageData.length / maxSize >= 1 && q >= 0) {
        q = q - 0.1;
        imageData = UIImageJPEGRepresentation(newImage, q);
    }
    return imageData;
}
@end
