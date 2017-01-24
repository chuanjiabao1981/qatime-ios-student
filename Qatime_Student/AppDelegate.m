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
#import "LivePlayerViewController.h"

//#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
//#endif

#import <sys/utsname.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate,NIMSystemNotificationManager,NIMLoginManagerDelegate>{
    
    /* 推送的设置*/
    BOOL push_AlertON;
    BOOL push_VoiceON;
    BOOL notificatoin_ON;
    /* 是否绑定了微信*/
    BOOL bindingWechat;
    /* 是否允许屏幕旋转*/
    BOOL _allowRotation;
    
    
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window = [[UIWindow alloc]init];
    [_window makeKeyAndVisible];
    _window.backgroundColor = [UIColor whiteColor];
    
    /* 判断是否是第一次进入程序,加载引导图页面*/
    NSUserDefaults *useDef = [NSUserDefaults standardUserDefaults];
    // 使用 NSUserDefaults 读取用户数据
    if (![useDef boolForKey:@"notFirst"]) {
        // 如果是第一次进入引导页
        _window.rootViewController = [[GuideViewController alloc] init];
        /* 执行第一次要加载的数据*/
        //        [self loadFirstLoginData];
        
    }
    else{
        /* 判断登录条件*/
        /* 根据本地保存的用户文件  判断是否登录*/
        NSString *userFilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"User.data"];
        if (![[NSFileManager defaultManager]fileExistsAtPath:userFilePath]) {
            /* 如果没有登录信息,登录页作为root*/
            _loginViewController = [[LoginViewController alloc]init];
            UINavigationController *naviVC=[[UINavigationController alloc]initWithRootViewController:_loginViewController];
            [_window setRootViewController:naviVC];
            
        }else{
            /* 如果有登录信息,直接登录,并保存token和id*/
            _viewController = [[ViewController alloc]init];
            UINavigationController *viewVC = [[UINavigationController alloc]initWithRootViewController:_viewController];
            [_window setRootViewController:viewVC];
            NSString *token= [[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"];
            NSString *userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"id"];
            NSLog(@"token:%@,id:%@",token,userid);
            
            /* 上传用户信息*/
            dispatch_queue_t info = dispatch_queue_create("info", DISPATCH_QUEUE_SERIAL);
            dispatch_async(info, ^{
                [self sendDeviceInfo];
                
            });
            
        }
    }
    
    NSLog(@"本地沙盒存储路径：%@", NSHomeDirectory());
    
    /* 注册微信API*/
    [WXApi registerApp:@"wxf2dfbeb5f641ce40"];
    
    /* 初始化云信SDK*/
    [[NIMSDK sharedSDK] registerWithAppID:IM_APPKEY cerName:PushCerName];
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    
    /* 登录云信*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"chat_account"]) {
        NSDictionary *chatDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"chat_account"];
        NIMAutoLoginData *lodata = [[NIMAutoLoginData alloc]init];
        lodata.account =chatDic [@"accid"];
        lodata.token = chatDic[@"token"];
        [[[NIMSDK sharedSDK]loginManager]autoLogin:lodata];
        
    }
    
    /* 推送状态读取*/
    /* 读取本地存储的默认是否要开启推送的声音和震动的设置数据*/
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"NotificationAlert"]) {
        push_AlertON =[[NSUserDefaults standardUserDefaults]boolForKey:@"NotificationAlert"];
    }else{
        push_AlertON = YES;
    }
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"NotificationVoice"]) {
        push_VoiceON =[[NSUserDefaults standardUserDefaults]boolForKey:@"NotificationVoice"];
    }else{
        push_VoiceON = YES;
    }
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"IMNotification"]) {
        notificatoin_ON = [[NSUserDefaults standardUserDefaults]valueForKey:@"IMNotification"];
    }else{
        notificatoin_ON = YES;
    }
    
    /* 推送设置*/
    /* 友盟推送设置初始化*/
    [UMessage startWithAppkey:@"5846465b1c5dd042ae000732" launchOptions:launchOptions httpsenable:YES];
    
    /* 程序运行时,开启捕获异常,在程序出现不可避免的崩溃和闪退的时候,弹窗提醒而不闪退*/
    [UncaughtExceptionHandler installUncaughtExceptionHandler:YES showAlert:YES];
    
    /* 推送是否需要关闭*/
    if (notificatoin_ON == NO) {
        /* 注销推送*/
        [[UIApplication sharedApplication]unregisterForRemoteNotifications];
    }else{
        /* 注册推送*/
        [self registNotification];
    }
    
    /* 云信推送是否要关闭*/
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"IMNotification"]) {
        
        NIMPushNotificationSetting *setting =  [[[NIMSDK sharedSDK] apnsManager] currentSetting];
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"IMNotification"]==NO) {
            
            setting.noDisturbing = NO;
        }else{
            
            setting.noDisturbing = YES;
        }
        /* 发送云信消息设置*/
        [[[NIMSDK sharedSDK] apnsManager] updateApnsSetting:setting
                                                 completion:^(NSError *error) {}];
    }
    
    /* 浅色状态栏设置*/
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    /* 添加消息中心监听 判断登录状态*/
    /* 用户登出*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogOut) name:@"userLogOut" object:nil];
    /* 用户登录*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRootViewConroller:) name:@"UserLogin" object:nil];
    /* 用户在应用程序里登录*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLoginAgain:) name:@"UserLoginAgain" object:nil];
    /* 直接进入而没有登录*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRootViewConroller:) name:@"EnterWithoutLogin" object:nil];
    /* 监听登录方式:账号密码登录(Normal)或是微信登录(wechat)*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangeLoginRoot:) name:@"Login_Type" object:nil];
    
    /*监听 是否微信绑定状态*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bindingWechat) name:@"BindingWechat" object:nil];
    
    /* 监听用户是否关闭推送声音和震动*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(turnPushSound:) name:@"NotificationSound" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(turnPushAlert:) name:@"NotificationAlert" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(turnNotification:) name:@"Notification" object:nil];

    return YES;
}

#pragma mark- 注册推送
- (void)registNotification{
    
    /* 注册云信(系统)推送 兼容iOS10以下的系统*/
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]){
        UIUserNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |      UIRemoteNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound |        UIRemoteNotificationTypeBadge;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
    
    //注册友盟通知 友盟
    [UMessage registerForRemoteNotifications];
    
    //iOS10的推送设置 友盟
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            
        } else {
            //点击不允许
            
        }
    }];
    
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];

}



