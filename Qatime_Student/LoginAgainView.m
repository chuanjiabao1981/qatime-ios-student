
//
//  LoginAgainView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/10.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "LoginAgainView.h"

#define SCREENWIDES CGRectGetWidth(self.frame)
#define SCREENHEIGHT CGRectGetHeight(self.frame)



#import "UIView+FontSize.h"



@interface LoginAgainView (){
    
    /* logo图片*/
    UIImageView *_logoImage;
    
    
    
    
    
    
}

@end

@implementation LoginAgainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        
        
        
        
        
        
        /* 输入账号密码*/
        /* 框1 输入用户账号*/
        
        UIView *text1=[[UIView alloc]init];
        //        text1.layer.masksToBounds=YES;
        //        text1.layer.cornerRadius = M_PI;
        text1.layer.borderWidth = 1;
        text1.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:text1];
        
        
        /* 用户名输入框*/
        _userName = [[UITextField alloc]init];
        [text1 addSubview:_userName];
        _userName.placeholder = @"请输入手机号码或邮箱";
        
        
        /* 框2 输入密码*/
        _text2=[[UIView alloc]init];
        //        _text2.layer.masksToBounds=YES;
        //        _text2.layer.cornerRadius = M_PI;
        _text2.layer.borderWidth = 1;
        _text2.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:_text2];
        
        
        
        /* 密码输入框*/
        /* 用户名输入框*/
        _passWord = [[UITextField alloc]init];
        [_text2 addSubview:_passWord];
        _passWord.placeholder = @"请输入密码";
        
        
        /* 注册按钮*/
        
        _signUpButton = [[UIButton alloc]init];
        [_signUpButton setTitle:@"注册账号" forState:UIControlStateNormal];
        [_signUpButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self addSubview:_signUpButton];
        _signUpButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _signUpButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        
        /* 忘记密码*/
        
        _forgottenPassorwdButton = [[UIButton alloc]init];
        [self addSubview:_forgottenPassorwdButton];
        _forgottenPassorwdButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_forgottenPassorwdButton setTitle:@"找回密码" forState:UIControlStateNormal];
        [_forgottenPassorwdButton setTitleColor:[UIColor grayColor]  forState:UIControlStateNormal];
        
        
        
        
        /* 登录按钮*/
        _loginButton =[[UIButton alloc]init];
        _loginButton.layer.borderColor =[UIColor colorWithRed:0.79 green:0.0 blue:0.0 alpha:1.00].CGColor;
        _loginButton.layer.borderWidth = 1.0f;
        
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor colorWithRed:0.79 green:0.0 blue:0.0 alpha:1.00] forState:UIControlStateNormal];
        [self addSubview:_loginButton];
        
        
        /* 微信登录按钮*/
        
        _wechatButton = [[UIButton alloc]init];
        [_wechatButton setImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
        [self addSubview:_wechatButton];
        
        /* 其他方式登录label和view*/
        UILabel *wechatLogin = [[UILabel alloc]init];
        wechatLogin.text = @"其他方式登录";
        wechatLogin.textColor = [UIColor lightGrayColor];
        wechatLogin.font = [UIFont systemFontOfSize:16];
        [self addSubview:wechatLogin];
        
        UIView *line1 = [[UIView alloc]init];
        line1.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line1];
        
        UIView *line2 = [[UIView alloc]init];
        line2.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line2];
        
        
        /* 跳过登录*/
        _acrossLogin = [[UIButton alloc]init];
        [self addSubview:_acrossLogin];
        [_acrossLogin setTitle:@"跳过登录" forState:UIControlStateNormal];
        _acrossLogin.layer.masksToBounds = YES;
        _acrossLogin.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _acrossLogin.layer.borderWidth = 1.0f;
        [_acrossLogin setTitleColor:[UIColor colorWithRed:0.79 green:0.00 blue:0.00 alpha:1.00] forState:UIControlStateNormal];
        _acrossLogin.titleLabel.font = [UIFont systemFontOfSize:16];
        
        
        /* 验证码按钮*/
        _keyCodeButton = [[UIButton alloc]init];
        _keyCodeButton.backgroundColor = [UIColor lightGrayColor];
        [_keyCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_keyCodeButton];
        _keyCodeButton.hidden = YES;
        _keyCodeButton.titleLabel.font = [UIFont systemFontOfSize:22];
        
        /* 验证码框*/
        _text3 = [[UIView alloc]init];
        _text3.layer.borderWidth =1;
        _text3.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:_text3];
        
        _text3.hidden = YES;
        
        /* 验证码输入框*/
        
        _keyCodeText =[[UITextField alloc]init];
        [_text3 addSubview:_keyCodeText];
        _keyCodeText.hidden = YES;
        
        
        
        
        
        /* 布局*/
        text1.sd_layout
        .leftSpaceToView(self,20)
        .topSpaceToView(self,40)
        .rightSpaceToView(self,20)
        .heightRatioToView(self,0.065f);
        //        text1.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        
        _userName.sd_layout
        .leftSpaceToView(text1,10)
        .topSpaceToView(text1,10)
        .bottomSpaceToView(text1,10)
        .rightSpaceToView(text1,10);
        
        _text2.sd_layout
        .topSpaceToView(text1,-1)
        .leftEqualToView(text1)
        .rightEqualToView(text1)
        .heightRatioToView(text1,1.0f);
        //        _text2.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        
        _passWord.sd_layout
        .leftSpaceToView(_text2,10)
        .topSpaceToView(_text2,10)
        .bottomSpaceToView(_text2,10)
        .rightSpaceToView(_text2,10);
        
        
        _loginButton.sd_layout
        .topSpaceToView(_text2,20)
        .leftEqualToView(_text2)
        .rightEqualToView(_text2)
        .heightRatioToView(_text2,0.8f);
        _loginButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        
        
        _signUpButton.sd_layout
        .leftEqualToView(_loginButton)
        .topSpaceToView(_loginButton,30)
        .heightIs(20)
        .widthIs(80);
        
        _forgottenPassorwdButton.sd_layout
        .rightEqualToView(_loginButton)
        .topSpaceToView(_loginButton,30)
        .heightIs(20)
        .widthIs(80);
        
        
        /* 微信按钮布局*/
        
        _wechatButton.sd_layout
        .centerXEqualToView(self)
        .bottomSpaceToView(self,25)
        .widthIs(30)
        .heightIs(30);
        
        
        wechatLogin.sd_layout
        .centerXEqualToView(self)
        .bottomSpaceToView(_wechatButton,20)
        .heightIs(20);
        [wechatLogin setSingleLineAutoResizeWithMaxWidth:500];
        
        
        line1.sd_layout
        .centerYEqualToView(wechatLogin)
        .leftEqualToView(self)
        .rightSpaceToView(wechatLogin,25)
        .heightIs(0.6);
        
        line2.sd_layout
        .centerYEqualToView(wechatLogin)
        .rightEqualToView(self)
        .leftSpaceToView(wechatLogin,25)
        .heightIs(0.6);
        
        
        
        /* 跳过登录*/
        
//        _acrossLogin.sd_layout
//        .centerXEqualToView(self)
//        .heightIs(30)
//        .widthIs(100)
//        .bottomSpaceToView(wechatLogin,25) ;
//        _acrossLogin.sd_cornerRadius = [NSNumber numberWithFloat:M_PI*2];
        
        
        /* 验证码生成*/
        _keyCodeButton.sd_layout
        .rightEqualToView(_text2)
        .heightRatioToView(_text2,0.9)
        .topSpaceToView(_text2,20)
        .widthRatioToView(_text2,2/5.0f);
        
        _text3.sd_layout
        .leftEqualToView(_text2)
        .rightSpaceToView(_keyCodeButton,0)
        .topEqualToView(_keyCodeButton)
        .bottomEqualToView(_keyCodeButton);
        
        _keyCodeText.sd_layout
        .leftSpaceToView(_text3,10)
        .topSpaceToView(_text3,10)
        .bottomSpaceToView(_text3,10)
        .rightSpaceToView(_text3,10);
        
        
    }
    return self;
}




@end
