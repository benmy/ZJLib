//
//  ZJDeviceInfo.h
//  ZJUtils
//
//  Created by 朱佳伟 on 15/3/12.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
typedef long NSInteger;
typedef unsigned long NSUInteger;
#else
typedef int NSInteger;
typedef unsigned int NSUInteger;
#endif

#define DECREASE_COUNT(v)	\
((v)>0 ? (--(v)) : 0)

#define VER(a,b,c)	\
((a) * 1000000 + (b) * 1000 + (c))

#define DICT_ADD_STR(dict, key, value)	\
[(dict) setObject:[NSString ifNilToStr:(value)] forKey:(key)]
#define DICT_ADD_INT_STR(dict, key, value)	\
[(dict) setObject:[NSString stringWithLongLong:(value)] forKey:(key)]
#define DICT_ADD_FLOAT_STR(dict, key, value)	\
[(dict) setObject:[NSString stringWithDouble:(value)] forKey:(key)]

#define J2Str(value)	\
[ZJDeviceInfo toStringWithJsonValue:value]

#define J2Integer(value)	\
[ZJDeviceInfo toIntegerWithJsonValue:value]

#define J2Int64(value)	\
[ZJDeviceInfo toInt64WithJsonValue:value]

#define J2Short(value)	\
[ZJDeviceInfo toShortWithJsonValue:value]

#define J2Float(value)	\
[ZJDeviceInfo toFloatWithJsonValue:value]

#define J2Double(value)	\
[ZJDeviceInfo toDoubleWithJsonValue:value]

#define J2Array(value)	\
[ZJDeviceInfo toArrayWithJsonValue:value]

#define J2Dict(value)	\
[ZJDeviceInfo toDictionaryWithJsonValue:value]

#define J2NumInteger(value)	\
[NSNumber numberWithInteger:[ZJDeviceInfo toIntegerWithJsonValue:value]]

#define J2NumInt64(value)	\
[NSNumber numberWithLongLong:[ZJDeviceInfo toInt64WithJsonValue:value]]

#define J2NumShort(value)	\
[NSNumber numberWithShort:[ZJDeviceInfo toShortWithJsonValue:value]]

#define J2NumFloat(value)	\
[NSNumber numberWithFloat:[ZJDeviceInfo toFloatWithJsonValue:value]]

#define J2NumDouble(value)	\
[NSNumber numberWithDouble:[ZJDeviceInfo toDoubleWithJsonValue:value]]

#define V2Str(value)	\
[NSString ifNilToStr:(value)]

#define V2NumInteger(value)	\
[NSNumber numberWithInteger:(value)]

#define V2NumInt64(value)	\
[NSNumber numberWithLongLong:(value)]

#define V2NumShort(value)	\
[NSNumber numberWithShort:(value)]

#ifndef IS_IOS70
#define IS_IOS70 ([ZJDeviceInfo iosVer] >= VER(7, 0, 0) && [ZJDeviceInfo iosVer] < VER(7, 1, 0))
#endif

#ifndef IS_IOS6
#define IS_IOS6	([ZJDeviceInfo iosVer] >= VER(6, 0, 0))
#endif

#ifndef IS_IOS7
#define IS_IOS7 ([ZJDeviceInfo iosVer] >= VER(7, 0, 0))
#endif

#ifndef IS_IOS8
#define IS_IOS8 ([ZJDeviceInfo iosVer] >= VER(8, 0, 0))
#endif

#ifndef IS_IOS9
#define IS_IOS9 ([ZJDeviceInfo iosVer] >= VER(9, 0, 0))
#endif

//#ifndef IS_IPHONE5
//	#define IS_IPHONE5 ([ZJDeviceInfo isIPhone5Type])
//#endif
//
//#ifndef IS_IPHONE6
//    #define IS_IPHONE6 ([ZJDeviceInfo isIPhone6Type])
//#endif
//
//#ifndef IS_IPHONE6P
//    #define IS_IPHONE6P ([ZJDeviceInfo isIPhone6PType])
//#endif
#ifndef IS_SIMULATOR
#define IS_SIMULATOR ([[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"i386"] || [[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"x86_64"])
#endif

#ifndef IS_IPHONE4
#define IS_IPHONE4 ([[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPhone3,1"] || [[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPhone3,2"] || [[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPhone3,3"] || [[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPhone4,1"])
#endif

#ifndef IS_IPHONE5
#define IS_IPHONE5 ([[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPhone6,2"] || [[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPhone6,1"] || [[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPhone5,1"] || [[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPhone5,2"] || [[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPhone5,3"] || [[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPhone5,4"])
#endif

#ifndef IS_IPHONE6
#define IS_IPHONE6 ([[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPhone7,2"])
#endif

