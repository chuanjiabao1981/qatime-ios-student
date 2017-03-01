//
//  ChangePhoneGetCodeViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/5.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ChangePhoneGetCodeViewController.h"
#import "NavigationBar.h"
 

#import "UIViewController+HUD.h"
#import "UIViewController_HUD.h"

#import "ChangePhoneViewController.h"

@interface ChangePhoneGetCodeViewController (){
    
    NavigationBar *_navigationBar;
    
    /* 保存电话号*/
    
    NSString *phoneNumber;
}


@end

@implementation ChangePhoneGetCodeViewController


- (instancetype)initWithPhone:(NSString *)phone
{
    self = [super init];
    if (self) {
        
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    [self.view addSubview:_navigationBar];
    _navigationBar.titleLabel.text = @"绑定新手机";
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    _getCodeView = [[ChangePhoneGetCodeView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64)];
    [self.view addSubview:_getCodeView];
    
    [_getCodeView.getCodeButton addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    
    phoneNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"login_mobile"]];
    
    _getCodeView.phoneLabel .text = phoneNumber;
    
    [_getCodeView.nextButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
}



#pragma mark- 下一步
- (void)nextStep{
    
    if ([_getCodeView.codeText.text isEqualToString:@""]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入收到的验证码    " preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }] ;
        [alert addAction:sure];
        
        [self presentViewController:alert animated:YES completion:nil];

    }else{
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager POST:[NSString stringWithFormat:@"%@/api/v1/captcha/verify",Request_Header] parameters:@{@"send_to":phoneNumber,@"captcha":_getCodeView.codeText.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            [self loginStates:dic];
            if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
                
                if ([dic[@"data"]isEqual:[NSNull null]]) {
                    /* 验证码正确*/
                    [self loadingHUDStopLoadingWithTitle:@"验证码正确!"];
                    ChangePhoneViewController *vc = [ChangePhoneViewController new];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"验证码错误!" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }] ;
                    [alert addAction:sure];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }else{
                
                [self loadingHUDStopLoadingWithTitle:@"数据请求错误!"];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
 
}


#pragma mark- 获取验证码的按钮点击事件
- (void)getCode:(UIButton *)sender{
    
    if (sender.enabled ==YES) {
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager POST:[NSString stringWithFormat:@"%@/api/v1/captcha",Request_Header] parameters:@{@"send_to":phoneNumber,@"key":@"send_captcha"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
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
