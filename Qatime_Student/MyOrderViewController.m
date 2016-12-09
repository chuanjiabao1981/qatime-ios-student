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

#import "MyOrderTableViewCell.h"
#import "PaidOrderTableViewCell.h"
#import "CancelOrderTableViewCell.h"

#import "UIViewController+HUD.h"
#import "YYModel.h"
#import "MJRefresh.h"
@interface MyOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    
    NSString *_token;
    NSString *_idNumber;
    
    
    NavigationBar *_navigationBar;
    
    /* 保存数据的数组*/
    NSMutableArray *_unpaidArr;
    NSMutableArray *_paidArr;
    NSMutableArray *_caneldArr;
    
    
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
        
        unpaidPage = 1;
        paidPage = 1;
        cancelPage = 1;
        
        unpaidPageTime = 0;
        paidPageTime = 0;
        cancelPageTime = 0;

        
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _navigationBar = ({
        NavigationBar *_=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
        _.titleLabel.text = @"我的订单";
        [_.leftButton setImage:[UIImage imageNamed:@"leftArrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_];
        _;
    });
    
    /*加载页面视图*/
    _myOrderView = ({
    
        MyOrderView *_ = [[MyOrderView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64)];
        
        /* 设置代理*/
        _.scrollView.delegate = self;
        
        
        /* 滑动效果*/
        typeof(self) __weak weakSelf = self;
        [ _.segmentControl setIndexChangeBlock:^(NSInteger index) {
            [weakSelf.myOrderView.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.view.bounds) * index, 0, CGRectGetWidth(weakSelf.view.bounds), CGRectGetHeight(weakSelf.view.frame)-64-40) animated:YES];
            
            switch (index) {
                case 0:{
                    if (unpaidPageTime == 0) {
                        
                        [_unpaidView.mj_footer beginRefreshing];
                        
                        
                    }else{
                        
                    }
                    unpaidPageTime ++;
                }
                    break;
                case 1:{
                    if (paidPageTime == 0) {
                        [self loadingHUDStartLoadingWithTitle:@"正在加载数据"];
                        [_paidView.mj_footer beginRefreshing];

                    }else{
                        
                    }
                    
                    paidPageTime ++;
                }
                    break;
                case 2:{
                    if (cancelPageTime == 0) {
                        
                        [_cancelView.mj_footer beginRefreshing];
                        
                    }else{
                        
                    }

                    cancelPageTime++;
                    
                }
                    break;
                    
            }
            
        }];
        [_.scrollView scrollRectToVisible:CGRectMake(-CGRectGetWidth(self.view.bounds), 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) animated:YES];
        
        [self.view addSubview:_];
        _;
    });
    
    _unpaidView = ({
        UnpaidOrderView *_=[[UnpaidOrderView alloc]init];
        _.delegate = self;
        _.dataSource = self;
        _.tag = 1;
        
        [_myOrderView.scrollView addSubview:_];
        _.sd_layout
        .leftSpaceToView(_myOrderView.scrollView,0)
        .topSpaceToView(_myOrderView.scrollView,0)
        .bottomSpaceToView(_myOrderView.scrollView,0)
        .widthIs(self.view.width_sd);
        
        _.tableFooterView = [[UIView alloc]init];
        
//        _.bounces = NO;

        _.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (unpaidPage ==1) {
                [self requestUnpaid];
                unpaidPage ++;
            }else{
                unpaidPage ++;
                [self requestUnpaid];
            }
           
            
        }];

        _;
    });
    
    _paidView = ({
        PaidOrderView *_=[[PaidOrderView alloc]init];
        _.delegate = self;
        _.dataSource = self;
        _.tag = 2;
        _.tableFooterView = [[UIView alloc]init];
        [_myOrderView.scrollView addSubview:_];
        
        _.sd_layout
        .leftSpaceToView(_unpaidView,0)
        .topSpaceToView(_myOrderView.scrollView,0)
        .bottomSpaceToView(_myOrderView.scrollView,0)
        .widthIs(self.view.width_sd);
        
        _.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            if (paidPage ==1) {
                
                [self requestPaid];
                paidPage ++;
            }else{
                paidPage ++;
                 [self requestPaid];
            }
            
          

        }];
        
        _;
    });
    
    _cancelView = ({
        CanceldOrderView *_=[[CanceldOrderView alloc]init];
        _.delegate = self;
        _.dataSource = self;
        _.tag = 3;
         _.tableFooterView = [[UIView alloc]init];
        [_myOrderView.scrollView addSubview:_];
        _.sd_layout
        .leftSpaceToView(_paidView,0)
        .topSpaceToView(_myOrderView.scrollView,0)
        .bottomSpaceToView(_myOrderView.scrollView,0)
        .widthIs(self.view.width_sd);
        
        _.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (cancelPage ==1) {
                
                 [self requestCanceld];
                cancelPage ++;
                
            }else{
                cancelPage ++;
                [self requestCanceld];
            }
            
            
        }];
        
        _;
    });
        
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
//    /* 请求已支付数据*/
//    [self requestPaid];
//    /* 请求取消的数据*/
//    
//    [self requestCanceld];
    
}

