//
//  NSIndexPath+Offset.h
//  ZJLib
//
//  Created by 朱佳伟 on 16/2/16.
//  Copyright © 2016年 朱佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSIndexPath(Offset)

/* Compute previous row indexpath */
- (NSIndexPath *)previousRow;

/* Compute next row indexpath */
- (NSIndexPath *)nextRow;

/* Compute previous item indexpath */
- (NSIndexPath *)previousItem;

/* Compute next item indexpath */
- (NSIndexPath *)nextItem;

/* Compute next section indexpath */
- (NSIndexPath *)nextSection;

/* Compute previous section indexpath */
- (NSIndexPath *)previousSection;
@end
