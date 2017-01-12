//
//  LoginViewController.m
//  Login
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "FindPasswordViewController.h"
#import "YYModel.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "UIViewController+HUD.h"
#import "UIViewController_HUD.h"

#import "BindingViewController.h"
#import "UIAlertController+Blocks.h"

typedef NS_ENUM(NSUInteger, LoginType) {
    Normal =0, //账号密码登录
    Wechat,  //微信登录
    
};


@interface LoginViewController ()<UITextFieldDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,UITextInputDelegate>{
    
    
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
    
    
    
    
    
}

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
    _navigationBar.backgroundColor= [UIColor whiteColor];
    [self .view addSubview:_navigationBar];
    /* logo图片布局*/
    _logoImage = [[UIImageView alloc]init];
    [_navigationBar addSubview:_logoImage];
    [_logoImage setImage:[UIImage imageNamed:@"Logo"]];
    
    _logoImage.sd_layout
    .topSpaceToView(_navigationBar,30)
    .bottomSpaceToView(_navigationBar,10)
    .centerXEqualToView(_navigationBar)
    .widthIs(24*1080/208.0f);
    
    
    needCheckCaptcha = NO;
    _wrongTimes = 0;
    _captcha =[NSMutableString string ];
    
    _loginView = [[LoginView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64)];
    [self.view addSubview:_loginView];
    
    
    [_loginView.signUpButton addTarget:self action:@selector(enterSignUpPage:) forControlEvents:UIControlEventTouchUpInside];
    
    [_loginView.loginButton addTarget:self action:@selector(userLogin:) forControlEvents:UIControlEventTouchUpInside];
    _loginView.userName.delegate = self;
    _loginView.passWord.delegate = self;
    _loginView.passWord.secureTextEntry = YES;
    
    
    /* 忘记密码按钮*/
    [_loginView.forgottenPassorwdButton addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    
    /* 错误次数达到5次的监听*/
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyCodeAppear) name:@"FivethWrongTime" object:nil];
    /* 验证码按钮的点击事件*/
    [_loginView.keyCodeButton addTarget:self action:@selector(makeCaptcha) forControlEvents:UIControlEventTouchUpInside];
    
    
    /* 微信按钮加点击事件 点击登录*/
    [_loginView.wechatButton addTarget:self action:@selector(sendAuthRequest) forControlEvents:UIControlEventTouchUpInside];
    
    
    /**
     测试调用方法

     @param sendAuthRequest
     @return
     */
//    [_loginView.wechatButton addTarget:self action:@selector(mypage) forControlEvents:UIControlEventTouchUpInside];

    
    /* 跳过登录直接进主页的方法*/
    [_loginView.acrossLogin addTarget:self action:@selector(enterWithoutLogin) forControlEvents:UIControlEventTouchUpInside];
    
    
    /* 添加微信登录成功的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wechatLoginSucess:) name:@"WechatLoginSucess" object:nil];
    
    /* 输入字符改变的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
}

-(void)textDidChange:(id<UITextInput>)textInput{
    
    /* 验证是否有中文字符*/
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @".{0,}[\u4E00-\u9FA5].{0,}"];
    if ([regextestmobile evaluateWithObject:_loginView.userName.text]==YES) {
        
        [_loginView.userName.text substringFromIndex:_loginView.userName.text.length];
        
        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"请勿输入中文!" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {}];
        
    }
    
    if ([regextestmobile evaluateWithObject:_loginView.passWord.text]==YES) {
        
        [_loginView.passWord.text substringFromIndex:_loginView.passWord.text.length];
        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"请勿输入中文!" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {}];
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
            
        
            for (NSString *key in dic[@"data"]) {
                if ([key isEqualToString:@"remember_token"]) {
                    /* 在后台查到该用户的信息*/
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"UserLogin" object:nil];
                    /* 保存用户信息*/
                    [self saveUserInfo:dic[@"data"] loginType:Wechat];
                    
                    [self loadingHUDStopLoadingWithTitle:@"登录成功"];
                    
                }else{
                    
                    /* 登录信息拉取信息成功*/
                    openID = dic[@"data"][@"openid"];
                    
                    BindingViewController *bVC = [[BindingViewController alloc]initWithOpenID:openID];
                    [self.navigationController pushViewController:bVC animated:YES];
                }
            }
            
            
        }else{
            /* 登录信息拉取失败*/
            
            [self loadingHUDStopLoadingWithTitle:@"获取微信登录信息失败,请重试!"];
            
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
    _loginView.keyCodeButton.hidden = NO;
    _loginView.text3.hidden = NO;
    _loginView.keyCodeText.hidden = NO;
    
    _loginView.loginButton.sd_resetLayout
    .topSpaceToView(_loginView.text3,20)
    .leftEqualToView(_loginView.text3)
    .rightEqualToView(_loginView.keyCodeButton)
    .heightRatioToView(_loginView.text2,0.8);
    
    
    [self makeCaptcha];
    
    
    
    
    
}

