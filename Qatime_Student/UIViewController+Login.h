//
//  UIViewController+Login.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/10.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAgainViewController.h"

typedef void(^ReturnState)();


@interface UIViewController (Login)

@property (nonatomic, assign) BOOL loginAlertShow ;

@property (nonatomic, copy) ReturnState returnBlock ;

/**
 再次登录
 */
- (void)loginAgain;


/**
 根据数据内容判断登录状态
 */
- (void)loginStates:(NSDictionary *)dataDic ;

- (void)loginStates:(NSDictionary *)dataDic  state:(ReturnState)block;


/**
 是否登录

 @return 是或否
 */
- (BOOL)isLogin;


@end
