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
#import "UIViewController_HUD.h"

#import "GradeList.h"
@interface BindingViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    
    NavigationBar *_navigationBar;
    
    
    GradeList *gradelist;
    UIVisualEffectView *effectView;
    UIPickerView *pickerView;
    UIView *dock;
    UIBlurEffect *effect;
}

@end

@implementation BindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    [self.view addSubview:_navigationBar];
    [_navigationBar.titleLabel setText:@"绑定"];
   
    _bindingView = [[BindingView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64)];
    [self.view addSubview:_bindingView];
    
    
    [_bindingView.getCheckCodeButton addTarget:self action:@selector(getCheckCode:) forControlEvents:UIControlEventTouchUpInside];
    
    [_bindingView.nextStepButton addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(readGradeOver) name:@"LoadGradeOver" object:nil];
    
    
    /* 加载年级信息*/
    gradelist = [[GradeList alloc]init];
    
    //    选项
    
    [_bindingView.chosenButton addTarget:self action:@selector(chosenProtocol:) forControlEvents:UIControlEventTouchUpInside];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseGrade)];
    
    [_bindingView.gradeText addGestureRecognizer:tap];
    
    
    [self loadingHUDStartLoadingWithTitle:@"正在获取年级信息"];
    
}

- (void)readGradeOver{
    
    [self loadingHUDStopLoadingWithTitle:@"年级信息加载完毕!"];
    
}

/* 选择协议*/
- (void)chosenProtocol:(UIButton *)sender{
    
    if (sender.selected ==NO) {
        
        sender.layer.borderWidth = 0;
        sender.backgroundColor = [UIColor colorWithRed:0.84 green:0.33 blue:0.6 alpha:1.00];
        [sender setImage:[UIImage imageNamed:@"right_button"] forState:UIControlStateNormal];
        
        sender.selected = YES;
    }else{
        
        sender.layer.borderColor =[UIColor blackColor].CGColor;
        sender.layer.borderWidth=1.0f;
        [sender setImage:nil forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor clearColor];
        
        
        
        sender.selected= NO;
        
    }
    
    
}



/* 点击下一步按钮*/
- (void)nextStep:(UIButton *)sender{
    
    /* 测试口  直接跳转*/
    
//    /* 进入下一页*/
//    _signUpInfoViewController = [[SignUpInfoViewController alloc]init];
//    
//    [self.navigationController pushViewController:_signUpInfoViewController animated:YES];
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
        
        [self showAlertWith:@"请输入6-16位密码！"];
        
    }
    if ([self checkPassWord: _bindingView.userPassword.text]&&![_bindingView.userPassword.text isEqualToString:_bindingView.userPasswordCompare.text]) {
        
        [self showAlertWith:@"前后密码不一致"];
        
    }
    
    //    if (!([_signUpView.phoneNumber.text isEqualToString:@""]&&[_signUpView.userPassword.text isEqualToString:@""]&&[_signUpView.userPasswordCompare.text isEqualToString:@""]&&[_signUpView.checkCode.text isEqualToString:@""])&&[_signUpView.unlockKey.text isEqualToString:@""]) {
    //        [self showAlertWith:@"请输入注册号"];
    //
    //    }
    
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
                                        @"register_code_value":@"code",
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
                    
                    
                    [self loadingHUDStopLoadingWithTitle:@"验证成功!"];
                    
                    
                    
//                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                    hud.mode = MBProgressHUDModeText;
//                    hud.labelText = @"验证成功！";
//                    hud.yOffset= 150.f;
//                    hud.removeFromSuperViewOnHide = YES;
//                    
//                    [hud hide:YES afterDelay:1.0];
                    
                    
#pragma mark- 把token和id(key : data)存储到本地沙盒路径
                    
                    NSString *tokenFilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"token.data"];
                    [NSKeyedArchiver archiveRootObject:dataDic toFile:tokenFilePath];
                    
                    
                    
                    /* 进入下一页*/
//                    _signUpInfoViewController = [[SignUpInfoViewController alloc]init];
//                    
//                    [self.navigationController pushViewController:_signUpInfoViewController animated:YES];
                    
                    
                }
                else if (![[dataDic allKeys]containsObject:@"remember_token"]){
                    
                    [self showAlertWith:@"验证失败！"];
                    
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
        
        
    }
    
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
        
        [manager POST:@"http://testing.qatime.cn/api/v1/captcha" parameters:@{@"send_to":_bindingView.phoneNumber.text,@"key":@"register_captcha"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
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

#pragma mark- 倒计时方法封装
/* 倒计时方法封装*/
- (void)deadLineTimer:(UIButton *)button{
    
    
    /* 按钮倒计时*/
    __block int deadline=10;
    
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
            
            [button setEnabled:NO];
            
            
            
        });
        deadline--;
        
        /* 倒计时结束 关闭线程*/
        if(deadline<=0){
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                [button setTitle:@"获取校验码" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                [button setEnabled:YES];
                
                
            });
        }
    });
    dispatch_resume(_timer);
    
    
    
}


#pragma mark- 选择年级列表
- (void)chooseGrade{
    
    //     添加一个模糊背景
    effect=[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    effectView=[[UIVisualEffectView alloc]initWithEffect:effect];
    [effectView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    [self.view addSubview:effectView];
    
    
    
    pickerView=[[UIPickerView alloc]init];
    pickerView .dataSource = self;
    pickerView .delegate = self;
    pickerView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:pickerView];
    
    pickerView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightRatioToView(self.view,0.25).widthRatioToView(self.view,1.0f).bottomSpaceToView(self.view,0);
    
    /* pickerView的顶视图 确定和取消两个选项。*/
    dock=[[UIView alloc]init];
    [self.view addSubview:dock];
    dock.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(pickerView,0).heightRatioToView(pickerView,0.25f);
    dock.backgroundColor = USERGREEN;
    
    
    /* 确定按钮*/
    UIButton *sureButton=[[UIButton alloc]init];
    [dock addSubview:sureButton];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.sd_layout.heightRatioToView(dock,0.8).centerYEqualToView(dock).widthIs(60).rightSpaceToView(dock,0);
    [sureButton addTarget:self action:@selector(sureChoseGrade) forControlEvents:UIControlEventTouchUpInside];
    
    
}

/* pickerView的代理方法*/
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 30;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return gradelist.grade.count;
    
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    
    
    return gradelist.grade[row];
    
    
    
}


/* 选择的*/
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    [_bindingView.gradeText setText:gradelist.grade[row] ];
    
    
    
}


/* 确定选择*/
- (void)sureChoseGrade{
    
    [pickerView removeFromSuperview];
    [dock removeFromSuperview ];
    [effectView removeFromSuperview];
    
    
    
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
