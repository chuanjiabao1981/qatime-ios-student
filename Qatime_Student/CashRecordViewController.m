//
//  CashRecordViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "CashRecordViewController.h"
#import "NavigationBar.h"
#import "UIViewController+HUD.h"
#import "YYModel.h"
#import "RechargeTableViewCell.h"
#import "WithDrawTableViewCell.h"
#import "PaymentTableViewCell.h"
#import "RefundTableViewCell.h"
 

#import "Recharge.h"
#import "WithDraw.h"
#import "Payment.h"
#import "Refund.h"

#import "HaveNoClassView.h"

#import "UIViewController+HUD.h"
#import "UIAlertController+Blocks.h"
#import "ConfirmChargeViewController.h"
#import "UIViewController+AFHTTP.h"

#import "DrawBackViewController.h"
#import "MJRefresh.h"
#import "CYLTableViewPlaceHolder.h"

//刷新方式
typedef NS_ENUM(NSUInteger, RefreshType) {
    PullToRefresh,
    PushToLoadMore,
};

@interface CashRecordViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    
    NavigationBar *_navigationBar;
    
    /* 选择跳转框*/
    
    //   NSInteger selectedItem;
    
    NSString *_token;
    NSString *_idNumber;
    
    
    /* 展示数据的model的保存数组*/
    NSMutableArray *_rechargeArr;
    NSMutableArray *_withDrawArr;
    NSMutableArray *_paymentArr;
    NSMutableArray *_refundArr;
    
    //4个页数
    NSInteger _recahrgePage;
    NSInteger _withdrawPage;
    NSInteger _paymentPage;
    NSInteger _refundPage;
    
}

@property(nonatomic,strong) NSString *selectedItem ;

@end

@implementation CashRecordViewController

- (instancetype)initWithSelectedItem:(NSInteger)item
{
    self = [super init];
    if (self) {
        
        _selectedItem = [NSString stringWithFormat:@"%ld",item];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //导航栏
    [self setupNavigation];
    //基础数据
    [self makeData];
    //主视图
    [self setupMainView];
    
    
    [_mainView.rechargeView.mj_header beginRefreshing];
    [_mainView.withDrawView.mj_header beginRefreshing];
    [_mainView.paymentView.mj_header beginRefreshing];
    [_mainView.refundView.mj_header beginRefreshing];
    
}


- (void)makeData{
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    /* 初始化数据*/
    _rechargeArr = @[].mutableCopy;
    _withDrawArr = @[].mutableCopy;
    _paymentArr = @[].mutableCopy;
    _refundArr = @[].mutableCopy;
    
    _refundPage = 1;
    _withdrawPage = 1;
    _paymentPage = 1;
    _refundPage = 1;

    
}

- (void)setupNavigation{
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), Navigation_Height)];
    [self.view addSubview:_navigationBar];
    _navigationBar.titleLabel.text = @"资金记录";
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBar.rightButton setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
    [_navigationBar.rightButton addTarget:self action:@selector(callForServiece) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupMainView{
    
    /* view的初始化*/
    _mainView = ({
        
        CashRecordView *_ = [[CashRecordView alloc]initWithFrame:CGRectMake(0, Navigation_Height, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-Navigation_Height)];
        [self.view addSubview:_];
        _;
    });
    
    _mainView.rechargeView.delegate = self;
    _mainView.rechargeView.dataSource = self;
    _mainView.rechargeView.tag = 1;
    
    _mainView.withDrawView.delegate = self;
    _mainView.withDrawView.dataSource = self;
    _mainView.withDrawView.tag = 2;
    
    _mainView.paymentView.delegate = self;
    _mainView.paymentView.dataSource = self;
    _mainView.paymentView.tag = 3;
    
    _mainView.refundView.delegate = self;
    _mainView.refundView.dataSource = self;
    _mainView.refundView.tag = 4;
    
    _mainView.scrollView.delegate = self;
    
    
    //刷新方式
    _mainView.rechargeView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [self requestRechargeWithRefreshType:PullToRefresh];
    }];
    _mainView.rechargeView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
       
        [self requestRechargeWithRefreshType:PushToLoadMore];
    }];
    
    
    _mainView.withDrawView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self requestWithDrawWithRefreshType:PullToRefresh];
    }];
    _mainView.withDrawView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self requestWithDrawWithRefreshType:PushToLoadMore];
    }];
    
    
    _mainView.paymentView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self requestPaymentWithRefreshType:PullToRefresh];
    }];
    _mainView.paymentView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self requestPaymentWithRefreshType:PushToLoadMore];
    }];
    
    
    _mainView.refundView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self requestRefundWithRefreshType:PullToRefresh];
    }];
    _mainView.refundView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self requestRefundWithRefreshType:PushToLoadMore];
    }];
    
    
    /* 滑动效果*/
    typeof(self) __weak weakSelf = self;
    [ _mainView.segmentControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.mainView.scrollView scrollRectToVisible:CGRectMake(self.view.width_sd * index, 0, CGRectGetWidth(weakSelf.view.bounds), CGRectGetHeight(weakSelf.view.frame)-Navigation_Height-40) animated:YES];
    }];
    
    [_mainView.scrollView scrollRectToVisible:CGRectMake(self.view.width_sd*(_selectedItem.integerValue-1), 0, self.view.width_sd, self.view.height_sd) animated:YES];
    
    _mainView.segmentControl.selectedSegmentIndex = _selectedItem.integerValue;
    
}




