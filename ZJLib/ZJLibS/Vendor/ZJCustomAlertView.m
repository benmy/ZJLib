//
//  ZJCustomAlertView.m
//  MyClass3
//
//  Created by 朱佳伟 on 15/5/4.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import "ZJCustomAlertView.h"
#import <QuartzCore/QuartzCore.h>

#define kAlertWidth 300.0f
#define kAlertHeight 177.5f
#define kAlertWidthImage 310.0f
#define kAlertHieghtImage 413.0f
#define kAlertHeightOther 175.0f

#define kImageWith 235.0f

#define kTitleYOffset 15.0f
#define kTitleYOffsetImage 33.0f
#define kTitleHeight 60

#define kContentOffset 30.0f
#define kBetweenLabelOffset 20.0f

#define kCoupleButtonWidth 105.0f
#define kButtonHeight 45.0f
#define kButtonBottomOffset 28.0f

#define kCheckHeight 50.0f
@implementation ZJCustomAlertView

+ (CGFloat)alertWidth
{
    return kAlertWidth;
}

+ (CGFloat)alertHeight
{
    return kAlertHeight + 15;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
        contentText:(NSArray *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
  withAlertViewType:(ZJCustomAlertViewType)type{
    if (self = [super init]) {
        _alertViewType = type;
        self.layer.masksToBounds = YES;//圆角
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        _params = content;
        
        switch (type) {
            case ZJCustomAlertViewNormal:
            {
                _width = kAlertWidth;
                _height = kAlertHeight + 15;
                _offset = kButtonBottomOffset;
                self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width, kTitleHeight)];
                self.alertTitleLabel.textAlignment = NSTextAlignmentCenter;
                self.alertTitleLabel.font = SystemFont(18);
//                [self.alertTitleLabel setBackgroundColorWithDef:kColorF];
                [self addSubview:self.alertTitleLabel];
                
                //竖线
                UIView* line2 = [[UIView alloc]initWithFrame:CGRectMake(0, kTitleHeight - 0.5, _width, 0.5)];
                [line2 setBackgroundColor:kColorE];
                [self addSubview:line2];
                
                CGFloat contentLabelWidth = _width - 40;
                self.alertContentLabel = [[UILabel alloc] initWithFrame:CGRectMake((_width - contentLabelWidth) * 0.5, CGRectGetMaxY(self.alertTitleLabel.frame), contentLabelWidth, 80)];
                self.alertContentLabel.numberOfLines = 0;
                self.alertContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
                self.alertContentLabel.textAlignment = NSTextAlignmentCenter;
                self.alertContentLabel.font = SystemFont(16);
                [self addSubview:self.alertContentLabel];
                self.alertTitleLabel.text = title;
                self.alertContentLabel.text = [content objectAtIndex:0];
                
                _bottom = [[UIView alloc]initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + _height - kButtonHeight, _width, kButtonHeight)];
                //        [_bottom setBackgroundColor:ColorOfIndictor];
                if (![rigthTitle isEmpty]) {
                    CGRect leftBtnFrame = CGRectMake(0, 0, _width / 2, kButtonHeight);
                    CGRect rightBtnFrame = CGRectMake(_width / 2, 0, _width / 2, kButtonHeight);
                    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    self.leftBtn.frame = leftBtnFrame;
                    self.rightBtn.frame = rightBtnFrame;
                    [self addSubview:_bottom];
                    
                    [_leftBtn setTitleForAllState:leftTitle];
                    [_rightBtn setTitleForAllState:rigthTitle];
//                    [ZJUIKit styleButtonLeft:self.leftBtn];
//                    [ZJUIKit styleButtonRight:self.rightBtn];
                    
                    [self.leftBtn addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
                    [self.rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
                    [_bottom addSubview:self.leftBtn];
                    [_bottom addSubview:self.rightBtn];
                } else {
                    CGRect leftBtnFrame = CGRectMake(0, 0, _width, kButtonHeight);
                    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    self.leftBtn.frame = leftBtnFrame;
                    [self addSubview:_bottom];
                    
                    [_leftBtn setTitleForAllState:leftTitle];
//                    [ZJUIKit styleButtonRight:self.leftBtn];
                    
                    [self.leftBtn addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
                    [_bottom addSubview:self.leftBtn];
                }

            }
                break;

            case ZJCustomAlertViewRightCorner:
            {
                _height = kButtonHeight - 10;
                self.backgroundColor = kColorA;
                CGRect leftBtnFrame = CGRectMake(0, 0, 130, kButtonHeight - 10);
                self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                self.leftBtn.frame = leftBtnFrame;
                [_leftBtn setTitleForAllState:leftTitle];
//                [ZJUIKit styleButtonRight:self.leftBtn];
                self.leftBtn.titleLabel.font = SystemFont(15);
                [self.leftBtn addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:self.leftBtn];

                if (![rigthTitle isEmpty]) {
                    _height = (kButtonHeight - 10) * 2;
                    CGRect rightBtnFrame = CGRectMake(0, kButtonHeight - 10, 130, kButtonHeight - 10);
                    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    self.rightBtn.frame = rightBtnFrame;
                    //                [self addSubview:_bottom];
                    
                    [_rightBtn setTitleForAllState:rigthTitle];
//                    [ZJUIKit styleButtonRight:self.rightBtn];
                    self.rightBtn.titleLabel.font = SystemFont(15);
                    
                    [self.rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:self.rightBtn];
                }
               
            }
                break;


        }
    }
    return self;
}

- (void)number_button_Click:(UIButton *)button {
    button.selected = !button.selected;
    
}

- (void)leftBtnClicked
{
    [self dismissAlert];
    if (self.leftBlock) {
        self.leftBlock();
    }
}

- (void)rightBtnClicked
{
    [self performSelectorOnMainThread:@selector(dismissAlert) withObject:nil waitUntilDone:YES];
    if (self.rightBlock) {
        self.rightBlock(_result);
    }
}

- (void)show
{
    //    UIViewController *topVC = [self appRootViewController];
    UIWindow *tempWindow = [UIApplication sharedApplication].keyWindow;
//    self.frame = CGRectMake((CGRectGetWidth(tempWindow.bounds) - _width) * 0.5, - _height - 30, _width, _height);
    self.frame =  CGRectMake((CGRectGetWidth(tempWindow.bounds) - _width) * 0.5, (CGRectGetHeight(tempWindow.bounds) - _height) * 0.5, _width, _height);
    if (self.alertViewType == ZJCustomAlertViewRightCorner) {
        self.frame = CGRectMake(CGRectGetWidth(tempWindow.bounds) - 140, 64, 130, _height);
    }
    self.alpha = 0;
    [tempWindow addSubview:self];
}

- (void)dismissAlert
{
    [self removeFromSuperview];
}

- (void)removeFromSuperview
{
    if (self.backImageView == nil) {
        return;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.backImageView removeFromSuperview];
    self.backImageView = nil;
    
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    //    UIViewController *topVC = [self appRootViewController];
    UIWindow *tempWindow = [UIApplication sharedApplication].keyWindow;
    if (!self.backImageView) {
        self.backImageView = [[UIControl alloc] initWithFrame:tempWindow.bounds];
        self.backImageView.backgroundColor = [UIColor blackColor];
        self.backImageView.alpha = 0.6f;
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        if (_alertViewType == ZJCustomAlertViewRightCorner) {
            [_backImageView addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventAllEvents];
        }
    }
    [tempWindow addSubview:self.backImageView];
    
    CGRect afterFrame = CGRectMake((CGRectGetWidth(tempWindow.bounds) - _width) * 0.5, (CGRectGetHeight(tempWindow.bounds) - _height) * 0.5, _width, _height);
    if (self.alertViewType == ZJCustomAlertViewRightCorner) {
        afterFrame = CGRectMake(CGRectGetWidth(tempWindow.bounds) - 140, 64, 130, _height);
    }
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 1;
        self.frame = afterFrame;
    } completion:^(BOOL finished) {
    }];
    [super willMoveToSuperview:newSuperview];
}
@end
