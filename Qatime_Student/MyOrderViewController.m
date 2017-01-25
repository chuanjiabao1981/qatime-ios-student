//
//  MyOrderViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "MyOrderViewController.h"
#import "RDVTabBarController.h"
#import "Unpaid.h"
#import "Paid.h"
#import "Canceld.h"
#import "Refund.h"

#import "MyOrderTableViewCell.h"
#import "PaidOrderTableViewCell.h"
#import "CancelOrderTableViewCell.h"



#import "UIViewController+HUD.h"
#import "YYModel.h"
#import "MJRefresh.h"

#import "LoginAgainViewController.h"
#import "OrderViewController.h"
#import "MyOrderViewController.h"
#import "DrawBackViewController.h"
#import "HaveNoClassView.h"
#import "NSString+TimeStamp.h"

#import "OrderInfoViewController.h"
#import "ConfirmChargeViewController.h"
#import "UIViewController+AFHTTP.h"
#import "UIAlertController+Blocks.h"

@interface MyOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    
    NSString *_token;
    NSString *_idNumber;
    
    
    NavigationBar *_navigationBar;
    
    /* 保存数据的数组*/
    NSMutableArray *_unpaidArr;
    NSMutableArray *_paidArr;
    NSMutableArray *_caneldArr;
    NSMutableArray *_refundsArr;
    
    
    /* 页数*/
    NSInteger unpaidPage;
    NSInteger paidPage;
    NSInteger cancelPage;
    
    /* 选项卡选择次数*/
    NSInteger unpaidPageTime;
    NSInteger paidPageTime;
    NSInteger cancelPageTime;
    
}

@end

@implementation MyOrderViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        /* 数据初始化*/
        
        _unpaidArr = @[].mutableCopy;
        _paidArr = @[].mutableCopy;
        _caneldArr = @[].mutableCopy;
        _refundsArr = @[].mutableCopy;
        
        unpaidPage = 1;
        paidPage = 1;
        cancelPage = 1;
        
        unpaidPageTime = 1;
        paidPageTime = 0;
        cancelPageTime = 0;
        
    }
    return self;
}


/* 视图布局*/

/* 加载滚动视图*/
- (void)setupOrderViews{
    /*加载页面视图*/
    _myOrderView = ({
        
        MyOrderView *_ = [[MyOrderView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64)];
        
        /* 设置代理*/
        _.scrollView.delegate = self;
        _.scrollView.tag=0;
        
        /* 滑动效果*/
        typeof(self) __weak weakSelf = self;
        [ _.segmentControl setIndexChangeBlock:^(NSInteger index) {
            [weakSelf.myOrderView.scrollView scrollRectToVisible:CGRectMake(self.view.width_sd * index, 0, CGRectGetWidth(weakSelf.view.bounds), CGRectGetHeight(weakSelf.view.frame)-64) animated:YES];
            
            switch (index) {
                case 0:{
                    
                    [_unpaidView.tableView.mj_footer beginRefreshing];
                    
                }
                    break;
                case 1:{
                    
                    [_paidView.tableView.mj_footer beginRefreshing];
                    
                }
                    break;
                case 2:{
                    
                    [_cancelView.tableView.mj_footer beginRefreshing];
                }
                    break;
                    
            }
            
        }];
        [_.scrollView scrollRectToVisible:CGRectMake(-self.view.width_sd, 0, self.view.width_sd, self.view.height_sd) animated:YES];
        
        [self.view addSubview:_];
        _;
    });
    
}

/* 加载未支付页面*/
- (void)setupUnpaidViews{
    _unpaidView = ({
        UnpaidOrderView *_=[[UnpaidOrderView alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, _myOrderView.scrollView.height_sd)];
        _.tableView.delegate = self;
        _.tableView.dataSource = self;
        _.tableView.tag = 1;
        
        [_myOrderView.scrollView addSubview:_];
        
        _.tableView.tableFooterView = [[UIView alloc]init];
        _.tableView.tableHeaderView = [[UIView alloc]init];
        _.tableView.showsVerticalScrollIndicator=NO;
        _.tableView.showsHorizontalScrollIndicator=NO;
        
        _.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [_.tableView.mj_footer endRefreshingWithNoMoreData];
        }];
        
        _;
    });
    
    
}