/* 拨打客服电话*/
- (void)callForServiece{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"0353-2135828"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}

#pragma mark- 请求充值记录数据
- (void)requestRechargeWithRefreshType:(RefreshType)refreshType{
    
    if (refreshType == PullToRefresh) {
        _rechargeArr = @[].mutableCopy;
        _refundPage = 1;
        [_mainView.rechargeView.mj_footer resetNoMoreData];
        
    }else{
        _refundPage++;
    }
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/recharges",Request_Header,_idNumber] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:@{@"page":[NSString stringWithFormat:@"%ld",_refundPage]} completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil] ;
        
        [self loginStates:dic];
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            
            NSMutableArray *dataArr = [NSMutableArray arrayWithArray:[dic valueForKey:@"data"]];
            
            if (dataArr.count !=0) {
                for (NSInteger i = 0; i<dataArr.count; i++) {
                    Recharge *mod = [Recharge yy_modelWithJSON:dataArr[i]];
                    mod.idNumber = [dataArr[i] valueForKey:@"id"];
                    /* 目前暂不支持支付宝,预留支付宝的筛选接口*/
                    if ([[dataArr[i] valueForKey:@"pay_type"]isEqualToString:@"alipay"]) {
                        mod.timeStamp = @"无";
                    }else{
                        
                        NSString *timeStamp = [[dataArr[i] valueForKey:@"app_pay_params"]valueForKey:@"timestamp"];
                        if (![timeStamp isEqual:[NSNull null]]) {
                            
                            NSTimeInterval time=[timeStamp integerValue]+28800;//因为时差问题要加8小时 == 28800 sec
                            NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
                            
                            //实例化一个NSDateFormatter对象
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                            //设定时间格式,这里可以设置成自己需要的格式
                            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                            NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
                            
                            mod.timeStamp = currentDateStr;
                        }else{
                            mod.timeStamp = @"";
                        }
                    }
                    
                    [_rechargeArr addObject:mod];
                    
                }
                
                [_mainView.rechargeView cyl_reloadData];
                if (refreshType == PullToRefresh) {
                    [_mainView.rechargeView.mj_header endRefreshing];
                }else{
                    [_mainView.rechargeView.mj_footer endRefreshing];
                }
                
                
            }else{
                
                /* 没有充值记录*/
                [_mainView.rechargeView cyl_reloadData];
                
                if (refreshType == PullToRefresh) {
                    [_mainView.rechargeView.mj_header endRefreshing];
                }else{
                    [_mainView.rechargeView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            
        }else{
            
            /* 数据为0条*/
            [_mainView.rechargeView cyl_reloadData];
            
            if (refreshType == PullToRefresh) {
                [_mainView.rechargeView.mj_header endRefreshing];
            }else{
                [_mainView.rechargeView.mj_footer endRefreshing];
            }
            
        }
        

    } failure:^(id  _Nullable erros) {
        
        [_mainView.rechargeView cyl_reloadData];
        
        if (refreshType == PullToRefresh) {
            [_mainView.rechargeView.mj_header endRefreshing];
        }else{
            [_mainView.rechargeView.mj_footer endRefreshing];
        }
    }];
}




