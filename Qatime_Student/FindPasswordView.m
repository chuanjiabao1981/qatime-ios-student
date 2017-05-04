//
//  FindPasswordView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/2.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "FindPasswordView.h"

@implementation FindPasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = BACKGROUNDGRAY;
        
        /* 手机号输入框的创建和布局*/
        UIView *text1 = [[UIView alloc]init];
        text1.backgroundColor = [UIColor whiteColor];
        text1.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        text1.layer.borderWidth = 1;
        [self addSubview:text1];
        text1.sd_layout
        .topSpaceToView(self, 20*ScrenScale)
        .leftSpaceToView(self, 30*ScrenScale)
        .rightSpaceToView(self, 30*ScrenScale)
        .heightIs(40*ScrenScale320);
        text1.sd_cornerRadius = @2;
        
        _phoneNumber = [[UITextField alloc]init];
        _phoneNumber.font = TEXT_FONTSIZE;
        [text1 addSubview:_phoneNumber];
        _phoneNumber.placeholder =@"请输入绑定手机号码";
        _phoneNumber.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        _phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNumber.sd_layout
        .topSpaceToView(text1,0)
        .leftSpaceToView(text1,10)
        .rightSpaceToView(text1,0)
        .bottomSpaceToView(text1,0);
        
        /* 手机校验码输入框*/
        UIView *text2 = [[UIView alloc]init];
        text2.backgroundColor = [UIColor whiteColor];
        text2.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        text2.layer.borderWidth = 1;
        [self addSubview:text2];
        text2.sd_layout
        .topSpaceToView(text1, 15*ScrenScale)
        .leftEqualToView(text1)
        .widthRatioToView(text1, 0.6)
        .heightRatioToView(text1, 1.0);
        text2.sd_cornerRadius = @2;
        
        _checkCode = [[UITextField alloc]init];
        _checkCode.font = TEXT_FONTSIZE;
        _checkCode.keyboardType = UIKeyboardTypeNumberPad;
        [text2 addSubview:_checkCode];
        _checkCode.placeholder =@"输入校验码";
        _checkCode.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        _checkCode.sd_layout
        .topSpaceToView(text2, 0)
        .leftSpaceToView(text2, 10)
        .rightSpaceToView(text2, 0)
        .bottomSpaceToView(text2, 0);
        
        /* 获取校验码按钮*/
        _getCheckCodeButton = [[UIButton alloc]init];
        [self addSubview:_getCheckCodeButton];
        _getCheckCodeButton.layer.borderWidth = 1;
        _getCheckCodeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _getCheckCodeButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        _getCheckCodeButton.sd_layout
        .topEqualToView(text2)
        .leftSpaceToView(text2, 0)
        .rightEqualToView(text1)
        .bottomEqualToView(text2);
        _getCheckCodeButton.titleLabel.font = TEXT_FONTSIZE;
        [_getCheckCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_getCheckCodeButton setTitle:@"获取校验码" forState:UIControlStateNormal];
        [_getCheckCodeButton setBackgroundColor:[UIColor lightGrayColor]];
        _getCheckCodeButton.enabled = NO;
        [_getCheckCodeButton setEnlargeEdge:10];
        
        /* 用户密码输入框*/
        UIView *text3 = [[UIView alloc]init];
        text3.backgroundColor = [UIColor whiteColor];
        text3.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        text3.layer.borderWidth = 1;
        [self addSubview:text3];
        text3.sd_layout
        .topSpaceToView(text2, 15*ScrenScale)
        .leftEqualToView(text1)
        .rightEqualToView(text1)
        .heightRatioToView(text1, 1.0);
        text3.sd_cornerRadius = @2;
        
        _userPassword = [[UITextField alloc]init];
        _userPassword .font = TEXT_FONTSIZE;
        _userPassword.secureTextEntry = YES;
        [text3 addSubview:_userPassword];
        _userPassword.placeholder =@"输入新密码";
        _userPassword.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        _userPassword.sd_layout
        .topSpaceToView(text3, 0)
        .bottomSpaceToView(text3,0)
        .leftSpaceToView(text3, 10)
        .rightSpaceToView(text3, 0);
        
        /* 确认登录密码框*/
        UIView *text4 = [[UIView alloc]init];
        text4.backgroundColor = [UIColor whiteColor];
        text4.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        text4.layer.borderWidth = 1;
        [self addSubview:text4];
        text4.sd_layout
        .topSpaceToView(text3, 15*ScrenScale)
        .leftEqualToView(text1)
        .rightEqualToView(text1)
        .heightRatioToView(text1, 1.0);
        text4.sd_cornerRadius = @2;

        _userPasswordCompare =[[UITextField alloc]init];
        _userPasswordCompare.font = TEXT_FONTSIZE;
        _userPasswordCompare.secureTextEntry = YES;
        [text4 addSubview:_userPasswordCompare];
        _userPasswordCompare.placeholder =@"确认新的密码";
        _userPasswordCompare.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        _userPasswordCompare.sd_layout
        .leftSpaceToView(text4, 10)
        .rightSpaceToView(text4, 0)
        .topSpaceToView(text4, 0)
        .bottomSpaceToView(text4, 0);
        
        /* 下一步按钮*/
        _nextStepButton = [[UIButton alloc]init];
        _nextStepButton.sd_cornerRadius = @2 ;
        _nextStepButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _nextStepButton.layer.borderWidth = 1;
        _nextStepButton.titleLabel.font = TEXT_FONTSIZE;
        [self addSubview:_nextStepButton];
        [_nextStepButton setTitle:@"提交" forState:UIControlStateNormal];
        [_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextStepButton.backgroundColor = [UIColor lightGrayColor];
        
        _nextStepButton.sd_layout
        .leftEqualToView(text1)
        .rightEqualToView(text1)
        .heightIs(40*ScrenScale320)
        .topSpaceToView(text4,30*ScrenScale);
        _nextStepButton.enabled = NO;
        [_nextStepButton setEnlargeEdge:20];
        
    }
    return self;
}

@end
