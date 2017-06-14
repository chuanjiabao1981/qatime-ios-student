//
//  GuestBindingViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/6/2.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "GuestBindingViewController.h"
#import "NavigationBar.h"
#import "UIViewController+AFHTTP.h"
#import "UIAlertController+Blocks.h"
#import "UIViewController+HUD.h"
#import "SAMKeychain.h"
#import <NIMSDK/NIMSDK.h>
#import "UIControl+RemoveTarget.h"
#import "LoginViewController.h"


#import "SafeViewController.h"
#import "MyWalletViewController.h"

typedef NS_ENUM(NSUInteger, LoginType) {
    Normal =0, //账号密码登录
    Wechat,  //微信登录
    Guest,   //游客登录
};

@interface GuestBindingViewController ()<UITextFieldDelegate,UIScrollViewDelegate>{
    
    NavigationBar *_navigationBar;
    
    NSString *_token;
    NSString *_id;
    
    
    //如果有完善信息的前提
    NSString *_phoneNumber;
    
}

@end


@implementation GuestBindingViewController

-(instancetype)initWithPhoneNumber:(NSString *)phoneNumber{
    self = [super init];
    if (self) {
        
        _phoneNumber = [NSString stringWithFormat:@"%@",phoneNumber];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载数据
    [self makeData];
    
    //加载导航栏
    [self setupNavigation];
    
    //加载主视图
    [self setupMainView];
    
}

/**加载基础数据*/
- (void)makeData{
    
    _token = [NSString stringWithFormat:@"%@",[SAMKeychain passwordForService:Qatime_Service account:@"Remember-Token"]];
    _id = [NSString stringWithFormat:@"%@",[SAMKeychain passwordForService:Qatime_Service account:@"id"]];
}


/**加载导航栏*/
- (void)setupNavigation{
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview:_navigationBar];
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    _navigationBar.titleLabel.text = @"账户绑定";
    
}
/**加载主视图*/
- (void)setupMainView{
    
    _mainView = [[GuestBindingView alloc]initWithFrame:CGRectMake(0, Navigation_Height, self.view.width_sd, self.view.height_sd - Navigation_Height)];
    [self.view addSubview:_mainView];
    _mainView.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resign)];
    [_mainView addGestureRecognizer:tap];
    
    //在可能有部分值的情况下赋值
    if (_phoneNumber) {
        _mainView.phoneText.text = _phoneNumber;
        _mainView.getCheckCodeBtn.enabled = YES;
        [_mainView.getCheckCodeBtn setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
        [_mainView.getCheckCodeBtn setBackgroundColor:[UIColor whiteColor]];
        _mainView.getCheckCodeBtn.layer.borderColor = NAVIGATIONRED.CGColor;
        
        [_mainView.getCheckCodeBtn addTarget:self action:@selector(getCheckCode:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    //输入框代理
    _mainView.nameText.delegate = self ;
    _mainView.phoneText.delegate = self;
    _mainView.chekCodeText.delegate = self;
    _mainView.passwordText.delegate = self;
    _mainView.passwordConfirmText.delegate = self;
    [_mainView.applyProtocolSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    
    //加个输入框监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    //增加键盘监听
    [self registerForKeyboardNotifications];
    
}

/**注册键盘监听*/
- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    // 获取通知的信息字典
    NSDictionary *userInfo = [notification userInfo];
    
    // 获取键盘弹出后的rect
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    // 获取键盘弹出动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        if ([_mainView.passwordText isFirstResponder]||[_mainView.passwordConfirmText isFirstResponder]) {
            
            [_mainView setFrame:CGRectMake(0, -keyboardRect.size.height+40*ScrenScale320*2+20*ScrenScale320*2+Navigation_Height, self.view.width_sd, self.view.height_sd)];
        }
        
    }];
    
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    // 获取通知信息字典
    NSDictionary* userInfo = [notification userInfo];
    
    // 获取键盘隐藏动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        [_mainView setFrame:CGRectMake(0, Navigation_Height, self.view.width_sd, self.view.height_sd)];
        
    }];
    
}




