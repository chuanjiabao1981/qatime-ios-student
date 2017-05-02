//
//  MyOrderViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "MyOrderViewController.h"

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
#import "WXApi.h"
#import "PayConfirmViewController.h"

#import "CYLTableViewPlaceHolder.h"
#import "HaveNoClassView.h"

/**刷新方式*/
typedef enum : NSUInteger {
    PullToRefresh,
    PushToLoadMore,
} RefreshType;

/**订单类型*/
typedef enum : NSUInteger {
    UnpaidType,
    PaidType,
    CancelType,
} OrderType;

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
    
    /* 余额*/
    CGFloat balance;
    
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


/** 主视图布局*/
- (void)setupOrderViews{
    
    /*加载页面视图*/
    _myOrderView = [[MyOrderView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64)];
    [self.view addSubview:_myOrderView];
    
    /* 设置代理*/
    _myOrderView.scrollView.delegate = self;
    _myOrderView.scrollView.tag=0;
    
    _myOrderView.unpaidView.delegate = self;
    _myOrderView.unpaidView.dataSource = self;
    _myOrderView.unpaidView.tag = 1;
    
    _myOrderView.unpaidView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [self requestDataWithRefreshType:PullToRefresh andOrderType:UnpaidType];
        
    }];
    
    _myOrderView.unpaidView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestDataWithRefreshType:PushToLoadMore andOrderType:UnpaidType];
    }];
    
    
    _myOrderView.paidView.delegate = self;
    _myOrderView.paidView.dataSource = self;
    _myOrderView.paidView.tag = 2;
    
    _myOrderView.paidView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self requestDataWithRefreshType:PullToRefresh andOrderType:PaidType];
        
    }];
    
    _myOrderView.paidView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestDataWithRefreshType:PushToLoadMore andOrderType:PaidType];
    }];

    
    _myOrderView.cancelView.delegate = self;
    _myOrderView.cancelView.dataSource = self;
    _myOrderView.cancelView.tag = 3;
    
    _myOrderView.cancelView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self requestDataWithRefreshType:PullToRefresh andOrderType:CancelType];
        
    }];
    
    _myOrderView.cancelView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestDataWithRefreshType:PushToLoadMore andOrderType:CancelType];
    }];
    
    /* 滑动效果*/
    typeof(self) __weak weakSelf = self;
    [ _myOrderView.segmentControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.myOrderView.scrollView scrollRectToVisible:CGRectMake(self.view.width_sd * index, 0, CGRectGetWidth(weakSelf.view.bounds), CGRectGetHeight(weakSelf.view.frame)-64) animated:YES];
        switch (index) {
                
            case 1:{
                if (paidPageTime==0) {
                    
                    [weakSelf.myOrderView.paidView.mj_header beginRefreshing];
                }
                paidPageTime ++;
                
            }
                break;
            case 2:{
                
                if (cancelPageTime == 0) {
                    
                    [weakSelf.myOrderView.cancelView.mj_header beginRefreshing];
                }
                cancelPageTime ++;
            }
                break;
        }
        
    }];
    
}


/**申请退款*/
- (void)repage:(UIButton *)sender{

    NSIndexPath *index = [NSIndexPath indexPathForRow:sender.tag - 400 inSection:0];

    PaidOrderTableViewCell *cell = [_myOrderView.paidView cellForRowAtIndexPath:index];

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
    
        [_myOrderView.unpaidView.mj_header beginRefreshingWithCompletionBlock:^{
            
        }];
    
    /* 微信支付成功的监听回调*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySucess) name:@"ChargeSucess" object:nil];
    
    /* 删除完订单后,刷新视图*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshPage) name:@"DeleteOrder" object:nil];
    
    /* 监听是否有重新下单,有下单的情况要请求未支付的订单.*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshPage) name:@"OrderSuccess" object:nil];
    
    /**退款成功的回调*/
    [[NSNotificationCenter defaultCenter]addObserverForName:@"RefundSuccess" object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
       
        [_myOrderView.paidView.mj_header beginRefreshing];
    }];
    
}

/* 刷新页面*/
- (void)refreshPage{
    
    //    _unpaidArr = @[].mutableCopy;
    
    //    /* 请求未支付的数据*/
    //    [self requestUnpaid];
    //
    //    /* 请求已支付数据*/
    //    [self requestPaid];
    //
    //    /* 请求取消的数据*/
    //    [self requestCanceld];
    
}