#pragma mark- 请求订单数据
- (void)requestUnpaid{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/payment/orders?cate=unpaid&per_page=6&page=%ld",unpaidPage] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            /* 获取数据成功*/
            if ([dic[@"data"] count]!=0) {
                /* 有数据*/
                
                _unpaidView.hidden = NO;
                
                __block NSMutableArray *unpaidArr = [NSMutableArray arrayWithArray:dic[@"data"]];
                
                NSMutableArray *compArr = unpaidArr.copy;
                
                
                for (NSInteger i = 0; i<compArr.count; i++) {
                    
                    /* 遍历完,model赋值,写入数组*/
                    Unpaid *mod = [Unpaid yy_modelWithJSON:unpaidArr[i][@"product"]];
                    
                    mod.status =unpaidArr[i][@"status"];
                    mod.pay_type = unpaidArr[i][@"pay_type"];
                    mod.appid = unpaidArr[i][@"app_pay_params"][@"appid"];
                    mod.timestamp = unpaidArr[i][@"app_pay_params"][@"timestamp"];
                    
                    [_unpaidArr addObject:mod];
                }
                [_unpaidView reloadData];
                [_unpaidView setNeedsDisplay];
                [_unpaidView.mj_footer endRefreshing];
                
            }else{
                /* 没更多的数据了*/
                
                if (_unpaidArr.count == 0) {
                    _unpaidView.hidden = YES;
                }
                
                [self loadingHUDStopLoadingWithTitle:@"没有符合条件的订单!"];
                [_unpaidView.mj_footer endRefreshingWithNoMoreData];
                
            }
            
            
        }else{
            
            /* 获取数据失败,需要用户重新登录*/
            
            [_unpaidView.mj_footer endRefreshingWithNoMoreData];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_unpaidView.mj_footer endRefreshing];
    }];
    
    [self loadingHUDStopLoadingWithTitle:@"加载完成"];
    
    
}

- (void)requestPaid{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/payment/orders?cate=paid&per_page=6&page=%ld",paidPage] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            /* 获取数据成功*/
            if ([dic[@"data"] count]!=0) {
                /* 有数据*/
                
                _paidView.hidden = NO;
                
                __block NSMutableArray *paidArr = [NSMutableArray arrayWithArray:dic[@"data"]];
                
                NSMutableArray *compArr = paidArr.copy;
                
                
                for (NSInteger i = 0; i<compArr.count; i++) {
                    
                    /* 遍历完,model赋值,写入数组*/
                    Paid *mod = [Paid yy_modelWithJSON:paidArr[i][@"product"]];
                    
                    mod.status =paidArr[i][@"status"];
                    mod.pay_type = paidArr[i][@"pay_type"];
                    mod.appid = paidArr[i][@"app_pay_params"][@"appid"];
                    mod.timestamp = paidArr[i][@"app_pay_params"][@"timestamp"];
                    
                    [_paidArr addObject:mod];
                }
                
                [_paidView reloadData];
                [_paidView setNeedsDisplay];
                [_paidView.mj_footer endRefreshing];
            }else{
                /* 没更多的数据了*/
                
                if (_paidArr.count == 0) {
                    _paidView.hidden = YES;
                }
                
                [_paidView.mj_footer endRefreshingWithNoMoreData];
                [self loadingHUDStopLoadingWithTitle:@"没有符合条件的订单!"];
                
            }
            
            [self loadingHUDStopLoadingWithTitle:@"加载完成"];
            
        }else{
            
            /* 获取数据失败,需要用户重新登录*/
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [_paidView.mj_footer endRefreshing];
    }];
    

    
    
}
- (void) requestCanceld{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/payment/orders?cate=canceled&per_page=6&page=%ld",paidPage] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            /* 获取数据成功*/
            if ([dic[@"data"] count]!=0) {
                /* 有数据*/
                
                _cancelView.hidden = NO;
                
                __block NSMutableArray *cancelArr = [NSMutableArray arrayWithArray:dic[@"data"]];
                
                NSMutableArray *compArr = cancelArr.copy;
                
                
                for (NSInteger i = 0; i<compArr.count; i++) {
                    
                    /* 遍历完,model赋值,写入数组*/
                    Canceld *mod = [Canceld yy_modelWithJSON:cancelArr[i][@"product"]];
                    
                    mod.status =cancelArr[i][@"status"];
                    mod.pay_type = cancelArr[i][@"pay_type"];
                    mod.appid = cancelArr[i][@"app_pay_params"][@"appid"];
                    mod.timestamp = cancelArr[i][@"app_pay_params"][@"timestamp"];
                    
                    [_caneldArr addObject:mod];
                }
                [_cancelView reloadData];
                [_cancelView setNeedsDisplay];
                [_cancelView.mj_footer endRefreshing];
                
            }else{
                /* 没更多的数据了*/
                
                if (_caneldArr.count == 0) {
                    _cancelView.hidden = YES;
                }
                [_cancelView.mj_footer endRefreshingWithNoMoreData];
                [self loadingHUDStopLoadingWithTitle:@"没有符合条件的订单!"];
                
            }
            
           
            [self loadingHUDStopLoadingWithTitle:@"加载完成"];
            
        }else{
            
            /* 获取数据失败,需要用户重新登录*/
            
        }
       
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [_cancelView.mj_footer endRefreshing];
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
                
                [cell.leftButton addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
              
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
                
                cell.sd_tableView = tableView;
            }
            
            if (_caneldArr.count>indexPath.row) {
                
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


/* 取消订单*/

- (void)cancelOrder:(MyOrderTableViewCell *)cell{
    
//    cell.unpaidModel.
    
    
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
                    
                    [_unpaidView.mj_footer beginRefreshing];
                    
                    
                }else{
                    
                }
                unpaidPageTime ++;
            }
                break;
            case 1:{
                if (paidPageTime == 0) {
                    [_paidView.mj_footer beginRefreshing];
                    
                }else{
                    
                }
                
                paidPageTime ++;
            }
                break;
            case 2:{
                if (cancelPageTime == 0) {
                    
                    [_cancelView.mj_footer beginRefreshing];
                    
                }else{
                    
                }
                
                cancelPageTime++;
                
            }
                break;
                
        }

        
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
