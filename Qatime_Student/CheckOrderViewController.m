//
//  CheckOrderViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/13.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "CheckOrderViewController.h"
#import "NavigationBar.h"

#import "TutoriumInfoViewController.h"


#define RED [UIColor colorWithRed:0.84 green:0.13 blue:0.10 alpha:1.00]
#define GREEN [UIColor colorWithRed:0.20 green:0.67 blue:0.15 alpha:1.00]

@interface CheckOrderViewController (){
    
    
    NavigationBar *_navigationBar;
    
    NSString *_token;
    NSString *_idNumber;
    
    
    /* 订单号*/
    NSString *_numbers;
    
    /* 充值金额*/
    NSString *_amount;
    
    
    /* 支付状态*/
    PayStatus _paystatus;
    
    /**查询次数*/
    NSInteger checkTime;

}

@end

@implementation CheckOrderViewController


- (instancetype)initWithIDNumber:(NSString *)number andAmount:(NSString *)amount
{
    self = [super init];
    if (self) {
        
        _numbers = [NSString stringWithFormat:@"%@",number];
        _amount = [NSString  stringWithFormat:@"%@",amount];
        
        
        /* 提出token和学生id*/
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
            _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
        }
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
            
            _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
        }
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNDGRAY;
    _navigationBar = ({
        NavigationBar *_=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
        
        _.titleLabel.text = @"支付结果";
        [self.view addSubview:_];
        _;
    });
    
    checkTime = 0;
    
    /* 请求支付状态*/
    [self requestPayStatus];
    
}

- (void)setupMainView{
   
    _checkOrderView =({
        CheckOrderView *_=[[CheckOrderView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64)];
        [_.finishButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_];
        _;
    });
    
}
- (void)requestPayStatus{
    
    if (_numbers) {
        
        checkTime++;
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
        [manager GET:[NSString stringWithFormat:@"%@/api/v1/payment/orders/%@/result",Request_Header,_numbers] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
                /* 获取状态数据成功*/
                
                if (![dic[@"data"] isEqualToString:@"shipped"]) {
                    
                    if (checkTime>6) {
                        
                        [self requestPayStatus];
                        
                    }else{
                        
                        _paystatus = unpaid;
                        
                        [self setupMainView];
                        [_checkOrderView.statusImage setImage:[UIImage imageNamed:@"selectedCircle"]];
                        _checkOrderView.status.text = @"未查到购买结果";
                        _checkOrderView.number.text = _numbers;
                        _checkOrderView.chargeMoney.text = _amount;
                        _checkOrderView.explain.hidden = NO;

                    }
                    
                    /* 未支付状态*/
        
                    
                }else{
                    
                    _paystatus = recieved;
                    [self setupMainView];
                    
                    [_checkOrderView.statusImage setImage:[UIImage imageNamed:@"selectedCircle"]];
                    _checkOrderView.status.text = @"课程购买成功";
                    _checkOrderView.number.text = _numbers;
                    _checkOrderView.chargeMoney.text = _amount;
                    _checkOrderView.explain.hidden = YES;
                    
                    
                }
            
            }else if([dic[@"status"]isEqual:[NSNumber numberWithInteger:0]]){
                
                _paystatus = other;
                
            }else{
                /* 获取数据错误,需重新登录*/
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"查询数据错误,请重新登录" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"userLogOut" object:nil ];
                    
                }] ;
                
                
                [alert addAction:sure];
                
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            
//            [self loadViewWithStatus:_paystatus];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        
    }
    
}

#pragma mark- 三种不同数据状态的加载方法
- (void)loadViewWithStatus:(PayStatus)paystatus{
    
    /* 存储所有需要展示的字段*/
    __block NSString *status=@"".mutableCopy;
    __block UIImage *image = nil;
    __block NSString *balance = @"".mutableCopy;
    __block NSString *number = @"".mutableCopy;
    __block NSString *chargeMoney = @"".mutableCopy;
    __block UIColor *color = [UIColor whiteColor];
    
    
    switch (paystatus) {
            
        case recieved:{
            /* 查询成功,请求余额数据等信息*/
            AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer =[AFHTTPResponseSerializer serializer];
            [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
            [manager GET:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/cash",Request_Header,_idNumber] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
                    balance = [NSString stringWithFormat:@"最新余额 %@",dic[@"data"][@"balance"]];
                    status = @"支付成功";
                    color = GREEN;
                    image = [UIImage imageNamed:@"yes_green"];
                    if (_amount) {
                        
                        chargeMoney = _amount;
                    }
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
            _checkOrderView.explain.hidden =YES;
            
            
        }
            break;
        case unpaid:{
            
            
            status = @"充值结果未找到";
            color = RED;
            image = [UIImage imageNamed:@"wrong_green"];
            if (_amount) {
                
                chargeMoney = _amount;
            }
            
            _checkOrderView.explain.hidden =NO;
            
        }
            break;
            
        case other:{
            
            
            status = @"充值结果未找到";
            color = RED;
            image = [UIImage imageNamed:@"wrong_red"];
            if (_amount) {
                
                chargeMoney = _amount;
            }
            
            _checkOrderView.explain.hidden =NO;
            
            
        }
            break;
            
    }
    
    _checkOrderView.status.textColor = color;
    _checkOrderView.status.text = status;
    [_checkOrderView.statusImage setImage:image];
    _checkOrderView.balance.text = balance;
    _checkOrderView.number.text = _numbers;
    _checkOrderView.chargeMoney.text = chargeMoney;
    
    
    
}




- (void)returnLastPage{
    
    /* 跳转至辅导班详情页*/
    
    TutoriumInfoViewController *tutVC = [[TutoriumInfoViewController alloc]init];
    UIViewController *controller = nil;
    
    for (UIViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[tutVC class]]) {
            
            controller = VC;
            [self.navigationController popToViewController:controller animated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshTutoriumInfo" object:nil];
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
