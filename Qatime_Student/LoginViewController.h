//
//  LoginViewController.h
//  Login
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginView.h"
#import "SignUpViewController.h"
#import "Chat_Account.h"

@interface LoginViewController : UIViewController

@property(nonatomic,strong) LoginView  *loginView ;

/* 密码输入错误次数*/
@property(nonatomic,assign) NSInteger wrongTimes;

@end
