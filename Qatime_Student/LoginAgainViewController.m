//
//  LoginAgainViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/10.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "LoginAgainViewController.h"
#import "MBProgressHUD.h"
#import "FindPasswordViewController.h"
#import "YYModel.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "UIViewController+HUD.h"
#import <NIMSDK/NIMSDK.h>
#import "UIAlertController+Blocks.h"
#import "GuestBindingViewController.h"

#import "Chat_Account.h"

#import "BindingViewController.h"

#import "SAMKeychain.h"

typedef NS_ENUM(NSUInteger, LoginType) {
    Normal =0, //账号密码登录
    Wechat,  //微信登录
    Guest,   //游客登录
};

@interface LoginAgainViewController ()<UITextFieldDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,WXApiDelegate>{
    
    
    NavigationBar *_navigationBar;
    
    UIImageView *_logoImage;
    
    
    NSInteger keyHeight;
    
    FindPasswordViewController *findPasswordViewController;
    
    /* 用户聊天信息存本地*/
    
    Chat_Account *_chat_Account;
    
    
    /* 验证码*/
    NSMutableString *_captcha;
    
    /* 需要对比验证码*/
    BOOL needCheckCaptcha;
    
    
    /* 是否有返回键*/
    BOOL haveReturnButton;
    
    //是否需要检查用户信息
    BOOL needCheckGuest;
    
    
}

@end

@implementation LoginAgainViewController

//-(instancetype)initWithReturnButton:(BOOL)returnButton{
//
//    self = [super init];
//    if (self) {
//
//        haveReturnButton = returnButton;
//
//    }
//    return self;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
    
    _navigationBar.titleLabel.text = @"登录";
    
    [self .view addSubview:_navigationBar];
    
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    needCheckCaptcha = NO;
    _wrongTimes = 0;
    _captcha =[NSMutableString string ];
    
    _loginAgainView = [[LoginAgainView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64)];
    [self.view addSubview:_loginAgainView];
    
    [_loginAgainView.signUpButton addTarget:self action:@selector(enterSignUpPage:) forControlEvents:UIControlEventTouchUpInside];
    
    [_loginAgainView.loginButton addTarget:self action:@selector(userLogin:) forControlEvents:UIControlEventTouchUpInside];
    _loginAgainView.userName.delegate = self;
    _loginAgainView.passWord.delegate = self;
    _loginAgainView.passWord.secureTextEntry = YES;
    
    
    /* 忘记密码按钮*/
    [_loginAgainView.forgottenPassorwdButton addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    
    /* 错误次数达到5次的监听*/
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyCodeAppear) name:@"FivethWrongTime" object:nil];
    /* 验证码按钮的点击事件*/
//    [_loginAgainView.keyCodeButton addTarget:self action:@selector(makeCaptcha) forControlEvents:UIControlEventTouchUpInside];
    
    
    /* 微信按钮加点击事件 点击登录*/
    
    [_loginAgainView.wechatButton addTarget:self action:@selector(sendAuthRequest) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    /**
     测试调用方法
     
     @param sendAuthRequest
     @return
     */
    //        [_loginAgainView.wechatButton addTarget:self action:@selector(mypage) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    /* 跳过登录直接进主页的方法*/
    
    [_loginAgainView.acrossLogin addTarget:self action:@selector(enterWithoutLogin) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    /* 添加微信登录成功的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wechatLoginSucess:) name:@"WechatLoginSucess" object:nil];
    
    
    //检查是否需要检查用户信息
    if ([SAMKeychain allAccounts]==nil) {
        needCheckGuest = NO;
    }else{
        needCheckGuest = YES;
    }

}

#pragma mark- UITextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (needCheckGuest == YES) {
        
        if (textField == _loginAgainView.userName) {
            NSArray *keys = [SAMKeychain allAccounts];
            
            //访问本地钥匙串,看是否有游客信息,有则提示,没有的话就没事
            /**
             以本地是否保存了@"Remember-Token"为用户名的keychain作为依据
             */
            if ([SAMKeychain passwordForService:@"Qatime_Student" account:@"Remember-Token"]==nil) {
                //没有不管,可以直接输入字符
                
            }else{
                
                [UIAlertController showAlertInViewController:self withTitle:@"警告!" message:@"系统检测到您之前使用游客身份登录,如您使用其他账号登录则无法找回之前登录的所有信息(包括账户资金和一切消费记录)!\n是否确定使用新的账户登录?" cancelButtonTitle:@"我要完善当前账号信息" destructiveButtonTitle:nil otherButtonTitles:@[@"确定使用新账号登录"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                    
                    if (buttonIndex == 0) {
                        //绑定和完善当前账号信息 前往绑定
                        GuestBindingViewController *controller = [[GuestBindingViewController alloc]init];
                        [self.navigationController pushViewController:controller animated:YES];
                        
                        
                    }else{
                        //使用新账号,登录成功后会冲掉原有的游客信息
                        
                        needCheckGuest = NO;
                        [textField becomeFirstResponder];
                    }
                    
                }];
            }
            
        }
        
    }else{
        
        
    }
    
    
}



