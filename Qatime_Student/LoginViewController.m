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

@interface LoginViewController ()<UITextFieldDelegate>{
    
    
    NSInteger keyHeight;
    
    FindPasswordViewController *findPasswordViewController;
    
    /* 用户聊天信息存本地*/
    
    Chat_Account *_chat_Account;
    
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    
    _loginView = [[LoginView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    [self.view addSubview:_loginView];
    
    /* status bar的绿色*/
    UIView *status=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20)];
    [self .view addSubview:status];
    [status setBackgroundColor:[UIColor colorWithRed:26/255.0 green:183/255.0 blue:159/255.0 alpha:1.0]];
    
    [_loginView.signUpButton addTarget:self action:@selector(enterSignUpPage:) forControlEvents:UIControlEventTouchUpInside];
    
    [_loginView.loginButton addTarget:self action:@selector(userLogin:) forControlEvents:UIControlEventTouchUpInside];
    _loginView.userName.delegate = self;
    _loginView.passWord.delegate = self;
    
    
    
    
    //增加监听，当键盘出现或改变时收出消息
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShow:)
     
                                                 name:UIKeyboardWillShowNotification
     
                                               object:nil];
    
    
    
    //增加监听，当键退出时收出消息
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillHide:)
     
                                                 name:UIKeyboardWillHideNotification
     
                                               object:nil];
    
    
    
    
    /* 忘记密码按钮*/
    [_loginView.forgottenPassorwdButton addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
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
        
        /* HUD框 提示正在登陆*/
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeDeterminate;
//        hud.backgroundView.style = MBProgressHUDBackgroundStyleBlur;
        hud.labelText = @"正在登陆";
        
        
        /* 对应接口要上传的用户登录账号密码*/
        NSDictionary *userInfo = @{@"login_account":[NSString stringWithFormat:@"%@",_loginView.userName.text],
                                   @"password":[NSString stringWithFormat:@"%@",_loginView.passWord.text],
                                   @"client_type":@"app",
                                   @"client_cate":@"student_client"};
        
        /* 登录请求*/
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager POST:@"http://testing.qatime.cn/api/v1/sessions" parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            /* 解析返回数据*/
            NSDictionary *userInfoGet=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            NSLog(@"%@",userInfoGet);
            
            NSDictionary *dicGet=[NSDictionary dictionaryWithDictionary:userInfoGet[@"data"]];
            
            NSLog(@"%@",dicGet);
            
            
            /* 如果返回的字段里包含key值“remember_token“ 为登录成功*/
            /* 如果登录成功*/
            if ([[dicGet allKeys]containsObject:@"remember_token" ]) {
                
                [hud hide:YES];
                
                
                #pragma mark- 本地登录成功后 保存token文件，并且转到主页面
                
                 NSString *userTokenFilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"User.data"];
                
                NSLog(@"保存的数据\n%@",dicGet);
                /* 归档*/
                [NSKeyedArchiver archiveRootObject:dicGet toFile:userTokenFilePath];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"UserLogin" object:nil];
                
                /* 另存一份userdefault  只存token和id*/
                NSString *remember_token = [NSString stringWithFormat:@"%@",dicGet[@"remember_token"]];
                
                NSDictionary *user=[NSDictionary dictionaryWithDictionary:dicGet[@"user"]];
                NSLog(@"%@",user);
                
                
                NSString *userID = [NSString stringWithFormat:@"%@",[[dicGet valueForKey:@"user"] valueForKey:@"id"]];
                
                [[NSUserDefaults standardUserDefaults]setObject:remember_token forKey:@"remember_token"];
                [[NSUserDefaults standardUserDefaults]setObject:userID forKey:@"id"];
                
                
                NSLog(@"token:%@,id:%@",remember_token,userID);
                
                
                /* 另存一个userdefault ，只存user的头像地址*/
                [[NSUserDefaults standardUserDefaults]setObject:dicGet[@"user"][@"avatar_url"] forKey:@"avatar_url"];
                
                
                
                
             #pragma mark- 把用户聊天账户信息存本地
                
                
                
                /* 另存一份userdefault  只存chat_account*/
                
                NSDictionary *chat_accountDic = [NSDictionary dictionaryWithDictionary:[[dicGet valueForKey:@"user"]valueForKey:@"chat_account"]];
                
            NSLog(@"%@",chat_accountDic);
                
                
                
                
                
                
                [[NSUserDefaults standardUserDefaults]setObject:chat_accountDic forKey:@"chat_account"];
                
                
                
                
            }else{
                
                [hud hide:YES];
                
                /* 账户名密码错误提示*/
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"账户名或密码错误！" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:action];
                
                [self presentViewController:alert animated:YES completion:nil];
                
                
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"%@",error);
            
            MBProgressHUD *hud2=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud2.mode = MBProgressHUDModeText;
            hud2.labelText = @"登陆失败";
            
        }];
        
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
