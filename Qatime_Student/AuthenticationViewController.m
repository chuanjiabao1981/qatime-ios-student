//
//  AuthenticationViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/1/16.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "NavigationBar.h"
#import "UIViewController+HUD.h"
#import "UIAlertController+Blocks.h"
#import "SetPayPasswordViewController.h"

@interface AuthenticationViewController (){
    
    NavigationBar *_navigationBar;
    
    NSString *_token;
    NSString *_idNumber;
    
}

@end

@implementation AuthenticationViewController


- (void)loadView{
    [super loadView];
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
    [self.view addSubview:_navigationBar];
    
    _authenticationView  = [[AuthenticationView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64)];
    [self.view addSubview:_authenticationView];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    _navigationBar.titleLabel.text = @"验证身份";
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    

    
    [_authenticationView.getCodeButton addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    _authenticationView.getCodeButton.enabled = NO;
    [_authenticationView.nextStepButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    _authenticationView.nextStepButton.enabled = NO;
    
    [_authenticationView.passwordText addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    _authenticationView.passwordText.secureTextEntry = YES;
    
    [_authenticationView.checkCodeText addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    _authenticationView.checkCodeText.secureTextEntry = YES;
    
    
}


/* 字符改变的问题*/
- (void)textDidChange:(UITextField *)textField{
    
    /* 验证是否有中文字符*/
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @".{0,}[\u4E00-\u9FA5].{0,}"];
    if ([regextestmobile evaluateWithObject:textField.text]==YES) {
        
        [textField.text substringFromIndex:textField.text.length];
        
        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"请勿输入中文!" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {}];
        
    }
    
    if (textField == _authenticationView.passwordText) {
        if (textField.text.length>0) {
            _authenticationView.getCodeButton.enabled = YES;
            _authenticationView.getCodeButton.layer.borderColor = BUTTONRED.CGColor;
            [_authenticationView.getCodeButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
            
        }else if (textField.text.length==0){
            _authenticationView.getCodeButton.enabled = NO;
            _authenticationView.getCodeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [_authenticationView.getCodeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
        }
        
    }
    
    if (textField == _authenticationView.checkCodeText) {
        if (textField.text.length>0) {
            if (_authenticationView.passwordText.text.length>0) {
                _authenticationView.nextStepButton.enabled = YES;
                _authenticationView.nextStepButton.layer.borderColor = BUTTONRED.CGColor;
                [_authenticationView.nextStepButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
                _authenticationView.nextStepButton.layer.borderWidth = 1;
                
            }else if (_authenticationView.passwordText.text.length==0){
                _authenticationView.nextStepButton.enabled = NO;
                _authenticationView.nextStepButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
                [_authenticationView.nextStepButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                _authenticationView.nextStepButton.layer.borderWidth = 1;
                
            }
            
            
        }
    }
    
    
    
}



#pragma mark- 获取验证码的按钮点击事件
- (void)getCode:(UIButton *)sender{
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"login_mobile"]) {
    
        if (sender.enabled ==YES) {
            AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer =[AFHTTPResponseSerializer serializer];
            [manager POST:[NSString stringWithFormat:@"%@/api/v1/captcha",Request_Header] parameters:@{@"send_to":[[NSUserDefaults standardUserDefaults]valueForKey:@"login_mobile"],@"key":@"update_payment_pwd"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
                    
                    [self loadingHUDStopLoadingWithTitle:@"发送成功!"];
                    
                }else{
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"信息错误!" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }] ;
                    [alert addAction:sure];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    
//                    [self loadingHUDStopLoadingWithTitle:@""];
                }
                
                
                
                
                [self deadLineTimer:sender];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
        }
    }else{
        
        /* 登录超时*/
        [self loginAgain];
        
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
            
            NSString *strTime = [NSString stringWithFormat:@"重发验证码(%d)",deadline];
            
            [button setTitle:strTime forState:UIControlStateNormal];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            
            [button setEnabled:NO];
            
        });
        deadline--;
        
        /* 倒计时结束 关闭线程*/
        if(deadline<=0){
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                [button setTitle:@"获取校验码" forState:UIControlStateNormal];
                [button setTitleColor:BUTTONRED forState:UIControlStateNormal];
                button.layer.borderColor = BUTTONRED.CGColor;
                
                [button setEnabled:YES];
                
                
            });
        }
    });
    dispatch_resume(_timer);
    
    
    
}





/* 下一步*/
- (void)nextStep{
    
    /* 验证密码输入是否正确*/
    
    if ([self checkPassWord:_authenticationView.passwordText.text]==NO) {
        /* 密码错误*/
        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"请输入6-16位密码" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        }];
    }else{
        
        if (_authenticationView.checkCodeText.text.length>0) {
            
            [self loadingHUDStartLoadingWithTitle:@"正在请求"];
            /* 发送验证申请*/
            AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer =[AFHTTPResponseSerializer serializer];
            [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
            [manager POST:[NSString stringWithFormat:@"%@/api/v1/payment/cash_accounts/%@/password/ticket_token",Request_Header,_idNumber] parameters:@{@"password":_authenticationView.passwordText.text,@"captcha_confirmation":_authenticationView.checkCodeText.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                if ([dic[@"status"]isEqualToNumber:@1]) {
                    /* 成功*/
                    
                    if (dic[@"data"]!=nil) {
                        [[NSUserDefaults standardUserDefaults]setValue:dic[@"data"] forKey:@"ticket_token"];
                    }
                    
                    [self loadingHUDStopLoadingWithTitle:@"验证成功!"];
                    
                    [self performSelector:@selector(nextPage) withObject:nil afterDelay:1];
                    
                }else{
                    [self loadingHUDStopLoadingWithTitle:@"登录密码或校验码错误!"];
                    
                }
                
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
            
            
        }
        
        
        
        
    }
    
    
}
/* 进入下一页 设置密码*/
- (void)nextPage{
    
    SetPayPasswordViewController *controller =[[SetPayPasswordViewController alloc]initWithPageType:SetNewPassword];
    [self.navigationController pushViewController:controller animated:YES];
    
}

-(BOOL)checkPassWord:(NSString *)password{
    
    //6-16位数字和字母组成
    //    ^[A-Za-z0-9]{6,16}$
    NSString *regex = @"^[A-Za-z0-9]{6,16}";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:password]) {
        return YES ;
    }else
        return NO;
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
