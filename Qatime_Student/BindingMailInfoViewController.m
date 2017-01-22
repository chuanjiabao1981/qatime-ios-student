//
//  BindingMailInfoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/14.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "BindingMailInfoViewController.h"
#import "NavigationBar.h"
#import "UIViewController+HUD.h"

#import "SafeViewController.h"

@interface BindingMailInfoViewController ()<UITextFieldDelegate>{
    
    NavigationBar *_navigationBar;
    
    NSString *_token;
    NSString *_idNumber;
    
    
}

@end

@implementation BindingMailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _navigationBar = ({
        NavigationBar *_=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
        _.titleLabel.text = @"绑定邮箱";
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_];
        _;
    });
    
    _bindingMailInfoView = ({
        BindingMailInfoView *_=[[BindingMailInfoView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64)];
        [_.getKeyCodeButton addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
        [_.nextStepButton addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
        _.mailText.delegate = self;
        
        [_.mailText becomeFirstResponder];
        
        [self.view addSubview:_];
        _;
    
    });
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }

    [_bindingMailInfoView.mailText addTarget:self action:@selector(checkMail:) forControlEvents:UIControlEventEditingChanged];
    
    
}

/* 检查邮箱是否规范*/
- (void)checkMail:(UITextField *)sender{
    
    if ([self isValidateEmail:sender.text]) {
        
        
    }
}


#pragma mark- finish按钮发送修改请求的点击事件
- (void)finish{
    
    if ([_bindingMailInfoView.keyCodeText.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确的验证码!" preferredStyle:UIAlertControllerStyleAlert];
      
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }] ;
        
        [alert addAction:sure];
        [self presentViewController:alert animated:YES completion:nil];

    }else{
        
        [self loadingHUDStartLoadingWithTitle:@"正在申请"];
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
        [manager PUT:[NSString stringWithFormat:@"%@/api/v1/users/%@/email",Request_Header,_idNumber] parameters:@{@"email":_bindingMailInfoView.mailText.text,@"captcha_confirmation":_bindingMailInfoView.keyCodeText.text} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
                /* 绑定成功*/
                [self loadingHUDStopLoadingWithTitle:@"绑定成功!"];
                
                [self performSelector:@selector(returnFrontPage) withObject:nil afterDelay:1];
                
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        
        
        
    }
    
}







#pragma mark- 获取验证码的按钮点击事件
- (void)getCode:(UIButton *)sender{
    
    
    if ([_bindingMailInfoView.mailText.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入邮箱!" preferredStyle:UIAlertControllerStyleAlert];
       
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }] ;
        
        [alert addAction:sure];
        
        [self presentViewController:alert animated:YES completion:nil];

    }
    
    if (![self isValidateEmail:_bindingMailInfoView.mailText.text]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确的邮箱格式!" preferredStyle:UIAlertControllerStyleAlert];
       
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }] ;
        
        [alert addAction:sure];
        
        [self presentViewController:alert animated:YES completion:nil];

    }
    if (![_bindingMailInfoView.mailText.text isEqualToString:@""]&&[self isValidateEmail:_bindingMailInfoView.mailText.text]) {
        
        if (sender.enabled ==YES) {
            
            AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer =[AFHTTPResponseSerializer serializer];
            [manager POST:[NSString stringWithFormat:@"%@/api/v1/captcha",Request_Header] parameters:@{@"send_to":_bindingMailInfoView.mailText.text,@"key":@"change_email_captcha"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
                    
                    [self loadingHUDStopLoadingWithTitle:@"发送申请成功!\n请查阅邮箱!"];
                    
                }else{
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"信息错误!" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }] ;
                    [alert addAction:sure];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }
                
                [self deadLineTimer:sender];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
            
        }
    }
    
}


/* 正则判断邮箱格式*/

-(BOOL)isValidateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
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

- (void)returnFrontPage{
    
    UIViewController  *controller = nil;
    for (UIViewController *choseVC in self.navigationController.viewControllers) {
        
        if ([choseVC isMemberOfClass:[SafeViewController class]]) {
            
            controller = choseVC;
        }
    }
    [self.navigationController popToViewController:controller animated:YES];
    
    
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    [_bindingMailInfoView.mailText resignFirstResponder];
    [_bindingMailInfoView.keyCodeText resignFirstResponder];
    
    
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
