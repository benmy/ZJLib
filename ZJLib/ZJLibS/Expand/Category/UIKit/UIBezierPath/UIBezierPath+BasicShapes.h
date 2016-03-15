//
//  UIBezierPath+BasicShapes.h
//  Example
//
//  Created by Pierre Dulac on 26/02/13.
//  Copyright (c) 2013 Pierre Dulac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (BasicShapes)

/**
 *  爱心
 *
 *  @param originalFrame
 *
 *  @return
 */
+ (UIBezierPath *)heartShape:(CGRect)originalFrame;

/**
 *  人物头像
 *
 *  @param originalFrame
 *
 *  @return
 */
+ (UIBezierPath *)userShape:(CGRect)originalFrame;
+ (UIBezierPath *)martiniShape:(CGRect)originalFrame;
+ (UIBezierPath *)beakerShape:(CGRect)originalFrame;

/**
 *  五角星
 *
 *  @param originalFrame
 *
 *  @return
 */
+ (UIBezierPath *)starShape:(CGRect)originalFrame;
+ (UIBezierPath *)stars:(NSUInteger)numberOfStars shapeInFrame:(CGRect)originalFrame;

//基本path
/**
 *  三角形
 *
 *  @return
 */
+ (UIBezierPath *)defaultPath:(CGRect)originalFrame;
@end
