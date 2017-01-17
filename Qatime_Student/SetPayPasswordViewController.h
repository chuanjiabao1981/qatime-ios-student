//
//  SetPayPasswordViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/1/16.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetPayPasswordView.h"

typedef NS_ENUM(NSUInteger, SetPayPassordType) {
    VerifyPassword = 0, //验证密码
    SetNewPassword,     //设置新密码
    CompareNewPassword, //确认新密码
};


@interface SetPayPasswordViewController : UIViewController

/* 页面风格(页面用途)*/
@property(nonatomic,assign) SetPayPassordType pageType ;

@property(nonatomic,strong) SetPayPasswordView *setPayPasswordView ;

/* 找回密码按钮*/
@property(nonatomic,strong) UIButton *findPayPasswordButton;


/* 完成按钮*/
@property(nonatomic,strong) UIButton *finishButton ;

/* 输入密码的textfiled,隐藏*/
@property(nonatomic,strong) UITextField *passwordText;

/* 验证支付密码*/
-(instancetype)initWithPageType:(SetPayPassordType)type;



@end
