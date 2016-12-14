//
//  BindingMailInfoView.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/14.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BindingMailInfoView : UIView

/* 绑定邮箱账号*/
@property(nonatomic,strong) UITextField *mailText ;

/* 验证码输入框*/
@property(nonatomic,strong) UITextField *keyCodeText ;

/* 获取验证码按钮*/
@property(nonatomic,strong) UIButton *getKeyCodeButton ;

/* 下一步按钮*/
@property(nonatomic,strong) UIButton *nextStepButton ;

@end
