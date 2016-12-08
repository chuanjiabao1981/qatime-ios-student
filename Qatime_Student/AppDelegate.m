//
//  AppDelegate.m
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "AppDelegate.h"
#import "NIMSDK.h"


#import "BindingViewController.h"

#import "UMessage.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogOut) name:@"userLogOut" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRootViewConroller:) name:@"UserLogin" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRootViewConroller:) name:@"EnterWithoutLogin" object:nil];
    
    
    
    /* 监听登录方式:账号密码登录(Normal)或是微信登录(wechat)*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangeLoginRoot:) name:@"Login_Type" object:nil];
    
    
    /* 微信登录状态的监听*/
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangRootToPerInfo:) name:@"WechatLoginSucess" object:nil];
    
    
    /* 获取code成功*/
//       [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangRootToPerInfo) name:@"GetCodeSucess" object:nil];
//    
    
    
    
    /* 添加消息监听 判断用户退出登录*/
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    

    
    /* 注册微信API*/
    
    [WXApi registerApp:@"wxf2dfbeb5f641ce40"];
    
    
    
    /* 初始化网易云信SDK*/
    
    
    [[NIMSDK sharedSDK] registerWithAppID:@"2a24ca70e580cab2bef58b1e62478f9f"
                                  cerName:@"QatimeStudent_aps"];
    
    
    
    
    #pragma mark- 注册系统推送
    //初始化方法,也可以使用(void)startWithAppkey:(NSString *)appKey launchOptions:(NSDictionary * )launchOptions httpsenable:(BOOL)value;这个方法，方便设置https请求。
    [UMessage startWithAppkey:@"5846465b1c5dd042ae000732" launchOptions:launchOptions];
    
    
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];
    
    
    return YES;
}


#pragma mark- 推送回调

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    
    NSLog(@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
    
    
    /// Required - 注册 DeviceToken
    
    
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
    
 
    
}
//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
    //    self.userInfo = userInfo;
    //    //定制自定的的弹出框
    //    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    //    {
    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
    //                                                            message:@"Test On ApplicationStateActive"
    //                                                           delegate:self
    //                                                  cancelButtonTitle:@"确定"
    //                                                  otherButtonTitles:nil];
    //
    //        [alertView show];
    //
    //    }
}


//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
    
}




/* 云信收到消息的回调监听*/
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification{
    
}

#pragma mark- 登录后的通知回调
- (void)ChangeLoginRoot:(NSNotification *)notification{
    
    NSString *type = [notification object];
    /* 登录方式存本地*/
    
    [[NSUserDefaults standardUserDefaults]setObject:type forKey:@"Login_Type"];
    
    /* 账号密码方式登录*/
    if ([type isEqualToString:@"Normal"]) {
        /* 发送消息,切换rootcontroller*/
        [[NSNotificationCenter defaultCenter]postNotificationName:@"UserLogin" object:nil];
        
    }else if([type isEqualToString:@"wechat"]){
        /* 微信登录*/
         [[NSNotificationCenter defaultCenter]postNotificationName:@"UserLogin" object:nil];
        
    }
    
    
}


/* 微信登录成功后,rootcontroller改变*/
- (void)ChangRootToPerInfo:(NSNotification *)notification{
    
       
    
    
//    BindingViewController *binVC = [BindingViewController new];
//    [_window setRootViewController:binVC];
    
}




/* 修改rootViewController为系统的主页controller*/
- (void)changeRootViewConroller:(NSNotification *)notification{
    
    _viewController = [[ViewController alloc]init];
    
    [_window setRootViewController:_viewController];
    
}

/* 用户退出登录后 跳转到登录页面*/
- (void)userLogOut{
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"Login"];
    
     _loginViewController = [[LoginViewController alloc]init];
    UINavigationController *naviVC=[[UINavigationController alloc]initWithRootViewController:_loginViewController];
    
    [_window setRootViewController:naviVC];
    
    
}



#pragma mark- 微信sdk  重写openurl 的两个方法
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    return [WXApi handleOpenURL:url delegate:self];
    
}



-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    /* 微信登录成功的回调 直接跳转界面到这里.*/
    
        
    
    return [WXApi handleOpenURL:url delegate:self];
    
}


#pragma mark- 微信的两个回调
/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
- (void)onReq:(BaseReq *)req {
    
    
    
}




/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
- (void)onResp:(BaseResp *)resp {
    
    /* 条件:拿到登录回调信息*/
    if ([resp isKindOfClass:[SendAuthResp class]]) {
       
            
            if (resp.errCode ==0) {
                /* 登录成功*/
                SendAuthResp *respdata = (SendAuthResp *)resp;
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"WechatLoginSucess" object:respdata.code];
                NSLog(@"%@",respdata.code);
                
                
                
                
                
            }else if (resp.errCode == -1){
                /* 登录失败*/
                [[NSNotificationCenter defaultCenter]postNotificationName:@"wechatLoginFaild" object:nil];

                
                
            }else if (resp.errCode == -2){
                /* 取消登录*/
                
                
            
            
            
        }
        
        
        SendAuthResp *respData = (SendAuthResp *)resp;
//        respData.code
        
        
        
    }
    
    /* 条件 :拿到支付回调信息*/
    if ([resp isKindOfClass:[PayResp class]]) {
        
        if (resp.errCode ==0) {
            /* 充值成功*/
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ChargeSucess" object:nil];
            
            
        }else if (resp.errCode == -1){
            /* 充值失败*/
            
            
        }else if (resp.errCode == -2){
            /* 取消充值*/
            
            
        }

        
    }
    
    NSLog(@"%@,%d,%d",resp.errStr,resp.errCode,resp.type);
    
    
    
}



- (void)clearBadge{
    
    
    /* badge归零*/
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
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
   
    [self clearBadge];
   
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
