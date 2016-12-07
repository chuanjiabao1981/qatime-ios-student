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

#import "Recharge.h"
#import "WithDraw.h"
#import "Payment.h"




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
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    [self.view addSubview:_navigationBar];
    
    _navigationBar.titleLabel.text = @"资金记录";
    
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"leftArrow"] forState:UIControlStateNormal];
    
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    /* view的初始化*/
    _cashRecordView = ({
    
        CashRecordView *_ = [[CashRecordView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64)];
        [self.view addSubview:_];
        
        
        
        _;
    });
    
    _cashRecordView.rechargeView.delegate = self;
    _cashRecordView.rechargeView.dataSource = self;
    _cashRecordView.rechargeView.tag = 1;
    
    _cashRecordView.withDrawView.delegate = self;
    _cashRecordView.withDrawView.dataSource = self;
    _cashRecordView.withDrawView.tag = 2;
    
    _cashRecordView.paymentView.delegate = self;
    _cashRecordView.paymentView.dataSource = self;
    _cashRecordView.paymentView.tag = 3;
    
    _cashRecordView.scrollView.delegate = self;
    
    
    /* 滑动效果*/
    typeof(self) __weak weakSelf = self;
    [ _cashRecordView.segmentControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.cashRecordView.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.view.bounds) * index, 0, CGRectGetWidth(weakSelf.view.bounds), CGRectGetHeight(weakSelf.view.frame)-64-40) animated:YES];
    }];
    [_cashRecordView.scrollView scrollRectToVisible:CGRectMake(-CGRectGetWidth(self.view.bounds), 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) animated:YES];
    
    
//    _cashRecordView.segmentControl.selectedSegmentIndex = _selectedItem.integerValue;
    
    
    

    
    
    /* 初始化数据*/
    _rechargeArr = @[].mutableCopy;
    _withDrawArr = @[].mutableCopy;
    _paymentArr = @[].mutableCopy;
    
    
    /* 请求充值记录数据*/
    [self requestRecharge];
    /* 请求提现记录*/
    [self requestWithDraw];
    
    /* 请求提现记录*/
    [self requestPayment];

    
    
}

#pragma mark- 请求充值记录数据
- (void)requestRecharge{
    
//    _rechargeArr = @[].mutableCopy;
    
    [self loadingHUDStartLoadingWithTitle:@"正在加载数据"];
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/payment/users/%@/recharges",_idNumber] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil] ;
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            
            /* 获取数据成功  数据写到rechararr数组里*/
            NSMutableArray *recharge = [NSMutableArray arrayWithArray:dic[@"data"]];
        
            if (recharge.count!= 0) {
               
                for (NSInteger i = 0; i<recharge.count; i++) {
                    
                    Recharge *reMod = [Recharge yy_modelWithJSON:recharge[i]];
                    
                    reMod.idNumber = recharge[i][@"id"];
                    reMod.timeStamp = recharge[i][@"app_pay_params"][@"timestamp"];
                    
                    [_rechargeArr addObject:reMod];
                    
                }
                
                
                [_cashRecordView.rechargeView reloadData];
                [_cashRecordView.rechargeView setNeedsDisplay];
                [self loadingHUDStopLoadingWithTitle:@"加载成功!"];
                
                
            }else{
                
                /* 数据为0条*/
                
                [self loadingHUDStopLoadingWithTitle:@"没有充值记录!"];
                
                
            }
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
}




#pragma mark- 请求提现数据
- (void)requestWithDraw{
    
//    _withDrawArr = @[].mutableCopy;
//    [self loadingHUDStartLoadingWithTitle:@"正在加载数据"];
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/payment/users/%@/withdraws",_idNumber] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil] ;
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            
            /* 获取数据成功  数据写到rechararr数组里*/
            NSMutableArray *recharge = [NSMutableArray arrayWithArray:dic[@"data"]];
            
            if (recharge.count!=0) {
                
                for (NSInteger i = 0; i<recharge.count; i++) {
                    
                    WithDraw *wiMod = [WithDraw yy_modelWithJSON:recharge[i]];
                    
                    [_withDrawArr addObject:wiMod];
                    
                }
                
                
               
                
                [_cashRecordView.withDrawView reloadData];
                [_cashRecordView.withDrawView setNeedsDisplay];
                [self loadingHUDStopLoadingWithTitle:@"加载成功!"];
                
                
            }else{
                
                /* 数据为0条*/
                
                [self loadingHUDStopLoadingWithTitle:@"没有提现记录!"];
                
                
            }
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];

    
    
    
}


#pragma mark- 请求消费记录
- (void)requestPayment{
    
    
//    _paymentArr = @[].mutableCopy;
//    [self loadingHUDStartLoadingWithTitle:@"正在加载数据"];
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/payment/users/%@/consumption_records",_idNumber] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil] ;
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            
            /* 获取数据成功  数据写到rechararr数组里*/
            NSMutableArray *recharge = [NSMutableArray arrayWithArray:dic[@"data"]];
            
            if (recharge.count!=0) {
                
                for (NSInteger i = 0; i<recharge.count; i++) {
                    
                    Payment *payMod = [Payment yy_modelWithJSON:recharge[i]];
                    
                    payMod.idNumber = recharge[i][@"id"];
                    
                    
                    [_paymentArr addObject:payMod];
                    
                }
                
                [self loadingHUDStopLoadingWithTitle:@"加载成功!"];
                
            }else{
                
                /* 数据为0条*/
                
                [self loadingHUDStopLoadingWithTitle:@"没有消费记录!"];
                
                
            }
            
            [_cashRecordView.paymentView reloadData];
            [_cashRecordView.paymentView setNeedsDisplay];

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
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
                cell.sd_tableView = tableView;
            }
            
            
            if (_rechargeArr.count >indexPath.row) {
                
                cell.model  = _rechargeArr[indexPath.row];
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
                cell.sd_tableView = tableView;
            }
            
            
            if (_withDrawArr.count >indexPath.row) {
                
                cell.model  = _withDrawArr[indexPath.row];
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
                cell.sd_tableView = tableView;
            }
            
            
            if (_paymentArr.count> indexPath.row) {
                
                cell.model  = _paymentArr[indexPath.row];
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
  
        
    }
    
    return  height;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 1;
    
}




- (void)returnLastPage{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

// segment的滑动代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == _cashRecordView.scrollView) {
        
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        
        [_cashRecordView.segmentControl setSelectedSegmentIndex:page animated:YES];
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
