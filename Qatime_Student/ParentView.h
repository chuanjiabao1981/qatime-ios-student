//
//  ParentView.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/2.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTextView.h"

@interface ParentView : UIView

/* 家长手机号*/
@property(nonatomic,strong) UILabel *parentPhoneLabel ;

/* 登录密码框*/
//@property(nonatomic,strong) UITextField *password ;

/* 家长手机号*/
@property(nonatomic,strong) UITextField *parentPhoneText ;

/* 校验码*/

@property(nonatomic,strong) UITextField *keyCodeText ;


/* 获取校验码按钮*/

@property(nonatomic,strong) UIButton  *getCodeButton;

/* 完成按钮*/

@property(nonatomic,strong) UIButton *finishButton ;


@end
