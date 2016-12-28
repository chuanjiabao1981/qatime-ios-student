//
//  ConfirmChargeViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ConfirmChargeViewController.h"
#import "NavigationBar.h"
#import "RDVTabBarController.h"
#import "NSString+TimeStamp.h"
#import "WXApi.h"
#import "UIViewController+HUD.h"
#import "CheckChargeViewController.h"
#import "MyWalletViewController.h"


@interface ConfirmChargeViewController (){
    
    NavigationBar *_navigationBar;
    
    NSMutableDictionary *dataInfo;
    
    /* 支付方式*/
    
    NSString *_pay_type;
    
}

@end

@implementation ConfirmChargeViewController


- (instancetype)initWithInfo:(__kindof NSDictionary *)info
{
    self = [super init];
    if (self) {
        
        dataInfo  = [NSMutableDictionary dictionaryWithDictionary:info];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor= [UIColor whiteColor];
    
    _navigationBar = ({
        
        NavigationBar *_=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
        
        _.titleLabel.text = @"交易确认";
        
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_];
        _;
        
    });
    
    
    _confirmView = ({
        
        ConfirmChargeView *_=[[ConfirmChargeView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64)];
        
        if (dataInfo) {
            _.number.text = dataInfo[@"id"];
            _.time.text = [dataInfo[@"created_at"]timeStampToDate];
            _.charge_type.text = @"账户储值";
           
            if ([dataInfo[@"pay_type"] isEqualToString:@"weixin"]) {
                _.pay_type.text = @"微信支付";
            }else if ([dataInfo[@"pay_type"] isEqualToString:@"alipay"]){
                _.pay_type.text = @"支付宝支付";
            }else if ([dataInfo[@"pay_type"] isEqualToString:@"offline"]){
                _.pay_type.text = @"线下支付";
            }
            
            _.money.text = [NSString stringWithFormat:@"¥%@",dataInfo[@"amount"]];
            
            [_.payButton addTarget:self action:@selector(sureToPay) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        
        
        
        
        [self.view addSubview:_];
        _;
    
    });
    
    
    if (dataInfo) {
        _pay_type = [NSString stringWithFormat:@"%@",dataInfo[@"pay_type"]];
    }
    
    /* 支付成功后会接受这个回调通知*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CheckPayStatus) name:@"ChargeSucess" object:nil];

    
    
    /* 查询支付状态完毕后的消息->跳转*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(returnWalletPage) name:@"CheckDone" object:nil];
    
    
}


/* 确认支付*/
- (void)sureToPay{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请再次确认支付信息!\n是否支付?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }] ;
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        if (dataInfo) {
            
            [self requestChargWithType:_pay_type andData:dataInfo];
        }else{
            
            [self loadingHUDStopLoadingWithTitle:@"加载错误,请从新登录"];
        }
        
        
    }] ;
    
    [alert addAction:cancel];
    [alert addAction:sure];
    
    [self presentViewController:alert animated:YES completion:nil];

    
    
    
}


#pragma mark- 发送支付跳转申请

- (void)requestChargWithType:(NSString *)type andData:(NSMutableDictionary *)data{
    
    if ([type isEqualToString:@"weixin"]) {
        
        PayReq *request = [[PayReq alloc] init] ;
        
        request.partnerId = data[@"app_pay_params"][@"partnerid"];
        
        request.prepayId= data[@"app_pay_params"][@"prepayid"];
        
        request.package = data[@"app_pay_params"][@"package"];
        
        request.nonceStr= data[@"app_pay_params"][@"noncestr"];
        
        request.timeStamp= [ data[@"app_pay_params"][@"timestamp"] intValue];
        
        request.sign = data[@"app_pay_params"][@"sign"];
        
        [WXApi sendReq:request];
    }else if ([type isEqualToString:@"alipay"]){
        
        
    }
    
    
    
    
}

#pragma mark- 查询页面退出后,直接跳转到rootcontroller
- (void)returnWalletPage{
    
    
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark- 接到消息回调,进入支付状态查询页面
- (void)CheckPayStatus{
    
    if (dataInfo) {
        
        CheckChargeViewController *chVC = [[CheckChargeViewController alloc]initWithIDNumber:dataInfo[@"id"] andAmount:dataInfo[@"amount"] ];
        [self.navigationController pushViewController:chVC animated:YES ];
   
    }
    
    
}




- (void)returnLastPage{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.rdv_tabBarController setTabBarHidden:NO];
    
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
