//
//  NSString+Extends.h
//  VoiceRecorder
//
//  Created by 朱佳伟 on 14/11/25.
//  Copyright (c) 2014年 朱佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSString (Extends)

/**
 *  将json转化为字典或数组
 *
 *  @return 
 */
- (id)JSONValue;

/**
 *  将字符串的首尾空格去掉
 *
 *  @return
 */
- (NSString *)trim;

/**
 *  文字行数
 *
 *  @return 返回行数
 */
- (NSUInteger)numberOfLines;

/**
 *  返回字符串长度
 *
 *  @return
 */
- (NSInteger)charCount;

/**
 *  判断字符串是否为空
 *
 *  @param value 被检查的字符串
 *
 *  @return 布尔值,YES:字符串为为空字符串
 */
- (BOOL)isEmpty;

/**
 *  字符串为nil，即字符串对象不存在
 *
 *  @param value
 *
 *  @return
 */
+ (NSString *)ifNilToStr:(NSString *)value;

//下面的方法从基本数据类型的数据转化为字符串
+ (NSString *)stringWithInteger:(NSInteger)value;
+ (NSString *)stringWithLong:(long)value;
+ (NSString *)stringWithLongLong:(int64_t)value;
+ (NSString *)stringWithFloat:(float)value;
+ (NSString *)stringWithDouble:(double)value;

- (NSString *)stringByURLEncoding;
- (NSString *)stringByURLDecoding;
- (NSString *)stringByFilterSymbols:(NSArray *)symbols;
- (NSString *)stringByTTSFilter;

/**
 *  判断字符串是否为手机号码
 *
 *  @return
 */
- (BOOL)isPhone;

/**
 *  判断字符串是否为电子邮箱
 *
 *  @return
 */
- (BOOL)isEmail;

/**
 *  获取控件填充字符串占有的高度
 *
 *  @param font    字体
 *  @param width   控件宽度
 *
 *  @return 高度
 */
- (CGFloat)heightWithFont:(UIFont *)font width:(CGFloat)width;

/**
 *  获取控件填充字符串占有的宽度
 *
 *  @param font 字体
 *
 *  @return 宽度
 */
- (CGFloat)widthWithFont:(UIFont *)font;

/**
 *  生成MD5字符串
 *
 *  @return
 */
- (NSString *)toMD5;
@end

@interface NSMutableString (RFKit)

- (void)removeLastChar;

@end
