//
//  NSDictionary+JSON.h
//  ZJLib
//
//  Created by 朱佳伟 on 16/2/16.
//  Copyright © 2016年 朱佳伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(JSON)

/**
 *  @brief NSDictionary转换成JSON字符串
 *
 *  @return  JSON字符串
 */
- (NSString *)JSONString;
@end
