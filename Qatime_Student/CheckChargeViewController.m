//
//  CheckChargeViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/8.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "CheckChargeViewController.h"
#import "NavigationBar.h"
#import "MyWalletViewController.h"
#import "UIViewController+HUD.h"

#define RED [UIColor colorWithRed:0.84 green:0.13 blue:0.10 alpha:1.00]
#define GREEN [UIColor colorWithRed:0.20 green:0.67 blue:0.15 alpha:1.00]

@interface CheckChargeViewController (){
    
    NavigationBar *_navigationBar;
    
    NSString *_token;
    NSString *_idNumber;
    
    
    /* 订单号*/
    NSString *_numbers;
    
    /* 充值金额*/
    NSString *_amount;
    
    
    /* 支付状态*/
    PayStatus _paystatus;
    
    /**transaction*/
    SKPaymentTransaction *_transaction;
    
    /**产品*/
    ItunesProduct *_product;
    
    /**查询验证次数*/
    NSInteger checkTime;
    
}


@end

@implementation CheckChargeViewController

- (instancetype)initWithIDNumber:(NSString *)number andAmount:(NSString *)amount
{
    self = [super init];
    if (self) {
        
        _numbers = [NSString stringWithFormat:@"%@",number];
        _amount = [NSString  stringWithFormat:@"%@",amount];
        
    }
    return self;
}


-(instancetype)initWithTransaction:(SKPaymentTransaction *)transaction andProduct:(ItunesProduct *)product{
    
    self = [super init];
    if (self) {
        
        _transaction = transaction;
        _product = product;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    /**初始化*/
    checkTime = 0;
    
    [self getToken];
    
    _navigationBar = ({
        NavigationBar *_=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
        _.titleLabel.text = @"充值结果";
        [self.view addSubview:_];
        _;
    });
    
    /* 请求支付状态*/
    [self requestPayStatus];
    
    [self HUDStartWithTitle:nil];
    
    
}
/**获取token*/
- (void)getToken{
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
}

/**加载主视图*/
- (void)setupMainView{
    
    _checkChargeView =({
        CheckChargeView *_=[[CheckChargeView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64)];
        [_.finishButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_];
        _;
    });
}

/**获取充值状态*/
- (void)requestPayStatus{
    
    checkTime++;
    NSData *receiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    NSString *receiptString = [receiptData base64EncodedStringWithOptions:0];
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager POST:[NSString stringWithFormat:@"%@/api/v1/payment/recharges/%@/verify_receipt",Request_Header,_transaction.transactionIdentifier] parameters:@{@"product_id":_product.product_id,@"receipt_data":receiptString} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            if (![dic[@"data"][@"status"]isEqualToString:@"received"]) {
                /**状态不对就继续请求*/
                
                if (checkTime>10) {
                    
                    /**主视图*/
                    [self setupMainView];
                    [_checkChargeView.statusImage setImage:[UIImage imageNamed:@"wrong_red"]];
                    _checkChargeView.status.textColor = NAVIGATIONRED;
                    _checkChargeView.status.text = @"验证失败";
                    _checkChargeView.number.text =_transaction.transactionIdentifier;
                    _checkChargeView.chargeMoney.text = [NSString stringWithFormat:@"%@", _product.amount];
                    _checkChargeView.explain.hidden = NO;
                    [self stopHUD];
                    
                    //离线验证
                    [self offlineCheck];
                    
                }else{
                    
                    [self requestPayStatus];
                }
            }else{
                
                /**主视图*/
                [self setupMainView];
                [_checkChargeView.statusImage setImage:[UIImage imageNamed:@"selectedCircle"]];
                _checkChargeView.status.textColor = [UIColor colorWithRed:0.16 green:0.87 blue:0.46 alpha:1.00];
                _checkChargeView.status.text = @"充值成功";
                _checkChargeView.number.text =_transaction.transactionIdentifier;
                _checkChargeView.chargeMoney.text = [NSString stringWithFormat:@"%@", _product.amount];
                _checkChargeView.explain.hidden = YES;
                
                [self stopHUD];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ChargeSuccess" object:nil];
            }
            
        }else{
            [self requestPayStatus];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"购买失败，请重试"delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
        [alertView show];
    }];

}


/**
 在当前验证失败之后,在下次系统启动的时候,发送充值验证
 */
- (void)offlineCheck{
    
    
}


- (void)returnLastPage{
    
    /* 跳转至我的资产页面*/
    
    MyWalletViewController *myVC = [[MyWalletViewController alloc]init];
    
    for (UIViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[myVC class]]) {
            
            [self.navigationController popToViewController:VC animated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"PopToRoot" object:nil];
            
        }
    }
    
    
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
