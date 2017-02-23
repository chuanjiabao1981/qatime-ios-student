//
//  SignUpViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

//即是找回密码的验证页面  也是提交注册申请的页面

#import <UIKit/UIKit.h>
#import "SignUpView.h"
#import "NavigationBar.h"


@interface SignUpViewController : UIViewController

@property(nonatomic,strong) NavigationBar  *navigationBar ;

@property(nonatomic,strong) SignUpView  *signUpView ;


@end
