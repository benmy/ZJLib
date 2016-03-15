//
//  NSData+Hash.h
//  ZJLib
//
//  Created by 朱佳伟 on 16/2/16.
//  Copyright © 2016年 朱佳伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(Hash)

/**
 *  @brief  md5 NSData
 */
@property (readonly) NSData *md5Data;
/**
 *  @brief  sha1Data NSData
 */
@property (readonly) NSData *sha1Data;
/**
 *  @brief  sha256Data NSData
 */
@property (readonly) NSData *sha256Data;
/**
 *  @brief  sha512Data NSData
 */
@property (readonly) NSData *sha512Data;

/**
 *  @brief  md5 NSData
 *
 *  @param key 密钥
 *
 *  @return 结果
 */
- (NSData *)hmacMD5DataWithKey:(NSData *)key;
/**
 *  @brief  sha1Data NSData
 *
 *  @param key 密钥
 *
 *  @return 结果
 */
- (NSData *)hmacSHA1DataWithKey:(NSData *)key;
/**
 *  @brief  sha256Data NSData
 *
 *  @param key 密钥
 *
 *  @return 结果
 */
- (NSData *)hmacSHA256DataWithKey:(NSData *)key;
/**
 *  @brief  sha512Data NSData
 *
 *  @param key 密钥
 *
 *  @return 结果
 */
- (NSData *)hmacSHA512DataWithKey:(NSData *)key;
@end
