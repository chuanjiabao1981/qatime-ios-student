//
//  FindPasswordViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/2.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "MBProgressHUD.h"
#import "UIAlertController+Blocks.h"
#import "UIViewController+HUD.h"

@interface FindPasswordViewController ()<UITextFieldDelegate,UITextInputDelegate>{
    
    
    BOOL findPassword;
    
    
    BOOL changePassword;
    
}

@end

@implementation FindPasswordViewController

-(instancetype)initWithFindPassword{
    
    self = [super init];
    if (self) {
       
        findPassword = YES;
        changePassword = YES;
        

    }
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    [self.view addSubview:_navigationBar];
    
    [_navigationBar.titleLabel setText:@"找回密码"];
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(backToFrontPage:) forControlEvents:UIControlEventTouchUpInside];
    
    _findPasswordView = [[FindPasswordView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64)];
    [self .view addSubview:_findPasswordView];
    
    [_findPasswordView.getCheckCodeButton addTarget:self action:@selector(getCheckCode:) forControlEvents:UIControlEventTouchUpInside];
    
    [_findPasswordView.nextStepButton addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    
    if (findPassword == YES) {
        _findPasswordView.phoneNumber.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"login_mobile"];
        
        _findPasswordView.getCheckCodeButton.enabled = YES;
        [_findPasswordView.getCheckCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    if (changePassword == YES) {
        _findPasswordView.phoneNumber.enabled = NO;
    }
    
}


/* 点击下一步按钮*/
- (void)nextStep:(UIButton *)sender{
    
    /* 测试口  直接跳转*/
    
    /* 进入下一页*/
    // _signUpInfoViewController = [[SignUpInfoViewController alloc]init];
    
    //[self.navigationController pushViewController:_signUpInfoViewController animated:YES];
    
    ////////////////////////////////////////////
    
    
    /* 有信息填写不正确*/
    if ([_findPasswordView.phoneNumber.text isEqualToString:@""]) {
        
        [self showAlertWith:@"请输入手机号！"];
    }
    if (![self isMobileNumber:_findPasswordView.phoneNumber.text]) {
        
        [self showAlertWith:@"请输入正确的手机号！"];
        
    }
    if ([self checkPassWord: _findPasswordView.userPassword.text]&&![_findPasswordView.userPassword.text isEqualToString:_findPasswordView.userPasswordCompare.text]) {
        
        [self showAlertWith:@"前后密码不一致"];
        
    }
    if ([_findPasswordView.userPassword.text isEqualToString:@""]||![self checkPassWord: _findPasswordView.userPassword.text] ) {
        
        [self showAlertWith:@"请输入6-16位密码！"];
        
    }else{
        
        /* 所有信息都填写正确的情况*/
        if (!([_findPasswordView.phoneNumber.text isEqualToString:@""]&&[_findPasswordView.userPassword.text isEqualToString:@""]&&[_findPasswordView.userPasswordCompare.text isEqualToString:@""]&&[_findPasswordView.checkCode.text isEqualToString:@""]&&[_findPasswordView.userPasswordCompare.text isEqualToString:_findPasswordView.userPassword.text])) {
            
            /* 所有信息汇总成字典*/
            
            NSDictionary *signUpInfo =@{
                                        @"login_account":_findPasswordView.phoneNumber.text,
                                        @"captcha_confirmation":_findPasswordView.checkCode.text,
                                        @"password":_findPasswordView.userPassword.text,
                                        @"password_confirmation":_findPasswordView.userPasswordCompare.text,
                                        };
            
            /* 验证码 请求状态*/
            AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer =[AFHTTPResponseSerializer serializer];
            
            [manager PUT:[NSString stringWithFormat:@"%@/api/v1/password",Request_Header] parameters:signUpInfo success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *codeState = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                NSLog(@"%@",codeState);
                
                NSString *status = [NSString stringWithFormat:@"%@",codeState[@"status"]];
                
#pragma mark-注册信息校验正确
                /* 注册信息校验正确*/
                
                if ([status isEqualToString:@"1"]){
                    
                    /* 发送成功提示框*/
                    [self loadingHUDStopLoadingWithTitle:@"密码修改成功!"];
                    [self performSelector:@selector(backToFrontPage:) withObject:nil afterDelay:1];
                    
                    
                    
                    
                }
                else if (![status isEqualToString:@"1"]){
                    
                    [self showAlertWith:@"验证失败！请输入正确的信息！"];
                    
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
            
            
            
        }
    }
    
    
    
}

/* 输入框字符发生改变*/

-(void)textDidChange:(id<UITextInput>)textInput{
    
    if (![_findPasswordView.phoneNumber.text isEqualToString:@""]) {
        _findPasswordView.getCheckCodeButton.enabled = YES;
        [_findPasswordView.getCheckCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_findPasswordView.getCheckCodeButton addTarget:self action:@selector(getCheckCode:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        _findPasswordView.getCheckCodeButton.enabled = NO;
        [_findPasswordView.getCheckCodeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_findPasswordView.getCheckCodeButton removeTarget:self action:@selector(getCheckCode:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    if (_findPasswordView.phoneNumber.text.length > 11) {
        _findPasswordView.phoneNumber.text = [_findPasswordView.phoneNumber.text substringToIndex:11];
        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"请输入11位手机号" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {}];
    }
    
    if (_findPasswordView.phoneNumber.text.length>0&&_findPasswordView.checkCode.text.length>0&&_findPasswordView.userPassword.text.length>0&&_findPasswordView.userPasswordCompare.text.length>0){
        _findPasswordView.nextStepButton.enabled = YES;
        [_findPasswordView.nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else{
        _findPasswordView.nextStepButton.enabled = NO;
        [_findPasswordView.nextStepButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
    }
    
    
    
}





/*点击按钮  获取验证码*/

- (void)getCheckCode:(UIButton *)sender{
    
    /* 手机号码正确的情况
     正则表达式 判断手机号的正确或错误
     */
    if ([self isMobileNumber:_findPasswordView.phoneNumber.text]){
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        
        [manager POST:[NSString stringWithFormat:@"%@/api/v1/captcha",Request_Header] parameters:@{@"send_to":_findPasswordView.phoneNumber.text,@"key":@"get_password_back"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            /* 发送成功提示框*/
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"发送成功！";
            hud.yOffset= 150.f;
            hud.removeFromSuperViewOnHide = YES;
            
            
            /* 重新发送验证码*/
            [self deadLineTimer:_findPasswordView.getCheckCodeButton];
            
            [hud hide:YES afterDelay:2.0];
            
            
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
    
    NSString *MOBILE = @"^1(1[0-9]|3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
}



#pragma 正则匹配用户密码 6 - 16 位数字和字母组合
-(BOOL)checkPassWord:(NSString *)password{
    //6-16位数字和字母组成
    NSString *regex = @"^[A-Za-z0-9]{6,16}$";
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
            [button setEnabled:NO];
            
            [button setBackgroundColor:[UIColor lightGrayColor]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            
            
            
            
        });
        deadline--;
        
        /* 倒计时结束 关闭线程*/
        if(deadline<=0){
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                [button setTitle:@"获取校验码" forState:UIControlStateNormal];
                [button setEnabled:YES];
                
                [button setBackgroundColor:[UIColor whiteColor]];
                [button setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
                button.layer.borderColor = NAVIGATIONRED.CGColor;
                
            });
        }
    });
    dispatch_resume(_timer);
    
    
    
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
