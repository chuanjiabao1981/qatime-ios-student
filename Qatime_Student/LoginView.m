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
#import "SDAutoLayout.h"
@interface LoginView (){
    
    /* logo图片*/
    UIImageView *_logoImage;
}

@end

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /* logo图片布局*/
        _logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, SCREENWIDES, SCREENWIDES*0.4f)];
        
        [_logoImage setImage:[UIImage imageNamed:@"WechatIMG2"]];
        [self addSubview:_logoImage];
        
        
//        /* <# State #>*/
//        /* 参考线*/
//        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_logoImage.frame), CGRectGetWidth(self.frame), 1)];
//        [line setBackgroundColor:[UIColor grayColor]];
//        [self addSubview:line];
        
        
        
        /* 忘记密码*/
        
        
        _forgottenPassorwdButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDES/2-100, SCREENHEIGHT-50, 200, 30)];
        [self addSubview:_forgottenPassorwdButton];
        [_forgottenPassorwdButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgottenPassorwdButton setTitleColor:[UIColor blueColor]  forState:UIControlStateNormal];
        
        /* 输入账号密码*/
        /* 框1 输入用户账号*/
    
        UIView *text1=[[UIView alloc]init];
        text1.layer.masksToBounds=YES;
        text1.layer.cornerRadius = M_PI*2;
        text1.layer.borderWidth = 0.6;
        text1.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:text1];
        text1.sd_layout.leftSpaceToView(self,20).rightSpaceToView(self,20).topSpaceToView(_logoImage,140).heightIs(60);
        
        /* 用户名框的图标和布局*/
        UIImageView  *loginImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"account"]];
        [text1 addSubview:loginImage];
        loginImage.sd_layout.leftSpaceToView(text1,20).topSpaceToView(text1,20).bottomSpaceToView(text1,20).widthIs(20);

        /* 用户名输入框*/
        _userName = [[UITextField alloc]init];
        [text1 addSubview:_userName];
        _userName.placeholder = @"请输入账号";
        _userName.sd_layout.leftSpaceToView(loginImage,20).topSpaceToView(text1,20).bottomSpaceToView(text1,20).rightSpaceToView(text1,20);
        
        
        /* 框2 输入密码*/
        UIView *text2=[[UIView alloc]init];
        text2.layer.masksToBounds=YES;
        text2.layer.cornerRadius = M_PI*2;
        text2.layer.borderWidth = 0.6;
        text2.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:text2];
        text2.sd_layout.topSpaceToView(text1,0).widthRatioToView(text1,1).heightRatioToView(text1,1).leftSpaceToView(self,20);
        
        /* 用户名框的图标和布局*/
        UIImageView  *passwordImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bags"]];
        [text2 addSubview:passwordImage];
        passwordImage.sd_layout.leftSpaceToView(text2,20).topSpaceToView(text2,20).bottomSpaceToView(text2,20).widthIs(20);
        
        
        /* 密码输入框*/
        /* 用户名输入框*/
        _passWord = [[UITextField alloc]init];
        [text2 addSubview:_passWord];
        _passWord.placeholder = @"请输入密码";
        _passWord.sd_layout.leftSpaceToView(loginImage,20).topSpaceToView(text2,20).bottomSpaceToView(text2,20).rightSpaceToView(text2,20);
        
        
        /* 注册按钮*/
        
        _signUpButton = [[UIButton alloc]init];
        [_signUpButton setBackgroundColor:[UIColor colorWithRed:231/255.0 green:151/255.0 blue:105/255.0 alpha:1.0]];
        [_signUpButton setTitle:@"注册" forState:UIControlStateNormal];
        [_signUpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_signUpButton];
        _signUpButton.sd_layout.leftSpaceToView(self ,20).heightIs(50).widthRatioToView(self,(float)2/5).topSpaceToView(text2,50);
        _signUpButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI*2];
        
        
        
        /* 登录按钮*/
        _loginButton =[[UIButton alloc]init];
        [_loginButton setBackgroundColor:[UIColor colorWithRed:231/255.0 green:151/255.0 blue:105/255.0 alpha:1.0]];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_loginButton];
        _loginButton.sd_layout.rightSpaceToView(self ,20).heightIs(50).widthRatioToView(self,(float)2/5).topSpaceToView(text2,50);
        _loginButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI*2];
        
        
        
        
        
        
    }
    return self;
}




@end