- (void)makeCaptcha{
    
    _captcha = [NSMutableString string];
    
    
    /* 生成验证码的方法*/
    NSArray  *changeArray = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",nil];
    
    //随机从数组中选取需要个数的字符，然后拼接为一个字符串
    for(int i = 0; i < 4; i++)
    {
        NSInteger index = arc4random() % ([changeArray count] - 1);
        NSString *getStr = [changeArray objectAtIndex:index];
        
        _captcha = (NSMutableString *)[_captcha stringByAppendingString:getStr];
    }
    
    [_loginView.keyCodeButton setTitle:_captcha forState:UIControlStateNormal];
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
    
    
    /* 如果用户名为空*/
    if ([_loginView.userName.text isEqualToString:@""]) {
        
        /* 弹出alert框 提示输入账户名*/
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"账号不能为空！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action1];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    /* 如果密码为空*/
    if ([_loginView.passWord.text isEqualToString:@""]) {
        
        /* 弹出alert框 提示输入账户名*/
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"密码不能为空！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action1];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    
    
    if (![_loginView.userName.text isEqualToString:@""]&![_loginView.passWord.text isEqualToString:@""]) {
       
        /* 判断是否需要输入验证码*/
        if (needCheckCaptcha == YES&&[_loginView.keyCodeText.text isEqualToString:@""]) {
            
            /* 弹出alert框 提示输入验证码*/
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"请输入验证码！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action1];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        if (needCheckCaptcha == YES&&![_loginView.keyCodeText.text.lowercaseString isEqualToString:_captcha.lowercaseString]) {
            
            /* 弹出alert框 提示输入正确的验证码*/
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确的验证码！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action1];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        
        
        /* 不需要输入验证码或者验证码输入正确的情况*/
        if (needCheckCaptcha == NO || (needCheckCaptcha == YES&&[_loginView.keyCodeText.text.lowercaseString isEqualToString:_captcha.lowercaseString])) {
            /* HUD框 提示正在登陆*/
//            MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeIndeterminate;
//            hud.labelText = @"正在登陆";
//            [hud show:YES];
            [self loadingHUDStartLoadingWithTitle:@"正在登陆"];
            
            /* 对应接口要上传的用户登录账号密码*/
            NSDictionary *userInfo = @{@"login_account":[NSString stringWithFormat:@"%@",_loginView.userName.text],
                                       @"password":[NSString stringWithFormat:@"%@",_loginView.passWord.text],
                                       @"client_type":@"app",
                                       @"client_cate":@"student_client"};
            
            /* 登录请求*/
            AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer =[AFHTTPResponseSerializer serializer];
            [manager POST:[NSString stringWithFormat:@"%@/api/v1/sessions",Request_Header ]parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                /* 解析返回数据*/
                NSDictionary *userInfoGet=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                NSLog(@"%@",userInfoGet);
                
                NSDictionary *dicGet=[NSDictionary dictionaryWithDictionary:userInfoGet[@"data"]];
                
                NSLog(@"%@",dicGet);
                
                /* 如果返回的字段里包含key值“remember_token“ 为登录成功*/
                /* 如果登录成功*/
                if ([[dicGet allKeys]containsObject:@"remember_token" ]) {
                    
                    [self saveUserInfo:dicGet loginType:Normal];
//                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Login"];
//                   
//                    
////                    [hud hide:YES];
//                    
//                    
//                    
//#pragma mark- 本地登录成功后 保存token文件，并且转到主页面
//                    
//                    NSString *userTokenFilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"User.data"];
//                    
//                    NSLog(@"保存的数据\n%@",dicGet);
//                    /* 归档*/
//                    [NSKeyedArchiver archiveRootObject:dicGet toFile:userTokenFilePath];
//                    
//                    [[NSNotificationCenter defaultCenter]postNotificationName:@"UserLogin" object:nil];
//                    
//                    /* 另存一份userdefault  只存token和id*/
//                    NSString *remember_token = [NSString stringWithFormat:@"%@",dicGet[@"remember_token"]];
//                    
//                    NSDictionary *user=[NSDictionary dictionaryWithDictionary:dicGet[@"user"]];
//                    NSLog(@"%@",user);
//                    
//                    
//                    NSString *userID = [NSString stringWithFormat:@"%@",[[dicGet valueForKey:@"user"] valueForKey:@"id"]];
//                    
//                    [[NSUserDefaults standardUserDefaults]setObject:remember_token forKey:@"remember_token"];
//                    [[NSUserDefaults standardUserDefaults]setObject:userID forKey:@"id"];
//                    
//                    
//                    NSLog(@"token:%@,id:%@",remember_token,userID);
//                    
//                    
//                    /* 另存一个userdefault ，只存user的头像地址*/
//                    [[NSUserDefaults standardUserDefaults]setObject:dicGet[@"user"][@"avatar_url"] forKey:@"avatar_url"];
//                    
//                    /* 另存一个useerdefault 存user的name*/
//                     [[NSUserDefaults standardUserDefaults]setObject:dicGet[@"user"][@"name"] forKey:@"name"];
//                    
//                    /* 另存一个userdefault 存电话*/
//                    if (dicGet[@"user"][@"login_mobile"] !=nil) {
//                        [[NSUserDefaults standardUserDefaults]setObject:dicGet[@"user"][@"login_mobile"] forKey:@"login_mobile"];
//                    }
//                    
//                    
//                    
//#pragma mark- 把用户聊天账户信息存本地
//                    
//                    
//                    /* 另存一份userdefault  只存chat_account*/
//                    
//                    NSDictionary *userDic =[NSDictionary dictionaryWithDictionary:[dicGet valueForKey:@"user"]];
//                    
//                    NSLog(@"%@",userDic);
//                    
//                    if ([userDic valueForKey:@"chat_account"]!=nil&&![[userDic valueForKey:@"chat_account"] isEqual:[NSNull null]]) {
//                        
//                        NSDictionary *chat_accountDic = [NSDictionary dictionaryWithDictionary:[userDic valueForKey:@"chat_account"]];
//                        
//                        NSLog(@"%@",chat_accountDic);
//                        
//                        
//                        [[NSUserDefaults standardUserDefaults]setObject:chat_accountDic forKey:@"chat_account"];
//                    }
                    
                    [self loadingHUDStopLoadingWithTitle:@"登录成功"];
                    
                }else{
                    
//                    [hud hide:YES];
                    [self loadingHUDStopLoadingWithTitle:@"登录失败"];
                    _wrongTimes ++;
                    if (_wrongTimes >=5) {
                        
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"FivethWrongTime" object:nil];
                        
                    }
                    
                    
                    /* 账户名密码错误提示*/
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"账户名或密码错误！" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:action];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }
                
                [self loadingHUDStopLoadingWithTitle:@"登录成功!"];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                NSLog(@"%@",error);

                [self loadingHUDStopLoadingWithTitle:@"登录失败"];
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
    /* 归档*/
    [NSKeyedArchiver archiveRootObject:userDic toFile:userTokenFilePath];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UserLogin" object:nil];
    
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
            break;
            
        case 1:
            type = [NSString stringWithFormat:@"Wechat"];
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
        
        NSDictionary *chat_accountDic = [NSDictionary dictionaryWithDictionary:[chatAccount valueForKey:@"chat_account"]];
        
        NSLog(@"%@",chat_accountDic);
        
        
        [[NSUserDefaults standardUserDefaults]setObject:chat_accountDic forKey:@"chat_account"];
        
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
    
    [_loginView.userName resignFirstResponder];
    [_loginView.passWord resignFirstResponder];
    [_loginView.keyCodeText resignFirstResponder];
}

#pragma mark- 微信直接拉起请求
-(void)sendAuthRequest
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init ]  ;
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    
    
    [WXApi sendReq:req];
    
    
}

//- (void)returnLastPage{
//    
//    [self.navigationController popViewControllerAnimated:YES];
//}






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
