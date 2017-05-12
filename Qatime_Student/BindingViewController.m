//
//  BindingViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/2.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "BindingViewController.h"
#import "NavigationBar.h"

#import "UIViewController+HUD.h"
#import "UIViewController+HUD.h"
#import "GradeList.h"
#import "MMPickerView.h"
#import "UIAlertController+Blocks.h"
#import "UIViewController+HUD.h"
#import "LCActionSheet.h"
#import "SignUpInfoViewController.h"
#import "ProvinceChosenViewController.h"


@interface BindingViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextInputDelegate>{
    
    NavigationBar *_navigationBar;
    
    NSString *_openID;
    
    NSString *accept;
    
    /* 保存年级信息*/
    GradeList *gradeList;
    
    NSString *_provinceID;
    NSString *_cityID;
    
}

@end

@implementation BindingViewController

- (instancetype)initWithOpenID:(NSString *)openID{
    self = [super init];
    if (self) {
        
        _openID = [NSString stringWithFormat:@"%@",openID];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_navigationBar];
    [_navigationBar.titleLabel setText:@"绑定"];
    
    _bindingView = [[BindingView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64)];
    
    [self.view addSubview:_bindingView];
    
    [_bindingView.getCheckCodeButton addTarget:self action:@selector(getCheckCode:) forControlEvents:UIControlEventTouchUpInside];
    
    [_bindingView.nextStepButton addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(readGradeOver) name:@"LoadGradeOver" object:nil];
    
    //修改地址
    [[NSNotificationCenter defaultCenter]addObserverForName:@"ChangeLocation" object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
       
        NSDictionary *dic = [note object];
        
        NSArray *province = [[NSUserDefaults standardUserDefaults]valueForKey:@"province"];
        
        for (NSDictionary *pro in province) {
            if ([dic[@"province"] isEqualToString:pro[@"name"]]) {
                _provinceID = [NSString stringWithFormat:@"%@",pro[@"id"]];
            }
        }
        NSArray *city = [[NSUserDefaults standardUserDefaults]valueForKey:@"city"];
        for (NSDictionary *citydic in city) {
            if ([dic[@"city"]isEqualToString:citydic[@"name"]]) {
                _cityID = [NSString stringWithFormat:@"%@",citydic[@"id"]];
            }
        }
        [_bindingView.chooseCitys setTitle:[NSString stringWithFormat:@"%@  %@",dic[@"province"],dic[@"city"]] forState:UIControlStateNormal];
        [_bindingView.chooseCitys setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }];
    
    
    /* 加载年级信息*/
    gradeList = [[GradeList alloc]init];
    
    
    // 选项
    
    [_bindingView.chosenButton addTarget:self action:@selector(chosenProtocol:) forControlEvents:UIControlEventTouchUpInside];
    
    [_bindingView.chooseGrade addTarget:self action:@selector(chooseGrade:) forControlEvents:UIControlEventTouchUpInside];
    
    [_bindingView.chooseCitys addTarget:self action:@selector(chooseCitys:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    
    [self HUDStartWithTitle:@"正在获取年级信息"];
    
}

- (void)readGradeOver{
    
    [self HUDStopWithTitle:nil];
    
}

/* 输入框字符发生改变*/

-(void)textDidChange:(id<UITextInput>)textInput{
    
    if ([self isMobileNumber:_bindingView.phoneNumber.text]) {
        if ([_bindingView.getCheckCodeButton.titleLabel.text isEqualToString:@"获取校验码"]) {
            _bindingView.getCheckCodeButton.enabled = YES;
            [_bindingView.getCheckCodeButton setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
            [_bindingView.getCheckCodeButton setBackgroundColor:[UIColor whiteColor]];
            _bindingView.getCheckCodeButton.layer.borderColor = NAVIGATIONRED.CGColor;
            
            [_bindingView.getCheckCodeButton addTarget:self action:@selector(getCheckCode:) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            
        }
        
    }else{
        
        _bindingView.getCheckCodeButton.enabled = NO;
        [_bindingView.getCheckCodeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_bindingView.getCheckCodeButton removeTarget:self action:@selector(getCheckCode:) forControlEvents:UIControlEventTouchUpInside];
        
        [_bindingView.getCheckCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bindingView.getCheckCodeButton setBackgroundColor:[UIColor lightGrayColor]];
        _bindingView.getCheckCodeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    if (_bindingView.phoneNumber.text.length > 11) {
        _bindingView.phoneNumber.text = [_bindingView.phoneNumber.text substringToIndex:11];
        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"请输入11位手机号" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {}];
    }
    
    if (_bindingView.phoneNumber.text.length>0&&_bindingView.checkCode.text.length>0&&_bindingView.userPassword.text.length>0&&_bindingView.userPasswordCompare.text.length>0&&_bindingView.chosenButton.selected==YES) {
        
        _bindingView.nextStepButton.enabled = YES;
        [_bindingView.nextStepButton setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
        [_bindingView.nextStepButton setBackgroundColor: [UIColor whiteColor]];
        _bindingView.nextStepButton.layer.borderColor = NAVIGATIONRED.CGColor;
        
    }else{
        _bindingView.nextStepButton.enabled = NO;
        
        [_bindingView.nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bindingView.nextStepButton setBackgroundColor: [UIColor lightGrayColor]];
        _bindingView.nextStepButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
    }

}


/* 选择协议*/
- (void)chosenProtocol:(UIButton *)sender{
    
    if (sender.selected ==NO) {
        
        if (_bindingView.phoneNumber.text.length>0&&_bindingView.checkCode.text.length>0&&_bindingView.userPassword.text.length>0&&_bindingView.userPasswordCompare.text.length>0) {
            _bindingView.nextStepButton.enabled = YES;
            sender.backgroundColor = [UIColor colorWithRed:0.84 green:0.33 blue:0.6 alpha:1.00];
            [sender setImage:[UIImage imageNamed:@"right_button"] forState:UIControlStateNormal];
            
            sender.selected = YES;
            
            [_bindingView.nextStepButton setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
            [_bindingView.nextStepButton setBackgroundColor: [UIColor whiteColor]];
            _bindingView.nextStepButton.layer.borderColor = NAVIGATIONRED.CGColor;
            
            
        }else{
            
            sender.backgroundColor = [UIColor colorWithRed:0.84 green:0.33 blue:0.6 alpha:1.00];
            [sender setImage:[UIImage imageNamed:@"right_button"] forState:UIControlStateNormal];
            
            [_bindingView.nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_bindingView.nextStepButton setBackgroundColor: [UIColor lightGrayColor]];
            _bindingView.nextStepButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
            
            sender.selected = YES;
            
        }
        
        
    }else{
        
        if (_bindingView.phoneNumber.text.length>0&&_bindingView.checkCode.text.length>0&&_bindingView.userPassword.text.length>0&&_bindingView.userPasswordCompare.text.length>0) {
            
            _bindingView.nextStepButton.enabled = NO;
            [_bindingView.nextStepButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
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
    
    //    /* 进入下一页*/
//      SignUpInfoViewController * _signUpInfoViewController = [[SignUpInfoViewController alloc]init];
//    
//        [self.navigationController pushViewController:_signUpInfoViewController animated:YES];
    //
    ////////////////////////////////////////////
    
    
    /* 有信息填写不正确*/
    if ([_bindingView.phoneNumber.text isEqualToString:@""]) {
        
        [self showAlertWith:@"请输入手机号！"];
    }
    if (![self isMobileNumber:_bindingView.phoneNumber.text]) {
        
        [self showAlertWith:@"请输入正确的手机号！"];
        
    }
    if ([_bindingView.userPassword.text isEqualToString:@""]||![self checkPassWord: _bindingView.userPassword.text] ) {
        
        [self showAlertWith:@"请输入6-16位字母数字密码组合！"];
        
    }
    if ([self checkPassWord: _bindingView.userPassword.text]&&![_bindingView.userPassword.text isEqualToString:_bindingView.userPasswordCompare.text]) {
        
        [self showAlertWith:@"前后密码不一致"];
        
    }
    if ([_bindingView.chooseGrade.titleLabel.text isEqualToString:@"请选择年级"]) {
        
        [self showAlertWith:@"请选择年级"];
    }
    
    /* 所有信息都填写正确的情况*/
    if (!([_bindingView.phoneNumber.text isEqualToString:@""]&&[_bindingView.userPassword.text isEqualToString:@""]&&[_bindingView.userPasswordCompare.text isEqualToString:@""]&&[_bindingView.checkCode.text isEqualToString:@""]/*&&[_signUpView.unlockKey.text isEqualToString:@""] 注册码功能暂时去掉*/)&&[_bindingView.userPasswordCompare.text isEqualToString:_bindingView.userPassword.text]) {
        
        if (!_bindingView.chosenButton.isSelected) {
            
            [self showAlertWith:@"请遵守《答疑时间用户协议》"];
            
        }else{
            
            /* 所有信息汇总成字典*/
            
            NSDictionary *signUpInfo =@{
                                        @"login_mobile":_bindingView.phoneNumber.text,
                                        @"captcha_confirmation":_bindingView.checkCode.text,
                                        @"password":_bindingView.userPassword.text,
                                        @"password_confirmation":_bindingView.userPasswordCompare.text,
                                        @"accept":_bindingView.chosenButton.isSelected==YES?@"1":@"2",
                                        @"register_code_value":@"code",
                                        @"type":@"Student",
                                        @"client_type":@"app",
                                        @"grade":_bindingView.chooseGrade.titleLabel.text,
                                        @"openid":_openID,
                                        @"province_id":_provinceID,
                                        @"city_id":_cityID
                                        };
            
            [self HUDStartWithTitle:@"绑定中"];
            
            /* 验证码 请求状态*/
            AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer =[AFHTTPResponseSerializer serializer];
            [manager POST:[NSString stringWithFormat:@"%@/api/v1/user/wechat_register",Request_Header] parameters:signUpInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                //                NSDictionary *dataDic=[NSDictionary dictionaryWithDictionary: codeState[@"data"]];
                
#pragma mark-注册信息校验正确
                
                /* 注册信息校验正确*/
                
                if ([dataDic[@"status"]isEqualToNumber:@1]) {
                    
                    if ([[dataDic allKeys]containsObject:@"remember_token"]){
                        
                        /* 发送成功提示框*/
                        
                        [self HUDStopWithTitle:@"绑定成功!"];
#pragma mark- 把token和id(key : data)存储到本地沙盒路径
                        
                        NSString *tokenFilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"User.data"];
                        [NSKeyedArchiver archiveRootObject:dataDic toFile:tokenFilePath];
                        
                        NSLog(@"保存的数据\n%@",dataDic);
                        
                        /* 归档*/
                        [NSKeyedArchiver archiveRootObject:dataDic toFile:tokenFilePath];
                        
                        
                        /* 另存一份userdefault  只存token和id*/
                        NSString *remember_token = [NSString stringWithFormat:@"%@",dataDic[@"remember_token"]];
                        
                        NSDictionary *user=[NSDictionary dictionaryWithDictionary:dataDic[@"user"]];
                        NSLog(@"%@",user);
                        
                        
                        NSString *userID = [NSString stringWithFormat:@"%@",[[dataDic valueForKey:@"user"] valueForKey:@"id"]];
                        
                        [[NSUserDefaults standardUserDefaults]setObject:remember_token forKey:@"remember_token"];
                        [[NSUserDefaults standardUserDefaults]setObject:userID forKey:@"id"];
                        
                        /* 另存一个userdefault ，只存user的头像地址*/
                        [[NSUserDefaults standardUserDefaults]setObject:dataDic[@"user"][@"avatar_url"] forKey:@"avatar_url"];
                        
                        /* 另存一个useerdefault 存user的name*/
                        [[NSUserDefaults standardUserDefaults]setObject:dataDic[@"user"][@"name"] forKey:@"name"];
                        
                        /* 发出一条消息:账号密码方式登录*/
                        
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"Login_Type" object:@"wechat"];
                        
                        /* 绑定完成后,直接登录到主页*/
                        [self performSelector:@selector(login) withObject:nil afterDelay:1.0];
                        
                        
                    }
                    else if (![[dataDic allKeys]containsObject:@"remember_token"]){
                        
                        [self HUDStopWithTitle:nil];
                        
                        [self showAlertWith:@"验证失败！请仔细填写信息!"];
                        
                    }
                }else{
                    
                    if (dataDic) {
                        
                        if ([[[dataDic valueForKey:@"error"]valueForKey:@"code"] isEqualToNumber:@3002]) {
                            [self HUDStopWithTitle:nil];
                            [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"该手机已注册,请登录后进入个人中心>安全设置进行绑定。" cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@[@"新号码注册",@"登录"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                
                                if (buttonIndex ==2 ) {
                                    _bindingView.phoneNumber.text = @"";
                                    _bindingView.checkCode.text = @"";
                                    _bindingView.userPassword.text = @"";
                                    _bindingView.userPasswordCompare.text = @"";
//                                    _bindingView.unlockKey.text = @"";
                                    
                                    [_bindingView.phoneNumber becomeFirstResponder];
                                    
                                }
                                if (buttonIndex ==3) {
                                    [[NSNotificationCenter defaultCenter]postNotificationName:@"userLogOut" object:nil];
                                }
                                
                            }];
                        }
                    }
                }
            }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
    }
}


/* 绑定完成后登录*/
- (void)login{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"userLogOut" object:nil];
    
    
}



/*点击按钮  获取验证码*/

- (void)getCheckCode:(UIButton *)sender{
    
    /* 手机号码正确的情况
     正则表达式 判断手机号的正确或错误
     */
    if ([self isMobileNumber:_bindingView.phoneNumber.text]){
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        
        [manager POST:[NSString stringWithFormat:@"%@/api/v1/captcha",Request_Header ] parameters:@{@"send_to":_bindingView.phoneNumber.text,@"key":@"register_captcha"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            /* 发送成功提示框*/
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            [hud setLabelText:@"发送成功！"];
            hud.yOffset= 150.f;
            hud.removeFromSuperViewOnHide = YES;
            
            /* 重新发送验证码*/
            [self deadLineTimer:_bindingView.getCheckCodeButton];
            
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


#pragma mark- 选择年级列表
- (void)chooseGrade:(UIButton *)sender{
    
    [_bindingView.phoneNumber resignFirstResponder];
    [_bindingView.checkCode resignFirstResponder];
    [_bindingView.userPassword resignFirstResponder];
    [_bindingView.userPasswordCompare resignFirstResponder];
    
    [MMPickerView showPickerViewInView:self.view withStrings:gradeList.grade withOptions:@{NSFontAttributeName:[UIFont systemFontOfSize:15*ScrenScale]} completion:^(NSString *selectedString) {
        
        [sender setTitle:selectedString forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } ];
}

#pragma mark- 选择地区
- (void)chooseCitys:(UIButton *)sender{
    
    ProvinceChosenViewController *controller = [[ProvinceChosenViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}



/* 返回上一页面*/

- (void)backToFrontPage:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_bindingView.checkCode resignFirstResponder];
    [ _bindingView.userPassword resignFirstResponder];
    [_bindingView.userPasswordCompare resignFirstResponder];
    [_bindingView.phoneNumber resignFirstResponder];
    
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
