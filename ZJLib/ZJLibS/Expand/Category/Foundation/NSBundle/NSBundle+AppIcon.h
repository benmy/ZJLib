//
//  NSBundle+AppIcon.h
//  ZJLib
//
//  Created by 朱佳伟 on 16/2/16.
//  Copyright © 2016年 朱佳伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSBundle (AppIcon)

- (NSString*)appIconPath;

- (UIImage*)appIcon;

@end
