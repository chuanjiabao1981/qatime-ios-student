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
    
    /* 4个viewcontroller的NavigationController作为根视图*/
    UINavigationController *indexPageVC;
    UINavigationController *tutoriumVC ;
    UINavigationController *classTimeVC ;
    UINavigationController *personalVC ;
    
    
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
    
    NSInteger i = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (i == UIInterfaceOrientationLandscapeRight){
        
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationLandscapeLeft;//这里可以改变旋转的方向
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
        
    }else if (i == UIInterfaceOrientationLandscapeLeft){
        
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationLandscapeRight;//这里可以改变旋转的方向
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
        
    }
    
    
    /* 强制旋转成竖屏*/
//
    [[UIApplication sharedApplication]setStatusBarOrientation:UIInterfaceOrientationPortrait];
//    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait]forKey:@"orientation"];
//    self.view.frame = CGRectMake(CGRectGetWidth([[UIScreen mainScreen]bounds]), 0, CGRectGetHeight([[UIScreen mainScreen]bounds]), CGRectGetWidth([[UIScreen mainScreen]bounds]));
    
    [self.view layoutSubviews];
    [self.view layoutIfNeeded];
    
//    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController .toolbar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    /* 初始化存放item的数组*/
    items = @[].mutableCopy;

    /* 初始化四个viewcontroller*/
    _indexPageViewController = [[IndexPageViewController alloc]init];
    _tutoriumViewController = [[TutoriumViewController alloc]init];
    _classTimeViewController = [[ClassTimeViewController alloc]init];
    _personalViewController = [[PersonalViewController alloc]init];
    
    /* 初始化4个navigationcontroller*/
    indexPageVC = [[UINavigationController alloc]initWithRootViewController:_indexPageViewController];
    tutoriumVC = [[UINavigationController alloc]initWithRootViewController:_tutoriumViewController];
    classTimeVC = [[UINavigationController alloc]initWithRootViewController:_classTimeViewController];
    personalVC = [[UINavigationController alloc]initWithRootViewController:_personalViewController];
    
    /* 选项卡的ViewControllers*/
    [self setViewControllers:@[indexPageVC,tutoriumVC,classTimeVC,personalVC]];
    
    /* 设置选项卡未选中情况的图标*/
    unselectedImage = @[
                        [UIImage imageNamed:@"tab_home_n"],
                        [UIImage imageNamed:@"tab_tutorium_n"],
                        [UIImage imageNamed:@"tab_class_n"],
                        [UIImage imageNamed:@"tab_me_n"]
                        ];
    
    /* 选中状态的图标*/
    selectedImage = @[
                      [UIImage imageNamed:@"tab_home_h"],
                      [UIImage imageNamed:@"tab_tutorium_h"],
                      [UIImage imageNamed:@"tab_class_h"],
                      [UIImage imageNamed:@"tab_me_h"]
                      ];
    
    
    /* 选项卡的标题*/
    titles = @[
               NSLocalizedString(@"首页", comment:""),
               NSLocalizedString(@"辅导班", comment:""),
               NSLocalizedString(@"课程表", comment:""),
               NSLocalizedString(@"个人", comment:"")
               ];
    
    /* 遍历选项卡按钮*/
    
    for (int i=0; i<4; i++) {
        
        RDVTabBarItem *item=[[RDVTabBarItem alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.tabBar.frame)/4*i, 0, CGRectGetWidth(self.tabBar.frame)/4, CGRectGetHeight(self.tabBar.frame))];
    
        [item setFinishedSelectedImage:selectedImage[i] withFinishedUnselectedImage:unselectedImage[i]];
        [item setTitle:titles[i]];
        item.unselectedTitleAttributes= @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00]};
        
        item.selectedTitleAttributes=@{NSForegroundColorAttributeName:TITLERED};
        [item setTitlePositionAdjustment:UIOffsetMake(0, 3)];
        
        [items addObject:item];
    }
    
       [self.tabBar setItems:items];
//    self.tabBar.backgroundView.backgroundColor=BLUECOLOR;
   
    self.selectedIndex=0;
    
    self.tabBar.height = TabBar_Height;
    self.tabBar.backgroundView.backgroundColor = [UIColor whiteColor];
    
    _appDelegate = [[AppDelegate alloc]init];
    
//    UIView *line = [[UIView alloc]init];
//    [self.view addSubview:line];
//    line.sd_layout
//    .leftEqualToView(self.view)
//    .rightEqualToView(self.view)
//    .bottomSpaceToView(self.tabBar,0)
//    .heightIs(1);
//    line.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tab_background"]];
    image.frame = CGRectMake(0, 0, self.view.width_sd, 49) ;
    [self.tabBar.backgroundView addSubview:image];
    
}
    
- (BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}



// 是否支持自动转屏
//- (BOOL)shouldAutorotate{
//    
//    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"SupportedLandscape"]) {
//        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"SupportedLandscape"]==YES) {
//            return YES;
//        }else{
//            
//        }
//    }else{
//        
//    }
//    return NO;
//}
//
//// 支持哪些屏幕方向
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    
//
//    
//    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"SupportedLandscape"]) {
//        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"SupportedLandscape"]==YES) {
//            return UIInterfaceOrientationMaskAllButUpsideDown;
//        }else{
//            
//        }
//    }else{
//        
//    }
//    
//    
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationPortrait;
//}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