/**输入框变化*/
-(void)textDidChange:(id<UITextInput>)textInput{
    /* 手机号框*/
    
    if ([self isMobileNumber:_mainView.phoneText.text]) {
        
        if ([_mainView.getCheckCodeBtn.titleLabel.text isEqualToString:@"获取校验码"]) {
            _mainView.getCheckCodeBtn.enabled = YES;
            [_mainView.getCheckCodeBtn setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
            [_mainView.getCheckCodeBtn setBackgroundColor:[UIColor whiteColor]];
            _mainView.getCheckCodeBtn.layer.borderColor = NAVIGATIONRED.CGColor;
            
            [_mainView.getCheckCodeBtn addTarget:self action:@selector(getCheckCode:) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            
        }
        
    }else{
        
        _mainView.getCheckCodeBtn.enabled = NO;
        [_mainView.getCheckCodeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_mainView.getCheckCodeBtn removeTarget:self action:@selector(getCheckCode:) forControlEvents:UIControlEventTouchUpInside];
        
        [_mainView.getCheckCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mainView.getCheckCodeBtn setBackgroundColor:[UIColor lightGrayColor]];
        _mainView.getCheckCodeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    if (_mainView.phoneText.text.length > 11) {
        _mainView.phoneText.text = [_mainView.phoneText.text substringToIndex:11];
        [UIAlertController showAlertInViewController:self withTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入11位手机号", nil) cancelButtonTitle:NSLocalizedString(@"确定", nil) destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            _mainView.getCheckCodeBtn.enabled = YES;
            [_mainView.getCheckCodeBtn setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
            [_mainView.getCheckCodeBtn setBackgroundColor:[UIColor whiteColor]];
            _mainView.getCheckCodeBtn.layer.borderColor = NAVIGATIONRED.CGColor;
            
            [_mainView.getCheckCodeBtn addTarget:self action:@selector(getCheckCode:) forControlEvents:UIControlEventTouchUpInside];
        }];
    }
    
    
    if (_mainView.phoneText.text.length>0&&_mainView.chekCodeText.text.length>0&&_mainView.passwordText.text.length>0&&_mainView.passwordConfirmText.text.length>0&&_mainView.applyProtocolSwitch.on==YES) {
        
        _mainView.finishBtn.enabled = YES;
        [_mainView.finishBtn setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
        [_mainView.finishBtn setBackgroundColor: [UIColor whiteColor]];
        _mainView.finishBtn.layer.borderColor = NAVIGATIONRED.CGColor;
        [_mainView.finishBtn addTarget:self action:@selector(binding:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        _mainView.finishBtn.enabled = NO;
        
        [_mainView.finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mainView.finishBtn setBackgroundColor: [UIColor lightGrayColor]];
        _mainView.finishBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
    }
    
}

/*点击按钮  获取验证码*/

- (void)getCheckCode:(UIButton *)sender{
    
    /* 手机号码正确的情况
     正则表达式 判断手机号的正确或错误
     */
    if ([self isMobileNumber:_mainView.phoneText.text]){
        
        //先判断该手机号是不是已经注册了
        [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/user/check",Request_Header] withHeaderInfo:nil andHeaderfield:nil parameters:@{@"account":_mainView.phoneText.text} completeSuccess:^(id  _Nullable responds) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
            if ([dic[@"status"]isEqualToNumber:@1]) {
                
                if ([dic[@"data"]boolValue]==YES) {
                    
                    //已经被占用
                    [self HUDStopWithTitle:@"该手机号码已经被注册"];
                    
                }else{
                    //可以使用该手机进行账户绑定
                    
                    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
                    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
                    
                    [manager POST:[NSString stringWithFormat:@"%@/api/v1/captcha",Request_Header] parameters:@{@"send_to":_mainView.phoneText.text,@"key":@"register_captcha"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        
                        /* 发送成功提示框*/
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        hud.mode = MBProgressHUDModeText;
                        [hud setLabelText:NSLocalizedString(@"发送成功!", nil)];
                        hud.yOffset= 150.f;
                        hud.removeFromSuperViewOnHide = YES;
                        
                        
                        /* 重新发送验证码*/
                        [self deadLineTimer:_mainView.getCheckCodeBtn];
                        
                        [hud hide:YES afterDelay:2.0];
                        
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
                    }];
                    
                }
                
            }else{
                //网络错误
                [self HUDStopWithTitle:@"网络繁忙,请稍后重试"];
            }
            
        } failure:^(id  _Nullable erros) {
            //网络错误
            [self HUDStopWithTitle:@"网络繁忙,请稍后重试."];
            
        }];
        
        
    }
    
    /* 手机号输入为空或错误的情况*/
    else  {
        
        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:NSLocalizedString(@"请输入正确的手机号!", nil) cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
        }];
        
    }
    
}

#pragma mark- 倒计时方法封装
/* 倒计时方法封装*/
- (void)deadLineTimer:(UIButton *)button{
    
    /* 按钮倒计时*/
    __block int deadline=CheckCodeTime;
    
    /* 子线程 倒计时*/
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    /* 执行时间为1秒*/
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(_timer, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *strTime = [NSString stringWithFormat:@"%@(%d)",NSLocalizedString(@"重发验证码", nil),deadline];
            
            [button setTitle:strTime forState:UIControlStateNormal];
            
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor lightGrayColor]];
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [button setEnabled:NO];
            
        });
        deadline--;
        
        /* 倒计时结束 关闭线程*/
        if(deadline<=0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [button setTitle:NSLocalizedString(@"获取校验码", nil) forState:UIControlStateNormal];
                [button setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor whiteColor]];
                button.layer.borderColor = NAVIGATIONRED.CGColor;
                
                [button setEnabled:YES];
                
            });
        }
    });
    dispatch_resume(_timer);
    
}


