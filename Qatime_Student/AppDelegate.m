//
//  AppDelegate.m
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "AppDelegate.h"
#import <NIMSDK/NIMSDK.h>


#import "BindingViewController.h"
#import "GuideViewController.h"

#import "UMessage.h"
#import "UncaughtExceptionHandler.h"
#import "LivePlayerViewController.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif


#import "RealReachability.h"
#import "SAMKeychain.h"

#import "DevieceManager.h"

//#import <iflyMSC/iflyMSC.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate,NIMSystemNotificationManager,NIMLoginManagerDelegate>{
    
    /* 推送的设置*/
    BOOL push_AlertON;
    BOOL push_VoiceON;
    BOOL notificatoin_ON;
    /* 是否绑定了微信*/
    BOOL bindingWechat;
    /* 是否允许屏幕旋转*/
    BOOL _allowRotation;
    
    /* 5个viewcontroller的NavigationController作为根视图*/
    UINavigationController *indexPageVC;
    UINavigationController *tutoriumVC ;
    UINavigationController *classTimeVC ;
    UINavigationController *personalVC ;
    UINavigationController *noticeVC;
    
    UINavigationController *chooseVC;
    
    UINavigationController *naviVC;
    
    /* 推送部分*/
    NSDictionary *remoteNotification;


}


/**
 是否通过点击推送消息进入应用
 */
@property (nonatomic) BOOL isLaunchedByNotification;

/* 五个选项卡的ViewController*/
@property(nonatomic,strong) IndexPageViewController *indexPageViewController ;
//@property(nonatomic,strong) TutoriumViewController *tutoriumViewController ;
@property(nonatomic,strong) ClassTimeViewController *classTimeViewController ;
@property(nonatomic,strong) PersonalViewController *personalViewController ;
@property(nonatomic,strong) NoticeIndexViewController *noticeIndexViewController ;

@property(nonatomic,strong) ChooseGradeAndSubjectViewController *chooseClassViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    /* 默认初始方向屏幕不可旋转*/
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"SupportedLandscape"];

    _window = [[UIWindow alloc]init];
    [_window makeKeyAndVisible];
    _window.backgroundColor = [UIColor whiteColor];
    
    /* 选项卡视图初始化*/
    [self updateTabBarViews];
    
    /* 设置TabBarController*/
    [self setTabBarController];
    
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
            /**如果没有登录信息,查询keychain是否有保存游客信息*/
            
            NSArray *accounts = [SAMKeychain allAccounts];
            if (accounts ==nil) {
                /* 如果没有登录信息,登录页作为root*/
                _loginViewController = [[LoginViewController alloc]init];
                
                naviVC=[[UINavigationController alloc]initWithRootViewController:_loginViewController];
                [naviVC setNavigationBarHidden:YES];
                
                [_window setRootViewController:naviVC];
            }else{
                
                /* 如果有游客登录信息,直接登录,并保存token和id*/
                [_window setRootViewController:_viewController];
                
                NSString *userid = [SAMKeychain passwordForService:Qatime_Service account:@"id"];
                NSString *token = [SAMKeychain passwordForService:Qatime_Service account:@"Remember-Token"];
                [[NSUserDefaults standardUserDefaults]setObject:userid forKey:@"id"];
                [[NSUserDefaults standardUserDefaults]setObject:token forKey:@"remember-token"];
                NSLog(@"token:%@,id:%@",token,userid);
                
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Login"];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"is_Guest"];
                
                /* 上传用户信息*/
                dispatch_queue_t info = dispatch_queue_create("info", DISPATCH_QUEUE_SERIAL);
                dispatch_async(info, ^{
                    [self sendDeviceInfo];
                    
                });
                
            }
            
        }else{
            /* 如果有普通用户信息,直接登录,并保存token和id*/
            [_window setRootViewController:_viewController];
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
    
//    /* 增加热修复技术*/
//    [JSPatch startWithAppKey:@"f3da4b3b9ce10b8e"];
//    [JSPatch sync];
//    
    /* 键盘管理器*/
//    [[IQKeyboardManager sharedManager]setEnable:YES];
    
    
    
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
    
    /* 动态检测网络状态*/
    GLobalRealReachability.hostForPing = Request_Header;
    [GLobalRealReachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:kRealReachabilityChangedNotification object:nil];


    
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
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRootViewConroller:) name:@"EnterWithoutLogin" object:nil];
    /* 监听登录方式:账号密码登录(Normal)或是微信登录(wechat)*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangeLoginRoot:) name:@"Login_Type" object:nil];
    
    /*监听 是否微信绑定状态*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bindingWechat:) name:@"BindingWechat" object:nil];
    
    /* 监听用户是否关闭推送声音和震动*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(turnPushSound:) name:@"NotificationSound" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(turnPushAlert:) name:@"NotificationAlert" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(turnNotification:) name:@"Notification" object:nil];
    
    /* 监听跳转到root后的tabbar变化*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideTabbar) name:@"PopToRoot" object:nil];
    
    /* tabbar隐藏*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tabbarHide) name:@"TabbarHide" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tabbarShow) name:@"TabbarShow" object:nil];
    
    /**选择年级的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeItem:) name:@"ChooseGrade" object:nil];
    
    
    /**监听游客退出登录*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(guestLogOut) name:@"guestLogOut" object:nil];
    
    
    /* 获取推送消息内容 10以下系统获取方法*/
   remoteNotification =  [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    return YES;
}




