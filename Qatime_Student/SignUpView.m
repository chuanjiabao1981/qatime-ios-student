//
//  SignUpView.m
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "SignUpView.h"
#import "UIView+FontSize.h"

@interface SignUpView()<UITextFieldDelegate>{
    
    BOOL selectedPolicy;
    
}

@end

@implementation SignUpView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        /* 手机号输入框的创建和布局*/
        _phoneNumber = [[UITextField alloc]init];
        [self addSubview:_phoneNumber];
        _phoneNumber.placeholder =NSLocalizedString(@" 请输入大陆地区11位手机号", nil);
        _phoneNumber.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _phoneNumber.layer.borderWidth=0.6;
        _phoneNumber.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        _phoneNumber.sd_layout.topSpaceToView(self,15).leftSpaceToView(self,20).rightSpaceToView(self,20).heightIs(40);
        _phoneNumber.keyboardType = UIKeyboardTypePhonePad;
        
        
        /* 手机校验码输入框*/
        _checkCode = [[UITextField alloc]init];
        [self addSubview:_checkCode];
        _checkCode.placeholder = NSLocalizedString(@" 输入校验码", nil) ;
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
        [_getCheckCodeButton setTitle:NSLocalizedString(@"获取校验码", nil) forState:UIControlStateNormal];
        [_getCheckCodeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        [_getCheckCodeButton setBackgroundColor:[UIColor colorWithRed:231.0/255.0 green:151.0/255.0 blue:105.0/255.0 alpha:1]];
        _getCheckCodeButton.enabled = NO;
        [_getCheckCodeButton setEnlargeEdge:10];
        
        /* 用户密码输入框*/
        
        _userPassword = [[UITextField alloc]init];
        [self addSubview:_userPassword];
        _userPassword.placeholder = NSLocalizedString(@" 输入登录密码", nil);
        _userPassword.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _userPassword.layer.borderWidth=0.6;
        _userPassword.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        _userPassword.sd_layout.topSpaceToView(_checkCode,15).leftSpaceToView(self,20).rightSpaceToView(self,20).heightIs(40);
        _userPassword.secureTextEntry = YES;
        
        
        /* 确认登录密码框*/
        _userPasswordCompare =[[UITextField alloc]init];
        [self addSubview:_userPasswordCompare];
        _userPasswordCompare.placeholder =NSLocalizedString(@" 确认登录密码", nil);
        _userPasswordCompare.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _userPasswordCompare.layer.borderWidth=0.6;
        _userPasswordCompare.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        _userPasswordCompare.sd_layout.topSpaceToView(_userPassword,15).leftSpaceToView(self,20).rightSpaceToView(self,20).heightIs(40);
        _userPasswordCompare.secureTextEntry = YES;
        
        /* 注册码输入框  暂时隐藏*/
        
        _unlockKey =[[UITextField alloc]init];
        [self addSubview:_unlockKey];
        _unlockKey .hidden = YES;
        _unlockKey.placeholder =@" 请输入答疑时间注册码";
        _unlockKey.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _unlockKey.layer.borderWidth=0.6;
        _unlockKey.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        _unlockKey.sd_layout.topSpaceToView(_userPasswordCompare,15).leftSpaceToView(self,20).rightSpaceToView(self,20).heightIs(40);
        
        
        
        /* 同意用户协议的选择框*/
        
        _chosenButton = [[UIButton alloc]init];
        [self addSubview:_chosenButton];
        _chosenButton .layer.borderColor =TITLECOLOR.CGColor;
        _chosenButton.layer.borderWidth=1.0f;
        _chosenButton.sd_layout.leftSpaceToView(self,30).widthIs(20).heightIs(20).topSpaceToView(_unlockKey,30);
        _chosenButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        
        _chosenButton.selected = NO;
        [_chosenButton setEnlargeEdge:20];
        
        /* 同意label*/
        _accessLabel= [[UILabel alloc]init];
        [self addSubview:_accessLabel];
        [_accessLabel setText:NSLocalizedString(@"同意", nil)];
        _accessLabel.textColor = TITLECOLOR;
        _accessLabel.sd_layout.leftSpaceToView(_chosenButton,10).topEqualToView(_chosenButton).bottomEqualToView(_chosenButton);
        [_accessLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        
        /* 查看协议 按钮*/
        _userPolicy = [[UIButton alloc]init];
        [self addSubview: _userPolicy];
        [_userPolicy setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_userPolicy  setTitle:NSLocalizedString(@"《答疑时间用户协议》", nil) forState:UIControlStateNormal];
        [_userPolicy setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        _userPolicy.sd_layout.leftSpaceToView(_accessLabel,0).topEqualToView(_accessLabel).bottomEqualToView(_accessLabel).widthIs(220);
        
        /* 下一步按钮*/
        _nextStepButton = [[UIButton alloc]init];
        _nextStepButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI] ;
        [self addSubview:_nextStepButton];
        [_nextStepButton setTitle:NSLocalizedString(@"下一步",nil) forState:UIControlStateNormal];
        [_nextStepButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _nextStepButton.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:151.0/255.0 blue:105.0/255.0 alpha:1];
        _nextStepButton.sd_layout.leftSpaceToView(self,20).rightSpaceToView(self,20).heightIs(40).topSpaceToView(_userPolicy,30);
        _nextStepButton.enabled = NO;
        [_nextStepButton setEnlargeEdge:20];
        
    }
    return self;
}






@end
