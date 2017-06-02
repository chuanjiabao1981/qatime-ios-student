//
//  GuestBindingView.m
//  Qatime_Student
//
//  Created by Shin on 2017/6/2.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "GuestBindingView.h"

@implementation GuestBindingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentSize = CGSizeMake(self.width_sd, 400);
        
        
        //姓名框
        UIView *nameView = [[UIView alloc]init];
        [self addSubview:nameView];
        nameView.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        nameView.layer.borderWidth = 0.6;
        nameView.backgroundColor = [UIColor whiteColor];
        nameView.sd_layout
        .leftSpaceToView(self, 20*ScrenScale)
        .rightSpaceToView(self, 20*ScrenScale)
        .topSpaceToView(self, 20*ScrenScale)
        .heightIs(40*ScrenScale320);
        
        _nameText = [[UITextField alloc]init];
        [nameView addSubview:_nameText];
        _nameText.placeholder = @"请输入姓名";
        _nameText.font = TEXT_FONTSIZE;
        _nameText.textColor = [UIColor blackColor];
        _nameText.sd_layout
        .leftSpaceToView(nameView, 10*ScrenScale)
        .rightSpaceToView(nameView, 10*ScrenScale)
        .topSpaceToView(nameView, 10*ScrenScale)
        .bottomSpaceToView(nameView, 10*ScrenScale);
        
        //要绑定的手机号
        UIView *phoneView = [[UIView alloc]init];
        [self addSubview:phoneView];
        phoneView.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        phoneView.layer.borderWidth = 0.6;
        phoneView.backgroundColor = [UIColor whiteColor];
        phoneView.sd_layout
        .leftEqualToView(nameView)
        .rightEqualToView(nameView)
        .topSpaceToView(nameView, 20*ScrenScale)
        .heightRatioToView(nameView, 1.0);
        
        _phoneText = [[UITextField alloc]init];
        [phoneView addSubview:_phoneText];
        _phoneText.placeholder = @"请输入要绑定的手机号";
        _phoneText.font = TEXT_FONTSIZE;
        _phoneText.textColor = [UIColor blackColor];
        _phoneText.sd_layout
        .leftSpaceToView(phoneView, 10*ScrenScale)
        .rightSpaceToView(phoneView, 10*ScrenScale)
        .topSpaceToView(phoneView, 10*ScrenScale)
        .bottomSpaceToView(phoneView, 10*ScrenScale);
        
        //校验码
        UIView *checkCodeView = [[UIView alloc]init];
        [self addSubview:checkCodeView];
        checkCodeView.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        checkCodeView.layer.borderWidth = 0.6;
        checkCodeView.backgroundColor = [UIColor whiteColor];
        checkCodeView.sd_layout
        .leftEqualToView(nameView)
        .topSpaceToView(phoneView, 20*ScrenScale)
        .widthRatioToView(nameView, 0.6)
        .heightRatioToView(nameView, 1.0);
        
        _chekCodeText = [[UITextField alloc]init];
        [checkCodeView addSubview:_chekCodeText];
        _chekCodeText.placeholder = @"请输入校验码";
        _chekCodeText.font = TEXT_FONTSIZE;
        _chekCodeText.textColor = [UIColor blackColor];
        _chekCodeText.keyboardType = UIKeyboardTypeNumberPad;
        _chekCodeText.sd_layout
        .leftSpaceToView(checkCodeView, 10*ScrenScale)
        .rightSpaceToView(checkCodeView, 10*ScrenScale)
        .topSpaceToView(checkCodeView, 10*ScrenScale)
        .bottomSpaceToView(checkCodeView, 10*ScrenScale);
        
        //获取校验码
        _getCheckCodeBtn = [[UIButton alloc]init];
        [self addSubview:_getCheckCodeBtn];
        [_getCheckCodeBtn setTitle:@"获取校验码" forState:UIControlStateNormal];
        [_getCheckCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_getCheckCodeBtn setBackgroundColor:SEPERATELINECOLOR_2];
        _getCheckCodeBtn.layer.borderWidth = 0.6;
        _getCheckCodeBtn.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        _getCheckCodeBtn.titleLabel.font = TEXT_FONTSIZE;
        _getCheckCodeBtn.sd_layout
        .leftSpaceToView(checkCodeView, 0)
        .topEqualToView(checkCodeView)
        .bottomEqualToView(checkCodeView)
        .rightEqualToView(phoneView);
        
        
        
        //密码
        UIView *passwordView = [[UIView alloc]init];
        [self addSubview:passwordView];
        passwordView.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        passwordView.layer.borderWidth = 0.6;
        passwordView.backgroundColor = [UIColor whiteColor];
        passwordView.sd_layout
        .leftEqualToView(phoneView)
        .rightEqualToView(phoneView)
        .topSpaceToView(checkCodeView, 20*ScrenScale)
        .heightRatioToView(phoneView, 1.0);
        
        _passwordText = [[UITextField alloc]init];
        [passwordView addSubview:_passwordText];
        _passwordText.placeholder = @"请输入密码";
        _passwordText.font = TEXT_FONTSIZE;
        _passwordText.textColor = [UIColor blackColor];
        _passwordText.secureTextEntry = YES;
        _passwordText.sd_layout
        .leftSpaceToView(passwordView, 10*ScrenScale)
        .rightSpaceToView(passwordView, 10*ScrenScale)
        .topSpaceToView(passwordView, 10*ScrenScale)
        .bottomSpaceToView(passwordView, 10*ScrenScale);

        
        //验证密码
        UIView *passwordConfirmView = [[UIView alloc]init];
        [self addSubview:passwordConfirmView];
        passwordConfirmView.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        passwordConfirmView.layer.borderWidth = 0.6;
        passwordConfirmView.backgroundColor = [UIColor whiteColor];
        passwordConfirmView.sd_layout
        .leftEqualToView(phoneView)
        .rightEqualToView(phoneView)
        .topSpaceToView(passwordView, 20*ScrenScale)
        .heightRatioToView(phoneView, 1.0);
        
        _passwordConfirmText = [[UITextField alloc]init];
        [passwordConfirmView addSubview:_passwordConfirmText];
        _passwordConfirmText.placeholder = @"确认密码";
        _passwordConfirmText.font = TEXT_FONTSIZE;
        _passwordConfirmText.textColor = [UIColor blackColor];
        _passwordConfirmText.secureTextEntry = YES;
        _passwordConfirmText.sd_layout
        .leftSpaceToView(passwordConfirmView, 10*ScrenScale)
        .rightSpaceToView(passwordConfirmView, 10*ScrenScale)
        .topSpaceToView(passwordConfirmView, 10*ScrenScale)
        .bottomSpaceToView(passwordConfirmView, 10*ScrenScale);
        

        //提示和选择器
        UILabel *tips = [[UILabel alloc]init];
        [self addSubview:tips];
        tips.text = @"接受《答疑时间服务协议》";
        tips.textColor = [UIColor blueColor];
        tips.font = TEXT_FONTSIZE;
        tips.sd_layout
        .leftEqualToView(nameView)
        .topSpaceToView(passwordConfirmView, 20*ScrenScale)
        .autoHeightRatio(0);
        [tips setSingleLineAutoResizeWithMaxWidth:200];
        
        _applyProtocolSwitch = [[UISwitch alloc]init];
        [self addSubview:_applyProtocolSwitch];
        _applyProtocolSwitch.onTintColor = BUTTONRED;
        _applyProtocolSwitch.on = NO;
        
        _applyProtocolSwitch.sd_layout
        .centerYEqualToView(tips)
        .rightEqualToView(nameView)
        .heightRatioToView(tips, 1.0)
        .widthEqualToHeight();
        
        
        //确认绑定按钮
        _finishBtn = [[UIButton alloc]init];
        [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_finishBtn setTitle:@"确认绑定" forState:UIControlStateNormal];
        [_finishBtn setBackgroundColor:SEPERATELINECOLOR_2];
        _finishBtn.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        _finishBtn.layer.borderWidth = 0.6;
        _finishBtn.titleLabel.font = TEXT_FONTSIZE;
        [self addSubview:_finishBtn];
        _finishBtn.sd_layout
        .leftEqualToView(nameView)
        .rightEqualToView(nameView)
        .topSpaceToView(_applyProtocolSwitch, 20*ScrenScale)
        .heightRatioToView(nameView, 1.0);
        
        _finishBtn.sd_cornerRadiusFromHeightRatio = @0.5;
        
        [self setupAutoContentSizeWithBottomView:_finishBtn bottomMargin:20];
        
    }
    return self;
}

@end