/* 加载TabBarController*/
- (void)setTabBarController{
    
    if (!_viewController) {
        
        _viewController = [[LCTabBarController alloc]init];
        _viewController.tabBar.backgroundColor = [UIColor whiteColor];
        _viewController.itemTitleColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
        _viewController.selectedItemTitleColor = NAVIGATIONRED;
        _viewController.viewControllers = @[indexPageVC,/*tutoriumVC,*/chooseVC,classTimeVC,noticeVC,personalVC];
    
    }
    
    /* 新收到消息的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNewNotice) name:@"ReceiveNewNotice" object:nil];
    
    /* 所有消息变为已读*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(allMessageRead) name:@"AllMessageRead" object:nil];
    
}



//收到新消息
- (void)receiveNewNotice{
    
    _noticeIndexViewController.tabBarItem.badgeValue=@"";
    
}

//所有消息已读
- (void)allMessageRead{
    
    _noticeIndexViewController.tabBarItem.badgeValue = nil;
    
}

//改变选项卡选项
- (void)changeItem:(NSNotification *)notification{
    
    [_viewController setSelectedIndex:1];
    
    _chooseClassViewController.selectedFilterGrade = [notification object];
    
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"ChooseFilterGrade" object:[notification object]];
    [_chooseClassViewController chooseFilterGrade:notification];
    
}




/* 加载核心视图框架 使用tabbarcontroller + navigation*/
- (void)updateTabBarViews{
    
    /* 初始化五个viewcontroller*/
    _indexPageViewController = [[IndexPageViewController alloc]init];
    _indexPageViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_home_h"];
    _indexPageViewController.tabBarItem.image = [UIImage imageNamed:@"tab_home_n"];
    _indexPageViewController.title = NSLocalizedString(@"首页", comment:"");
    
    
//    _tutoriumViewController = [[TutoriumViewController alloc]init];
//    _tutoriumViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_tutorium_h"];
//    _tutoriumViewController.tabBarItem.image = [UIImage imageNamed:@"tab_tutorium_n"];
//    _tutoriumViewController.title = NSLocalizedString(@"辅导班", comment:"");
    
    
    _chooseClassViewController = [[ChooseGradeAndSubjectViewController alloc]init];
    _chooseClassViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_tutorium_h"];
    _chooseClassViewController.tabBarItem.image = [UIImage imageNamed:@"tab_tutorium_n"];
    _chooseClassViewController.title = NSLocalizedString(@"选课", comment:"");
    
    _classTimeViewController = [[ClassTimeViewController alloc]init];
    _classTimeViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_class_h"];
    _classTimeViewController.tabBarItem.image = [UIImage imageNamed:@"tab_class_n"];
    _classTimeViewController.title = NSLocalizedString(@"课程表", comment:"");
    
    _noticeIndexViewController = [[NoticeIndexViewController alloc]init];
    _noticeIndexViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_message_h"];
    _noticeIndexViewController.tabBarItem.image = [UIImage imageNamed:@"tab_message_n"];
    _noticeIndexViewController.title = NSLocalizedString(@"消息", comment:"");
    
    _personalViewController = [[PersonalViewController alloc]init];
    _personalViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_me_h"];
    _personalViewController.tabBarItem.image = [UIImage imageNamed:@"tab_me_n"];
    _personalViewController.title = NSLocalizedString(@"个人", comment:"");
    
    /* 初始化五个navigationcontroller*/
    indexPageVC = [[UINavigationController alloc]initWithRootViewController:_indexPageViewController];
//    tutoriumVC = [[UINavigationController alloc]initWithRootViewController:_tutoriumViewController];
    classTimeVC = [[UINavigationController alloc]initWithRootViewController:_classTimeViewController];
    noticeVC = [[UINavigationController alloc]initWithRootViewController:_noticeIndexViewController];
    personalVC = [[UINavigationController alloc]initWithRootViewController:_personalViewController];
    chooseVC = [[UINavigationController alloc]initWithRootViewController:_chooseClassViewController];

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
    
    //如果你期望使用交互式(只有iOS 8.0及以上有)的通知，请参考下面注释部分的初始化代码
    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
    action1.identifier = @"action1_identifier";
    action1.title=@"打开应用";
    action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
    
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
    action2.identifier = @"action2_identifier";
    action2.title=@"忽略";
    action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
    action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    action2.destructive = YES;
    UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
    actionCategory1.identifier = @"category1";//这组动作的唯一标示
    [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
    NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
    
    //如果要在iOS10显示交互式的通知，必须注意实现以下代码
    if ([[[UIDevice currentDevice] systemVersion]intValue]>=10) {
        UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_ios10_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
        UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_ios10_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
        
        //UNNotificationCategoryOptionNone
        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
        UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category101" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        NSSet *categories_ios10 = [NSSet setWithObjects:category1_ios10, nil];
        [center setNotificationCategories:categories_ios10];
    }else
    {
        [UMessage registerForRemoteNotifications:categories];
    }

    
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];

}


/* 第一次运行程序时候所要执行的操作*/
- (void)loadFirstLoginData{
    
}

/* 处在绑定微信状态下*/
- (void)bindingWechat:(NSNotification *)note{

    bindingWechat  = [[note object]boolValue];

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
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"DeviceToken:%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]stringByReplacingOccurrencesOfString: @">" withString: @""]stringByReplacingOccurrencesOfString: @" " withString: @""]);
    
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

//    if (push_VoiceON==YES&&push_AlertON == YES) {
//        
//        completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
//    }
//    if (push_VoiceON==YES&&push_AlertON == NO) {
//        completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge);
//    }
//    if (push_VoiceON==NO&&push_AlertON == YES) {
//        completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
//    }
//    if (push_VoiceON==NO&&push_AlertON == NO) {
//        completionHandler(UNNotificationPresentationOptionBadge);
//    }
    
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
        
        //处理推送事件
        [self pushActionWithInfo:userInfo];
        
        
    }else{
        
    }
    
}