/* 第一次运行程序时候所要执行的操作*/
- (void)loadFirstLoginData{
    
}

/* 处在绑定微信状态下*/
- (void)bindingWechat{
    
    bindingWechat  = YES;

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
    
    /* 拿到devicetoken后,写本地*/
    [[NSUserDefaults standardUserDefaults]setValue:deviceToken forKey:@"Device-Token"];
    
}



//iOS10以下使用这个方法接收通知


/* 收到静默推送*/
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    
    /* 主页消息badge通知*/
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ReceiveNewNotice" object:nil];

    if (notificatoin_ON == YES) {
        
        //当应用处于前台时提示设置，需要哪个可以设置哪一个
           }else{
        completionHandler();
    }
    
    
    
}

/* 收到推送点击进入前/在前台收到推送后 的回调  /ios10收到静默推送*/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    /* 主页消息badge通知*/
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ReceiveNewNotice" object:nil];

    
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
    
    if(notificatoin_ON == YES){
        
        if (userInfo){
            completionHandler(UIBackgroundFetchResultNewData);
            if(userInfo[@"nim"]){
                
            }else{
                
                NSLog(@"%@", userInfo);
                //关闭友盟自带的弹出框
                [UMessage setAutoAlert:YES];
                [UMessage didReceiveRemoteNotification:userInfo];
            }
            
        }
    }else{
        
    }
    
    
}



/* 点击推送消息后的操作*/
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler{
    
}


//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    /* 主页消息badge通知*/
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ReceiveNewNotice" object:nil];
    
    
//    completionHandler(UNNotificationPresentationOptionAlert);
    
    if (notificatoin_ON == YES) {
        
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            //应用处于前台时的远程推送接受
            //关闭友盟自带的弹出框
            [UMessage setAutoAlert:NO];
            //必须加这句代码
            [UMessage didReceiveRemoteNotification:userInfo];
            
        }else{
            //应用处于前台时的本地推送接受
        }
    }else{
        
    }
    
    
}


