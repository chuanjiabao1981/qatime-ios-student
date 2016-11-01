//
//  LoginView.h
//  Login
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView

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

@end
