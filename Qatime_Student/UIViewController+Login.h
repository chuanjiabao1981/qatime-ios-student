//
//  UIViewController+Login.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/10.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAgainViewController.h"

@interface UIViewController (Login)


/**
 再次登录
 */
- (void)loginAgain;


/**
 根据数据内容判断登录状态
 */
- (void)loginStates:(NSDictionary *)dataDic;


/**
 是否登录

 @return 是或否
 */
- (BOOL)isLogin;


@end