/* 加载已支付页面*/

- (void)setupPaidView{
    
    _paidView = ({
        PaidOrderView *_=[[PaidOrderView alloc]initWithFrame:CGRectMake(self.view.width_sd, 0, self.view.width_sd, _myOrderView.scrollView.height_sd)];
        _.tableView.delegate = self;
        _.tableView.dataSource = self;
        _.tableView.tag = 2;
        _.tableView.tableFooterView = [[UIView alloc]init];
        [_myOrderView.scrollView addSubview:_];
        
        UIButton *but = [[UIButton alloc]init];
        [but setTitle:@"haha" forState:UIControlStateNormal];
        [but setTitleColor:TITLECOLOR forState:UIControlStateNormal];
        but.frame = CGRectMake(0, 100, 100, 100);
        [_paidView addSubview:but];
        [but addTarget:self action:@selector(repage:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            [_.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }];
        
        _;
    });
    
}


/* 加载取消页*/
- (void)setupCancelViews{
    
    _cancelView = ({
        CanceldOrderView *_=[[CanceldOrderView alloc]initWithFrame:CGRectMake(self.view.width_sd*2, 0, self.view.width_sd, _myOrderView.scrollView.height_sd)];
        _.tableView.delegate = self;
        _.tableView.dataSource = self;
        _.tableView.tag = 3;
        _.tableView.tableFooterView = [[UIView alloc]init];
        [_myOrderView.scrollView addSubview:_];
        //        _.sd_layout
        //        .leftSpaceToView(_paidView,0)
        //        .topSpaceToView(_myOrderView.scrollView,0)
        //        .bottomSpaceToView(_myOrderView.scrollView,0)
        //        .widthIs(self.view.width_sd);
        
        _.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            [_.tableView.mj_footer endRefreshingWithNoMoreData];
        }];
        
        _;
    });
    
}



- (void)repage:(UIButton *)sender{
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:sender.tag - 400 inSection:0];
    
    PaidOrderTableViewCell *cell = [_paidView.tableView cellForRowAtIndexPath:index];
    
    DrawBackViewController *new = [[DrawBackViewController alloc]initWithPaidOrder:cell.paidModel];
    
    [self.navigationController pushViewController:new animated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _navigationBar = ({
        NavigationBar *_=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
        _.titleLabel.text = @"我的订单";
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_];
        _;
    });
    
    /* 加载大滚动视图*/
    [self setupOrderViews];
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    
    /* 发起网络请求*/
    /* 请求未支付的数据*/
    [self requestUnpaid];
    
    /* 请求已支付数据*/
    [self requestPaid];
    
    /* 请求取消的数据*/
    [self requestCanceld];
    
    
    
    /* 微信支付成功的监听回调*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySucess) name:@"ChargeSucess" object:nil];
    
    /* 删除完订单后,刷新视图*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshPage) name:@"DeleteOrder" object:nil];
    
    
    
}

/* 刷新页面*/
- (void)refreshPage{
    
    /* 请求未支付的数据*/
    [self requestUnpaid];
    
    /* 请求已支付数据*/
    [self requestPaid];
    
    /* 请求取消的数据*/
    [self requestCanceld];
    
}


