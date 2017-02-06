//
//  BindingMailViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/13.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "BindingMailViewController.h"
#import "NavigationBar.h"
#import "UIViewController+HUD.h"
#import "BindingMailInfoViewController.h"

@interface BindingMailViewController (){
    
    NavigationBar *_navigationBar;
    
    NSString *_phoneNumber;
    
    NSString *_token;
    NSString *_idNumber;
    
    
}

@end

@implementation BindingMailViewController

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
    
    
    _bindingMailView = ({
    
        BindingMailView *_=[[BindingMailView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64)];
        
        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"login_mobile"]) {
        
            
            _phoneNumber = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"login_mobile"]];
            
           
            _.phoneLabel.text =_phoneNumber;
            
            [_.getKeyCodeButton addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
            
            [_.nextStepButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [self loadingHUDStopLoadingWithTitle:@"数据错误,请重新登录"];
            
            [self performSelector:@selector(returnLastPage) withObject:nil afterDelay:1];
            
        }
        
        
        
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

    
    
    
}

#pragma mark- 下一步
- (void)nextStep{
    
    [self loadingHUDStartLoadingWithTitle:@"正在验证"];
    
    if (![_bindingMailView.keyCodeText.text isEqualToString:@""]) {
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
        [manager POST:[NSString stringWithFormat:@"%@/api/v1/captcha/verify",Request_Header] parameters:@{@"send_to":_phoneNumber,@"captcha":_bindingMailView.keyCodeText.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            [self loginStates:dic];
            
            if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
                /* 验证成功*/
                /* 跳转到下一页*/
                [self loadingHUDStopLoadingWithTitle:@"验证成功!"];
                
                [self performSelector:@selector(nextPage) withObject:nil afterDelay:1];
                
                
            }else{
                /* 验证失败*/
                [self loadingHUDStopLoadingWithTitle:@"验证错误,请重试!"];
                
            }
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        
        
        
    }
    
    
    
}

#pragma mark- 跳转至下一页
- (void)nextPage{
    
    BindingMailInfoViewController *bindingVC = [BindingMailInfoViewController new];
    [self.navigationController pushViewController:bindingVC animated:YES];
    
}




#pragma mark- 获取验证码的按钮点击事件
- (void)getCode:(UIButton *)sender{
    
    if (sender.enabled ==YES) {
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager POST:[NSString stringWithFormat:@"%@/api/v1/captcha",Request_Header] parameters:@{@"send_to":_phoneNumber,@"key":@"send_captcha"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            [self loginStates:dic];
            
            if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
                
                [self loadingHUDStopLoadingWithTitle:@"发送申请成功!"];
                
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
