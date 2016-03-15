//
//  NSArray+Access.h
//  ZJLib
//
//  Created by 朱佳伟 on 16/2/16.
//  Copyright © 2016年 朱佳伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSArray (Access)

- (id)objectWithIndex:(NSUInteger)index;

- (NSString*)stringWithIndex:(NSUInteger)index;

- (NSNumber*)numberWithIndex:(NSUInteger)index;

- (NSDecimalNumber *)decimalNumberWithIndex:(NSUInteger)index;

- (NSArray*)arrayWithIndex:(NSUInteger)index;

- (NSDictionary*)dictionaryWithIndex:(NSUInteger)index;

- (NSInteger)integerWithIndex:(NSUInteger)index;

- (NSUInteger)unsignedIntegerWithIndex:(NSUInteger)index;

- (BOOL)boolWithIndex:(NSUInteger)index;

- (int16_t)int16WithIndex:(NSUInteger)index;

- (int32_t)int32WithIndex:(NSUInteger)index;

- (int64_t)int64WithIndex:(NSUInteger)index;

- (char)charWithIndex:(NSUInteger)index;

- (short)shortWithIndex:(NSUInteger)index;

- (float)floatWithIndex:(NSUInteger)index;

- (double)doubleWithIndex:(NSUInteger)index;

- (NSDate *)dateWithIndex:(NSUInteger)index dateFormat:(NSString *)dateFormat;

//CG
- (CGFloat)CGFloatWithIndex:(NSUInteger)index;

- (CGPoint)pointWithIndex:(NSUInteger)index;

- (CGSize)sizeWithIndex:(NSUInteger)index;

- (CGRect)rectWithIndex:(NSUInteger)index;

- (void)each:(void (^)(id object))block;

- (void)eachWithIndex:(void (^)(id object, NSUInteger index))block;

- (NSArray *)map:(id (^)(id object))block;

- (NSArray *)filter:(BOOL (^)(id object))block;

- (NSArray *)reject:(BOOL (^)(id object))block;

- (id)detect:(BOOL (^)(id object))block;

- (id)reduce:(id (^)(id accumulator, id object))block;

- (id)reduce:(id)initial withBlock:(id (^)(id accumulator, id object))block;
@end