//处理推送消息
- (void)pushActionWithInfo:(NSDictionary *)info{
    
    if (info[@"nim"]) {
        
        //接到了云信的推送消息,进入聊天列表页面
        /* 发通知跳转到聊天页面*/
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"NIMNotification" object:info];
        
        _viewController.selectedIndex = 3;
        
    }
    
    
}




/* 网络状态发生变化的时候,触发该方法*/
- (void)networkChanged:(NSNotification *)notification{
    
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    NSLog(@"currentStatus:%@",@(status));
    switch (status) {
        case RealStatusUnknown:{
            
        }
            break;
            
        case RealStatusViaWWAN:{
            //  case ReachableViaWWAN handler
            /* 预留功能*/
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前处于2G/3G网络环境下,是否切换至wifi网络?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
//            [alert show];
        }
            break;
        case RealStatusViaWiFi:{
            //  case ReachableViaWiFi handler
            /* 预留功能.*/
            
        }
            break;
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
    
    if ([_window.rootViewController isEqual:_viewController]) {
        
        
    }else{
        _viewController = [[LCTabBarController alloc]init];
        _viewController.tabBar.backgroundColor = [UIColor whiteColor];
        _viewController.itemTitleColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
        _viewController.selectedItemTitleColor = NAVIGATIONRED;
        _viewController.viewControllers = @[indexPageVC,/*tutoriumVC,*/chooseVC,classTimeVC,noticeVC,personalVC];
//        [self setTabBarController];
        [UIView transitionFromView:_window.rootViewController.view toView:_viewController.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
            
            [_window setRootViewController:_viewController];
            _viewController.selectedIndex = 0;
        }];
        
    }
    
    
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
    
    naviVC=[[UINavigationController alloc]initWithRootViewController:_loginViewController];
    [naviVC setNavigationBarHidden:YES];
    
    [UIView transitionFromView:_window.rootViewController.view toView:naviVC.view duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
        
        [_window setRootViewController:naviVC];
    }];
    
}

/**游客退出登录 切换root*/
- (void)guestLogOut{
    
    if (!_loginViewController) {
        
        _loginViewController = [[LoginViewController alloc]init];
    }
    
        naviVC=[[UINavigationController alloc]initWithRootViewController:_loginViewController];
        [naviVC setNavigationBarHidden:YES];
    
    
    
    [UIView transitionFromView:_window.rootViewController.view toView:naviVC.view duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
        
        [_window setRootViewController:naviVC];
    }];

    
}

- (void)hideTabbar{
    
    [_viewController removeOriginControls];
    
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


/* 隐藏选项卡*/
- (void)tabbarHide{
    
//    self.viewController.tabBar.hidden = YES;
    
}

/* 显示选项卡*/
- (void)tabbarShow{
    self.viewController.tabBar.hidden = NO;
    
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
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"id"]) {
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
    [manager POST:[NSString stringWithFormat:@"%@/api/v1/system/device_info",Request_Header] parameters:@{@"user_id":idNumber==nil?@"":idNumber,@"device_token":device_token==nil?@"":device_token,@"device_model":device_model==nil?@"":device_model,@"app_name":Qatime_Service,@"app_version":app_version==nil?@"":app_version} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}


- (NSString *)iphoneType {

    return [[DevieceManager defaultManager]devieceInfo];
    
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
