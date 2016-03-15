//
//  ColorConstants.h
//  ZJUtils
//
//  Created by 朱佳伟 on 15/3/13.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#ifndef ZJUtils_ColorConstants_h
#define ZJUtils_ColorConstants_h

// 字体大小(常规/粗体)
#define BlodSystemFont(FontSize)[UIFont boldSystemFontOfSize:FontSize]
#define SystemFont(FontSize)    [UIFont systemFontOfSize:FontSize]
#define Font(Name, FontSize)    [UIFont fontWithName:(Name) size:(FontSize)]

//中文字体
#define CHINESE_FONT_NAME       @"Heiti SC"
#define CHINESE_SYSTEM(x)       [UIFont fontWithName:CHINESE_FONT_NAME size:x]

#define UNICODETOUTF16(x)       (((((x - 0x10000) >>10) | 0xD800) << 16)  | (((x-0x10000)&3FF) | 0xDC00))
#define MULITTHREEBYTEUTF16TOUNICODE(x,y) (((((x ^ 0xD800) << 2) | ((y ^ 0xDC00) >> 8)) << 8) | ((y ^ 0xDC00) & 0xFF)) + 0x10000

//色值
#define RGBA(r,g,b,a)           [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b)              RGBA(r,g,b,1.0f)

#define HEXCOLOR(hex)           [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

#define COLOR_RGB(rgbValue,a)   [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 green:((float)(((rgbValue) & 0xFF00)>>8))/255.0 blue: ((float)((rgbValue) & 0xFF))/255.0 alpha:(a)]

/**
 *  颜色配置
 *
 *  @param kColorA  颜色名称
 *  @param 0x39b44a 颜色16进制
 *  @param 1        透明度
 *
 *  @return
 */
#define kColorA                 COLOR_RGB(kColorA, 0x39b44a, 1)
#define kColorB                 COLOR_RGB(kColorA, 0xf43531, 1)
#define kColorC                 COLOR_RGB(kColorA, 0x333333, 1)
#define kColorD                 COLOR_RGB(kColorA, 0x929292, 1)
#define kColorE                 COLOR_RGB(kColorA, 0xe2e2e5, 1)
#define kColorF                 COLOR_RGB(kColorA, 0xf2f2f2, 1)
#endif
