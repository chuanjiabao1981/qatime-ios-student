//
//  LoginAgainViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/10.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAgainView.h"
@interface LoginAgainViewController : UIViewController

@property(nonatomic,strong) LoginAgainView *loginAgainView ;


/* 密码输入错误次数*/
@property(nonatomic,assign) NSInteger wrongTimes;


@end
