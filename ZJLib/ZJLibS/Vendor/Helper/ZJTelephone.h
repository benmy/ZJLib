//
//  ZJTelephone.h
//  ZJUtils
//
//  Created by 朱佳伟 on 15/3/12.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import <Foundation/Foundation.h>

// need CoreTelephony.framework and MessageUI.framework support
@interface ZJTelephone : NSObject

/**
 *  get the instance
 *
 *  @return ZJTelephone
 */
+ (ZJTelephone *)shared;

/**
 *  check the phone is a phone number or not
 *
 *  @param phone
 *
 *  @return 
 */
- (BOOL)isPhone:(NSString *)phone;

/**
 *  An NSString containing the name of the subscriber's cellular service provider.
 *
 *  @return carrierName
 */
- (NSString *)carrierName;

/**
 *  An NSString containing the mobile country code and the mobile network for the subscriber's
 *   cellular service provider, in its numeric representation
 *
 *  @return carrierCode
 */
- (NSString *)carrierCode;

/**
 *  make a call
 *
 *  @param aPhone An NSString containing the phoneNumber
 *
 *  @return YES:call success NO:call failed
 */
- (BOOL)callWithPhone:(NSString *)aPhone;

/**
 *  send a SMS
 *
 *  @param aPhone   An NSString containing the phoneNumber
 *  @param aContent An NSString containing the SMS content
 *
 *  @return YES:send success NO:send failed
 */
- (BOOL)sendSMSWithPhone:(NSString *)aPhone content:(NSString *)aContent;

/**
 *  添加-
 *
 *  @param phone
 *
 *  @return
 */
- (NSString*)transferPhoneToDisplay:(NSString*)phone;

@end
