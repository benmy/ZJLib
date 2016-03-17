//
//  ZJTapAssetView.m
//  ZJUtils
//
//  Created by 朱佳伟 on 15/3/13.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import "ZJTapAssetView.h"

@implementation ZJTapAssetView

static UIImage *checkedNoIcon;

static UIImage *checkedIcon;
static UIColor *selectedColor;
static UIColor *disabledColor;

+ (void)initialize
{
    //    checkedIcon     = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"ZAssetPicker.Bundle/Images/%@@2x.png",(!IS_IOS7) ? @"AssetsPickerChecked" : @"AssetsPickerChecked"]]];
    //
    //    checkedNoIcon     = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"ZAssetPicker.Bundle/Images/%@@2x.png",(!IS_IOS7) ? @"No" : @"No"]]];
    
    checkedIcon = [UIImage imageNamed:@"btn_img_checked"];
    checkedNoIcon = [UIImage imageNamed:@"btn_img_unchecked"];
    
    selectedColor   = [UIColor colorWithWhite:1 alpha:0.3];
    disabledColor   = [UIColor colorWithWhite:1 alpha:0.9];
}

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        //设置勾勾的位置
        _selectView=[[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-checkedIcon.size.width-2, 2, checkedIcon.size.width, checkedIcon.size.height)];
        [self addSubview:_selectView];
    }
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_disabled) {
        return;
    }
    
    if (_delegate!=nil&&[_delegate respondsToSelector:@selector(shouldTap:)]) {
        if (![_delegate shouldTap:_selected]&&!_selected) {
            return;
        }
    }
    
    if ((_selected=!_selected)) {
        self.backgroundColor=selectedColor;
        [_selectView setImage:checkedIcon];
    }
    else{
        self.backgroundColor=[UIColor clearColor];
        //[_selectView setImage:nil];
        [_selectView setImage:checkedNoIcon];
    }
    if (_delegate!=nil&&[_delegate respondsToSelector:@selector(touchSelect:)]) {
        [_delegate touchSelect:_selected];
    }
}

-(void)setDisabled:(BOOL)disabled{
    _disabled=disabled;
    if (_disabled) {
        self.backgroundColor=disabledColor;
    }
    else{
        self.backgroundColor=[UIColor clearColor];
    }
}

-(void)setSelected:(BOOL)selected{
    if (_disabled) {
        self.backgroundColor=disabledColor;
        [_selectView setImage:nil];
        return;
    }
    
    _selected=selected;
    if (_selected) {
        self.backgroundColor=selectedColor;
        [_selectView setImage:checkedIcon];
    }
    else{
        self.backgroundColor=[UIColor clearColor];
        // [_selectView setImage:nil];
        [_selectView setImage:checkedNoIcon];
    }
}
@end