#pragma mark- 请求订单数据
- (void)requestUnpaid{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/payment/orders?cate=unpaid&per_page=6&page=%ld",Request_Header,unpaidPage] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            
            __block NSMutableArray *unpaidArr = [NSMutableArray arrayWithArray:dic[@"data"]];
            NSMutableArray *compArr = unpaidArr.copy;
            
            /* 获取数据成功*/
            if (unpaidArr.count !=0) {
                /* 有数据*/
                
                //                _unpaidView.hidden = NO;
                
                
                
                for (NSInteger i = 0; i<compArr.count; i++) {
                    
                    /* 遍历完,model赋值,写入数组*/
                    Unpaid *mod = [Unpaid yy_modelWithJSON:unpaidArr[i][@"product"]];
                    if (unpaidArr[i][@"app_pay_params"]) {
                        
                    }
                    
                    
                    
                    mod.status =[unpaidArr[i][@"status"]isEqual:[NSNull null]]?@"":unpaidArr[i][@"status"];
                    mod.pay_type = [unpaidArr[i][@"pay_type"]isEqual:[NSNull null]]?@"":unpaidArr[i][@"pay_type"];
                    mod.nonce_str =[unpaidArr[i][@"nonce_str"]isEqual:[NSNull null]]?@"":unpaidArr[i][@"nonce_str"];
                    mod.created_at =[unpaidArr[i][@"created_at"]isEqual:[NSNull null]]?@"":unpaidArr[i][@"created_at"];
                    mod.updated_at = [unpaidArr[i][@"updated_at"]isEqual:[NSNull null]]?@"":unpaidArr[i][@"updated_at"];
                    mod.pay_at =[unpaidArr[i][@"pay_at"]isEqual:[NSNull null]]?@"":unpaidArr[i][@"pay_at"];
                    
                    
                    if (![unpaidArr[i][@"app_pay_params"]isEqual:[NSNull null]]) {
                        
                        if (unpaidArr[i][@"app_pay_params"][@"appid"]) {
                            
                            mod.appid = unpaidArr[i][@"app_pay_params"][@"appid"];
                            mod.timestamp = unpaidArr[i][@"app_pay_params"][@"timestamp"];
                            mod.prepay_id = unpaidArr[i][@"prepay_id"];
                            
                            mod.app_pay_params =unpaidArr[i][@"app_pay_params"];
                        }
                    }else{
                        mod.appid =@"";
                    }
                    
                    
                    mod.orderID = [unpaidArr[i][@"id"]isEqual:[NSNull null]]?@"":unpaidArr[i][@"id"];
                    
                    [_unpaidArr addObject:mod];
                    
                    NSLog(@"%@",_unpaidArr[i]);
                }
                
                [_unpaidView.tableView.mj_footer endRefreshing];
                [self loadingHUDStopLoadingWithTitle:@"加载完成"];
                
                /* 加载未支付视图*/
                [self setupUnpaidViews];
                
            }else{
                /* 没更多的数据了*/
                
                HaveNoClassView *noDataView = [[HaveNoClassView alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, self.view.height_sd - 64 - _myOrderView.segmentControl.height_sd)];
                noDataView.titleLabel.text = @"暂时没有数据";
                [_myOrderView.scrollView addSubview:noDataView];
                
                [_unpaidView.tableView.mj_footer endRefreshingWithNoMoreData];
                
                [self loadingHUDStopLoadingWithTitle:@"没有符合条件的订单!"];
            }
            
        }else{
            
            /* 获取数据失败,需要用户重新登录*/
            //            _unpaidView.hidden = YES;
            [_unpaidView.tableView.mj_footer endRefreshingWithNoMoreData];
            [self loadingHUDStopLoadingWithTitle:@"没有符合条件的订单!"];
            
            //            [_unpaidView.mj_footer endRefreshingWithNoMoreData];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_unpaidView.tableView.mj_footer endRefreshing];
    }];
    
    
    
    
}

