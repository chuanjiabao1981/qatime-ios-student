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
        
        self.backgroundColor = [UIColor whiteColor];
        
        /* 手机号输入框的创建和布局*/
        _phoneNumber = [[UITextField alloc]init];
        [self addSubview:_phoneNumber];
        _phoneNumber.placeholder =@" 请输入绑定手机号码";
        _phoneNumber.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _phoneNumber.layer.borderWidth=0.6;
        _phoneNumber.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        _phoneNumber.sd_layout.topSpaceToView(self,15).leftSpaceToView(self,20).rightSpaceToView(self,20).heightIs(40);
        _phoneNumber.keyboardType = UIKeyboardTypePhonePad;
        
        
        /* 手机校验码输入框*/
        _checkCode = [[UITextField alloc]init];
        [self addSubview:_checkCode];
        _checkCode.placeholder =@" 输入校验码";
        _checkCode.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _checkCode.layer.borderWidth=0.6;
        _checkCode.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        _checkCode.sd_layout.topSpaceToView(_phoneNumber,15).leftSpaceToView(self,20).widthIs((CGRectGetWidth(self.frame)-40)/2).heightIs(40);
        _checkCode.keyboardType = UIKeyboardTypePhonePad;
        
        
        /* 获取校验码按钮*/
        _getCheckCodeButton = [[UIButton alloc]init];
        [self addSubview:_getCheckCodeButton];
        _getCheckCodeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _getCheckCodeButton.layer.borderWidth=0.6;
        _getCheckCodeButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        _getCheckCodeButton.sd_layout.topSpaceToView(_phoneNumber,15).leftSpaceToView(_checkCode,0).widthIs((CGRectGetWidth(self.frame)-40)/2).heightIs(40);
        [_getCheckCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_getCheckCodeButton setTitle:@"获取校验码" forState:UIControlStateNormal];
        
        [_getCheckCodeButton setBackgroundColor:[UIColor colorWithRed:231.0/255.0 green:151.0/255.0 blue:105.0/255.0 alpha:1]];
        
        
        /* 用户密码输入框*/
        
        _userPassword = [[UITextField alloc]init];
        [self addSubview:_userPassword];
        _userPassword.placeholder =@" 输入新密码";
        _userPassword.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _userPassword.layer.borderWidth=0.6;
        _userPassword.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        _userPassword.sd_layout.topSpaceToView(_checkCode,15).leftSpaceToView(self,20).rightSpaceToView(self,20).heightIs(40);
        _userPassword.secureTextEntry = YES;
        
        /* 确认登录密码框*/
        _userPasswordCompare =[[UITextField alloc]init];
        [self addSubview:_userPasswordCompare];
        _userPasswordCompare.placeholder =@" 确认新的密码";
        _userPasswordCompare.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _userPasswordCompare.layer.borderWidth=0.6;
        _userPasswordCompare.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        _userPasswordCompare.sd_layout.topSpaceToView(_userPassword,15).leftSpaceToView(self,20).rightSpaceToView(self,20).heightIs(40);
        _userPasswordCompare.secureTextEntry = YES;
        

        /* 下一步按钮*/
        
        _nextStepButton = [[UIButton alloc]init];
        _nextStepButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI] ;
        [self addSubview:_nextStepButton];
        [_nextStepButton setTitle:@"提交" forState:UIControlStateNormal];
        [_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextStepButton.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:151.0/255.0 blue:105.0/255.0 alpha:1];
        _nextStepButton.sd_layout.leftSpaceToView(self,20).rightSpaceToView(self,20).heightIs(40).topSpaceToView(_userPasswordCompare,30);
        
    
        
    }
    return self;
}

@end