#pragma mark- 微信请求code数据
- (void)wechatLoginSucess:(NSNotification *)notification{
    
    NSString *code = [notification object];
    
    __block NSString *openID  = @"".mutableCopy;
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/api/v1/sessions/wechat",Request_Header] parameters:@{@"code":code,@"client_cate":@"student_client",@"client_type":@"app"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            
            if ([[dic[@"data"]allKeys]containsObject:@"remember_token"]) {
                /* 在后台查到该用户的信息*/
                
                //                    [[NSNotificationCenter defaultCenter]postNotificationName:@"UserLogin" object:nil];
                /* 保存用户信息*/
                [self saveUserInfo:dic[@"data"] loginType:Wechat];
                [self stopHUD];
                [self HUDStopWithTitle:@"登录成功"];
                
                [self performSelector:@selector(returnLastPage) withObject:nil afterDelay:1];
                
            }else{
                
                /* 登录信息拉取信息成功*/
                openID = dic[@"data"][@"openid"];
                
                BindingViewController *bVC = [[BindingViewController alloc]initWithOpenID:openID];
                [self.navigationController pushViewController:bVC animated:YES];
            }
            
            
        }else{
            /* 登录信息拉取失败*/
            
            [self HUDStopWithTitle:@"获取微信登录信息失败,请重试!"];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}





- (void)mypage{
    BindingViewController *bVC=[BindingViewController new];
    [self.navigationController pushViewController:bVC animated:YES];
    
}



#pragma mark- 跳过登录直接进入主页
- (void)enterWithoutLogin{
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"Login"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"EnterWithoutLogin" object:nil];
    
}
#pragma mark- 输入密码次数达到5次

- (void)keyCodeAppear{
    
    needCheckCaptcha = YES;
    
    /* 验证码框出现,改变布局*/
    _loginAgainView.keyCodeButton.hidden = NO;
    _loginAgainView.text3.hidden = NO;
    _loginAgainView.keyCodeText.hidden = NO;
    _loginAgainView.authenCode.hidden = NO;
    [_loginAgainView.authenCode updateLayout];
    
    _loginAgainView.loginButton.sd_layout
    .topSpaceToView(_loginAgainView.text3, 20*ScrenScale);
    [_loginAgainView.loginButton updateLayout];
    
}


#pragma mark- 忘记密码点击事件
- (void)forgetPassword{
    
    /* 弹出找回密码页面*/
    findPasswordViewController = [[FindPasswordViewController alloc]init];
    [self.navigationController pushViewController:findPasswordViewController animated:YES];
    
    
}

#pragma mark- 注册按钮点击事件
/* 注册按钮点击事件*/
- (void)enterSignUpPage:(UIButton *)sender{
    
    SignUpViewController *_signUpViewController = [[SignUpViewController alloc]init];
    
    [self.navigationController pushViewController:_signUpViewController animated:YES];
    
}

#pragma mark- 登录按钮点击事件