- (void)requestPaid{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/payment/orders?cate=paid&per_page=6&page=%ld",Request_Header,paidPage] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            /* 获取数据成功*/
            if ([dic[@"data"] count]!=0) {
                /* 有数据*/
                
                //                _paidView.hidden = NO;
                __block NSMutableArray *paidArr = [NSMutableArray arrayWithArray:dic[@"data"]];
                NSMutableArray *compArr = paidArr.copy;
                
                for (NSInteger i = 0; i<compArr.count; i++) {
                    /* 遍历完,model赋值,写入数组*/
                    Paid *mod = [Paid yy_modelWithJSON:paidArr[i][@"product"]];
                    
                    if (paidArr[i][@"app_pay_params"]&&![paidArr[i][@"app_pay_params"]isEqual:[NSNull null]]) {
                        
                    }
                    
                    
                    mod.status =[paidArr[i][@"status"] isEqual:[NSNull null]]?@"":paidArr[i][@"status"];
                    mod.pay_type = [paidArr[i][@"pay_type"]isEqual:[NSNull null]]?@"":paidArr[i][@"pay_type"];
                    
                    mod.created_at = [paidArr[i][@"created_at"]isEqual:[NSNull null]]?@"":paidArr[i][@"created_at"];
                    mod.pay_at =[paidArr[i][@"pay_at"]isEqual:[NSNull null]]?@"":paidArr[i][@"pay_at"];
                    mod.updated_at =[paidArr[i][@"updated_at"]isEqual:[NSNull null]]?@"":paidArr[i][@"updated_at"];
                    
                    
                    if (![paidArr[i][@"app_pay_params"]isEqual:[NSNull null]]) {
                        
                        if (paidArr[i][@"app_pay_params"][@"appid"]) {
                            
                            mod.appid = paidArr[i][@"app_pay_params"][@"appid"];
                            mod.timestamp = paidArr[i][@"app_pay_params"][@"timestamp"];
                            
                            mod.app_pay_params =paidArr[i][@"app_pay_params"];
                        }
                    }else{
                        mod.appid =@"";
                    }
                    
                    mod.orderID = [paidArr[i][@"id"]isEqual:[NSNull null]]?@"":paidArr[i][@"id"];
                    
                    
                    
                    [_paidArr addObject:mod];
                }
                
                //                [_paidView.tableView reloadData];
                //                [_paidView.tableView setNeedsDisplay];
                [_paidView.tableView.mj_footer endRefreshing];
                [self loadingHUDStopLoadingWithTitle:@"加载完成"];
                /* 加载已支付的视图*/
                [self setupPaidView];
                /* 没更多的数据了*/
                
            }else{
                /* 没更多的数据了*/
                
                if (_paidArr.count == 0) {
                    HaveNoClassView *noDataView = [[HaveNoClassView alloc]initWithFrame:CGRectMake(self.view.width_sd, 0, self.view.width_sd, self.view.height_sd - 64 - _myOrderView.segmentControl.height_sd)];
                    noDataView.titleLabel.text = @"暂时没有数据";
                    [_myOrderView.scrollView addSubview:noDataView];
                    
                }
                
                [_paidView.tableView.mj_footer endRefreshingWithNoMoreData];
                [self loadingHUDStopLoadingWithTitle:@"没有符合条件的订单!"];
                
            }
            
            //            [self loadingHUDStopLoadingWithTitle:@"加载完成"];
            
        }else{
            
            /* 获取数据失败,需要用户重新登录*/
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_paidView.tableView.mj_footer endRefreshing];
    }];
    
    
}
- (void) requestCanceld{
    
    //    [self loadingHUDStartLoadingWithTitle:@"正在加载数据"];
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/payment/orders?cate=canceled&per_page=6&page=%ld",Request_Header,cancelPage] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            /* 获取数据成功*/
            if ([dic[@"data"] count]!=0) {
                
                /* 有数据*/
                
                __block NSMutableArray *cancelArr = [NSMutableArray arrayWithArray:dic[@"data"]];
                
                NSMutableArray *compArr = cancelArr.copy;
                
                for (NSInteger i = 0; i<compArr.count; i++) {
                    
                    /* 遍历完,model赋值,写入数组*/
                    Canceld *mod = [Canceld yy_modelWithJSON:cancelArr[i][@"product"]];
                    
                    if (cancelArr[i][@"app_pay_params"]&&![cancelArr[i][@"app_pay_params"]isEqual:[NSNull null]]) {
                        
                    }
                    mod.status = [cancelArr[i][@"status"] isEqual:[NSNull null]]?@"":cancelArr[i][@"status"];
                    mod.pay_type = [cancelArr[i][@"pay_type"]isEqual:[NSNull null]]?@"":cancelArr[i][@"pay_type"];
                    
                    if (![cancelArr[i][@"app_pay_params"]isEqual:[NSNull null]]) {
                        
                        if (cancelArr[i][@"app_pay_params"][@"appid"]) {
                            
                            mod.appid = cancelArr[i][@"app_pay_params"][@"appid"];
                            mod.timestamp = cancelArr[i][@"app_pay_params"][@"timestamp"];
                            
                            mod.app_pay_params =cancelArr[i][@"app_pay_params"];
                        }
                    }else{
                        mod.appid =@"";
                    }
                    
                    mod.orderID = [cancelArr[i][@"id"]isEqual:[NSNull null]]?@"":cancelArr[i][@"id"];
                    [_caneldArr addObject:mod];
                }
                
                [self loadingHUDStopLoadingWithTitle:@"加载完成"];
                [_cancelView.tableView.mj_footer endRefreshing];
                
                /* 加载视图*/
                [self setupCancelViews];
                /* 没更多的数据了*/
                
            }else{
                /* 没更多的数据了*/
                
                if (_caneldArr.count == 0) {
                    HaveNoClassView *noDataView = [[HaveNoClassView alloc]initWithFrame:CGRectMake(self.view.width_sd*2, 0, self.view.width_sd, self.view.height_sd - 64 - _myOrderView.segmentControl.height_sd)];
                    noDataView.titleLabel.text = @"暂时没有数据";
                    [_myOrderView.scrollView addSubview:noDataView];
                    
                }
                [_cancelView.tableView.mj_footer endRefreshingWithNoMoreData];
                [self loadingHUDStopLoadingWithTitle:@"没有符合条件的订单!"];
                
            }
            
            
            //            [self loadingHUDStopLoadingWithTitle:@"加载完成"];
            
        }else{
            
            /* 获取数据失败,需要用户重新登录*/
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_cancelView.tableView.mj_footer endRefreshing];
    }];
    
    
}




