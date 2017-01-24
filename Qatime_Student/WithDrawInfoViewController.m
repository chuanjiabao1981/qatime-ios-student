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
#import "UIAlertController+Blocks.h"
#import "AuthenticationViewController.h"


@interface WithDrawInfoViewController (){
    
    
    /* 导航栏*/
    NavigationBar *_navigationBar;
    
    /* 请求参数*/
    NSString *_amount;
    
    NSString *_payType;
    
    NSString *_ticket_Token;
    
    
    /* token和id*/
    NSString *_token;
    NSString *_idNumber;
    
    
}

@end

@implementation WithDrawInfoViewController

- (instancetype)initWithAmount:(NSString *)money andPayType:(NSString *)payType andTicketToken:(NSString *)ticketToken{
    self = [super init];
    if (self) {
        
        _amount = [NSString stringWithFormat:@"%@",money];
        
        _payType = [NSString stringWithFormat:@"%@",payType];
        
        _ticket_Token = [NSString stringWithFormat:@"%@",ticketToken];
        
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
        
        //        [_.getKeyCodeButton addTarget:self action:@selector(getCheckCode:) forControlEvents:UIControlEventTouchUpInside];
        
        
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
      //    满足所有条件 发送请求
    if (![_withDrawInfoView.accountText.text isEqualToString:@""]&&![_withDrawInfoView.nameText.text isEqualToString:@""]) {
        if (_idNumber&&_token) {
            if (_payType&&_amount) {
                NSDictionary *dataDic = @{@"amount":_amount,
                                          @"pay_type":_payType,
                                          @"account":_withDrawInfoView.accountText.text,
                                          @"name":_withDrawInfoView.nameText.text,
                                          /*@"verify":_withDrawInfoView.keyCodeText.text,*/
                                          @"ticket_token":_ticket_Token
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
                [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"支付密码错误" cancelButtonTitle:@"重试" destructiveButtonTitle:nil otherButtonTitles:@[@"找回支付密码"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                    if (buttonIndex!=0) {
                        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"新设置或修改后将在24小时内不能使用支付密码,是否继续?" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"继续"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                            if (buttonIndex!=0) {
                                AuthenticationViewController *controller = [[AuthenticationViewController alloc]init];
                                [self.navigationController pushViewController:controller animated:YES];
                            }
                        }];
                    }
                }];
            }
        }
    }
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
