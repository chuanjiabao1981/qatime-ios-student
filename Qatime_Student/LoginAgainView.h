//
//  LoginAgainView.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/10.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthenCode.h"

@interface LoginAgainView : UIView
/* 注册按钮*/
@property(nonatomic,strong) UIButton *signUpButton ;
/* 登录按钮*/
@property(nonatomic,strong) UIButton *loginButton ;
/* 用户名*/
@property(nonatomic,strong) UITextField *userName ;
/* 密码*/
@property(nonatomic,strong) UITextField *passWord ;

/* 忘记密码*/
@property(nonatomic,strong) UIButton *forgottenPassorwdButton;


/* 微信登录按钮*/
@property(nonatomic,strong) UIButton *wechatButton ;

/* 跳过登录*/
@property(nonatomic,strong) UIButton *acrossLogin ;

/* 验证码按钮*/
@property(nonatomic,strong) UIButton *keyCodeButton ;
@property (nonatomic, strong) AuthenCode *authenCode ;

/* 外边框*/
@property(nonatomic,strong) UIView *text2 ;
@property(nonatomic,strong) UIView *text3 ;

/* 验证码输入框*/
@property(nonatomic,strong) UITextField *keyCodeText ;
@end
