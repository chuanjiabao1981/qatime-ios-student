//
//  FindPasswordView.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/2.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindPasswordView : UIView

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

/* 下一步按钮*/

@property(nonatomic,strong)  UIButton *nextStepButton;



@end
