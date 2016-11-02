//
//  AppDelegate.h
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,strong) LoginViewController *loginViewController ;

@property(nonatomic,strong) ViewController *viewController ;

@end

