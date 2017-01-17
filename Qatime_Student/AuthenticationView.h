//
//  AuthenticationView.h
//  Qatime_Student
//
//  Created by Shin on 2017/1/16.
//  Copyright © 2017年 WWTD. All rights reserved.
//

/* 支付密码专用 -- 验证身份页面*/

#import <UIKit/UIKit.h>

@interface AuthenticationView : UIView

/* 密码输入框*/
@property(nonatomic,strong) UITextField *passwordText ;

/* 校验码输入框*/
@property(nonatomic,strong) UITextField *checkCodeText ;

/* 获取校验码按钮*/
@property(nonatomic,strong) UIButton *getCodeButton ;

/* 下一步按钮*/
@property(nonatomic,strong) UIButton *nextStepButton ;

@end
