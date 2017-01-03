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
#import "GuideViewController.h"

#import "UMessage.h"
#import "UncaughtExceptionHandler.h"

//#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
//#endif

@interface AppDelegate ()<UNUserNotificationCenterDelegate,NIMSystemNotificationManager,NIMLoginManagerDelegate>{
    
    
    BOOL push_AlertON;
    
    BOOL push_VoiceON;
    
    
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window = [[UIWindow alloc]init];
    [_window makeKeyAndVisible];
    _window.backgroundColor = [UIColor whiteColor];
    
    
    NSUserDefaults *useDef = [NSUserDefaults standardUserDefaults];
    // 使用 NSUserDefaults 读取用户数据
    if (![useDef boolForKey:@"notFirst"]) {
        // 如果是第一次进入引导页
        _window.rootViewController = [[GuideViewController alloc] init];
        
        /* 执行第一次要加载的数据*/
        [self loadFirstLoginData];
        
    }
    else{
        // 否则直接进入应用
        
        /* 判断登录条件*/
        /* 根据本地保存的用户文件  判断是否登录*/
        NSString *userFilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"User.data"];
        if (![[NSFileManager defaultManager]fileExistsAtPath:userFilePath]) {
            
            /* 如果没有登录信息,登录页作为root*/
            
            _loginViewController = [[LoginViewController alloc]init];
            UINavigationController *naviVC=[[UINavigationController alloc]initWithRootViewController:_loginViewController];
            
            [_window setRootViewController:naviVC];
            
        }else{
            
            _viewController = [[ViewController alloc]init];
            UINavigationController *viewVC = [[UINavigationController alloc]initWithRootViewController:_viewController];
            
            [_window setRootViewController:viewVC];
            
            NSString *token= [[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"];
            NSString *userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"id"];
            
            
            NSLog(@"%@,%@",token,userid);
            
            
        }
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
    
    
    [[NIMSDK sharedSDK] registerWithAppID:IM_APPKEY
                                  cerName:@"QatimeStudentPushDev"];
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    
    /* 本地保存云信推送的设置*/
    //    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"NotificationVoice"];
    //    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"NotificationAlert"];
    //    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"IMNotification"];
    
    /* 登录云信*/
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"chat_account"]) {
        
        NSDictionary *chatDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"chat_account"];
        NIMAutoLoginData *lodata = [[NIMAutoLoginData alloc]init];
        
        lodata.account =chatDic [@"accid"];
        lodata.token = chatDic[@"token"];
        
        [[[NIMSDK sharedSDK]loginManager]autoLogin:lodata];
        
        
    }
    
    
    
#pragma mark- 注册系统推送
    
    
    /* 默认开启推送的声音和震动*/
    push_AlertON = YES;
    push_VoiceON = YES;
    
    //初始化方法,也可以使用(void)startWithAppkey:(NSString *)appKey launchOptions:(NSDictionary * )launchOptions httpsenable:(BOOL)value;这个方法，方便设置https请求。
    [UMessage startWithAppkey:@"5846465b1c5dd042ae000732" launchOptions:launchOptions httpsenable:YES];
    
    /* 注册云信(系统)推送*/
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]){
        UIUserNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |      UIRemoteNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else{
        UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound |        UIRemoteNotificationTypeBadge;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
    
    
    //注册友盟通知，如果要使用category的自定义策略，可以参考demo中的代码。
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
    
    
    /* 捕获异常*/
    [UncaughtExceptionHandler installUncaughtExceptionHandler:YES showAlert:YES];
    
    
    
    /* 监听用户是否关闭推送声音和震动*/
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(turnPushSound:) name:@"NotificationSound" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(turnPushAlert:) name:@"NotificationAlert" object:nil];
    
    
    
    return YES;
}

/* 第一次运行程序时候所要执行的操作*/
- (void)loadFirstLoginData{
    
}



/* 云信登录成功的回调 */
- (void)onLogin:(NIMLoginStep)step{
    
    /* 登录成功*/
    if (step == NIMLoginStepLoginOK) {
        
        NSLog(@"%@",[[[NIMSDK sharedSDK]teamManager]allMyTeams]);
        
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"NIMSDKLogin"];
        
    }
    /* 聊天室信息同步完成*/
    if (step == NIMLoginStepSyncOK) {
        
        
    }
    
}



#pragma mark- 推送回调

//注册apns的token
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]stringByReplacingOccurrencesOfString: @">" withString: @""]stringByReplacingOccurrencesOfString: @" " withString: @""]);
    
    /// Required - 注册 DeviceToken
    
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
    
}
//iOS10以下使用这个方法接收通知
/* 在前台*/
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    if (push_VoiceON==YES&&push_AlertON == YES) {
        
        completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    }
    if (push_VoiceON==YES&&push_AlertON == NO) {
        completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge);
    }
    if (push_VoiceON==NO&&push_AlertON == YES) {
        completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    }
    if (push_VoiceON==NO&&push_AlertON == NO) {
        completionHandler(UNNotificationPresentationOptionBadge);
    }
    
    
}


/* 在后台*/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler NS_AVAILABLE_IOS(7_0){
    
    if (userInfo){
        completionHandler(UIBackgroundFetchResultNewData);
        if(userInfo[@"nim"]){
            
            
        }else{
            
            NSLog(@"%@", userInfo);
            //关闭友盟自带的弹出框
            [UMessage setAutoAlert:NO];
            [UMessage didReceiveRemoteNotification:userInfo];
        }
        
    }
    
    
    
}



/* 点击消息后的操作*/
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler{
    
    
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
    if (push_VoiceON==YES&&push_AlertON == YES) {
        
        completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    }
    if (push_VoiceON==YES&&push_AlertON == NO) {
        completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge);
    }
    if (push_VoiceON==NO&&push_AlertON == YES) {
        completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    }
    if (push_VoiceON==NO&&push_AlertON == NO) {
        completionHandler(UNNotificationPresentationOptionBadge);
    }
    
    
}


//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台点击后的本地推送接受
        
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
    
    
    
    
}




/* 修改rootViewController为系统的主页controller*/
- (void)changeRootViewConroller:(NSNotification *)notification{
    
    _viewController = [[ViewController alloc]init];
//    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:_viewController];
    
    [UIView transitionFromView:_window.rootViewController.view toView:_viewController.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
        
        [_window setRootViewController:_viewController];
    }];
    
    
    
}

/* 用户退出登录后 跳转到登录页面*/
- (void)userLogOut{
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"Login"];
    
    /* 退出云信*/
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error){}];
    
    _loginViewController = [[LoginViewController alloc]init];
    
    UINavigationController *naviVC=[[UINavigationController alloc]initWithRootViewController:_loginViewController];
    
    [UIView transitionFromView:_window.rootViewController.view toView:_loginViewController.view duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
        
        [_window setRootViewController:naviVC];
    }];
    
    
    
    
    
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


#pragma mark- 推送设置操作

/* 用户开关推送声音*/
- (void)turnPushSound:(NSNotification *)notification{
    
    UIButton *sender = [notification object];
    if (sender.selected ==YES) {
        push_VoiceON = YES;
    }else{
        push_VoiceON = NO;
    }
}

/* 用户开关推送震动*/
- (void)turnPushAlert:(NSNotification *)notification{
    
    UIButton *sender = [notification object];
    if (sender.selected == YES) {
        push_AlertON = YES;
    }else{
        push_AlertON = NO;
    }
    
    
    
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
