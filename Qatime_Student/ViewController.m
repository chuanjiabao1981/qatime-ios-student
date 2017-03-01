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


}

- (void)showNIMPage:(NSNotification *)notification{
    
    
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
