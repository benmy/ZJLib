//
//  ZJTelephone.m
//  ZJUtils
//
//  Created by 朱佳伟 on 15/3/12.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import "ZJTelephone.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <MessageUI/MessageUI.h>
#import "ARCMacros.h"
#import "NSString+Extends.h"
#import "UIViewController+Extends.h"

@interface ZJTelephone ()<MFMessageComposeViewControllerDelegate>

@property (nonatomic, SAFE_ARC_STRONG) MFMessageComposeViewController *msgCtrl;

@end

@implementation ZJTelephone

/**
 *  get the instance
 *
 *  @return ZJTelephone
 */
+ (ZJTelephone *)shared{
    static ZJTelephone *s_instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [[ZJTelephone alloc] init];
    });
    
    return s_instance;
}

- (BOOL)isPhone:(NSString *)phone
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178
     * 联通：130,131,132,152,155,156,185,186,145,176
     * 电信：133,1349,153,180,181,189, 177
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,183,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[0-9]|8[0-9])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|4[0-9]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[0-9])[0-9]|349|76)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:phone] == YES)
        || ([regextestcm evaluateWithObject:phone] == YES)
        || ([regextestct evaluateWithObject:phone] == YES)
        || ([regextestcu evaluateWithObject:phone] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/**
 *  An NSString containing the name of the subscriber's cellular service provider.
 *
 *  @return carrierName
 */
- (NSString *)carrierName{
    NSString *ret = nil;
    
    CTTelephonyNetworkInfo *cn = [[CTTelephonyNetworkInfo alloc] init];
    if (cn.subscriberCellularProvider != nil)
    {
        NSString *tmp = cn.subscriberCellularProvider.carrierName;
        if (![tmp isEmpty])
        {
            ret = [tmp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        }
    }
    SAFE_ARC_RELEASE(cn);
    
    return ret;
}

/**
 *  An NSString containing the mobile country code and the mobile network for the subscriber's
 *   cellular service provider, in its numeric representation
 *
 *  @return carrierCode
 */
- (NSString *)carrierCode{
    NSString *ret = nil;
    
    CTTelephonyNetworkInfo *cn = [[CTTelephonyNetworkInfo alloc] init];
    if (cn.subscriberCellularProvider != nil)
    {
        NSString *mobileCountryCode = cn.subscriberCellularProvider.mobileCountryCode;
        NSString *mobileNetworkCode = cn.subscriberCellularProvider.mobileNetworkCode;
        NSMutableString *buffer = [NSMutableString stringWithString:@""];
        if (![mobileCountryCode isEmpty])
        {
            [buffer appendString:mobileCountryCode];
        }
        if (![mobileNetworkCode isEmpty])
        {
            [buffer appendString:mobileNetworkCode];
        }
        if (![buffer isEmpty])
        {
            ret = buffer;
        }
    }
    SAFE_ARC_RELEASE(cn);
    
    return ret;
}

/**
 *  make a call
 *
 *  @param aPhone An NSString containing the phoneNumber
 *
 *  @return YES:call success NO:call failed
 */
- (BOOL)callWithPhone:(NSString *)aPhone{
    if (![aPhone isEmpty])
    {
        NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", aPhone]];
        //NSLog(@"Call, URL=%@", phoneNumberURL);
        return [[UIApplication sharedApplication] openURL:phoneNumberURL];
    }
    return NO;
}

/**
 *  send a SMS
 *
 *  @param aPhone   An NSString containing the phoneNumber
 *  @param aContent An NSString containing the SMS content
 *
 *  @return YES:send success NO:send failed
 */
- (BOOL)sendSMSWithPhone:(NSString *)aPhone content:(NSString *)aContent
{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass == nil || ![messageClass canSendText])
    {
        return NO;
    }
    
    if (_msgCtrl != nil)
    {
        [_msgCtrl dismissMe];
        SAFE_ARC_AUTORELEASE(_msgCtrl);
        _msgCtrl = nil;
    }
    
    self.msgCtrl = SAFE_ARC_AUTORELEASE([[MFMessageComposeViewController alloc] init]);
    [_msgCtrl setMessageComposeDelegate:self];
    [_msgCtrl setBody:aContent];
    [_msgCtrl setRecipients:[NSArray arrayWithObject:aPhone]];
    
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    if (window.rootViewController != nil)
    {
        [window.rootViewController presentViewController:_msgCtrl animated:YES];
    }
    
    return YES;
}

- (NSString*)transferPhoneToDisplay:(NSString *)phone{
    NSMutableString *string = [NSMutableString stringWithString:phone];
    [string insertString:@"-" atIndex:3];
    [string insertString:@"-" atIndex:8];
    return string.description;
}

#pragma mark MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultSent:
            break;
        case MessageComposeResultFailed:
            break;
        default:
            break;
    }
    
    [controller dismissMe];
}
@end
