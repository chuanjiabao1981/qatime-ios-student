//
//  WithDrawInfoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/11.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "WithDrawInfoViewController.h"
#import "NavigationBar.h"

#import "UIViewController+HUD.h"

#import "LoginAgainViewController.h"
#import "WithdrawConfirmViewController.h"
#import "MyWalletViewController.h"
#import "WithdrawConfirmViewController.h"
#import "DCPaymentView.h"


@interface WithDrawInfoViewController (){
    
    
    /* 导航栏*/
    NavigationBar *_navigationBar;
    
    /* 请求参数*/
    NSString *_amount;
    
    NSString *_payType;
    
    
    /* token和id*/
    NSString *_token;
    NSString *_idNumber;
    
    
}

@end

@implementation WithDrawInfoViewController

- (instancetype)initWithAmount:(NSString *)money andPayType:(NSString *)payType{
    self = [super init];
    if (self) {
        
        _amount = [NSString stringWithFormat:@"%@",money];
        
        _payType = [NSString stringWithFormat:@"%@",payType];
        
    }
    
    return self;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _navigationBar = ({
        NavigationBar *_=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
        _.titleLabel.text = @"提现账号";
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_];
        
        _;
    });
    
    _withDrawInfoView= ({
        
        WithDrawInfoView *_=[[WithDrawInfoView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64)];
        
        if ([_payType isEqualToString:@"alipay"]) {
            
            _.accountText.placeholder = @"请输入支付宝账号";
            
        }else if ([_payType isEqualToString:@"bank"]){
            
            _.accountText.placeholder = @"请输入银行卡号";
            
        }
        
        [_.getKeyCodeButton addTarget:self action:@selector(getCheckCode:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_.applyButton addTarget:self action:@selector(requestApply) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_];;
        
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



#pragma mark- 提现申请
- (void)requestApply{
    
    if ([_withDrawInfoView.accountText.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入账号!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }] ;
        
        
        [alert addAction:sure];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    if ([_withDrawInfoView.nameText.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入姓名!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }] ;
        
        [alert addAction:sure];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    if ([_withDrawInfoView.keyCodeText.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入验证码!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }] ;
        
        [alert addAction:sure];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    //    满足所有条件 发送请求
    if (![_withDrawInfoView.accountText.text isEqualToString:@""]&&![_withDrawInfoView.nameText.text isEqualToString:@""]&&![_withDrawInfoView.keyCodeText.text isEqualToString:@""]) {
        if (_idNumber&&_token) {
            if (_payType&&_amount) {
                
                /* 弹窗输入支付密码*/
                
                [DCPaymentView showPayAlertWithTitle:@"请输入支付密码" andDetail:@"申请提现" andAmount:_amount.floatValue completeHandle:^(NSString *inputPwd) {
                    
                    //请求验证ticket_token
                    
                    [self loadingHUDStartLoadingWithTitle:@"验证支付"];
                    __block NSString *ticket_token = nil;
                    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
                    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
                    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
                    [manager GET:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/withdraws/ticket_token",Request_Header,_idNumber] parameters:@{@"password":inputPwd} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                        
                        if ([dic[@"status"]isEqualToNumber:@1]) {
                            
                            ticket_token = [NSString stringWithFormat:@"%@",dic[@"data"]];
                            
                            NSDictionary *dataDic = @{@"amount":_amount,
                                                      @"pay_type":_payType,
                                                      @"account":_withDrawInfoView.accountText.text,
                                                      @"name":_withDrawInfoView.nameText.text,
                                                      @"verify":_withDrawInfoView.keyCodeText.text,
                                                      @"ticket_token":ticket_token
                                                      };
                            
                            AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
                            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                            manager.responseSerializer =[AFHTTPResponseSerializer serializer];
                            [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
                            [manager POST:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/withdraws",Request_Header,_idNumber] parameters:dataDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                
                                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                                
                                
                                if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
                                    /* 请求成功*/
                                    
                                    [self loadingHUDStopLoadingWithTitle:@"提现申请成功!"];
                                    
                                    
                                    WithdrawConfirmViewController *conVC = [[WithdrawConfirmViewController alloc]initWithData:dic[@"data"]];
                                    
                                    [self.navigationController pushViewController:conVC animated:YES];
                                    
                                }else if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:0]]&&[dic[@"error"][@"code"]isEqual:[NSNumber numberWithInteger:3003]]){
                                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已有一笔提现申请正在审核中,请稍后再试" preferredStyle:UIAlertControllerStyleAlert];
                                    
                                    
                                    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                        
                                        [self loadingHUDStartLoadingWithTitle:@"正在取消..."];
                                        MyWalletViewController *mwVC = [[MyWalletViewController alloc]init];
                                        UIViewController *vc = nil;
                                        
                                        for (UIViewController *controller in self.navigationController.viewControllers) {
                                            
                                            if ([controller isKindOfClass:[mwVC class]]) {
                                                
                                                vc = controller;
                                            }
                                        }
                                        if (vc) {
                                            
                                            [self .navigationController popToViewController:vc animated:YES];
                                            
                                        }
                                        
                                        
                                    }] ;
                                    
                                    
                                    [alert addAction:sure];
                                    
                                    [self presentViewController:alert animated:YES completion:nil];
                                    
                                    
                                }else if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:0]]&&[dic[@"error"][@"code"]isEqual:[NSNumber numberWithInteger:2003]]){
                                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"验证码错误!" preferredStyle:UIAlertControllerStyleAlert];
                                    
                                    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                        
                                        [self loadingHUDStopLoadingWithTitle:@"提交失败"];
                                        
                                    }] ;
                                    
                                    
                                    [alert addAction:sure];
                                    
                                    [self presentViewController:alert animated:YES completion:nil];
                                    
                                    
                                }
                                
                                
                                
                                
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                
                            }];
                            
                        }else{
                            [self loadingHUDStopLoadingWithTitle:@"验证错误"];
                            
                        }
                        
                        
                        
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
                    }];
                    
                    
                }];
                
                
            }
        }
    }
    
}

/*点击按钮  获取验证码*/

- (void)getCheckCode:(UIButton *)sender{
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"login_mobile"]!=nil) {
        NSString *mobile = [[NSUserDefaults standardUserDefaults]valueForKey:@"login_mobile"];
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        
        [manager POST:[NSString stringWithFormat:@"%@/api/v1/captcha",Request_Header] parameters:@{@"send_to":mobile,@"key":@"withdraw_cash"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            /* 发送成功提示框*/
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            [hud setLabelText:@"发送成功！"];
            hud.yOffset= 150.f;
            hud.removeFromSuperViewOnHide = YES;
            
            /* 重新发送验证码*/
            [self deadLineTimer:_withDrawInfoView.getKeyCodeButton];
            
            [hud hide:YES afterDelay:2.0];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    
    /* 手机号输入为空或错误的情况*/
    else  {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"获取手机号失败!\n请重新登录!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            LoginAgainViewController *agVC = [[LoginAgainViewController alloc]init];
            [self.navigationController pushViewController:agVC animated:YES];
            
            
        }] ;
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }] ;
        
        [alert addAction:sure];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        
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
