//
//  SignUpInfoViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/1.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpInfoView.h"
#import "NavigationBar.h"

@interface SignUpInfoViewController : UIViewController

@property(nonatomic,strong) SignUpInfoView *signUpInfoView ;
@property(nonatomic,strong) NavigationBar *navigationBar ;

/* 初始化传登录账号密码值*/
-(instancetype)initWithAccount:(NSString *)account andPassword:(NSString *)password ;

@end