// 正则判断手机号码地址格式
- (BOOL)isMobileNumber:(NSString *)mobileNum {
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(1[0-9]|3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}


#pragma 正则匹配用户密码 6 - 16 位数字和字母组合
-(BOOL)checkPassWord:(NSString *)password{
    
    //6-16位数字和字母组成
    //    ^[A-Za-z0-9]{6,16}$
    NSString *regex = @"^[A-Za-z0-9\\~\\!\\/\\@\\#\\$\\%\\^\\&\\*\\(\\)\\-\\_\\=\\+\\\\\\|\\[\\{\\}\\]\\;\\:\\\'\\\"\\,\\<\\.\\>\\/\\?]{6,16}$";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:password]) {
        return YES ;
    }else
        return NO;
}

#pragma mark- UISwitch Changed
- (void)switchChange:(UISwitch *)switcher{
    
    if (switcher.on == YES) {
        if (_mainView.phoneText.text.length>0&&_mainView.chekCodeText.text.length>0&&_mainView.passwordText.text.length>0&&_mainView.passwordConfirmText.text.length>0){
            
            //所有信息正确,绑定按钮可用
            _mainView.finishBtn.enabled = YES;
            [_mainView.finishBtn setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
            [_mainView.finishBtn setBackgroundColor: [UIColor whiteColor]];
            _mainView.finishBtn.layer.borderColor = NAVIGATIONRED.CGColor;
            [_mainView.finishBtn addTarget:self action:@selector(binding:) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }else{
        
        _mainView.finishBtn.enabled = NO;
        [_mainView.finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mainView.finishBtn setBackgroundColor: SEPERATELINECOLOR_2];
        _mainView.finishBtn.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        [_mainView.finishBtn removeAllTargets];
        
    }
}


#pragma mark- Private Method

/**绑定方法*/
- (void)binding:(UIButton *)sender{
    
    //绑定之前先判断是否有未填写的资料
    if ([_mainView.nameText.text isEqualToString:@""]) {
        
        [self HUDStopWithTitle:@"请填您的名字"];
        
    }else{
        
        if ([_mainView.phoneText.text isEqualToString:@""]) {
            
            [self HUDStopWithTitle:@"请填写手机号并进行验证"];
        }else{
            
            if ([_mainView.passwordText.text isEqualToString:@""]) {
                [self HUDStopWithTitle:@"请务必填写密码!"];
            }else{
                
                if ([_mainView.passwordConfirmText.text isEqualToString:@""]) {
                    
                    [self HUDStopWithTitle:@"请确认密码"];
                }else{
                    if (![_mainView.passwordConfirmText.text isEqualToString:_mainView.passwordText.text]) {
                        
                        [self HUDStopWithTitle:@"两次密码填写不一致"];
                    }else{
                        //信息填写全部正确
                        
                        [self HUDStartWithTitle:nil];
                        [self POSTSessionURL:[NSString stringWithFormat:@"%@/api/v1/user/guests/%@/bind",Request_Header,_id] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:@{@"login_mobile":_mainView.phoneText.text,@"captcha_confirmation":_mainView.chekCodeText.text,@"password":_mainView.passwordText.text,@"password_confirmation":_mainView.passwordConfirmText.text,@"accept":@"1",@"name":_mainView.nameText.text} completeSuccess:^(id  _Nullable responds) {
                            [self stopHUD];
                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
                            if ([dic[@"status"]isEqualToNumber:@1]) {
                                
                                //绑定成功 如同登录成功
                                [self saveUserInfo:dic[@"data"] loginType:Normal];
                                
                                //绑定成功后,干掉所有游客信息keychain,并保存当前用户的keychain
//                                NSError *error = [[NSError alloc]init];
                                
                                NSArray *allKeys = [SAMKeychain allAccounts];
                                for (NSDictionary *key in allKeys) {
                                    
                                    if ([key[@"acct"]isEqualToString:@"Remember-Token"]) {
                                        
                                        [SAMKeychain deletePasswordForService:Qatime_Service account:@"Remember-Token" ];
                                    }else if ([key[@"acct"]isEqualToString:@"id"]){
                                        
                                        [SAMKeychain deletePasswordForService:Qatime_Service account:@"id"];
                                        
                                    }else if ([key[@"acct"]isEqualToString:@"password"]){
                                        
                                        [SAMKeychain deletePasswordForService:Qatime_Service account:@"password"];
                                    }
                                    
                                }
                                
                                [SAMKeychain setPassword:_mainView.passwordText.text forService:Qatime_Service account:_mainView.phoneText.text ];
                                [self HUDStopWithTitle:@"绑定成功!"];
                                
                                ///绑定成功后的跳转
                                [self backToAssign];
                                
                                
                            }else{
                                //绑定失败
                                [self HUDStopWithTitle:@"绑定失败,请稍后再试"];
                            }
                            
                        } failure:^(id  _Nullable erros) {
                            
                            [self HUDStopWithTitle:@"网络不给力,请稍后再试"];
                            
                        }];
                        
                    }
                    
                }
            }
        }
        
    }
    
}

/* 登录成功后,保存用户信息*/
- (void)saveUserInfo:(NSDictionary *)userDic loginType:(LoginType)loginType{
    
#pragma mark- 本地登录成功后 保存token文件，并且转到主页面
    
    
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


//指定页面跳转
- (void)backToAssign{
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        if ([controller isMemberOfClass:[SafeViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }else if([controller isMemberOfClass:[MyWalletViewController class]]){
            [self.navigationController popToViewController:controller animated:YES];
        }else if ([controller isMemberOfClass:[LoginViewController class]]){
            //从登录页过来的就直接登录吧 , 绑定手机和密码了也干不了啥别的了
            [[NSNotificationCenter defaultCenter]postNotificationName:@"UserLogin" object:nil];
            
        }else{
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
}





- (void)resign{
    
    [_mainView.nameText resignFirstResponder];
    [_mainView.phoneText resignFirstResponder];
    [_mainView.chekCodeText resignFirstResponder];
    [_mainView.passwordText resignFirstResponder];
    [_mainView.passwordConfirmText resignFirstResponder];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_mainView.nameText resignFirstResponder];
    [_mainView.phoneText resignFirstResponder];
    [_mainView.chekCodeText resignFirstResponder];
    [_mainView.passwordText resignFirstResponder];
    [_mainView.passwordConfirmText resignFirstResponder];
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