#pragma mark- 请求提现数据
- (void)requestWithDrawWithRefreshType:(RefreshType)refreshType{
    
    if (refreshType == PullToRefresh) {
        _withDrawArr = @[].mutableCopy;
        _withdrawPage = 1;
        [_mainView.withDrawView.mj_footer resetNoMoreData];
        
    }else{
        
        _withdrawPage++;
    }
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/withdraws",Request_Header,_idNumber] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:@{@"page":[NSString stringWithFormat:@"%ld",_withdrawPage]} completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil] ;
        [self loginStates:dic];
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            /* 获取数据成功  数据写到rechararr数组里*/
            NSMutableArray *withDraw = [NSMutableArray arrayWithArray:dic[@"data"]];
            if (withDraw.count!=0) {
                for (NSInteger i = 0; i<withDraw.count; i++) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:withDraw[i]];
                    for (NSString *key in withDraw[i]) {
                        if ([dic valueForKey:key]==nil||[[dic valueForKey:key]isEqual:[NSNull null]]) {
                            [dic setValue:@"" forKey:key];
                        }
                    }
                    WithDraw *wiMod = [WithDraw yy_modelWithJSON:dic];
                    [_withDrawArr addObject:wiMod];
                }
                
                [_mainView.withDrawView cyl_reloadData];
                if (refreshType == PullToRefresh) {
                    [_mainView.withDrawView.mj_header endRefreshing];
                }else{
                    [_mainView.withDrawView.mj_footer endRefreshing];
                }

            }else{
                
                [_mainView.withDrawView cyl_reloadData];
                if (refreshType == PullToRefresh) {
                    [_mainView.withDrawView.mj_header endRefreshing];
                }else{
                    [_mainView.withDrawView.mj_footer endRefreshingWithNoMoreData];
                }
 
            }
            
        }else{
            [_mainView.withDrawView cyl_reloadData];
            if (refreshType == PullToRefresh) {
                [_mainView.withDrawView.mj_header endRefreshing];
            }else{
                [_mainView.withDrawView.mj_footer endRefreshing];
            }

        }

    }failure:^(id  _Nullable erros) {
        [_mainView.withDrawView cyl_reloadData];
        if (refreshType == PullToRefresh) {
            [_mainView.withDrawView.mj_header endRefreshing];
        }else{
            [_mainView.withDrawView.mj_footer endRefreshing];
        }

    }];

}


#pragma mark- 请求消费记录
- (void)requestPaymentWithRefreshType:(RefreshType)refreshType{
    
    if (refreshType == PullToRefresh) {
        
        _paymentArr = @[].mutableCopy;
        _paymentPage = 1;
        [_mainView.paymentView.mj_footer resetNoMoreData];
        
    }else{
        _paymentPage++;
    }
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/consumption_records",Request_Header,_idNumber] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:@{} completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil] ;
        
        [self loginStates:dic];
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            
            /* 获取数据成功  数据写到数组里*/
            NSMutableArray *payment = [NSMutableArray arrayWithArray:dic[@"data"]];
            if (payment.count!=0) {
                for (NSInteger i = 0; i<payment.count; i++) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:payment[i]];
                    for (NSString *key in payment[i]) {
                        if ([dic valueForKey:key]==nil||[[dic valueForKey:key]isEqual:[NSNull null]]) {
                            [dic setValue:@"" forKey:key];
                            
                        }
                    }
                    
                    Payment *payMod = [Payment yy_modelWithJSON:dic];
                    payMod.idNumber = payment[i][@"id"];
                    [_paymentArr addObject:payMod];
                    
                }
                [_mainView.paymentView cyl_reloadData];
                if (refreshType == PullToRefresh) {
                    [_mainView.paymentView.mj_header endRefreshing];
                }else{
                    [_mainView.paymentView.mj_footer endRefreshing];
                }
                
            }else{
                
                [_mainView.paymentView cyl_reloadData];
                if (refreshType == PullToRefresh) {
                    [_mainView.paymentView.mj_header endRefreshing];
                }else{
                    [_mainView.paymentView.mj_footer endRefreshingWithNoMoreData];
                }

                
            }
            
            
        }else{
            [_mainView.paymentView cyl_reloadData];
            if (refreshType == PullToRefresh) {
                [_mainView.paymentView.mj_header endRefreshing];
            }else{
                [_mainView.paymentView.mj_footer endRefreshing];
            }
        }
        
    } failure:^(id  _Nullable erros) {
        [_mainView.paymentView cyl_reloadData];
        if (refreshType == PullToRefresh) {
            [_mainView.paymentView.mj_header endRefreshing];
        }else{
            [_mainView.paymentView.mj_footer endRefreshing];
        }
    }];
    
}