#ifndef IS_IPHONE6P
#define IS_IPHONE6P ([[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPhone7,1"])
#endif

#ifndef IS_IPHONE6S
#define IS_IPHONE6S ([[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPhone8,1"])
#endif

#ifndef IS_IPHONE6SP
#define IS_IPHONE6SP ([[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPhone8,2"])
#endif

#ifndef IS_IPAD
#define IS_IPAD ([[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPad1,1"])
#endif

#ifndef IS_IPAD2
#define IS_IPAD2 ([[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPad2,1"] || [[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPad2,2"] || [[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPad2,3"] || [[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPad2,4"])
#endif

#ifndef IS_IPAD3
#define IS_IPAD3 ([[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPad3,1"] || [[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPad3,2"] || [[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPad3,3"])
#endif

#ifndef IS_IPAD4
#define IS_IPAD4 ([[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPad3,4"] || [[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPad3,5"] || [[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPad3,6"])
#endif

#ifndef IS_IPADAIR
#define IS_IPADAIR ([[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPad4,1"] || [[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPad4,2"] || [[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPad4,3"])
#endif

#ifndef IS_IPADMIN
#define IS_IPADMIN ([[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPad2,5"] || [[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPad2,6"] || [[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPad2,7"])
#endif

#ifndef IS_IPADMIN2
#define IS_IPADMIN2 ([[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPad4,4"] || [[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPad4,5"] || [[ZJDeviceInfo iphoneDeviceType] isEqualToString:@"iPad4,6"])
#endif

#pragma mark ZJDeviceInfo

@interface ZJDeviceInfo : NSObject

/**
 *  DebugMode or not
 *
 *  @return BOOL
 */
+ (BOOL)isDebugMode;

/**
 *  indicate what language the app is actually running in
 *
 *  @return
 */
+ (NSString *)preferredLanguage;

/**
 *  is English or not
 *
 *  @return BOOL
 */
+ (BOOL)isEnLanguage;

/**
 *  is Chinese or not
 *
 *  @return BOOL
 */
+ (BOOL)isCnLanguage;

/**
 *  set the ios version NSString to NSInteger
 *
 *  @param strVer An NSString containing the ios version
 *
 *  @return NSInteger
 */
+ (NSInteger)verStrToInt:(NSString *)strVer;

/**
 *  the ios version of the running device
 *
 *  @return
 */
+ (NSInteger)iosVer;		// XXX.XXX.XXX => XXXXXXXXX 例1.0.1 => 1000001

/**
 *  the app version running
 *
 *  @return
 */
+ (NSInteger)appVer;		// XXX.XXX.XXX => XXXXXXXXX 例1.0.1 => 1000001

/**
 *  An NSString containing the type of device, ex(iPhone5,1)
 *
 *  @return
 */
+ (NSString*)iphoneDeviceType;

/**
 *  set the Application badge number to 0
 */
+ (void)clearApplicationIconBadgeNumber;

/**
 *  set the Application badge number, --
 */
+ (void)setApplicationIconBadgeNumber;

/**
 *  判断对象是否存在
 *
 *  @param value id
 *
 *  @return BOOL
 */
+ (BOOL)isNil:(id)value;

+ (id<NSCoding>)objectWithSerializedObject:(id<NSCoding>)aSerializedObject;
+ (id)loadObjectFromNibName:(NSString *)aNibName class:(Class)aClass;

/**
 *  应用信息，版本号，build号，名称等
 *
 *  @return 
 */
+ (NSString *)fullVersion;
+ (NSString *)bundleVersion;
+ (NSString *)bundleBuild;
+ (NSString *)bundleIdentifier;
+ (NSString *)bundleDisplayName;
+ (NSString *)bundleName;

/**
 *  className of class object
 *
 *  @param cls
 *
 *  @return 
 */
+ (NSString *)className:(Class)cls;

/**
 *  name of selector
 *
 *  @param aSelector
 *
 *  @return
 */
+ (NSString *)selectorName:(SEL)aSelector;

//解析JSON数据至基本类型
+ (NSString *)toStringWithJsonValue:(id)value;
+ (NSInteger)toIntegerWithJsonValue:(id)value;
+ (int64_t)toInt64WithJsonValue:(id)value;
+ (short)toShortWithJsonValue:(id)value;
+ (float)toFloatWithJsonValue:(id)value;
+ (double)toDoubleWithJsonValue:(id)value;
+ (id)toArrayWithJsonValue:(id)value;
+ (id)toDictionaryWithJsonValue:(id)value;

/**
 *  获取UUID
 *
 *  @return 
 */
+ (NSString *)getUUID;
+ (NSString *)getUUIDNoSeparator;

@end
