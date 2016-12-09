//
//  ViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ViewController.h"


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
    
}



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
               @"首页",
               @"辅导班",
               @"课程表",
               @"个人"
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
    
   
    
    
    
    
}
    
    
- (BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}





// 支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

// 页面展示的时候默认屏幕方向（当前ViewController必须是通过模态ViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
