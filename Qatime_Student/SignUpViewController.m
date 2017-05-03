//
//  SignUpViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "SignUpViewController.h"
#import "SignUpView.h"

#import "SignUpInfoViewController.h"
#import "UIAlertController+Blocks.h"
#import "UIViewController+HUD.h"
#import "UIAlertController+Blocks.h"

@interface SignUpViewController ()<UITextFieldDelegate,UITextInputDelegate>{
    
    /* 注册详细信息的controller*/
    SignUpInfoViewController *_signUpInfoViewController ;
    
}

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    [self.view addSubview:_navigationBar];
    [_navigationBar.titleLabel setText:NSLocalizedString(@"注册", nil)];
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(backToFrontPage:) forControlEvents:UIControlEventTouchUpInside];
    
    /* 视图*/
    _signUpView = [[SignUpView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64)];
    [self .view addSubview:_signUpView];
    
    _signUpView.phoneNumber.delegate = self;
    [_signUpView.nextStepButton addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    
    //选项
    [_signUpView.chosenButton addTarget:self action:@selector(chosenProtocol:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    
}


/* 选择协议*/
- (void)chosenProtocol:(UIButton *)sender{
    
    if (sender.selected ==NO) {
        
        if (_signUpView.phoneNumber.text.length>0&&_signUpView.checkCode.text.length>0&&_signUpView.userPassword.text.length>0&&_signUpView.userPasswordCompare.text.length>0) {
            
            _signUpView.nextStepButton.enabled = YES;
            
            sender.backgroundColor = [UIColor colorWithRed:0.84 green:0.33 blue:0.6 alpha:1.00];
            [sender setImage:[UIImage imageNamed:@"right_button"] forState:UIControlStateNormal];
            
            sender.selected = YES;
            
            [_signUpView.nextStepButton setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
            [_signUpView.nextStepButton setBackgroundColor: [UIColor whiteColor]];
            _signUpView.nextStepButton.layer.borderColor = NAVIGATIONRED.CGColor;
            
            
        }else{
            
            sender.backgroundColor = [UIColor colorWithRed:0.84 green:0.33 blue:0.6 alpha:1.00];
            [sender setImage:[UIImage imageNamed:@"right_button"] forState:UIControlStateNormal];
            
            [_signUpView.nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_signUpView.nextStepButton setBackgroundColor: [UIColor lightGrayColor]];
            _signUpView.nextStepButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
            
            sender.selected = YES;
            
        }
        
        
    }else{
        
        if (_signUpView.phoneNumber.text.length>0&&_signUpView.checkCode.text.length>0&&_signUpView.userPassword.text.length>0&&_signUpView.userPasswordCompare.text.length>0) {
            
            _signUpView.nextStepButton.enabled = NO;
            [_signUpView.nextStepButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            sender.layer.borderColor =[UIColor blackColor].CGColor;
            sender.layer.borderWidth=1.0f;
            [sender setImage:nil forState:UIControlStateNormal];
            sender.backgroundColor = [UIColor clearColor];
            
            sender.selected= NO;
        }else{
            
            sender.layer.borderColor =[UIColor blackColor].CGColor;
            sender.layer.borderWidth=1.0f;
            [sender setImage:nil forState:UIControlStateNormal];
            sender.backgroundColor = [UIColor clearColor];
            
            sender.selected= NO;
            
        }
        
        
    }
    
    
}



/* 点击下一步按钮*/
- (void)nextStep:(UIButton *)sender{
    
    /* 测试口  直接跳转*/
    
    /* 进入下一页*/
    //        _signUpInfoViewController = [[SignUpInfoViewController alloc]init];
    //
    //        [self.navigationController pushViewController:_signUpInfoViewController animated:YES];
    
    ////////////////////////////////////////////
    
    
    /* 有信息填写不正确*/
    if ([_signUpView.phoneNumber.text isEqualToString:@""]) {
        
        [self showAlertWith:NSLocalizedString(@"请输入手机号!", nil)];
    }else{
        
        if (![self isMobileNumber:_signUpView.phoneNumber.text]) {
            
            [self showAlertWith:NSLocalizedString(@"请输入正确的手机号!", nil)];
            
        }else{
            
            if ([_signUpView.userPassword.text isEqualToString:@""]||![self checkPassWord: _signUpView.userPassword.text] ) {
                
                [self showAlertWith:NSLocalizedString(@"请输入6-16位数字字母组合密码!", nil)];
                
            }else{
                
                if ([self checkPassWord: _signUpView.userPassword.text]&&![_signUpView.userPassword.text isEqualToString:_signUpView.userPasswordCompare.text]) {
                    
                    [self showAlertWith:NSLocalizedString(@"前后密码不一致", nil)];
                    
                }else{
                    /* 所有信息都填写正确的情况*/
                    if (!([_signUpView.phoneNumber.text isEqualToString:@""]&&[_signUpView.userPassword.text isEqualToString:@""]&&[_signUpView.userPasswordCompare.text isEqualToString:@""]&&[_signUpView.checkCode.text isEqualToString:@""]/*&&[_signUpView.unlockKey.text isEqualToString:@""] 注册码功能暂时去掉*/)&&[_signUpView.userPasswordCompare.text isEqualToString:_signUpView.userPassword.text]) {
                        
                        if (!_signUpView.chosenButton.isSelected) {
                            
                            [self showAlertWith:NSLocalizedString(@"请遵守《答疑时间用户协议》", nil)];
                            
                        }else{
                            
                            /* 所有信息汇总成字典*/
                            
                            NSDictionary *signUpInfo =@{
                                                        @"login_mobile":_signUpView.phoneNumber.text,
                                                        @"captcha_confirmation":_signUpView.checkCode.text,
                                                        @"password":_signUpView.userPassword.text,
                                                        @"password_confirmation":_signUpView.userPasswordCompare.text,
                                                        @"register_code_value":@"code",
                                                        @"accept":@"1",
                                                        @"type":@"Student",
                                                        @"client_type":@"app"
                                                        };
                            
                            NSLog(@"%@", signUpInfo);
                            
                            /* 验证码 请求状态*/
                            AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
                            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                            manager.responseSerializer =[AFHTTPResponseSerializer serializer];
                            [manager POST:[NSString stringWithFormat:@"%@/api/v1/user/register",Request_Header] parameters:signUpInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                
                                NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                                NSLog(@"%@",dataDic);
                                
                                //                NSDictionary *dataDic=[NSDictionary dictionaryWithDictionary: codeState[@"data"]];
                                
#pragma mark-注册信息校验正确
                                
                                /* 注册信息校验正确*/
                                
                                if ([dataDic[@"status"]isEqualToNumber:@1]) {
                                    
                                    if (dataDic[@"data"][@"remember_token"]){
                                        
                                        /* 发送成功提示框*/
                                        [self loadingHUDStopLoadingWithTitle:NSLocalizedString(@"注册成功!", nil)];
                                        
#pragma mark- 把token和id(key : data)存储到本地沙盒路径
                                        
                                        //                        NSString *tokenFilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"token.data"];
                                        //                        [NSKeyedArchiver archiveRootObject:dataDic[@"data"] toFile:tokenFilePath];
                                        
                                        
                                        /* id和token暂时不存本地*/
                                        
                                        
                                        [self performSelector:@selector(nextPage) withObject:nil afterDelay:1];
                                        
                                    }
                                    else {
                                        
                                        [self showAlertWith:NSLocalizedString(@"验证失败,请重试!", nil)];
                                        
                                    }
                                }
                                else {
                                    
                                    if (dataDic) {
                                        
                                        if ([[[dataDic valueForKey:@"error"]valueForKey:@"code"] isEqualToNumber:@3002]) {
                                            
                                            [UIAlertController showAlertInViewController:self withTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"该手机已注册,请直接登录", nil) cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@[NSLocalizedString(@"新号码注册", nil),NSLocalizedString(@"登录", nil)] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                                
                                                if (buttonIndex ==2 ) {
                                                    _signUpView.phoneNumber.text = @"";
                                                    _signUpView.checkCode.text = @"";
                                                    _signUpView.userPassword.text = @"";
                                                    _signUpView.userPasswordCompare.text = @"";
                                                    //                                                    _signUpView.unlockKey.text = @"";
                                                    
                                                    [_signUpView.phoneNumber becomeFirstResponder];
                                                    
                                                }
                                                if (buttonIndex ==3) {
                                                    [[NSNotificationCenter defaultCenter]postNotificationName:@"userLogOut" object:nil];
                                                }
                                                
                                            }];
                                            
                                        }
                                    } else{
                                        
                                        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:NSLocalizedString(@"验证错误,请重试", nil) cancelButtonTitle:NSLocalizedString(@"确定", nil) destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                            
                                        }];
                                        
                                    }
                                    
                                }
                                
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                
                            }];
                        }
                        
                    }
                    
                }
            }
        }
    }
}

