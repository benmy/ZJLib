/*
 *  pinyin.h
 *  Chinese Pinyin First Letter
 //  SNSClicent
 //
 //  Created by yang on 10-10-25.
 //  Copyright 2010 lzjtu. All rights reserved.
 //
 */

/*
 * // Example
 *
 * #import "pinyin.h"
 *
 * NSString *hanyu = @"中国共产党万岁！";
 * for (int i = 0; i < [hanyu length]; i++)
 * {
 *     printf("%c", pinyinFirstLetter([hanyu characterAtIndex:i]));
 * }
 *
 */

char pinyinFirstLetter(unsigned short hanzi);