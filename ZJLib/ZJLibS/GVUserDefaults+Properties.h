//
//  GVUserDefaults+Properties.h
//  Yxt
//
//  Created by 朱佳伟 on 16/3/17.
//  Copyright © 2016年 朱佳伟. All rights reserved.
//


//Use
//
//Set Data
//
//NSDictionary *defaults = @{
//                           @"NSUserDefaultUserName": @"default",
//                           @"NSUserDefaultUserId": @1,
//                           @"NSUserDefaultBoolValue": @YES
//                           };
//
//[[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
//
//Get Data
//
//[GVUserDefaults standardUserDefaults].userName

#import <Foundation/Foundation.h>
#import <GVUserDefaults/GVUserDefaults.h>

@interface GVUserDefaults (Properties)

@property (nonatomic, assign) NSInteger userid;
@property (nonatomic, strong) NSString *cellular;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *headPortrait;
@property (nonatomic, assign) NSInteger pushStatus;
@property (nonatomic, assign) NSInteger dndStatus;
@property (nonatomic, strong) NSString *dndStartTime;
@property (nonatomic, strong) NSString *dndEndTime;
@property (nonatomic, strong) NSString *sessionid;
@property (nonatomic, strong) NSDate* loginTime;

@end