#pragma mark- tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows = 10;
    
    switch (tableView.tag) {
        case 1:{
            if (_unpaidArr.count!=0) {
                
                rows =_unpaidArr.count;
            }
            
        }
            break;
        case 2:{
            if (_paidArr.count!=0) {
                rows = _paidArr.count;
            }
            
        }
            break;
        case 3:{
            
            if (_caneldArr.count!=0) {
                rows = _caneldArr.count;
            }
        }
            break;
        case 4:{
            
            if (_refundsArr.count!=0) {
                rows = _refundsArr.count;
            }
        }
            break;
            
    }
    
    
    
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [UITableViewCell new];
    
    switch (tableView.tag) {
        case 1:{
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            MyOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[MyOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
                cell.sd_tableView = tableView;
            }
            
            if (_unpaidArr.count>indexPath.row) {
                
                cell.unpaidModel = _unpaidArr[indexPath.row];
                cell.leftButton.tag = 100+indexPath.row;
                cell.rightButton.tag = 200+indexPath.row;
                [cell.leftButton addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
                [cell.rightButton addTarget:self action:@selector(payOrder:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell.leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
            }
            
            
            return  cell;
        }
            
            break;
        case 2:{
            
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            PaidOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[PaidOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
                cell.sd_tableView = tableView;
            }
            
            if (_paidArr.count>indexPath.row) {
                
                cell.paidModel = _paidArr[indexPath.row];
                cell.leftButton.hidden= YES;
                
                
                cell.rightButton.tag = 400+indexPath.row;
                
                /* 进入退款申请页面*/
                [cell.rightButton setTitle:@"申请退款" forState:UIControlStateNormal];
                [cell.rightButton addTarget:self action:@selector(repage:) forControlEvents:UIControlEventTouchUpInside];
                
                if ([cell.paidModel.status isEqualToString:@"refunding"]){
                    /* 取消退款申请*/
                    [cell.rightButton setTitle:@"取消退款" forState:UIControlStateNormal];
                    
                    [cell.rightButton removeTarget:self action:@selector(repage:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.rightButton addTarget:self action:@selector(cancelRefund:) forControlEvents:UIControlEventTouchUpInside];
                }else if ([cell.paidModel.status isEqualToString:@"completed"]){
                    
                }
                
            }
            
            return cell;
            
        }
            break;
        case 3:{
            
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            CancelOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[CancelOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
                cell.leftButton.tag = 500+indexPath.row;
                cell.rightButton.tag = 600+indexPath.row;
                
                [cell.leftButton setTitle:@"删除订单" forState:UIControlStateNormal];
                cell.leftButton.hidden = YES;
                [cell.rightButton setTitle:@"重新购买" forState:UIControlStateNormal];
                
                
                
                [cell.rightButton addTarget:self action:@selector(buyAgain:) forControlEvents:UIControlEventTouchUpInside];
                
                
                cell.sd_tableView = tableView;
                
            }
            
            if (_caneldArr.count>indexPath.row) {
                
                cell.canceldModel = _caneldArr[indexPath.row];
                cell.leftButton.tag = 500+indexPath.row;
                cell.rightButton.tag = 600+indexPath.row;
                //                [cell.leftButton addTarget:self action:@selector(repage:) forControlEvents:UIControlEventTouchUpInside];
                
                
                
            }
            
            return  cell;
            
            
        }
            break;
            
            
            
    }
    
    
    
    return cell;
    
}

#pragma mark- tableview delegate




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger height;
    
    switch (tableView.tag) {
        case 1:{
            
            if (_unpaidArr.count>indexPath.row) {
                
                Unpaid *model = _unpaidArr[indexPath.row];
                
                height= [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"unpaidModel" cellClass:[MyOrderTableViewCell class] contentViewWidth:self.view.width_sd];
            }
            
        }
            break;
            
        case 2:{
            
            if (_paidArr.count>indexPath.row) {
                
                Paid *model = _paidArr[indexPath.row];
                
                height= [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"paidModel" cellClass:[PaidOrderTableViewCell class] contentViewWidth:self.view.width_sd];
            }
            
        }
            break;
        case 3:{
            
            if (_caneldArr.count>indexPath.row) {
                
                Paid *model = _caneldArr[indexPath.row];
                
                height= [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"canceldModel" cellClass:[CancelOrderTableViewCell class] contentViewWidth:self.view.width_sd];
            }
            
            
        }
            break;
            
    }
    
    
    return height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (tableView.tag) {
            
        case 1:{
            MyOrderTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            
            //            NSDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{
            //                                                                                @"name":cell.unpaidModel.name,
            //                                                                                @"subject":cell.unpaidModel.subject,
            //                                                                                @"grade":cell.unpaidModel.grade,
            //                                                                                @"lessonTime":cell.unpaidModel.preset_lesson_count,
            //                                                                                @"teacherName":cell.unpaidModel.teacher_name,
            //                                                                                @"creatTime":cell.unpaidModel.created_at==nil?@"无":[cell.unpaidModel.created_at timeStampToDate],
            //                                                                                @"payTime":cell.unpaidModel.pay_at==nil?@"无":cell.unpaidModel.pay_at,
            //                                                                                @"payType":cell.unpaidModel.pay_type==nil?@"":cell.unpaidModel.pay_type,
            //                                                                                @"amount":cell.unpaidModel.price,
            //                                                                                @"status":cell.unpaidModel.status,
            //                                                                                @"orderNumber":cell.unpaidModel.orderID,
            //                                                                                @"app_pay_params":
            //                                                                                   cell.unpaidModel.app_pay_params==nil?@"":cell.unpaidModel.app_pay_params
            //                                                                                }];
            
            
            OrderInfoViewController *order = [[OrderInfoViewController alloc]initWithUnpaid:cell.unpaidModel];
            [self.navigationController pushViewController:order animated:YES];
            
            
        }
            break;
            
        case 2:{
            
            PaidOrderTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            //            NSDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{
            //                                                                                @"name":cell.paidModel.name,
            //                                                                                @"subject":cell.paidModel.subject,
            //                                                                                @"grade":cell.paidModel.grade,
            //                                                                                @"lessonTime":cell.paidModel.preset_lesson_count,
            //                                                                                @"teacherName":cell.paidModel.teacher_name,
            //                                                                                @"creatTime":cell.paidModel.created_at==nil?@"无":[cell.paidModel.created_at timeStampToDate],
            //                                                                                @"payTime":cell.paidModel.pay_at==nil?@"无":[cell.paidModel.pay_at timeStampToDate],
            //                                                                                @"payType":cell.paidModel.pay_type,
            //                                                                                @"amount":cell.paidModel.price,
            //                                                                                @"status":cell.paidModel.status,
            //                                                                                @"orderNumber":cell.paidModel.orderID,
            //                                                                                @"app_pay_params":               cell.paidModel.app_pay_params==nil?@"":cell.paidModel.app_pay_params                                                                             }];
            
            
            OrderInfoViewController *order = [[OrderInfoViewController alloc]initWithPaid:cell.paidModel];
            [self.navigationController pushViewController:order animated:YES];
            
        }
            break;
            
            
        case 3: {
            
            CancelOrderTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            
            NSDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"name":cell.canceldModel.name,
                                                                                @"subject":cell.canceldModel.subject,
                                                                                @"grade":cell.canceldModel.grade,
                                                                                @"lessonTime":cell.canceldModel.preset_lesson_count,
                                                                                @"teacherName":cell.canceldModel.teacher_name,
                                                                                @"creatTime":cell.canceldModel.created_at==nil?@"无":[cell.canceldModel.created_at timeStampToDate],
                                                                                @"payTime":cell.canceldModel.pay_at==nil?@"无":[cell.canceldModel.pay_at timeStampToDate],
                                                                                @"payType":cell.canceldModel.pay_type,
                                                                                @"amount":cell.canceldModel.price,
                                                                                @"status":cell.canceldModel.status,
                                                                                @"orderNumber":cell.canceldModel.orderID,
                                                                                @"app_pay_params":               cell.canceldModel.app_pay_params==nil?@"":cell.canceldModel.app_pay_params
                                                                                }];
            
            
            OrderInfoViewController *order = [[OrderInfoViewController alloc]initWithInfo:dic];
            [self.navigationController pushViewController:order animated:YES];
            
        }
            
            break;
            
            
    }
    
    
}


