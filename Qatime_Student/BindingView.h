//
//  BindingView.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/2.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SignUpView.h"

@interface BindingView : UIView

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
//@property(nonatomic,strong) UITextField *unlockKey ;

/* 下一步按钮*/
@property(nonatomic,strong)  UIButton *nextStepButton;

/**选择年级*/
@property (nonatomic, strong) UIButton *chooseGrade ;

@property (nonatomic, strong) UIButton *chooseCitys ;

/* 协议选择框*/
@property(nonatomic,strong) UIButton *chosenButton;

/* 同意label*/
@property(nonatomic,strong) UILabel *accessLabel ;

/* 年级选择框*/
//@property(nonatomic,strong) UIButton *grade ;

@end
