//
//  ZJCustomAlertView.h
//  MyClass3
//
//  Created by 朱佳伟 on 15/5/4.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SendBtnBlock)(NSString* string);
typedef void (^RightBlock)(NSString* string);

@interface ZJCustomAlertView : UIView<UITextFieldDelegate>{
    
}

typedef NS_ENUM(NSUInteger, ZJCustomAlertViewType)
{
    ZJCustomAlertViewNormal = 0,
    ZJCustomAlertViewRightCorner = 1,
};

@property (nonatomic, assign) ZJCustomAlertViewType alertViewType;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) NSString *result;
@property (nonatomic, strong) NSArray *params;

@property (nonatomic, strong) UIView *top;
@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UILabel *alertContentLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *bottom;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *left;
@property (nonatomic, strong) UIButton *right;
@property (nonatomic, strong) UIControl *backImageView;
@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UIView *rightLine;

// 创建班级成功
@property (nonatomic, strong) UIImageView *create_image;
// 加入班级
@property (nonatomic, strong) UIButton *number_button;

@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) RightBlock rightBlock;
@property (nonatomic, copy) SendBtnBlock sendBlock;

- (id)initWithTitle:(NSString *)title
        contentText:(NSArray *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
  withAlertViewType:(ZJCustomAlertViewType)type;

- (void)show;
- (void)dismissAlert;
@end