/* 取消退款功能*/
- (void)cancelRefund:(UIButton *)sender{
    
    //    [self loadingHUDStartLoadingWithTitle:@"正在取消"];
    if (sender.tag>=400&&sender.tag<500) {
        Paid *mod = _paidArr[sender.tag-400];
        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"确定取消退款?" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex!=0) {
                
                [self PUTSessionURL:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/refunds/%@/cancel",Request_Header,_idNumber,mod.orderID] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
                    
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
                    if ([dic[@"status"]isEqualToNumber:@1]) {
                        [self loadingHUDStopLoadingWithTitle:@"取消成功"];
                    }else{
                        [self loadingHUDStopLoadingWithTitle:@"服务器正忙,取消失败"];
                        
                    }
                    
                }];
            }
        }];
    }
    
}

/* 订单付款功能*/
- (void)payOrder:(UIButton *)sender{
    
    if (sender.tag>=200&&sender.tag<300) {
        /* 取消订单的左边按钮->取消订单*/
        
        Unpaid *mod =_unpaidArr[sender.tag-200];
        ConfirmChargeViewController *confirm = [[ConfirmChargeViewController alloc]initWithPayModel:mod];
        [self.navigationController pushViewController:confirm animated:YES];
        
        
    }
    
}



/* 再次购买功能*/
- (void)buyAgain:(UIButton *)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定重新够买该课程?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }] ;
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self loadingHUDStopLoadingWithTitle:@"正在加载订单信息"];
        
        __block NSString *productNumber = [NSString string];
        __block NSString *payType=[NSString string];
        if (sender.tag>=600&&sender.tag<700) {
            
            Canceld *mod=_caneldArr[sender.tag-600];
            productNumber = mod.productID;
            payType = mod.pay_type;
            
            /* 发送再次购买请求*/
            
            AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer =[AFHTTPResponseSerializer serializer];
            [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
            [manager POST:[NSString stringWithFormat:@"%@/api/v1/live_studio/courses/%@/orders",Request_Header,productNumber] parameters:@{@"pay_type":mod.pay_type} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
                    /* 订单申请成功*/
                    OrderViewController *orderVC = [[OrderViewController alloc]initWithClassID:mod.productID];
                    [self.navigationController pushViewController:orderVC animated:YES];
                    
                    
                }else{
                    
                    
                    [self loadingHUDStopLoadingWithTitle:@"订单创建失败,请重试!"];
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
        }
    }] ;
    
    [alert addAction:cancel];
    [alert addAction:sure];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}