/* 进入下一页*/
- (void)nextPage{
    /* 进入下一页*/
    _signUpInfoViewController = [[SignUpInfoViewController alloc]initWithAccount:_signUpView.phoneNumber.text andPassword:_signUpView.userPassword.text];
    
    [self.navigationController pushViewController:_signUpInfoViewController animated:YES];
    
}



/* 输入框字符发生改变*/

-(void)textDidChange:(id<UITextInput>)textInput{
    
    /* 手机号框*/
    
    if ([self isMobileNumber:_signUpView.phoneNumber.text]) {
        
        if ([_signUpView.getCheckCodeButton.titleLabel.text isEqualToString:@"获取校验码"]) {
            _signUpView.getCheckCodeButton.enabled = YES;
            [_signUpView.getCheckCodeButton setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
            [_signUpView.getCheckCodeButton setBackgroundColor:[UIColor whiteColor]];
            _signUpView.getCheckCodeButton.layer.borderColor = NAVIGATIONRED.CGColor;
            
            [_signUpView.getCheckCodeButton addTarget:self action:@selector(getCheckCode:) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            
        }
        
    }else{
        
        _signUpView.getCheckCodeButton.enabled = NO;
        [_signUpView.getCheckCodeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_signUpView.getCheckCodeButton removeTarget:self action:@selector(getCheckCode:) forControlEvents:UIControlEventTouchUpInside];
        
        [_signUpView.getCheckCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_signUpView.getCheckCodeButton setBackgroundColor:[UIColor lightGrayColor]];
        _signUpView.getCheckCodeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    if (_signUpView.phoneNumber.text.length > 11) {
        _signUpView.phoneNumber.text = [_signUpView.phoneNumber.text substringToIndex:11];
        [UIAlertController showAlertInViewController:self withTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入11位手机号", nil) cancelButtonTitle:NSLocalizedString(@"确定", nil) destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {}];
    }
    
    
    if (_signUpView.phoneNumber.text.length>0&&_signUpView.checkCode.text.length>0&&_signUpView.userPassword.text.length>0&&_signUpView.userPasswordCompare.text.length>0&&_signUpView.chosenButton.selected==YES) {
        
        _signUpView.nextStepButton.enabled = YES;
        [_signUpView.nextStepButton setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
        [_signUpView.nextStepButton setBackgroundColor: [UIColor whiteColor]];
        _signUpView.nextStepButton.layer.borderColor = NAVIGATIONRED.CGColor;
        
    }else{
        _signUpView.nextStepButton.enabled = NO;
        
        [_signUpView.nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_signUpView.nextStepButton setBackgroundColor: [UIColor lightGrayColor]];
        _signUpView.nextStepButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
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
        
        [manager POST:[NSString stringWithFormat:@"%@/api/v1/captcha",Request_Header] parameters:@{@"send_to":_signUpView.phoneNumber.text,@"key":@"register_captcha"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            /* 发送成功提示框*/
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            [hud setLabelText:NSLocalizedString(@"发送成功!", nil)];
            hud.yOffset= 150.f;
            hud.removeFromSuperViewOnHide = YES;
            
            
            /* 重新发送验证码*/
            [self deadLineTimer:_signUpView.getCheckCodeButton];
            
            [hud hide:YES afterDelay:2.0];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    
    /* 手机号输入为空或错误的情况*/
    else  {
        
        [self showAlertWith:NSLocalizedString(@"请输入正确的手机号!", nil)];
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
    //    ^[A-Za-z0-9]{6,16}$
    NSString *regex = @"^[A-Za-z0-9\\~\\!\\/\\@\\#\\$\\%\\^\\&\\*\\(\\)\\-\\_\\=\\+\\\\\\|\\[\\{\\}\\]\\;\\:\\\'\\\"\\,\\<\\.\\>\\/\\?]{6,16}$";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:password]) {
        return YES ;
    }else
        return NO;
}

/* 弹出alter封装*/
- (void)showAlertWith:(NSString *)message{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(message, nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action=[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_signUpView.phoneNumber resignFirstResponder];
    [_signUpView.checkCode resignFirstResponder];
    [_signUpView.userPassword resignFirstResponder];
    [_signUpView.userPasswordCompare resignFirstResponder];
    //    [_signUpView.unlockKey resignFirstResponder];
    
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
