//
//  ConfirmChargeViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ConfirmChargeViewController.h"
#import "NavigationBar.h"
 
#import "NSString+TimeStamp.h"
#import "WXApi.h"
#import "UIViewController+HUD.h"
#import "CheckChargeViewController.h"
#import "MyWalletViewController.h"
#import "DCPaymentView.h"
#import "UIViewController+AFHTTP.h"


@interface ConfirmChargeViewController (){
    
    NavigationBar *_navigationBar;
    
    NSMutableDictionary *dataInfo;
    
    NSString *_token;
    NSString *_idNumber;
    
    /* 支付方式*/
    
    NSString *_pay_type;
    
    
    /**充值金额*/
    NSInteger rechargePrice;
    
    
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

-(instancetype)initWithModel:(Recharge *)model{
    
    if (self) {
        self = [super init];
        
        if (model.pay_at==nil) {
            model.pay_at = @"";
        }
        
        dataInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"amount":model.amount==nil?@"":model.amount,
                                                                   @"status":model.status==nil?@"":model.status,
                                                                   @"id":model.idNumber==nil?@"":model.idNumber,
                                                                   @"created_at":model.created_at==nil?@"":model.created_at,
                                                                   @"pay_type":model.pay_type==nil?@"":model.pay_type,
                                                                   @"pay_at":model.pay_at==nil?@"":model.pay_at,
                                                                   @"nonce_str":model.nonce_str==nil?@"":model.nonce_str,
                                                                   @"updated_at":model.updated_at==nil?@"":model.updated_at,
                                                                   @"prepay_id":model.prepay_id==nil?@"":model.prepay_id}];
    }
    return self;
    
}

-(instancetype)initWithPayModel:(Unpaid *)model{
    
    if (self) {
        self = [super init];
        
        if (model.pay_at==nil) {
            model.pay_at = @"";
        }
        if (model.timestamp == nil) {
            model.timestamp = @"" ;
        }
        dataInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"amount":model.price,
                                                                   @"status":model.status,
                                                                   @"id":model.orderID,
                                                                   @"created_at":model.created_at,
                                                                   @"pay_type":model.pay_type,
                                                                   @"pay_at":model.pay_at,
                                                                   @"nonce_str":model.nonce_str,
                                                                   @"updated_at":model.created_at,
                                                                   @"prepay_id":model.prepay_id==nil?@"":model.prepay_id,
                                                                   @"app_pay_params":model.app_pay_params==nil?@"":model.app_pay_params
                                                                   }];
    }
    return self;
}


-(instancetype)initWithPrice:(NSString *)price{
    self = [super init];
    if (self) {
        
        rechargePrice = price.integerValue;
        
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor= [UIColor whiteColor];
    
    _navigationBar = ({
        
        NavigationBar *_=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
        
        _.titleLabel.text = @"交易确认";
        
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_];
        _;
        
    });
    
    
    _confirmView = ({
        
        ConfirmChargeView *_=[[ConfirmChargeView alloc]initWithFrame:CGRectMake(0, Navigation_Height, self.view.width_sd, self.view.height_sd-Navigation_Height)];
        
        if (dataInfo) {
            _.number.text = dataInfo[@"id"];
            _.time.text = [dataInfo[@"created_at"]timeStampToDate];
            _.charge_type.text = @"账户储值";
           
            if ([dataInfo[@"pay_type"] isEqualToString:@"weixin"]) {
                _.pay_type.text = @"微信支付";
            }else if ([dataInfo[@"pay_type"] isEqualToString:@"alipay"]){
                _.pay_type.text = @"支付宝支付";
            }else if ([dataInfo[@"pay_type"] isEqualToString:@"account"]){
                _.pay_type.text = @"账户余额";
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
            
            [self HUDStopWithTitle:@"加载错误,请从新登录"];
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
            
            request.timeStamp= [data[@"app_pay_params"][@"timestamp"] intValue];
            
            request.sign = data[@"app_pay_params"][@"sign"];
            
            [WXApi sendReq:request];
            
        }else if ([type isEqualToString:@"alipay"]){
            /* 后台接口暂时未调通,暂时预留接口*/
            
        }else if ([type isEqualToString:@"amount"]){
            /* 余额支付方法*/
            
           __block NSString *ticketToken ;
            
         [DCPaymentView showPayAlertWithTitle:@"请输入支付密码" andDetail:@"订单支付" andAmount:[dataInfo[@"amount"]floatValue] completeHandle:^(NSString *inputPwd) {
             
             /* 请求ticket token*/
             [self POSTSessionURL:[NSString stringWithFormat:@"%@/api/v1/payment/orders/%@/pay/ticket_token",Request_Header,dataInfo[@"id"]] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
                 
                 NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
                 if ([dic[@"status"]isEqualToNumber:@1]) {
                     /* 获取成功*/
                     ticketToken = dic[@"data"];
                     /* 用ticket token 发起第二次请求*/
                     
                     [self POSTSessionURL:[NSString stringWithFormat:@"%@/api/v1/payment/orders/%@/pay",Request_Header,dataInfo[@"id"] ] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
                         
                     }];
                 }else{
                     
                     
                 }
             }];
             
         }];
            
            
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