/* 登录按钮点击事件*/
- (void)userLogin:(UIButton *)sender{
    
    
    /* 取消输入框响应*/
    [self cancelAllRespond];
    
    
    
    //友情判断 ,是不是还有游客信息,要是有的话就提示 ,没有的话就算了.
    //应该是有
    
    
    
    
    
    /* 如果用户名为空*/
    if ([_loginAgainView.userName.text isEqualToString:@""]) {
        
        /* 弹出alert框 提示输入账户名*/
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"账号不能为空！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action1];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    /* 如果密码为空*/
    if ([_loginAgainView.passWord.text isEqualToString:@""]) {
        
        /* 弹出alert框 提示输入账户名*/
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"密码不能为空！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action1];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }

    if (![_loginAgainView.userName.text isEqualToString:@""]&![_loginAgainView.passWord.text isEqualToString:@""]) {
        
        /* 判断是否需要输入验证码*/
        if (needCheckCaptcha == YES&&[_loginAgainView.keyCodeText.text isEqualToString:@""]) {
            
            /* 弹出alert框 提示输入验证码*/
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"请输入验证码！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action1];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        if (needCheckCaptcha == YES&&![_loginAgainView.keyCodeText.text.lowercaseString isEqualToString:_loginAgainView.authenCode.authCodeStr.lowercaseString]) {
            
            /* 弹出alert框 提示输入正确的验证码*/
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确的验证码！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action1];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        
        
        /* 不需要输入验证码或者验证码输入正确的情况*/
        if (needCheckCaptcha == NO || (needCheckCaptcha == YES&&[_loginAgainView.keyCodeText.text.lowercaseString isEqualToString:_loginAgainView.authenCode.authCodeStr.lowercaseString])) {
            //            /* HUD框 提示正在登陆*/
            //            MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //            hud.mode = MBProgressHUDModeDeterminate;
            //            //        hud.backgroundView.style = MBProgressHUDBackgroundStyleBlur;
            //            hud.labelText = @"正在登陆";
            [self HUDStartWithTitle:@"正在登录"];
            
            /* 对应接口要上传的用户登录账号密码*/
            NSDictionary *userInfo = @{@"login_account":[NSString stringWithFormat:@"%@",_loginAgainView.userName.text],
                                       @"password":[NSString stringWithFormat:@"%@",_loginAgainView.passWord.text],
                                       @"client_type":@"app",
                                       @"client_cate":@"student_client"};
            
            /* 登录请求*/
            AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer =[AFHTTPResponseSerializer serializer];
            [manager POST:[NSString stringWithFormat:@"%@/api/v1/sessions",Request_Header] parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                /* 解析返回数据*/
                NSDictionary *userInfoGet=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                NSLog(@"%@",userInfoGet);
                
                NSDictionary *dicGet=[NSDictionary dictionaryWithDictionary:userInfoGet[@"data"]];
                
                NSLog(@"%@",dicGet);
                /* 如果返回的字段里包含key值“remember_token“ 为登录成功*/
                /* 如果登录成功*/
                if ([[dicGet allKeys]containsObject:@"remember_token" ]) {
                    
                    
                    //不用干掉之前存储的keychain信息,增加新的keychain信息
                    NSArray *keys =  [SAMKeychain allAccounts];
                    NSError *error = [[NSError alloc]init];
                    if (keys!=nil) {
                        
                        for (NSDictionary *acc in keys) {
                            
                            [SAMKeychain deletePasswordForService:@"Qatime_Student" account:acc[@"acct"] error:&error];
                        }
                        
                    }
                    
                    //存储新的key
                    [SAMKeychain setPassword:_loginAgainView.passWord.text forService:@"Qatime_Student" account:_loginAgainView.userName.text error:&error];

                    [self saveUserInfo:dicGet loginType:Normal];
                    //
                    [self stopHUD];
                    [self HUDStopWithTitle:@"登录成功"];
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginSuccess" object:nil];
                    
                    [self performSelector:@selector(returnLastPage) withObject:nil afterDelay:1];
                    
                    
                }else{
                    
                    //                    [hud hide:YES];
                    
                    _wrongTimes ++;
                    if (_wrongTimes >=5) {
                        
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"FivethWrongTime" object:nil];
                        
                    }
                    
                    [self stopHUD];
                    /* 账户名密码错误提示*/
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"账户名或密码错误！" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:action];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                NSLog(@"%@",error);
                
                [self stopHUD];
                [self HUDStopWithTitle:@"登录失败,请稍后重试"];
                
            }];
        }
        
    }
    
}


/* 登录成功后,保存用户信息*/
- (void)saveUserInfo:(NSDictionary *)userDic loginType:(LoginType)loginType{
    
#pragma mark- 本地登录成功后 保存token文件，并且转到主页面
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Login"];
    
    NSString *userTokenFilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"User.data"];
    
    NSLog(@"保存的数据\n%@",userDic);
    
    
    /* 另存一份userdefault  只存token和id*/
    
    NSString *remember_token = [NSString stringWithFormat:@"%@",userDic[@"remember_token"]];
    
    NSDictionary *user=[NSDictionary dictionaryWithDictionary:userDic[@"user"]];
    NSLog(@"%@",user);
    
    NSString *userID = [NSString stringWithFormat:@"%@",[[userDic valueForKey:@"user"] valueForKey:@"id"]];
    
    [[NSUserDefaults standardUserDefaults]setObject:remember_token forKey:@"remember_token"];
    [[NSUserDefaults standardUserDefaults]setObject:userID forKey:@"id"];
    
    NSLog(@"token:%@,id:%@",remember_token,userID);
    
    
    /* 另存一个userdefault ，只存user的头像地址 如果有的话*/
    
    if (userDic[@"user"][@"avatar_url"]) {
        if (![userDic[@"user"][@"avatar_url"]isEqual:[NSNull null]]) {
            
            [[NSUserDefaults standardUserDefaults]setObject:userDic[@"user"][@"avatar_url"] forKey:@"avatar_url"];
        }
    }
    
    /* 另存一个useerdefault 存user的name 如果存在的话*/
    if (userDic[@"user"][@"name"]) {
        if (![userDic[@"user"][@"name"] isEqual:[NSNull null]]) {
            
            [[NSUserDefaults standardUserDefaults]setObject:userDic[@"user"][@"name"] forKey:@"name"];
        }
    }
    
    /* 另存一个userdefault 存电话*/
    if (userDic[@"user"][@"login_mobile"]) {
        if (![userDic[@"user"][@"login_mobile"] isEqual:[NSNull null]]) {
            
            [[NSUserDefaults standardUserDefaults]setObject:userDic[@"user"][@"login_mobile"] forKey:@"login_mobile"];
        }
        
    }
    
    NSString *type =nil;
    switch (loginType) {
        case 0:
            type = [NSString stringWithFormat:@"Normal"];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"is_Guest"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"UserLogin" object:nil];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Login"];
            /* 归档*/
            [NSKeyedArchiver archiveRootObject:userDic toFile:userTokenFilePath];
            break;
            
        case 1:
            type = [NSString stringWithFormat:@"Wechat"];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"is_Guest"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"UserLogin" object:nil];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Login"];
            /* 归档*/
            [NSKeyedArchiver archiveRootObject:userDic toFile:userTokenFilePath];
            break;
            
        case 2:
            type = [NSString stringWithFormat:@"Guest"];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"is_Guest"];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Login"];
            break;
    }
    
    
    /* 保存openID*/
    
    if (userDic[@"user"][@"openid"]) {
        if ([userDic[@"user"][@"openid"]isEqual:[NSNull null]]) {
            
        }else{
            /* 已经绑定了微信*/
            [[NSUserDefaults standardUserDefaults]setObject:userDic[@"user"][@"openid"] forKey:@"openID"];
            
        }
        
    }else{
        
        /* 未绑定微信.*/
        
    }
    
    /* 发出一条消息:登录方式*/
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Login_Type" object:type];
    
