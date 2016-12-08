//
//  ChargeViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ChargeViewController.h"
#import "NavigationBar.h"
#import "WXApi.h"
#import "RDVTabBarController.h"
#import "UIViewController+HUD.h"
#import "NSString+TimeStamp.h"
#import "ConfirmChargeViewController.h"

@interface ChargeViewController ()<UITextFieldDelegate>{
    
    
    NavigationBar *_navigationBar;
    
    
    /* 支付方式*/
    NSString *_payType;
    
    NSString *_token;
    NSString *_idNumber;
    
    /* 申请后获取到的数据*/
    
    NSMutableDictionary *_dataDic;
    
    
    
    
}

@end

@implementation ChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
    [self.view addSubview: _navigationBar];
    _navigationBar.titleLabel.text = @"充值选择";
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"leftArrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    
    _chargeView = [[ChargeView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64)];
    [self.view addSubview:_chargeView];
    
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    /* 初始化*/
    _payType = @"".mutableCopy;
    _dataDic = @{}.mutableCopy;
    
    
    /* 两个button的点击时间*/
    [_chargeView.wechatButton addTarget:self action:@selector(selectedWechat:) forControlEvents:UIControlEventTouchUpInside];
    [_chargeView.alipayButton addTarget:self action:@selector(selectedAlipay:) forControlEvents:UIControlEventTouchUpInside];
    
    /* 下一步按钮的点击事件*/
    
    [_chargeView.finishButton addTarget:self action:@selector(finishChosen) forControlEvents:UIControlEventTouchUpInside];
    
    /* 注册通知,接受支付成功的通知,自动跳转到状态查询页面*/
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CheckPayStatus) name:@"ChargeSucess" object:nil];
    
    _chargeView.moneyText.delegate = self;
    
    
    
    
}
#pragma mark- 立即支付按钮的点击事件
- (void)finishChosen{
    
    
    if (_chargeView.moneyText.text ==nil||[_chargeView.moneyText.text isEqualToString:@""]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入充值金额!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }] ;
        [alert addAction:sure];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        
        if (_chargeView.wechatButton.selected == YES) {
            /* 用户选择微信支付*/
            
            _payType  =@"weixin";
            
        }else if(_chargeView.alipayButton.selected == YES){
            /* 用户选择微信支付*/
            
            _payType = @"alipay";
            
            
        }else if (_chargeView.wechatButton.selected!=YES&&_chargeView.alipayButton.selected != YES){
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择支付方式!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }] ;
            [alert addAction:sure];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }
   
    
    if (![_chargeView.moneyText.text isEqualToString:@""]&&![_payType isEqualToString:@""]) {
        
        
        [self chargeWithType:_payType];
        
    }
    
}


#pragma mark- 发送支付申请


/**
 向服务器发送支付申请
 @param type 根据不同的type 会返回不同的支付openID
 */
- (void)chargeWithType:(NSString *)type{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager POST:[NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/payment/users/%@/recharges",_idNumber] parameters:@{@"amount":_chargeView.moneyText.text,@"pay_type":_payType} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {

            
            NSString *date = [NSString stringWithFormat:@"%@",dic[@"data"][@"created_at"]];
            
            /* 订单生成成功*/
            NSDictionary *infoDic = [NSDictionary dictionaryWithDictionary:dic[@"data"]];
            
            
            
            ConfirmChargeViewController *conVC = [[ConfirmChargeViewController alloc]initWithInfo:infoDic];
            [self.navigationController pushViewController:conVC animated:YES];
            [self.rdv_tabBarController setTabBarHidden:YES];

            
            
            
        }else{
            /* 失败*/
            /* 订单生成失败*/
            [self loadingHUDStopLoadingWithTitle:@"订单创建失败,请查看登录状态!"];
        
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    
    
    
    
}




//#pragma mark- 发送支付跳转申请
//
//- (void)requestChargWithType:(NSString *)type andData:(NSMutableDictionary *)data{
//    
//    if ([type isEqualToString:@"weixin"]) {
//        
//        PayReq *request = [[PayReq alloc] init] ;
//        
//        request.partnerId = data[@"app_pay_params"][@"partnerid"];
//        
//        request.prepayId= data[@"app_pay_params"][@"prepayid"];
//        
//        request.package = data[@"app_pay_params"][@"package"];
//        
//        request.nonceStr= data[@"app_pay_params"][@"noncestr"];
//        
//        request.timeStamp= [ data[@"app_pay_params"][@"timestamp"] intValue];
//        
//        request.sign = data[@"app_pay_params"][@"sign"];
//        
//        [WXApi sendReq:request];
//    }else if ([type isEqualToString:@"alipay"]){
//        
//        
//    }
//    
//
//    
//    
//}
//


- (void)selectedWechat:(UIButton *)sender{
    
    if (sender.selected ==YES) {
        
        sender.selected = NO;
        [sender setImage:nil forState:UIControlStateNormal];
        
    }else{
        
        sender.selected = YES;
        [sender setImage:[UIImage imageNamed:@"redDot"] forState:UIControlStateNormal];
        _chargeView.alipayButton.selected = NO;
        [_chargeView.alipayButton setImage:nil forState:UIControlStateNormal];
        
    }
    
    
    
}

- (void)selectedAlipay:(UIButton *)sender{
   
    if (sender.selected ==YES) {
        
        sender.selected = NO;
        [sender setImage:nil forState:UIControlStateNormal];
        
    }else{
        
        sender.selected = YES;
        [sender setImage:[UIImage imageNamed:@"redDot"] forState:UIControlStateNormal];
        _chargeView.wechatButton.selected = NO;
        [_chargeView.wechatButton setImage:nil forState:UIControlStateNormal];
        
        
    }

    
    
}
/* 检查支付结果*/
- (void)CheckPayStatus{
    
    ConfirmChargeViewController *conVC = [ConfirmChargeViewController new];
    [self.navigationController pushViewController:conVC animated:YES];
    [self.rdv_tabBarController setTabBarHidden:YES];
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    NSCharacterSet *cs;
   
    if ([textField isEqual:_chargeView.moneyText]) {
        NSUInteger nDotLoc = [textField.text rangeOfString:@"."].location;
        if (NSNotFound == nDotLoc && 0 != range.location) {
            cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789.\n"] invertedSet];
        }
        else {
            cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789\n"] invertedSet];
        }
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if (!basicTest) {
            
            [self loadingHUDStopLoadingWithTitle:@"只能输入数字和小数点"];
            return NO;
        }
        if (NSNotFound != nDotLoc && range.location > nDotLoc + 2) {
            [self loadingHUDStopLoadingWithTitle:@"小数点后最多两位"];
            return NO;
        }
    }
    
    return  YES;
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
