
//
//  ChangPhoneView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/1.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ChangPhoneView.h"

@implementation ChangPhoneView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = BACKGROUNDGRAY;
        [self setupViews];
    }
    return self;
}


- (void)setupViews{
    
    UIView *text1 = [[UIView alloc]init];
    [self addSubview:text1];
    text1.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
    text1.layer.borderWidth = 1;
    text1.backgroundColor = [UIColor whiteColor];
    
    text1.sd_layout
    .leftSpaceToView(self, 30*ScrenScale)
    .rightSpaceToView(self, 30*ScrenScale)
    .topSpaceToView(self, 20*ScrenScale)
    .heightIs(40*ScrenScale320);
    
    _phoneNumber = [[UITextField alloc]init];
    _phoneNumber.placeholder = @"输入新手机号(仅支持大陆地区11位)";
    _phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    
    [text1 addSubview:_phoneNumber];
    _phoneNumber.sd_layout
    .leftSpaceToView(text1,10*ScrenScale)
    .topSpaceToView(text1,10*ScrenScale)
    .rightSpaceToView(text1,10*ScrenScale)
    .bottomSpaceToView(text1, 10*ScrenScale);
    
    UIView *text2 = [[UIView alloc]init];
    [self addSubview:text2];
    text2.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
    text2.layer.borderWidth = 1;
    text2.backgroundColor = [UIColor whiteColor];
    
    text2.sd_layout
    .topSpaceToView(text1,10*ScrenScale320)
    .leftEqualToView(text1)
    .widthRatioToView(text1, 0.6)
    .heightRatioToView(text1, 1.0);

    _keyCode = [[UITextField alloc]init];
    _keyCode.placeholder = @"输入收到的验证码";
    _keyCode.keyboardType = UIKeyboardTypeNumberPad;
    
    [text2 addSubview:_keyCode];
    _keyCode.sd_layout
    .leftSpaceToView(text2, 10*ScrenScale)
    .rightSpaceToView(text2, 10*ScrenScale)
    .topSpaceToView(text2, 10*ScrenScale)
    .bottomSpaceToView(text2, 10*ScrenScale);
    
    _getKeyButton = [[UIButton alloc]init];
    [_getKeyButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [_getKeyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getKeyButton setBackgroundColor:TITLECOLOR];
    _getKeyButton.layer.borderWidth = 1;
    _getKeyButton.layer.borderColor = TITLECOLOR.CGColor;
    
    [self addSubview:_getKeyButton];
    
    _getKeyButton.sd_layout
    .leftSpaceToView(text2, 0)
    .topEqualToView(text2)
    .bottomEqualToView(text2)
    .rightEqualToView(text1);
    
    _finishButton = [[UIButton alloc]init];
    [_finishButton setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
    
    _finishButton.layer.borderWidth =1;
    _finishButton .layer.borderColor =NAVIGATIONRED.CGColor;
    [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
    
    [self addSubview:_finishButton];
    
    _finishButton.sd_layout
    .leftEqualToView(text1)
    .rightEqualToView(text1)
    .topSpaceToView(_getKeyButton,20*ScrenScale)
    .heightRatioToView(_getKeyButton,1.0f);
    _finishButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];

    
}

@end
