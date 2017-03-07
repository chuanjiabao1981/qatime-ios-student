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
#import "WXApi.h"

#import "IndexPageViewController.h"
#import "TutoriumViewController.h"
#import "ClassTimeViewController.h"
#import "PersonalViewController.h"
#import "NoticeIndexViewController.h"

#import "LCTabBarController.h"
#import "LCTabBar.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,LCTabBarDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,strong) LoginViewController *loginViewController ;

@property(nonatomic,strong) LCTabBarController *viewController ;




@end