//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{

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
    
    if (notificatoin_ON == YES) {
        NSDictionary * userInfo = response.notification.request.content.userInfo;
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            //应用处于后台时的远程推送接受
            //必须加这句代码
            [UMessage didReceiveRemoteNotification:userInfo];
            /* 主页消息badge通知*/
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ReceiveNewNotice" object:nil];
            
        }else{
            //应用处于后台点击后的本地推送接受
            
        }
    }else{
        
    }
    
}

/* 云信收到系统消息的回调监听*/
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification{
    
    
}

#pragma mark- 用户登录后的通知回调
- (void)ChangeLoginRoot:(NSNotification *)notification{
    
    NSString *type = [notification object];
    /* 登录方式存本地*/
    [[NSUserDefaults standardUserDefaults]setObject:type forKey:@"Login_Type"];
    /* 账号密码方式登录*/
    if ([type isEqualToString:@"Normal"]) {
        /* 发送消息,切换rootcontroller*/
        [[NSNotificationCenter defaultCenter]postNotificationName:@"UserLogin" object:nil];
        
    }else if([type isEqualToString:@"Wechat"]){
        /* 微信登录,切换到root*/
        [[NSNotificationCenter defaultCenter]postNotificationName:@"UserLogin" object:nil];
        
    }
}


/* 微信登录成功后,rootcontroller改变*/
- (void)ChangRootToPerInfo:(NSNotification *)notification{
    
}


/* 修改rootViewController为系统的主页controller*/
- (void)changeRootViewConroller:(NSNotification *)notification{
    
    _viewController = [[ViewController alloc]init];
        UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:_viewController];
    
    [UIView transitionFromView:_window.rootViewController.view toView:navVC.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
        
        [_window setRootViewController:navVC];
    }];
    
    /*登录成功后,上传设备信息*/
    dispatch_queue_t info = dispatch_queue_create("info", DISPATCH_QUEUE_SERIAL);
    dispatch_async(info, ^{
        
        [self sendDeviceInfo];
        
    });
    
    
}

/* 用户在应用程序内登录*/
- (void)userLoginAgain:(NSNotification *)notification{
    
    /*登录成功后,上传设备信息*/
    dispatch_queue_t info = dispatch_queue_create("info", DISPATCH_QUEUE_SERIAL);
    dispatch_async(info, ^{
        
        [self sendDeviceInfo];
        
    });

    
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
            
            
            /* 如果是要绑定微信*/
            if (bindingWechat == YES) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"RequestToBindingWechat" object:respdata.code];
                
                
            }else{
                /* 如果只是登录*/
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"WechatLoginSucess" object:respdata.code];
            }
            
            
            
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

/* 用户开启和关闭推送*/
- (void)turnNotification:(NSNotification *)notification{
    
    UISwitch *sender = [notification object];
    if (sender.on == YES) {
        /* 开启推送*/
        notificatoin_ON = YES;
        
        
    }else{
        /* 关闭推送*/
        notificatoin_ON = NO;
    }
    
}

/* 向服务器发送用户设备信息*/
- (void)sendDeviceInfo{
    
//    user_id         //用户id
//    device_token    //device token
//    device_model    //设备型号
//    app_name        //应用名称
//    app_version     //应用版本
    
    NSString *idNumber;
    NSString *device_token;
    NSString *device_model;
    NSString *app_version;
    
    /* 提出学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    /* 提出device token*/
    device_token = [[NSUserDefaults standardUserDefaults]valueForKey:@"Device-Token"];

    /* 获取设备型号*/
    device_model =  [NSString stringWithFormat:@"%@",[self iphoneType]];
    
    /* 应用版本*/
   app_version =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/api/v1/system/device_info",Request_Header] parameters:@{@"user_id":idNumber,@"device_token":device_token,@"device_model":device_model,@"app_name":@"Qatime_Student",@"app_version":app_version} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}


- (NSString *)iphoneType {

    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
    
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ApplicationDidEnterBackground" object:nil];
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [self clearBadge];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ApplicationDidBecomeActive" object:nil];
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