#pragma mark- 购买成功后,跳转页面
- (void)paySucess{
    
    if (_caneldArr) {
        
        MyOrderViewController *myorderVC = [[MyOrderViewController alloc]init];
        UIViewController *controller = nil;
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[myorderVC class]]) {
                controller = vc;
            }
        }
        
        [self.navigationController popToViewController:controller animated:YES];
        
    }
    
}




/* 取消订单*/

- (void)cancelOrder:(UIButton *)sender{
    
    //    [self loadingHUDStartLoadingWithTitle:@"正在订单"];
    
    __block NSString *oderNumber = [NSString string];
    
    if (sender.tag>=100&&sender.tag<200) {
        /* 取消订单的左边按钮->取消订单*/
        
        Unpaid *mod =_unpaidArr[sender.tag-100];
        oderNumber = mod.orderID;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否取消此订单?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }] ;
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            [self requestCancelOrder:oderNumber withTag:sender.tag];
            
        }] ;
        
        [alert addAction:cancel];
        [alert addAction:sure];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
    
    if (sender.tag>=300&&sender.tag<400) {
        
        /* 取消订单的左边按钮->取消订单*/
        
        Paid *mod =_paidArr[sender.tag-300];
        oderNumber = mod.orderID;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否取消此订单?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }] ;
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            [self requestCancelOrder:oderNumber withTag:sender.tag];
            
        }] ;
        
        [alert addAction:cancel];
        [alert addAction:sure];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    
}


