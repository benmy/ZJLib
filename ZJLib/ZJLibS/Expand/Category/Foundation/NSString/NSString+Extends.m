//
//  NSString+Extends.m
//  VoiceRecorder
//
//  Created by 朱佳伟 on 14/11/25.
//  Copyright (c) 2014年 朱佳伟. All rights reserved.
//

#import "NSString+Extends.h"
#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>

@implementation NSString (Extends)

- (id)JSONValue
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil)
        return nil;
    return result;
}

- (NSString *)trim
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSUInteger)numberOfLines {
    return [[self componentsSeparatedByString:@"\n"] count] + 1;
}

- (NSInteger)charCount
{
	int strlength = 0;
    char *p = (char *)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++)
	{
        if (*p)
		{
            p++;
            strlength++;
        }
        else
		{
            p++;
        }
    }
    return strlength;
}

- (BOOL)isEmpty
{
	if ((self == nil) || self == (NSString *)[NSNull null] || (self.length == 0))
	{
		return YES;
	}
	return NO;
}

+ (NSString *)ifNilToStr:(NSString *)value
{
	if ((value == nil) || (value == (NSString *)[NSNull null]))
	{
		return @"";
	}
	return value;
}

+ (NSString *)stringWithInteger:(NSInteger)value
{
	NSNumber *number = [NSNumber numberWithInteger:value];
	return [number stringValue];
}

+ (NSString *)stringWithLong:(long)value
{
	return [NSString stringWithFormat:@"%ld", value];
}

+ (NSString *)stringWithLongLong:(int64_t)value
{
	return [NSString stringWithFormat:@"%lld", value];
}

+ (NSString *)stringWithFloat:(float)value
{
	return [NSString stringWithFormat:@"%f", value];
}

+ (NSString *)stringWithDouble:(double)value
{
	return [NSString stringWithFormat:@"%lf", value];
}

- (NSString *)stringByURLEncoding
{
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																							 (CFStringRef)self,
																							 NULL,
																							 CFSTR("!*'();:@&=+$,/?%#[]"),
																							 kCFStringEncodingUTF8);
	return result;
}

- (NSString *)stringByURLDecoding
{
	NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																											 (CFStringRef)self,
																											 CFSTR(""),
																											 kCFStringEncodingUTF8);
    return result;
}

- (NSString *)stringByFilterSymbols:(NSArray *)symbols
{
	NSMutableString *buffer = [NSMutableString stringWithString:self];
	for (NSString *s in symbols)
	{
		[buffer replaceOccurrencesOfString:s withString:@"" options:NSLiteralSearch range:NSMakeRange(0, buffer.length)];
	}
	return buffer;
}

- (NSString *)stringByTTSFilter
{
	return [self stringByFilterSymbols:
			@[
              @"&",
              @"%",
              @"<",
              @">",
              @"#",
              @"$"
              ]
			];
}

- (BOOL)isPhone
{
	NSString *regex = @"\\d{3,20}";
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	if ([predicate evaluateWithObject:self])
	{
		return YES;
	}
	return NO;
}

- (BOOL)isEmail
{
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
	return [emailTest evaluateWithObject:self];
}

- (CGFloat)heightWithFont:(UIFont *)font width:(CGFloat)width
{
	CGFloat height = 0;
	
	CGSize size = CGSizeZero;
#ifdef __IPHONE_7_0
		NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
									font, NSFontAttributeName,
									nil];
		size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
								  options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
							   attributes:attributes
								  context:nil].size;
#else
		size = [self sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
#endif
	height = size.height;

	return height;
}

- (CGFloat)widthWithFont:(UIFont *)font
{
	CGSize size = CGSizeZero;
#ifdef __IPHONE_7_0
		NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
									font, NSFontAttributeName,
									nil];
		size = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, font.lineHeight)
								  options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
							   attributes:attributes
								  context:nil].size;
#else
		size = [self sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, font.lineHeight) lineBreakMode:NSLineBreakByCharWrapping];
#endif
	return size.width;
}

- (NSString *)toMD5
{
	const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
	
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end

#pragma mark NSMutableString (RFKit)

@implementation NSMutableString (RFKit)

- (void)removeLastChar
{
    if (self.length > 0)
    {
        [self deleteCharactersInRange:NSMakeRange((self.length - 1), 1)];
    }
}

@end

