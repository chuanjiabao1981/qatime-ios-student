//
//  BindingMailView.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/13.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindingMailView : UIView

/* 当前绑定手机*/
@property(nonatomic,strong) UILabel *phoneLabel ;

/* 验证码输入框*/
@property(nonatomic,strong) UITextField *keyCodeText ;

/* 获取验证码按钮*/
@property(nonatomic,strong) UIButton *getKeyCodeButton ;

/* 下一步按钮*/
@property(nonatomic,strong) UIButton *nextStepButton ;

@end