#pragma mark- 请求退款记录
- (void)requestRefundWithRefreshType:(RefreshType)refreshType{
    
    if (refreshType==PullToRefresh) {
        
        _refundArr = @[].mutableCopy;
        _refundPage = 1;
        [_mainView.rechargeView.mj_footer resetNoMoreData];
        
    }else{
        
        _refundPage++;
    }
    
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/refunds",Request_Header,_idNumber] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
       
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil] ;
        [self loginStates:dic];
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            /* 获取数据成功  数据写到rechararr数组里*/
            NSMutableArray *refund = [NSMutableArray arrayWithArray:dic[@"data"]];
            if (refund.count!=0) {
                for (NSInteger i = 0; i<refund.count; i++) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:refund[i]];
                    for (NSString *key in refund[i]) {
                        
                        if ([dic valueForKey:key]==nil||[[dic valueForKey:key]isEqual:[NSNull null]]) {
                            [dic setValue:@"" forKey:key];
                            
                        }
                    }
                    Refund *refundMod = [Refund yy_modelWithJSON:dic];
                    refundMod.idNumber = refund[i][@"id"];
                    [_refundArr addObject:refundMod];
                    
                }
                
                [_mainView.refundView cyl_reloadData];
                if (refreshType==PullToRefresh) {
                    
                    [_mainView.refundView.mj_header endRefreshing];
                    
                }else{
                    [_mainView.refundView.mj_footer endRefreshing];
                }
                
            }else{
                
                [_mainView.refundView cyl_reloadData];
                if (refreshType==PullToRefresh) {
                    
                    [_mainView.refundView.mj_header endRefreshing];
                    
                }else{
                    [_mainView.refundView.mj_footer endRefreshingWithNoMoreData];
                }
                
            }
            
        }else{
            [_mainView.refundView cyl_reloadData];
            if (refreshType==PullToRefresh) {
                
                [_mainView.refundView.mj_header endRefreshing];
                
            }else{
                [_mainView.refundView.mj_footer endRefreshing];
            }

            
        }

    }failure:^(id  _Nullable erros) {
        
        [_mainView.refundView cyl_reloadData];
        if (refreshType==PullToRefresh) {
            
            [_mainView.refundView.mj_header endRefreshing];
            
        }else{
            [_mainView.refundView.mj_footer endRefreshing];
        }

        
    }];

}


#pragma mark- tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows = 0 ;
    
    
    switch (tableView.tag) {
        case 1:{
            if (_rechargeArr.count!=0) {
                rows = _rechargeArr.count;
            }
            
        }
            break;
        case 2:{
            if (_withDrawArr.count!=0) {
                rows = _withDrawArr.count;
            }
            
        }
            break;
            
        case 3:{
            if (_paymentArr.count!=0) {
                rows = _paymentArr.count;
            }
            
        }
            break;
            
        case 4:{
            if (_refundArr.count!=0) {
                rows = _refundArr.count;
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
            RechargeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[RechargeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
            }
            
            
            if (_rechargeArr.count >indexPath.row) {
                
                cell.model  = _rechargeArr[indexPath.row];
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            }
            
            return  cell;
            
        }
            
            break;
            
        case 2:{
            
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            WithDrawTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[WithDrawTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
            }
            
            
            if (_withDrawArr.count >indexPath.row) {
                
                cell.model  = _withDrawArr[indexPath.row];
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                
                
            }
            
            return  cell;
            
        }
            
            break;
            
        case 3:{
            
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            PaymentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[PaymentTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
            }
            
            
            if (_paymentArr.count> indexPath.row) {
                
                cell.model  = _paymentArr[indexPath.row];
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            }
            
            return  cell;
            
            
        }
            break;
        case 4:{
            
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            RefundTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[RefundTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
            }
            
            
            if (_refundArr.count> indexPath.row) {
                
                cell.model  = _refundArr[indexPath.row];
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            }
            
            return  cell;
            
            
            
            
        }
            break;

            
    }
    
    return cell;
}