#pragma mark- 请求余额
- (void)requestBalance{
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/cash",Request_Header,_idNumber] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            balance = [dic[@"data"][@"balance"] floatValue];
            
        }else{
            
        }
        
    }];
}


/**
 请求数据方法
 
 @param refreshType 刷新方式,上滑/下拉
 @param orderType 订单类型/未支付/已支付/已取消
 */
- (void)requestDataWithRefreshType:(RefreshType)refreshType andOrderType:(OrderType)orderType{
    
    __block NSDictionary *dics ;
    
    if (refreshType == PullToRefresh) {
        
        if (orderType == UnpaidType) {
            
            unpaidPage = 1;
            _unpaidArr = @[].mutableCopy;
            
            dics = @{@"page":[NSString stringWithFormat:@"%ld",unpaidPage],
                     @"per_page":@"10",
                     @"cate":@"unpaid"};
        }else if (orderType == PaidType){
            paidPage = 1;
            _paidArr = @[].mutableCopy;
            dics = @{@"page":[NSString stringWithFormat:@"%ld",paidPage],
                     @"per_page":@"10",
                     @"cate":@"paid"};
            
        }else if (orderType == CancelType){
            
            cancelPage = 1;
            _caneldArr = @[].mutableCopy;
            dics = @{@"page":[NSString stringWithFormat:@"%ld",cancelPage],
                     @"per_page":@"10",
                     @"cate":@"canceled"};
        }
        
    }else{
        
        if (orderType == UnpaidType) {
            unpaidPage++;
            dics = @{@"page":[NSString stringWithFormat:@"%ld",unpaidPage],
                     @"per_page":@"10",
                     @"cate":@"unpaid"};
            
        }else if (orderType == PaidType){
            
            paidPage++;
            dics = @{@"page":[NSString stringWithFormat:@"%ld",paidPage],
                     @"per_page":@"10",
                     @"cate":@"paid"};
        }else if (orderType == CancelType){
            
            cancelPage++;
            dics = @{@"page":[NSString stringWithFormat:@"%ld",cancelPage],
                     @"per_page":@"10",
                     @"cate":@"canceled"};
        }
    }
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/payment/orders",Request_Header] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:dics completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            if ([dic[@"data"]count]!=0) {
                
                if (orderType == UnpaidType) {
                    
                    for (NSDictionary *unpaid in dic[@"data"]) {
                        Unpaid *mod = [Unpaid yy_modelWithJSON:unpaid];
                        mod.orderID = unpaid[@"id"];
                        [_unpaidArr addObject:mod];
                    }
                    
                    [_myOrderView.unpaidView.mj_header endRefreshing];
                    [_myOrderView.unpaidView.mj_footer endRefreshing];
                    [_myOrderView.unpaidView cyl_reloadData];
                    
                }else if(orderType == PaidType){
                    for (NSDictionary *paid in dic[@"data"]) {
                        Paid *mod = [Paid yy_modelWithJSON:paid];
                        mod.orderID = paid[@"id"];
                        [_paidArr addObject:mod];
                    }
                    [_myOrderView.paidView.mj_header endRefreshing];
                    [_myOrderView.paidView.mj_footer endRefreshing];
                    [_myOrderView.paidView cyl_reloadData];
                    
                }else if (orderType == CancelType){
                    
                    for (NSDictionary *cancel in dic[@"data"]) {
                        Canceld *mod = [Canceld yy_modelWithJSON:cancel];
                        mod.orderID = cancel[@"id"];
                        [_caneldArr addObject:mod];
                    }
                    [_myOrderView.cancelView.mj_header endRefreshing];
                    [_myOrderView.cancelView.mj_footer endRefreshing];
                    [_myOrderView.cancelView cyl_reloadData];
                }
            }else{
                
                if (refreshType == PushToLoadMore) {
                    if (orderType == UnpaidType) {
                        [_myOrderView.unpaidView.mj_footer endRefreshingWithNoMoreData];
                        [_myOrderView.unpaidView cyl_reloadData];
                        
                    }else if(orderType == PaidType){
                        [_myOrderView.paidView.mj_footer endRefreshingWithNoMoreData];
                        [_myOrderView.paidView cyl_reloadData];
                        
                    }else if (orderType == CancelType){
                        [_myOrderView.cancelView.mj_footer endRefreshingWithNoMoreData];
                        [_myOrderView.cancelView cyl_reloadData];
                    }

                }else{
                    if (orderType == UnpaidType) {
                        [_myOrderView.unpaidView.mj_header endRefreshing];
                        [_myOrderView.unpaidView cyl_reloadData];
                        
                    }else if(orderType == PaidType){
                        [_myOrderView.paidView.mj_header endRefreshing];
                        [_myOrderView.paidView cyl_reloadData];
                        
                    }else if (orderType == CancelType){
                        [_myOrderView.cancelView.mj_header endRefreshing];
                        [_myOrderView.cancelView cyl_reloadData];
                    }

                }
                
            }
        }else{
            
            
        }
        
        
    }];
    
}