/* 申请取消订单*/
- (void)requestCancelOrder:(NSString *)oderNumber withTag:(NSInteger)tags{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager PUT:[NSString stringWithFormat:@"%@/api/v1/payment/orders/%@/cancel",Request_Header,oderNumber] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            /* 数据请求成功*/
            [self loadingHUDStopLoadingWithTitle:@"取消订单成功!"];
            
            if (tags>=100&&tags<200) {
                _unpaidArr = @[].mutableCopy;
                unpaidPageTime = 1;
                unpaidPage = 1;
                [self requestUnpaid];
                
            }
            if (tags>=300&&tags<400) {
                _paidArr = @[].mutableCopy;
                paidPageTime = 1;
                paidPage = 1;
                [self requestPaid];
                
            }
            
            
        }else if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:0]]){
            if ([dic[@"error"][@"msg"]isEqualToString:@"授权过期"]) {
                /* 登录过期 得重新登录了*/
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录过期!请重新登录" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }] ;
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    /* 重新登录*/
                    
                    LoginAgainViewController *laVC = [LoginAgainViewController new];
                    [self.navigationController pushViewController:laVC animated:YES];
                    
                    
                }] ;
                
                [alert addAction:cancel];
                [alert addAction:sure];
                
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}



// segment的滑动代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    
    if (scrollView == _myOrderView.scrollView) {
        
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        
        [_myOrderView.segmentControl setSelectedSegmentIndex:page animated:YES];
        
        switch (page) {
            case 0:{
                if (unpaidPageTime == 0) {
                    
                    //                    [self loadingHUDStartLoadingWithTitle:@"正在加载"];
                    
                    [_unpaidView.tableView.mj_footer beginRefreshing];
                    
                    
                }else{
                    
                }
                unpaidPageTime ++;
            }
                break;
            case 1:{
                if (paidPageTime == 0) {
                    //                    [self loadingHUDStartLoadingWithTitle:@"正在加载"];
                    [_paidView.tableView.mj_footer beginRefreshing];
                    
                }else{
                    
                }
                
                paidPageTime ++;
            }
                break;
            case 2:{
                if (cancelPageTime == 0) {
                    //                    [self loadingHUDStartLoadingWithTitle:@"正在加载"];
                    
                    [_cancelView.tableView.mj_footer beginRefreshing];
                    
                }else{
                    
                }
                
                cancelPageTime++;
                
            }
                break;
                
        }
        
        
    }else{
        
        
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
