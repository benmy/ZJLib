//
//  NSDate+Extensions.h
//  ZJLib
//
//  Created by 朱佳伟 on 16/2/16.
//  Copyright © 2016年 朱佳伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extensions)

/**
 *  获取年份
 *
 *  @return
 */
- (NSUInteger)year;
+ (NSUInteger)year:(NSDate *)date;

/**
 *  获取月份
 *
 *  @return
 */
- (NSUInteger)month;
+ (NSUInteger)month:(NSDate *)date;

/**
 *  获取日期
 *
 *  @return
 */
- (NSUInteger)day;
+ (NSUInteger)day:(NSDate *)date;

/**
 *  获取小时
 *
 *  @return
 */
- (NSUInteger)hour;
+ (NSUInteger)hour:(NSDate *)date;

/**
 *  获取分钟
 *
 *  @return
 */
- (NSUInteger)minute;
+ (NSUInteger)minute:(NSDate *)date;

/**
 *  获取秒
 *
 *  @return
 */
- (NSUInteger)second;
+ (NSUInteger)second:(NSDate *)date;

/**
 * 获取一年中的总天数
 */
- (NSUInteger)daysInYear;
+ (NSUInteger)daysInYear:(NSDate *)date;

/**
 * 判断是否是润年
 * @return YES表示润年，NO表示平年
 */
- (BOOL)isLeapYear;
+ (BOOL)isLeapYear:(NSDate *)date;

/**
 * 获取该日期是该年的第几周
 */
- (NSUInteger)weekOfYear;
+ (NSUInteger)weekOfYear:(NSDate *)date;

/**
 * 获取格式化为YYYY-MM-dd格式的日期字符串
 */
- (NSString *)formatYMD;
+ (NSString *)formatYMD:(NSDate *)date;

/**
 * 返回当前月一共有几周(可能为4,5,6)
 */
- (NSUInteger)weeksOfMonth;
+ (NSUInteger)weeksOfMonth:(NSDate *)date;

/**
 * 获取该月的第一天的日期
 */
- (NSDate *)begindayOfMonth;
+ (NSDate *)begindayOfMonth:(NSDate *)date;

/**
 * 获取该月的最后一天的日期
 */
- (NSDate *)lastdayOfMonth;
+ (NSDate *)lastdayOfMonth:(NSDate *)date;

/**
 * 返回day天后的日期(若day为负数,则为|day|天前的日期)
 */
- (NSDate *)dateAfterDay:(NSUInteger)day;
+ (NSDate *)dateAfterDate:(NSDate *)date day:(NSInteger)day;

/**
 * 返回day天后的日期(若day为负数,则为|day|天前的日期)
 */
- (NSDate *)dateAfterMonth:(NSUInteger)month;
+ (NSDate *)dateAfterDate:(NSDate *)date month:(NSInteger)month;

/**
 *  获取星期几
 *
 *  @return Return weekday number
 *  [1 - Sunday]
 *  [2 - Monday]
 *  [3 - Tuerday]
 *  [4 - Wednesday]
 *  [5 - Thursday]
 *  [6 - Friday]
 *  [7 - Saturday]
 */
- (NSInteger)weekday;
+ (NSInteger)weekday:(NSDate *)date;

/**
 *  获取星期几(名称)
 *
 *  @return Return weekday as a localized string
 *  [1 - Sunday]
 *  [2 - Monday]
 *  [3 - Tuerday]
 *  [4 - Wednesday]
 *  [5 - Thursday]
 *  [6 - Friday]
 *  [7 - Saturday]
 */
- (NSString *)dayFromWeekday;
+ (NSString *)dayFromWeekday:(NSDate *)date;

/**
 *  日期是否相等
 *
 *  @param anotherDate The another date to compare as NSDate
 *  @return Return YES if is same day, NO if not
 */
- (BOOL)isSameDay:(NSDate *)anotherDate;

/**
 *  是否是今天
 *
 *  @return Return if self is today
 */
- (BOOL)isToday;

/**
 *  Add days to self
 *
 *  @param days The number of days to add
 *  @return Return self by adding the gived days number
 */
- (NSDate *)dateByAddingDays:(NSUInteger)days;

/**
 *  Get the month as a localized string from the given month number
 *
 *  @param month The month to be converted in string
 *  [1 - January]
 *  [2 - February]
 *  [3 - March]
 *  [4 - April]
 *  [5 - May]
 *  [6 - June]
 *  [7 - July]
 *  [8 - August]
 *  [9 - September]
 *  [10 - October]
 *  [11 - November]
 *  [12 - December]
 *
 *  @return Return the given month as a localized string
 */
+ (NSString *)monthWithMonthNumber:(NSInteger)month;

/**
 * 根据日期返回字符串
 */
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format;
- (NSString *)stringWithFormat:(NSString *)format;
+ (NSDate *)dateWithString:(NSString *)string format:(NSString *)format;

/**
 * 获取指定月份的天数
 */
- (NSUInteger)daysInMonth:(NSUInteger)month;
+ (NSUInteger)daysInMonth:(NSDate *)date month:(NSUInteger)month;

/**
 * 获取当前月份的天数
 */
- (NSUInteger)daysInMonth;
+ (NSUInteger)daysInMonth:(NSDate *)date;

/**
 * 分别获取yyyy-MM-dd/HH:mm:ss/yyyy-MM-dd HH:mm:ss格式的字符串
 */
- (NSString *)ymdFormat;
- (NSString *)hmsFormat;
- (NSString *)ymdHmsFormat;
+ (NSString *)ymdFormat;
+ (NSString *)hmsFormat;
+ (NSString *)ymdHmsFormat;

/**
 *  通过毫秒数获取时间字符串, 格式为yyyy-MM-dd HH:mm:ss
 *
 *  @param millisecond
 *
 *  @return
 */
+ (NSString *)yyyyMMddHHmmssSince1970:(int64_t)millisecond;
- (NSString *)yyyyMMddHHmmss;

/**
 *  通过毫秒数获取时间字符串, 格式为yyyy-MM-dd
 *
 *  @param millisecond
 *
 *  @return
 */
+ (NSString *)yyyyMMddSince1970:(int64_t)millisecond;
- (NSString *)yyyyMMdd;

/**
 *  通过毫秒数获取时间字符串, 格式为yyyyMMddHHmmss
 *
 *  @param millisecond
 *
 *  @return
 */
+ (NSString *)yyyyMMddHHmmssTimestampSince1970:(int64_t)millisecond;
- (NSString *)yyyyMMddHHmmssTimestampSince1970;

/**
 *  获取当前时间的毫秒数
 *
 *  @return
 */
+ (int64_t)millisecondSince1970;

/**
 *  通过毫秒数获取NSDate
 *
 *  @param millisecond
 *
 *  @return
 */
+ (NSDate *)dateWithMillisecondSince1970:(int64_t)millisecond;
@end