#pragma mark- tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows = 0;
    
    switch (tableView.tag) {
       
        case 1:{
            rows =_unpaidArr.count;
        }
            break;
        case 2:{
            
            rows = _paidArr.count;
            
            
        }
            break;
        case 3:{
            
            
            rows = _caneldArr.count;
            
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
                
            }
            
            if (_unpaidArr.count>indexPath.row) {
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
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
                
            }
            
            if (_caneldArr.count>indexPath.row) {
                //                cell.leftButton.tag = 500+indexPath.row;
                cell.rightButton.tag = 600+indexPath.row;
                
                //                cell.leftButton.hidden = YES;
                //                [cell.rightButton setTitle:@"重新下单" forState:UIControlStateNormal];
                
                [cell.rightButton addTarget:self action:@selector(buyAgain:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                cell.canceldModel = _caneldArr[indexPath.row];
                
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
    
    NSInteger height = 140;
    
//    switch (tableView.tag) {
//        case 1:{
//            
//            Unpaid *model = _unpaidArr[indexPath.row];
//            
//            height= [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"unpaidModel" cellClass:[MyOrderTableViewCell class]contentViewWidth:self.view.width_sd];
//            //            height = 160;
//            
//        }
//            break;
//            
//        case 2:{
//            
//            
//            Paid *model = _paidArr[indexPath.row];
//            
//            height= [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"paidModel" cellClass:[PaidOrderTableViewCell class] contentViewWidth:self.view.width_sd];
//            
//            
//        }
//            break;
//        case 3:{
//            
//            
//            Paid *model = _caneldArr[indexPath.row];
//            
//            height= [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"canceldModel" cellClass:[CancelOrderTableViewCell class] contentViewWidth:self.view.width_sd];
//            
//            
//            
//        }
//            break;
//            
//    }
    
    
    return height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (tableView.tag) {
            
        case 1:{
            MyOrderTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            OrderInfoViewController *order = [[OrderInfoViewController alloc]initWithOrderInfos:cell.unpaidModel];
            [self.navigationController pushViewController:order animated:YES];
            
            
        }
            break;
            
        case 2:{
            
            PaidOrderTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            OrderInfoViewController *order = [[OrderInfoViewController alloc]initWithOrderInfos:cell.paidModel];
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
                                                                                @"app_pay_params":               cell.canceldModel.app_pay_params==nil?@"":cell.canceldModel.app_pay_params,
                                                                                @"productID":cell.canceldModel.orderID==nil?@"":cell.canceldModel.orderID}];
            
            
            OrderInfoViewController *order = [[OrderInfoViewController alloc]initWithOrderInfos:cell.canceldModel];
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
                    [self loginStates:dic];
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
        if (balance) {
            if (balance>=mod.price.floatValue) {
                PayConfirmViewController *confirm = [[PayConfirmViewController alloc]initWithData:@{
                                                                                                    @"id":mod.orderID==nil?@"":mod.orderID,
                                                                                                    @"pay_at":mod.pay_at==nil?@"":mod.pay_at,
                                                                                                    @"amount":mod.amount==nil?@"":mod.amount,
                                                                                                    @"created_at":mod.created_at==nil?@"":mod.created_at,
                                                                                                    @"source":@"app",
                                                                                                    @"pay_type":@"account",
                                                                                                    
                                                                                                    @"nonce_str":mod.nonce_str==nil?@"":mod.nonce_str,
                                                                                                    @"app_pay_str":@"",
                                                                                                    @"updated_at":mod.updated_at==nil?@"":mod.updated_at,
                                                                                                    @"prepay_id":mod.prepay_id==nil?@"":mod.prepay_id,
                                                                                                    @"app_pay_params":mod.app_pay_params==nil?@"":mod.app_pay_params,
                                                                                                    @"status":mod.status==nil?@"":mod.status}];
                [self.navigationController pushViewController:confirm animated:YES];
                
            }else{
                
                [self loadingHUDStopLoadingWithTitle:@"余额不足,请充值!"];
            }
        }else{
            [self requestBalance];
            [self loadingHUDStopLoadingWithTitle:@"正在获取余额数据,请稍后重试"];
        }
        
    }
    
}



/* 再次购买功能*/
- (void)buyAgain:(UIButton *)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定重新购买该课程?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }] ;
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self loadingHUDStopLoadingWithTitle:@"正在加载订单信息"];
        
        __block NSString *productNumber = [NSString string];
        __block NSString *payType=[NSString string];
        
        NSString *course;
        NSString *courseNumber;
        if (sender.tag>=600&&sender.tag<700) {
            
            Canceld *mod=_caneldArr[sender.tag-600];
            productNumber = mod.orderID;
            payType = @"account";
            
            //判断课程类型
            if ([mod.product_type isEqualToString:@"LiveStudio::Course"]) {
                //直播课
                course = @"courses";
                courseNumber = [NSString stringWithFormat:@"%@",mod.product[@"id"]];
                
            }else if ([mod.product_type isEqualToString:@"LiveStudio::VideoCourse"]){
                //视频课
                course = @"video_courses";
                courseNumber = [NSString stringWithFormat:@"%@",mod.product_video_course[@"id"]];
                
            }else if ([mod.product_type isEqualToString:@"LiveStudio::InteractiveCourse"]){
                //一对一
                course = @"interactive_courses";
                courseNumber = [NSString stringWithFormat:@"%@",mod.product_interactive_course[@"id"]];
            }
            
            /* 发送再次购买请求*/
            AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer =[AFHTTPResponseSerializer serializer];
            [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
            [manager POST:[NSString stringWithFormat:@"%@/api/v1/live_studio/%@/%@/orders",Request_Header,course,courseNumber] parameters:@{@"pay_type":mod.pay_type} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                [self loginStates:dic];
                
                if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
                    /* 订单申请成功*/
                    OrderViewController *orderVC = [[OrderViewController alloc]initWithClassID:mod.orderID andClassType:LiveClassType];
                    [self.navigationController pushViewController:orderVC animated:YES];
                    
                    
                }else{
                    if ([dic[@"error"][@"code"]isEqualToNumber:@3002]) {
                        [self loadingHUDStopLoadingWithTitle:@"您已经购买过该课程"];
                    }else{
                        
                        [self loadingHUDStopLoadingWithTitle:@"订单创建失败,请重试!"];
                    }
                    
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
        [self loginStates:dic];
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            /* 数据请求成功*/
            [self loadingHUDStopLoadingWithTitle:@"取消订单成功!"];
            
            if (tags>=100&&tags<200) {
                //                _unpaidArr = @[].mutableCopy;
                //                unpaidPageTime = 1;
                //                unpaidPage = 1;
                if (_unpaidArr.count==0) {
//                    [self requestUnpaid];
                    
                }else{
                    
                    [_unpaidArr removeObjectAtIndex:tags-100];
                    [_myOrderView.unpaidView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                    if (_unpaidArr.count == 0) {
//                        [self requestUnpaid];
                    }
                }
                
                
            }
            //            if (tags>=300&&tags<400) {
            //                _paidArr = @[].mutableCopy;
            //                paidPageTime = 1;
            //                paidPage = 1;
            //                [self requestPaid];
            //
            //            }
            
            
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
                    [_myOrderView.unpaidView.mj_header beginRefreshing];
                }else{
                    
                }
                unpaidPageTime ++;
            }
                break;
            case 1:{
                if (paidPageTime == 0) {
        
                    [_myOrderView.paidView.mj_header beginRefreshing];
                    
                }else{
                    
                }
                
                paidPageTime ++;
            }
                break;
            case 2:{
                if (cancelPageTime == 0) {
                    [_myOrderView.cancelView.mj_header beginRefreshing];
                    
                }else{
                    
                }
                
                cancelPageTime++;
                
            }
                break;
                
        }
        
        
    }else{
        
        
    }
}

- (UIView *)makePlaceHolderView{
    
    HaveNoClassView *view = [[HaveNoClassView alloc]init];
    view.titleLabel.text = @"无相关订单";
    
    return view;
}


- (BOOL)enableScrollWhenPlaceHolderViewShowing{
    
    return YES;
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
