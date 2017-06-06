//
//  LoginView.m
//  Login
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#define SCREENWIDES CGRectGetWidth(self.frame)
#define SCREENHEIGHT CGRectGetHeight(self.frame)


#import "LoginView.h"
#import "AuthenCode.h"

@interface LoginView (){

    
}

@end

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

       
        /* 跳过登录*/
        _acrossLogin = [[UIButton alloc]init];
        [self addSubview:_acrossLogin];
        [_acrossLogin setTitle:NSLocalizedString(@"游客登录", comment:"") forState:UIControlStateNormal];
        [_acrossLogin setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _acrossLogin.titleLabel.font = [UIFont systemFontOfSize:16*ScrenScale];
        [_acrossLogin setBackgroundColor:[UIColor whiteColor]];
        
        _acrossLogin.sd_layout
        .rightSpaceToView(self, 15*ScrenScale)
        .topSpaceToView(self, 35*ScrenScale)
        .autoHeightRatio(0);
        [_acrossLogin setupAutoSizeWithHorizontalPadding:15 buttonHeight:30];
        [_acrossLogin updateLayout];
        [_acrossLogin setEnlargeEdge:20];
        
        /**logo*/
        _logoImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo_big"]];
        [self addSubview:_logoImage];
        
        _logoImage.sd_layout
        .centerXEqualToView(self)
        .topSpaceToView(_acrossLogin, Navigation_Height*2)
        .widthRatioToView(self, 2/3.0)
        .autoHeightRatio(112/479.0);
        [_logoImage updateLayout];
        
        
        /* 微信登录按钮*/
        _wechatButton = [[UIButton alloc]init];
        [_wechatButton setImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
        [self addSubview:_wechatButton];
        
        _wechatButton.sd_layout
        .centerXEqualToView(self)
        .bottomSpaceToView(self,10*ScrenScale320)
        .widthIs(25)
        .heightEqualToWidth();
        
        /* 其他方式登录label和view*/
        UILabel *wechatLogin = [[UILabel alloc]init];
        wechatLogin.text = NSLocalizedString(@"其他方式登录", comment:"");
        wechatLogin.textColor = [UIColor lightGrayColor];
        wechatLogin.font = [UIFont systemFontOfSize:16*ScrenScale];
        [self addSubview:wechatLogin];
        
        wechatLogin.sd_layout
        .centerXEqualToView(self)
        .bottomSpaceToView(_wechatButton,10*ScrenScale320)
        .autoHeightRatio(0);
        [wechatLogin setSingleLineAutoResizeWithMaxWidth:500];
        
        UIView *line1 = [[UIView alloc]init];
        line1.backgroundColor = SEPERATELINECOLOR_2;
        [self addSubview:line1];
        
        UIView *line2 = [[UIView alloc]init];
        line2.backgroundColor = SEPERATELINECOLOR_2;
        [self addSubview:line2];

        line1.sd_layout
        .centerYEqualToView(wechatLogin)
        .leftEqualToView(self)
        .rightSpaceToView(wechatLogin,15)
        .heightIs(0.5);
        
        line2.sd_layout
        .centerYEqualToView(wechatLogin)
        .rightEqualToView(self)
        .leftSpaceToView(wechatLogin,15)
        .heightIs(0.5);
        
        /* 输入账号密码*/
        /* 框1 输入用户账号*/
        _text1=[[UIView alloc]init];
        _text1.layer.borderWidth = 0.6;
        _text1.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        [self addSubview:_text1];
        
        _text1.sd_layout
        .leftSpaceToView(self,30*ScrenScale)
        .topSpaceToView(_logoImage,Navigation_Height*2)
        .rightSpaceToView(self,30*ScrenScale)
        .heightIs(50*ScrenScale);
        
        /* 用户名输入框*/
        _userName = [[UITextField alloc]init];
        _userName.font = TEXT_FONTSIZE;
        [_text1 addSubview:_userName];
        _userName.placeholder = NSLocalizedString(@"请输入手机号码或邮箱",comment: "");
        
        _userName.sd_layout
        .leftSpaceToView(_text1,10)
        .topSpaceToView(_text1,10)
        .bottomSpaceToView(_text1,10)
        .rightSpaceToView(_text1,10);

        
        /* 框2 输入密码*/
        _text2=[[UIView alloc]init];
        _text2.layer.borderWidth = 0.6;
        _text2.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        [self addSubview:_text2];
        _text2.sd_layout
        .topSpaceToView(_text1,-1)
        .leftEqualToView(_text1)
        .rightEqualToView(_text1)
        .heightRatioToView(_text1,1.0f);

        /* 密码输入框*/
        /* 用户名输入框*/
        _passWord = [[UITextField alloc]init];
        _passWord.font=TEXT_FONTSIZE;
        [_text2 addSubview:_passWord];
        _passWord.placeholder = NSLocalizedString(@"请输入密码", comment:"");
        
        _passWord.sd_layout
        .leftSpaceToView(_text2,10)
        .topSpaceToView(_text2,10)
        .bottomSpaceToView(_text2,10)
        .rightSpaceToView(_text2,10);
        
        
        /* 登录按钮*/
        _loginButton =[[UIButton alloc]init];
        _loginButton.layer.borderColor =NAVIGATIONRED.CGColor;
        _loginButton.layer.borderWidth = 1.0f;
        
        [_loginButton setTitle:NSLocalizedString(@"登录", comment:"") forState:UIControlStateNormal];
        [_loginButton setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
        [self addSubview:_loginButton];
        
        _loginButton.sd_layout
        .topSpaceToView(_text2,10*ScrenScale320)
        .leftEqualToView(_text2)
        .rightEqualToView(_text2)
        .heightRatioToView(_text2,0.9f);
        _loginButton.sd_cornerRadius = [NSNumber numberWithFloat:2];
        
        /* 注册按钮*/
        _signUpButton = [[UIButton alloc]init];
        [_signUpButton setTitle:NSLocalizedString(@"注册账号", comment:"") forState:UIControlStateNormal];
        [_signUpButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self addSubview:_signUpButton];
        _signUpButton.titleLabel.font = [UIFont systemFontOfSize:16*ScrenScale];
        [_signUpButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_signUpButton setEnlargeEdge:20];
        
        _signUpButton.sd_layout
        .leftEqualToView(_loginButton)
        .topSpaceToView(_loginButton,10*ScrenScale)
        .heightIs(20)
        .widthIs(80);
        
        /* 忘记密码*/
        _forgottenPassorwdButton = [[UIButton alloc]init];
        [self addSubview:_forgottenPassorwdButton];
        _forgottenPassorwdButton.titleLabel.font = [UIFont systemFontOfSize:16*ScrenScale];
        [_forgottenPassorwdButton setTitle:NSLocalizedString(@"忘记密码?", comment:"") forState:UIControlStateNormal];
        [_forgottenPassorwdButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_forgottenPassorwdButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_forgottenPassorwdButton setEnlargeEdge:20];
        
        _forgottenPassorwdButton.sd_layout
        .rightEqualToView(_loginButton)
        .topSpaceToView(_loginButton,10*ScrenScale)
        .heightIs(20)
        .widthIs(80);

       
        /* 验证码按钮*/
        _keyCodeButton = [[UIButton alloc]init];
//        _keyCodeButton.backgroundColor = [UIColor lightGrayColor];
        [_keyCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_keyCodeButton];
        _keyCodeButton.hidden = YES;
        _keyCodeButton.titleLabel.font = [UIFont systemFontOfSize:22*ScrenScale];
        
        /* 验证码生成*/
        _keyCodeButton.sd_layout
        .rightEqualToView(_text2)
        .heightRatioToView(_text2,0.9)
        .topSpaceToView(_text2,20)
        .widthRatioToView(_text2,2/5.0f);

        [_keyCodeButton updateLayout];
        
        /**自动变换验证码*/
        _authenCode = [[AuthenCode alloc]initWithFrame:CGRectMake(0, 0, _keyCodeButton.width_sd, _keyCodeButton.height_sd)];
        [_keyCodeButton addSubview: _authenCode];
        
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
