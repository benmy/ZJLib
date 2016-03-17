//
//  ZJFileHelper.h
//  MyClass3
//
//  Created by 朱佳伟 on 15/11/27.
//  Copyright © 2015年 朱佳伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJFileHelper : NSObject

@property (nonatomic, strong) NSString* filePath;   //上传文件路径
@property (nonatomic, strong) NSData* fileData;     //上传文件二进制数据
@property (nonatomic, strong) NSString* fileType;   //上传文件类型
@property (nonatomic, assign) NSInteger index;      //上传index
@property (nonatomic, assign) BOOL uploadSuc;       //上传状态

+ (NSString*)fileNameWithType:(NSString*)type andExtension:(NSString*)extension;

+ (NSString*)filePathWithType:(NSString*)type AndName:(NSString*)name;

@end