#pragma mark- 把用户聊天账户信息存本地
    
    /* 另存一份userdefault  只存chat_account*/
    
    NSDictionary *chatAccount =[NSDictionary dictionaryWithDictionary:[userDic valueForKey:@"user"]];
    
    NSLog(@"%@",chatAccount);
    
    if ([chatAccount valueForKey:@"chat_account"]!=nil&&![[chatAccount valueForKey:@"chat_account"] isEqual:[NSNull null]]) {
        
        NSMutableDictionary *chat_accountDic = [NSMutableDictionary dictionaryWithDictionary:[chatAccount valueForKey:@"chat_account"]];
        
        NSLog(@"%@",chat_accountDic);
        NSDictionary *chat = chat_accountDic.mutableCopy;
        
        for (NSString *key in chat) {
            if ([chat_accountDic[key] isEqual:[NSNull null]]||chat_accountDic[key]==nil) {
                chat_accountDic[key] = @"";
            }
        }
        
        [[NSUserDefaults standardUserDefaults]setObject:chat_accountDic forKey:@"chat_account"];
        
        /* 登录云信*/
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"chat_account"]) {
            NSDictionary *chatDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"chat_account"];
            NIMAutoLoginData *lodata = [[NIMAutoLoginData alloc]init];
            lodata.account =chatDic [@"accid"];
            lodata.token = chatDic[@"token"];
            [[[NIMSDK sharedSDK]loginManager]autoLogin:lodata];
            
        }
        
    }
    
}



/* 键盘出现*/

- (void)keyboardWillShow:(NSNotification *)aNotification{
    
    //获取键盘高度
    
    NSDictionary *info = [aNotification userInfo];
    
    //获取动画时间
    
    float duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //获取动画开始状态的frame
    
    CGRect beginRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    //获取动画结束状态的frame
    
    CGRect endRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    //计算高度差
    
    float offsety =  endRect.origin.y - beginRect.origin.y ;
    
    NSLog(@"键盘高度:%f 高度差:%f\n",beginRect.origin.y,offsety);
    
    //下面的动画，整个View上移动
    
    CGRect fileRect = self.view.frame;
    
    fileRect.origin.y += offsety;
    
    [UIView animateWithDuration:duration animations:^{
        
        self.view.frame = fileRect;
        
    }];
    
    
}

/* 键盘隐藏*/
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    [self.view setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self cancelAllRespond];
    
}

/* 取消响应*/
- (void)cancelAllRespond{
    
    [_loginAgainView.userName resignFirstResponder];
    [_loginAgainView.passWord resignFirstResponder];
    [_loginAgainView.keyCodeText resignFirstResponder];
}

#pragma mark- 微信直接拉起请求
-(void)sendAuthRequest{
    
    //    if ([WXApi isWXAppInstalled]==YES) {
    //
    //    }else{
    //        [self HUDStopWithTitle:@"登录失败，请使用手机号登录"];
    //    }
    
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init ]  ;
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendAuthReq:req viewController:self delegate:self];
    
}

- (void)returnLastPage{
    
    [self.navigationController popViewControllerAnimated:YES];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
