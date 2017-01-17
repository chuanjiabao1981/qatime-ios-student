//
//  AuthenticationView.m
//  Qatime_Student
//
//  Created by Shin on 2017/1/16.
//  Copyright © 2017年 WWTD. All rights reserved.
//


#import "AuthenticationView.h"

@implementation AuthenticationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /* 密码框*/
        _passwordText = [[UITextField alloc]init];
        _passwordText.placeholder = @"请输入登录密码";
        _passwordText.layer.borderWidth = 0.8;
        _passwordText.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        /* 校验码输入框*/
        _checkCodeText = [[UITextField alloc]init];
        _checkCodeText.placeholder = @"输入收到的手机校验码";
        _checkCodeText.layer.borderWidth = 0.8;
        _checkCodeText.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        /* 获取校验码按钮*/
        _getCodeButton = [[UIButton alloc]init];
        [_getCodeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_getCodeButton setTitle:@"获取校验码" forState:UIControlStateNormal];
        _getCodeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _getCodeButton.layer.borderWidth = 1;
        
        
        /* 下一步按钮*/
        
        _nextStepButton = [[UIButton alloc]init];
        [_nextStepButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
        _nextStepButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _nextStepButton.layer.borderWidth = 1;

        
        
        [self sd_addSubviews:@[_passwordText,_checkCodeText,_getCodeButton,_nextStepButton]];
        
        /* 布局*/
        _passwordText.sd_layout
        .topSpaceToView(self,20)
        .leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .heightRatioToView(self,0.07);
        
        _checkCodeText.sd_layout
        .topSpaceToView(_passwordText,20)
        .leftEqualToView(_passwordText)
        .widthRatioToView(_passwordText,0.5)
        .heightRatioToView(_passwordText,1.0);
        
        _getCodeButton.sd_layout
        .leftSpaceToView(_checkCodeText,0)
        .topEqualToView(_checkCodeText)
        .bottomEqualToView(_checkCodeText)
        .rightSpaceToView(self,20);
        
        _nextStepButton.sd_layout
        .leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .topSpaceToView(_getCodeButton,20)
        .heightRatioToView(_getCodeButton,1.0);
        
        
        
        
    }
    return self;
}

@end
