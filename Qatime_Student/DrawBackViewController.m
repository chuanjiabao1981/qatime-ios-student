//
//  DrawBackViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/1/9.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "DrawBackViewController.h"
#import "NavigationBar.h"
#import "UIViewController_HUD.h"

@interface DrawBackViewController (){
    
    NavigationBar *_navigationBar;
    
    NSString *_token;
    NSString *_idNumber;
    
    /* 订单信息*/
    Paid *_paidOrder;
    /* 取消订单数据的字典*/
    NSMutableDictionary *_dataDic;
    
}

@end

@implementation DrawBackViewController

-(instancetype)initWithPaidOrder:(Paid *)paidOrder{
    self = [super init];
    if (self) {
        
        _paidOrder = paidOrder;
        
    }
    return self;
    
}




-(void)loadView{
    [super loadView];
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0,0, self.view.width_sd, 64)];
    
    [self.view addSubview:_navigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    _navigationBar.titleLabel.text = @"退款申请";
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    _dataDic = @{}.mutableCopy;
    
    
    /* 请求数据*/
    [self requestDrawback];
    
}

/* 请求退款信息数据*/
- (void)requestDrawback{
    [self loadingHUDStartLoadingWithTitle:@"正在加载数据"];
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/refunds/info",Request_Header,_idNumber] parameters:@{@"order_id":_paidOrder.orderID} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            /* 请求数据成功*/
            _dataDic = [dic[@"data"] mutableCopy];
            [self setupView];
            
            [self loadingHUDStopLoadingWithTitle:@"加载完成"];
            
        }else{
           /* 请求数据失败*/
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

/* 加载视图*/
- (void)setupView{
    
    _drawBackView = [[DrawBackView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64-TabBar_Height)];
    [self.view addSubview:_drawBackView];
    
    if (_dataDic) {
        _drawBackView.number.text = _paidOrder.orderID;
        _drawBackView.className.text = _paidOrder.name;
        _drawBackView.progress.text =  [NSString stringWithFormat:@"%@/%@",_paidOrder.completed_lesson_count,_paidOrder.preset_lesson_count];
        _drawBackView.price.text = [NSString stringWithFormat:@"¥%@",_dataDic[@"amount"]];
        _drawBackView.enableDrawbackPrice.text = [NSString stringWithFormat:@"¥%@",_dataDic[@"refund_amount"]];
        _drawBackView.paidPrice.text = [NSString stringWithFormat:@"%ld",[_dataDic[@"amount"] integerValue]-[_dataDic[@"refund_amount"] integerValue]];
        
        if ([_dataDic[@"pay_type"]isEqualToString:@"weixin"]) {
            _drawBackView.drawBackWay.text = @"微信钱包";
            
        }else if ([_dataDic[@"pay_type"]isEqualToString:@"alipay"]){
            _drawBackView.drawBackWay.text = @"支付宝";
        }else if ([_dataDic[@"pay_type"]isEqualToString:@"balance"]){
            _drawBackView.drawBackWay.text = @"退至余额";
            
        }
        
        
    }
    
}

/* 返回上一页*/
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
