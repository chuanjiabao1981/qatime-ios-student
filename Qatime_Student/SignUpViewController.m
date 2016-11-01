//
//  SignUpViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "SignUpViewController.h"
#import "SignUpView.h"
#import "MBProgressHUD.h"
#import "SignUpInfoViewController.h"

@interface SignUpViewController (){
    
    SignUpInfoViewController *_signUpInfoViewController ;
    
    
}

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    [self.view addSubview:_navigationBar];
    [_navigationBar.titleLabel setText:@"设置登录"];
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(backToFrontPage:) forControlEvents:UIControlEventTouchUpInside];
    
    _signUpView = [[SignUpView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64)];
    [self .view addSubview:_signUpView];
    
    [_signUpView.getCheckCodeButton addTarget:self action:@selector(getCheckCode:) forControlEvents:UIControlEventTouchUpInside];
    
    [_signUpView.nextStepButton addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

/* 点击下一步按钮*/
- (void)nextStep:(UIButton *)sender{
    
    /* 测试口  直接跳转*/
    
    /* 进入下一页*/
   // _signUpInfoViewController = [[SignUpInfoViewController alloc]init];
    
    //[self.navigationController pushViewController:_signUpInfoViewController animated:YES];

    ////////////////////////////////////////////
    
    
    
    
    /* 有信息填写不正确*/
    if ([_signUpView.phoneNumber.text isEqualToString:@""]) {
        
        [self showAlertWith:@"请输入手机号！"];
    }
    if (![self isMobileNumber:_signUpView.phoneNumber.text]) {
        
        [self showAlertWith:@"请输入正确的手机号！"];
        
    }
    if ([_signUpView.userPassword.text isEqualToString:@""]||![self checkPassWord: _signUpView.userPassword.text] ) {
        
        [self showAlertWith:@"请输入6-16位密码！"];
        
    }
    if ([self checkPassWord: _signUpView.userPassword.text]&&![_signUpView.userPassword.text isEqualToString:_signUpView.userPasswordCompare.text]) {
        
        [self showAlertWith:@"前后密码不一致"];
        
    }
    
    if (!([_signUpView.phoneNumber.text isEqualToString:@""]&&[_signUpView.userPassword.text isEqualToString:@""]&&[_signUpView.userPasswordCompare.text isEqualToString:@""]&&[_signUpView.checkCode.text isEqualToString:@""])&&[_signUpView.unlockKey.text isEqualToString:@""]) {
        [self showAlertWith:@"请输入注册号"];
        
    }
    
    /* 所有信息都填写正确的情况*/
    if (!([_signUpView.phoneNumber.text isEqualToString:@""]&&[_signUpView.userPassword.text isEqualToString:@""]&&[_signUpView.userPasswordCompare.text isEqualToString:@""]&&[_signUpView.checkCode.text isEqualToString:@""]&&[_signUpView.unlockKey.text isEqualToString:@""])&&[_signUpView.userPasswordCompare.text isEqualToString:_signUpView.userPassword.text]) {
        
        /* 所有信息汇总成字典*/
        
        NSDictionary *signUpInfo =@{
                                    @"login_mobile":_signUpView.phoneNumber.text,
                                    @"captcha_confirmation":_signUpView.checkCode.text,
                                    @"password":_signUpView.userPassword.text,
                                    @"password_confirmation":_signUpView.userPasswordCompare.text,
                                    @"register_code_value":_signUpView.unlockKey.text,
                                    @"accept":@"1",
                                    @"type":@"Student",
                                    @"client_type":@"app"
                                    };
        
        /* 验证码 请求状态*/
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager POST:@"http://testing.qatime.cn/api/v1/captcha/verify" parameters:signUpInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *codeState = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",codeState);
            
            NSDictionary *dataDic=[NSDictionary dictionaryWithDictionary: codeState[@"data"]];
            
#pragma mark-注册信息校验正确
            /* 注册信息校验正确*/
            
            if ([[dataDic allKeys]containsObject:@"remember_token"]){
                
                /* 发送成功提示框*/
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                [hud.label setText:@"验证成功！"];
                hud.yOffset= 150.f;
                hud.removeFromSuperViewOnHide = YES;
                
                [hud hideAnimated:YES afterDelay:1.0];
                
                
                
                #pragma mark- 把token和id(key : data)存储到本地沙盒路径
                
                 NSString *tokenFilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"token.data"];
                [NSKeyedArchiver archiveRootObject:dataDic toFile:tokenFilePath];
                
                
                
                
                
                /* 进入下一页*/
                _signUpInfoViewController = [[SignUpInfoViewController alloc]init];
                
                [self.navigationController pushViewController:_signUpInfoViewController animated:YES];
                
                
            }
            else if ([[dataDic allKeys]containsObject:@"error"]){
                
                [self showAlertWith:@"验证失败！"];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }
    
}


/*点击按钮  获取验证码*/

- (void)getCheckCode:(UIButton *)sender{
    
    /* 手机号码正确的情况
     正则表达式 判断手机号的正确或错误
     */
    if ([self isMobileNumber:_signUpView.phoneNumber.text]){
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        
        [manager POST:@"http://testing.qatime.cn/api/v1/captcha" parameters:@{@"send_to":_signUpView.phoneNumber.text,@"key":@"register_captcha"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            /* 发送成功提示框*/
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            [hud.label setText:@"发送成功！"];
            hud.yOffset= 150.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hideAnimated:YES afterDelay:2.0];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    
    /* 手机号输入为空或错误的情况*/
    else  {
        
        [self showAlertWith:@"请输入正确的手机号！"];
    }
    
    
}

// 正则判断手机号码地址格式
- (BOOL)isMobileNumber:(NSString *)mobileNum {
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
}



#pragma 正则匹配用户密码 6 - 16 位数字和字母组合
-(BOOL)checkPassWord:(NSString *)password{
    //6-16位数字和字母组成
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:password]) {
        return YES ;
    }else
        return NO;
}





/* 弹出alter封装*/
- (void)showAlertWith:(NSString *)message{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}


/* 返回上一页面*/

- (void)backToFrontPage:(UIButton *)sender{
    
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