#pragma mark- tableview delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = 1;
    
    switch (tableView.tag) {
        case 1:{
            if (_rechargeArr.count >indexPath.row) {
                
                id mod = _rechargeArr[indexPath.row];
                
                height =  [tableView cellHeightForIndexPath:indexPath model:mod keyPath:@"model" cellClass:[RechargeTableViewCell class] contentViewWidth:self.view.width_sd];
            }
            
        }
        case 2:{
            if (_withDrawArr.count  >indexPath.row) {
                
                id mod = _withDrawArr[indexPath.row];
                
                height =  [tableView cellHeightForIndexPath:indexPath model:mod keyPath:@"model" cellClass:[WithDrawTableViewCell class] contentViewWidth:self.view.width_sd];
            }
            
        }
            
            
            break;
        case 3:{
            if (_paymentArr.count  >indexPath.row) {
                
                id mod = _paymentArr[indexPath.row];
                
                height =  [tableView cellHeightForIndexPath:indexPath model:mod keyPath:@"model" cellClass:[PaymentTableViewCell class] contentViewWidth:self.view.width_sd];
            }
            
        }
            
            break;
            
        case 4:{
            if (_refundArr.count  >indexPath.row) {
                
                id mod = _refundArr[indexPath.row];
                
                height =  [tableView cellHeightForIndexPath:indexPath model:mod keyPath:@"model" cellClass:[RefundTableViewCell class] contentViewWidth:self.view.width_sd];
            }
            
        }
            
            break;
    }
    
    return  height;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 1;
    
}



#pragma mark- tableview delegate -  didselected
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag ==1) {
//        RechargeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        if ([cell.model.status isEqualToString:@"unpaid"]) {
//            
//            ConfirmChargeViewController *pay = [[ConfirmChargeViewController alloc]initWithModel:cell.model];
//            [self.navigationController pushViewController:pay animated:YES];
//            
//        }
    }
    
    /* 提现页面*/
    if (tableView.tag ==2) {
        
        WithDrawTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if ([cell.model.status isEqualToString:@"canceled"]) {
            
        }else{
            
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否取消该提现申请?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }] ;
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                /* 发送取消订单申请*/
                [self cancelWithDrawRequest:cell.model.transaction_no andIndexPath:indexPath];
                
                
            }] ;
            
            [alert addAction:cancel];
            [alert addAction:sure];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }
    }
    
    if (tableView.tag==4) {
        
        RefundTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if ([cell.model.status isEqualToString:@"init"]) {
            
            [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"是否取消退款申请?" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                if (buttonIndex!=0) {
                    
                    [self cancelRefund:cell.model.transaction_no withIndexPath:indexPath];
                    
                }
            }];
        }else{

            
        }
    }
}

#pragma mark- 取消退款申请
- (void)cancelRefund:(NSString *)orderID withIndexPath:(NSIndexPath *)indePath{
    
   [self PUTSessionURL:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/refunds/%@/cancel",Request_Header,_idNumber,orderID] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
      
       NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
       [self loginStates:dic];
       if ([dic[@"status"]isEqualToNumber:@1]) {
           /* 取消成功*/
           [self HUDStopWithTitle:@"取消成功"];
           RefundTableViewCell *cell = [_mainView.refundView cellForRowAtIndexPath:indePath];
           cell.status.text = @"已取消";
           cell.model.status = @"canceled";
           
       }
       
   }failure:^(id  _Nullable erros) {
   }];
    
}

#pragma mark- 取消提现申请
- (void)cancelWithDrawRequest:(NSString *)orderNumber andIndexPath:(NSIndexPath *)indexPath{
    
    if (_idNumber&&orderNumber) {
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
        [manager PUT:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/withdraws/%@/cancel",Request_Header,_idNumber,orderNumber] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            [self loginStates:dic];
            
            if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
                /* 删除成功*/
                [self HUDStopWithTitle:@"取消成功!"];
                
                WithDrawTableViewCell *cell = [_mainView.withDrawView cellForRowAtIndexPath:indexPath];
                cell.status.text = @"已取消";
                
//                [self requestWithDraw];
                
            }else{
                
                [self HUDStopWithTitle:@"取消失败!"];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self HUDStopWithTitle:@"请求失败,请重试"];
            
        }];
        
    }else{
        [self HUDStopWithTitle:@"请求失败,请重试"];
        
    }
    
}




- (void)returnLastPage{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

// segment的滑动代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == _mainView.scrollView) {
        
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        
        [_mainView.segmentControl setSelectedSegmentIndex:page animated:YES];
    }
    
}

- (UIView *)makePlaceHolderView{
    
    HaveNoClassView *view = [[HaveNoClassView alloc]initWithTitle:@"暂无数据"];
    return view;
}


- (BOOL)enableScrollWhenPlaceHolderViewShowing{
    
    return YES;
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
