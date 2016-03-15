//
//  NSString+MIME.h
//  ZJLib
//
//  Created by 朱佳伟 on 16/2/16.
//  Copyright © 2016年 朱佳伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MIME)

/**
 *  @brief  根据文件url 返回对应的MIMEType
 *
 *  @return MIMEType
 */
- (NSString *)MIMEType;

/**
 *  @brief  根据文件url后缀 返回对应的MIMEType
 *
 *  @return MIMEType
 */
+ (NSString *)MIMETypeForExtension:(NSString *)extension;

/**
 *  @brief  常见MIME集合
 *
 *  @return 常见MIME集合
 */
+ (NSDictionary *)MIMEDict;

@end
