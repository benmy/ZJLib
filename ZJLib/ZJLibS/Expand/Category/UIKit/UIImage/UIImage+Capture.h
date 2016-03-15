//
//  UIImage+Capture.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Capture)
/**
 *  @brief  截图指定view成图片
 *
 *  @param view 一个view
 *
 *  @return 图片
 */
+ (UIImage *)captureWithView:(UIView *)view;

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
+ (UIImage *)screenshotWithView:(UIView *)aView limitWidth:(CGFloat)maxWidth;

///截图（未测试是否可行）
- (UIImage *)getImageWithSize:(CGRect)myImageRect;

/**
 *  //对图片尺寸进行压缩--
 *
 *  @param size
 *
 *  @return 截图uiimage对象
 */
- (UIImage *)imageScaleToSize:(CGSize)size;

/**
 *  截图
 *
 *  @param size 目标图片的尺寸
 *
 *  @return 截图uiimage对象
 */
- (UIImage *)captureWithSize:(CGSize)size;

/**
 *  从图片截取中间的一部分显示在指定asize中
 *
 *  @param image 原图
 *  @param asize 目标图片的尺寸
 *
 *  @return 截图uiimage对象
 */
- (UIImage *)squareThumbnailWithSize:(CGSize)asize;

/**
 *  压缩图片
 *
 *  @param image   图片对象
 *  @param maxSize 压缩后最大图片 如不超过1M
 *
 *  @return 压缩后图片
 */
+ (NSData*)imageData:(UIImage*)image maxSize:(NSInteger)maxSize;

/**
 *  拉伸图片
 *
 *  @param left
 *  @param top
 *
 *  @return
 */
- (UIImage *)imageStretchWithLeft:(NSInteger)left top:(NSInteger)top;

@end
