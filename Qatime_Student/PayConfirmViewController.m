//
//  PayConfirmViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/13.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "PayConfirmViewController.h"

#import "NSString+TimeStamp.h"
#import "UIViewController+HUD.h"
#import "WXApi.h"
#import "CheckChargeViewController.h"


@interface PayConfirmViewController (){
    
    NavigationBar *_navigationBar;
    
    /* 订单信息*/
    NSMutableDictionary *_dataDic;
    
    
}

@end

@implementation PayConfirmViewController

-(instancetype)initWithData:(NSDictionary *)dataDic{
   
    self = [super init];
    if (self) {
        
        _dataDic = [NSMutableDictionary dictionaryWithDictionary:dataDic];
        
    }

    return self;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _navigationBar = ({
        NavigationBar *_=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
        
        _.titleLabel.text = @"支付确认";
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_];
        _;
    });
    
    _payConfirmView = ({
    
        PayConfirmView *_=[[PayConfirmView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64)];
        
        if (_dataDic) {
            
            _.number.text = _dataDic[@"id"];
            _.time.text = [_dataDic[@"created_at"] timeStampToDate];
            
            if ([_dataDic[@"pay_type"]isEqualToString:@"weixin"]) {
                _.type.text = @"微信支付";
                
            }else if ([_dataDic[@"pay_type"]isEqualToString:@"alipay"]){
                _.type.text = @"支付宝支付";
            }else if ([_dataDic[@"pay_type"]isEqualToString:@"account"]){
                _.type.text = @"余额支付";
            }
            
            _.money.text = [NSString stringWithFormat:@"¥%@",_dataDic[@"amount"]];
            
            [_.finishButton addTarget:self action:@selector(payForOrder) forControlEvents:UIControlEventTouchUpInside];
        }else{
            
            /* 数据拉取失败*/
            [self loadingHUDStopLoadingWithTitle:@"获取数据失败!"];

            [self performSelector:@selector(returnLastPage) withObject:nil afterDelay:1];
        }
        
        
        
        [self.view addSubview:_];
        _;
    
    });
    
    
    /* 注册微信支付成功或失败的通知*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CheckPayStatus) name:@"ChargeSucess" object:nil];
    
    
    
}
#pragma mark- 支付订单
- (void)payForOrder{
    
    if ([_dataDic[@"pay_type"]isEqualToString:@"weixin"]) {
        /* 微信支付*/
        
        [self payWithWechat];
        
    }else if ([_dataDic[@"pay_type"]isEqualToString:@"alipay"]){
        /* 支付宝支付*/
        /* 预留接口*/
        
        [self payWithAlipay];
        
    }else if ([_dataDic[@"pay_type"]isEqualToString:@"account"]){
        /* 余额支付*/
        [self payWithBalance];
    }
    
    
}

#pragma mark- 使用微信支付
- (void)payWithWechat{
    
    if (_dataDic) {
        
        NSDictionary *payDic =[NSDictionary dictionaryWithDictionary: _dataDic[@"app_pay_params"]];
        PayReq *request = [[PayReq alloc] init] ;
        
        request.partnerId = payDic[@"partnerid"];
        
        request.prepayId= payDic[@"prepayid"];
        
        request.package = payDic[@"package"];
        
        request.nonceStr= payDic[@"noncestr"];
        
        request.timeStamp= payDic[@"timestamp"];
        
        request.sign= payDic[@"sign"];
        [WXApi sendReq:request];
        
    }else{
        
        [self loadingHUDStopLoadingWithTitle:@"数据错误"];
    }
    

    
}

#pragma mark- 使用支付宝支付
- (void)payWithAlipay{
    
    
}

#pragma mark- 余额支付
- (void)payWithBalance{
    
    
}

#pragma mark- 访问服务器,查询支付是否成功
- (void)CheckPayStatus{
    
    if (_dataDic) {
        CheckChargeViewController *checkVC = [[CheckChargeViewController alloc]initWithIDNumber:_dataDic[@"id"] andAmount:_dataDic[@"amount"]];
        [self.navigationController pushViewController:checkVC animated:YES];
        
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
