//
//  VerifyPasswordViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/20.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentViewController.h"


typedef enum : NSUInteger {
    ParentPhoneType,    //验证家长手机
    BindingEmail,       //绑定邮箱
    
} VerifyType;
@interface VerifyPasswordViewController : UIViewController

-(instancetype)initWithType:(VerifyType)verifyType;

/* 输入密码的textfiled,隐藏*/
@property(nonatomic,strong) UITextField *passwordText;

@end
