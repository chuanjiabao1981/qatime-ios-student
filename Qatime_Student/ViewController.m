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
#import "ChatViewController.h"


@interface ViewController (){
    
}

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBar.hidden = NO;
//     [self setValue:self.lcTabBar forKey:@"tabBar"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.hidden = NO;
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"NO"];
    
}


    
- (BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"SupportedLandscape"]==YES) {
        
        return  UIInterfaceOrientationMaskAllButUpsideDown;
    }else{
        
        return UIInterfaceOrientationMaskPortrait;
    }
  
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
