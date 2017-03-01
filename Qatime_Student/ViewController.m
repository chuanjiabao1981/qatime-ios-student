//
//  ViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ViewController.h"
#import "LivePlayerViewController.h"
#import "ReplayVideoPlayerViewController.h"
#import "AppDelegate.h"




@interface ViewController (){
    
        
    /* tabbar的items*/
    NSMutableArray *items;
    
    /* 未选中状态图标*/
    NSArray *unselectedImage;
    
    /* 选中状态的图标*/
    NSArray *selectedImage;
    
    /* 图标的title*/
    NSArray *titles;
    
    /* 代理单例*/
    AppDelegate *_appDelegate;
    
}



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    
//    NSInteger i = [[UIApplication sharedApplication] statusBarOrientation];
//    
//    if (i == UIInterfaceOrientationLandscapeRight){
//        
//        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//            SEL selector = NSSelectorFromString(@"setOrientation:");
//            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//            [invocation setSelector:selector];
//            [invocation setTarget:[UIDevice currentDevice]];
//            int val = UIInterfaceOrientationLandscapeLeft;//这里可以改变旋转的方向
//            [invocation setArgument:&val atIndex:2];
//            [invocation invoke];
//        }
//        
//    }else if (i == UIInterfaceOrientationLandscapeLeft){
//        
//        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//            SEL selector = NSSelectorFromString(@"setOrientation:");
//            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//            [invocation setSelector:selector];
//            [invocation setTarget:[UIDevice currentDevice]];
//            int val = UIInterfaceOrientationLandscapeRight;//这里可以改变旋转的方向
//            [invocation setArgument:&val atIndex:2];
//            [invocation invoke];
//        }
//        
//    }
//    
//    
//    /* 强制旋转成竖屏*/
//    
//    [[UIApplication sharedApplication]setStatusBarOrientation:UIInterfaceOrientationPortrait];
//
//    [self.view layoutSubviews];
//    [self.view layoutIfNeeded];
//    
//    self.navigationController.navigationBar.hidden = YES;
//    self.navigationController .toolbar.hidden = YES;
//    self.tabBarController.tabBar.hidden = YES;
//    
//    /* 初始化存放item的数组*/
//    items = @[].mutableCopy;
//    
//    /* 设置选项卡未选中情况的图标*/
//    unselectedImage = @[
//                        [UIImage imageNamed:@"tab_home_n"],
//                        [UIImage imageNamed:@"tab_tutorium_n"],
//                        [UIImage imageNamed:@"tab_class_n"],
//                        [UIImage imageNamed:@"tab_message_n"],
//                        [UIImage imageNamed:@"tab_me_n"]
//                        ];
//    
//    /* 选中状态的图标*/
//    selectedImage = @[
//                      [UIImage imageNamed:@"tab_home_h"],
//                      [UIImage imageNamed:@"tab_tutorium_h"],
//                      [UIImage imageNamed:@"tab_class_h"],
//                      [UIImage imageNamed:@"tab_message_h"],
//                      [UIImage imageNamed:@"tab_me_h"]
//                      ];

    /* 主页消息badge通知*/
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(badgeShows) name:@"ReceiveNewNotice" object:nil];
    
    /* 主页消息全读通知*/
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(badgeHides) name:@"AllMessageRead" object:nil];
    
}



    
- (BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
