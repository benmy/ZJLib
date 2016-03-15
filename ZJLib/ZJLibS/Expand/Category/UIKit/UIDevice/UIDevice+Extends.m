//
//  UIDevice+Extends.m
//  ZJUtils
//
//  Created by 朱佳伟 on 15/3/12.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import "UIDevice+Extends.h"
#include "sys/types.h"
#include "sys/sysctl.h"

@implementation UIDevice (Extends)

/**
 *  An NSString containing the type of machine
 *
 *  @return
 */
- (NSString*)machine
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char* name = (char*)malloc(size);
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    NSString* machine = [[NSString alloc]initWithUTF8String:name];
    free(name);
    
    return machine;
}
@end
