//
//  ZJUICountDownButton.m
//  MyClass_v3
//
//  Created by 朱佳伟 on 15/3/30.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import "ZJUICountDownButton.h"
#import "ARCMacros.h"

#define kProgressFull 30

@interface ZJUICountDownButton()


/**
 *  正常状态下的title
 */
@property (nonatomic, retain) NSString* normalTitle;

/**
 *  按下之后的title
 */
@property (nonatomic, retain) NSString* countDownTitle;

/**
 *  按下之后的titleFormat %@-%lds %@(%lds)
 */
@property (nonatomic, retain) NSString* countDownTitleFormat;

@property (nonatomic, assign) NSInteger progress;
@property (nonatomic, strong) NSTimer *timer;

- (void)timerProc:(NSTimer *)aTime;

@end

@implementation ZJUICountDownButton
@synthesize progress;
@synthesize timer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.countDownTitleFormat = @"%@(%lds)";
    }
    return self;
}

- (void)dealloc
{
    if (timer != nil)
    {
        [timer invalidate];
        SAFE_ARC_RELEASE(timer);
        timer = nil;
    }
    
    SAFE_ARC_SUPER_DEALLOC();
}

- (void)setNormalTitle:(NSString *)title{
    self.normalTitle = title;
}

- (void)setCountDownTitle:(NSString *)countDownTitle format:(NSString *)format{
    self.countDownTitle = countDownTitle;
    self.countDownTitleFormat = format;
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    if (enabled)
    {
        self.alpha = 1.0f;
    }
    else
    {
        self.alpha = 0.7f;
    }
}

- (void)waitOfProgress:(NSInteger)full
{
    self.enabled = NO;
    
    if (timer != nil)
    {
        [timer invalidate];
        SAFE_ARC_RELEASE(timer);
        timer = nil;
    }
    
    progress = full;
    [self setTitle:[NSString stringWithFormat:_countDownTitleFormat, _countDownTitle, (long)progress] forState:UIControlStateDisabled];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerProc:) userInfo:nil repeats:YES];
}

- (void)timerProc:(NSTimer *)aTime
{
    progress--;
    [ZJDataMgr sharedInstance].countDownButtonProgress = progress;
    if (progress <= 0)
    {
        if (timer != nil)
        {
            [timer invalidate];
            SAFE_ARC_RELEASE(timer);
            timer = nil;
        }
        [ZJDataMgr sharedInstance].countDownButtonProgress = 0;
        [self setTitle:_normalTitle forState:UIControlStateDisabled];
        [self setEnabled:YES];
    }else
    {
        if (progress == kProgressFull / 2 && _halfProgressBlock) {
            _halfProgressBlock();
        }
        [self setTitle:[NSString stringWithFormat:_countDownTitleFormat, _countDownTitle, (long)progress] forState:UIControlStateDisabled];
    }
}

@end

