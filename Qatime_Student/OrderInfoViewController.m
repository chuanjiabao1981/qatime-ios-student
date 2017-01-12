//
//  OrderInfoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/1/10.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "OrderInfoViewController.h"
#import "NavigationBar.h"
#import "NSString+TimeStamp.h"


@interface OrderInfoViewController (){
    
    NavigationBar *_navigationBar;
    
    /* 状态图*/
    UIImage *_statusImage;
    
    /* 三个model,判断订单类型*/
    Unpaid *_unPaid;
    Paid *_paid;
    Canceld *_canceld;
    
    /* 保存数据的dic*/
    NSMutableDictionary *_dataDic;
    
    
}

@end

@implementation OrderInfoViewController


/* 传值初始化方法*/
-(instancetype)initWithInfo:(NSDictionary *)info{
    
    self = [super init];
    if (self) {
        
        _dataDic = [NSMutableDictionary dictionaryWithDictionary:info];
    }
    return self;
    
}

- (void)loadView{
    [super loadView];
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
    [self.view addSubview:_navigationBar];
    
}

/* 加载订单信息图*/
- (void)setUpViews{
    _orderInfoView = [[OrderInfoView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64)];
    [self.view addSubview:_orderInfoView];
    
    
    /* 判断订单状态*/
    
    
    /* 信息赋值*/
    if ([_dataDic[@"status"]isEqualToString:@"shipped"]) {
        /* 交易完成的*/
        [_orderInfoView.statusImage setImage:[UIImage imageNamed:@"交易完成"]];
        
    }else if ([_dataDic[@"status"]isEqualToString:@"unpaid"]){
        [_orderInfoView.statusImage setImage:[UIImage imageNamed:@"正在交易"]];
        
    }else if ([_dataDic[@"status"]isEqualToString:@"canceled"]){
        [_orderInfoView.statusImage setImage:[UIImage imageNamed:@"交易关闭"]];
    }

    _orderInfoView.orderNumber.text = _dataDic[@"orderNumber"];
    
    _orderInfoView.subName.text = [NSString stringWithFormat:@"%@%@/共%@课/%@",_dataDic[@"subject"],_dataDic[@"grade"],_dataDic[@"lessonTime"],_dataDic[@"teacherName"]];
    _orderInfoView.name.text = _dataDic[@"name"];
    _orderInfoView.creatTime.text = _dataDic[@"creatTime"];
    _orderInfoView.payTime.text = _dataDic[@"payTime"];
    if ([_dataDic[@"payType"]isEqualToString:@"weixin"]) {
        _orderInfoView.payType.text = @"微信支付";
    }else if ([_dataDic[@"payType"]isEqualToString:@"alipay"]){
        _orderInfoView.payType.text = @"支付宝";
    }else{
        _orderInfoView.payType.text = @"线下支付";
    }
    _orderInfoView.amount.text = [NSString stringWithFormat:@"¥%@",_dataDic[@"amount"]];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    _navigationBar.titleLabel.text = @"订单详情";
    
    /* 加载数据和视图*/
    [self setUpViews];
    
    
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
