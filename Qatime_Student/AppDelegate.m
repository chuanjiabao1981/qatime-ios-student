//
//  AppDelegate.m
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "AppDelegate.h"
#import "NIMSDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window = [[UIWindow alloc]init];
    [_window makeKeyAndVisible];
    _window.backgroundColor = [UIColor whiteColor];
    
    
    /* 根据本地保存的用户文件  判断是否登录*/
     NSString *userFilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"User.data"];
    if (![[NSFileManager defaultManager]fileExistsAtPath:userFilePath]) {
        
        _loginViewController = [[LoginViewController alloc]init];
        UINavigationController *naviVC=[[UINavigationController alloc]initWithRootViewController:_loginViewController];
        
        [_window setRootViewController:naviVC];
    }else{
        
        _viewController = [[ViewController alloc]init];
        [_window setRootViewController:_viewController];
        
        NSString *token= [[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"];
        NSString *userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"id"];
        NSLog(@"%@,%@",token,userid);
        
    }
    
    
    
    
    
    
    NSLog(@"本地沙盒存储路径：%@", NSHomeDirectory());
    
    /* 添加消息中心监听 判断登录状态*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRootViewConroller:) name:@"UserLogin" object:nil];
    
    
    /* 添加消息监听 判断用户退出登录*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogOut) name:@"userLogOut" object:nil];
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    
    
    
    
    
    
    /* 初始化网易云信SDK*/
    /* 暂时没有推送证书 先暂时不添加推送功能*/
    
    [[NIMSDK sharedSDK] registerWithAppID:@"a4e8381f3955f062cda22fbd7a2c9125"
                                  cerName:@""];
    
    
    [[[NIMSDK sharedSDK] loginManager] login:@"0ba06bd120840dc0423db9d4cb861e99"
                                       token:@"ff1bcf619fb2e571ac3bba87bcac8aeb"
                                  completion:^(NSError *error) {
                                  
                                  NSLog(@"%@",error);
                                  
                                  }];
    
    

    
    
    return YES;
}

- (void)onLogin:(NIMLoginStep)step{
    
}

//APP主动发起自动登录
- (void)autoLogin:(NIMAutoLoginData *)loginData{
    
}

/* 修改rootViewController为系统的主页controller*/
- (void)changeRootViewConroller:(NSNotification *)notification{
    
    
    _viewController = [[ViewController alloc]init];
    
    [_window setRootViewController:_viewController];
    
}

/* 用户退出登录后 跳转到登录页面*/
- (void)userLogOut{
    
     _loginViewController = [[LoginViewController alloc]init];
    UINavigationController *naviVC=[[UINavigationController alloc]initWithRootViewController:_loginViewController];
    
    [_window setRootViewController:naviVC];
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
