//
//  ChangePasswordView.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/5.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordView : UIView

/* 当前密码*/
@property(nonatomic,strong) UITextField *passwordText ;
/* 新密码*/
@property(nonatomic,strong) UITextField *newsPasswordText ;
/* 确认密码*/
@property(nonatomic,strong) UITextField *comparePasswordText ;

/* 忘记密码按钮*/
@property(nonatomic,strong) UIButton *forgetPassword ;

/* 完成按钮*/

@property(nonatomic,strong) UIButton *finishButton ;



/* 两个判断输入密码情况的图*/

@property(nonatomic,strong) UIImageView *passwordImage ;

@property(nonatomic,strong) UIImageView *comparePasswordImage ;




@end
