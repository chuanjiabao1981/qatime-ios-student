//
//  SignUpView.h
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpView : UIView

/* 手机号*/
@property(nonatomic,strong) UITextField *phoneNumber ;

/* 校验码*/
@property(nonatomic,strong) UITextField *checkCode ;

/* 获取校验码按钮*/
@property(nonatomic,strong) UIButton *getCheckCodeButton ;

/* 密码*/
@property(nonatomic,strong) UITextField *userPassword ;

/* 确认密码*/
@property(nonatomic,strong) UITextField *userPasswordCompare ;

/* 注册码*/
@property(nonatomic,strong) UITextField *unlockKey ;

/* 下一步按钮*/

@property(nonatomic,strong)  UIButton *nextStepButton;

/* 协议选择框*/
@property(nonatomic,strong) UIButton *chosenButton; 


/* 同意label*/
@property(nonatomic,strong) UILabel *accessLabel ;

/* 用户协议*/
@property(nonatomic,strong)  UIButton *userPolicy; 


@end
