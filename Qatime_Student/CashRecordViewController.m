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
#import "RDVTabBarController.h"

#import "Recharge.h"
#import "WithDraw.h"
#import "Payment.h"

#import "UIViewController+HUD.h"




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
       
     [self.rdv_tabBarController setTabBarHidden:YES];

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
    
    _rechargeArr = @[].mutableCopy;
    
    [self loadingHUDStartLoadingWithTitle:@"正在加载数据"];
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/recharges",Request_Header,_idNumber] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil] ;
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            
            NSMutableArray *dataArr = [NSMutableArray arrayWithArray:[dic valueForKey:@"data"]];
            NSLog(@"%@",dataArr);
            if (dataArr.count !=0) {
                
                for (NSInteger i = 0; i<dataArr.count; i++) {
                    
                    
                    
                    Recharge *mod = [Recharge yy_modelWithJSON:dataArr[i]];
                    
                    mod.idNumber = [dataArr[i] valueForKey:@"id"];
//                    mod.timeStamp
                        
                    
                    /* 目前暂不支持支付宝,预留支付宝的筛选接口*/
                    
                    if ([[dataArr[i] valueForKey:@"pay_type"]isEqualToString:@"alipay"]) {
                        
                        
                        mod.timeStamp = @"无";
                    }else{
                        
                        NSString *timeStamp = [[dataArr[i] valueForKey:@"app_pay_params"]valueForKey:@"timestamp"];
                        
                        NSTimeInterval time=[timeStamp integerValue]+28800;//因为时差问题要加8小时 == 28800 sec
                        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
                        NSLog(@"date:%@",[detaildate description]);
                        //实例化一个NSDateFormatter对象
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                        //设定时间格式,这里可以设置成自己需要的格式
                        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
                        
                        mod.timeStamp = currentDateStr;
                    }
                    
                    [_rechargeArr addObject:mod];
                    
                    
                                        
                    
                }
                
                
                [_cashRecordView.rechargeView reloadData];
                [_cashRecordView.rechargeView setNeedsDisplay];
                
            }else{
                
                /* 没有充值记录*/
                
                
            }
            
            
            
            
            
            
            
            
            
            
            
        }else{
            
            /* 数据为0条*/
            
            [self loadingHUDStopLoadingWithTitle:@"没有充值记录!"];
            
            
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
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/withdraws",Request_Header,_idNumber] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil] ;
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
                
                
               
                
                [_cashRecordView.withDrawView reloadData];
//                [_cashRecordView.withDrawView setNeedsDisplay];
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
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/consumption_records",Request_Header,_idNumber] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil] ;
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            
            /* 获取数据成功  数据写到rechararr数组里*/
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



#pragma mark- tableview delegate -  didselected
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
                [self cancelWithDrawRequest:cell.model.transaction_no];
                
                
            }] ;
            
            [alert addAction:cancel];
            [alert addAction:sure];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        
        }
    }
    
}

#pragma mark- 取消提现申请
- (void)cancelWithDrawRequest:(NSString *)orderNumber{
    
    if (_idNumber&&orderNumber) {
        
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
        [manager PUT:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/withdraws/%@/cancel",Request_Header,_idNumber,orderNumber] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            NSLog(@"%@",dic);
            if ([dic[@"satatus"]isEqual:[NSNumber numberWithInteger:1]]) {
                /* 删除成功*/
                [self loadingHUDStopLoadingWithTitle:@"删除成功!"];
               
                [self requestWithDraw];
                
                
            }else{
                
                [self loadingHUDStopLoadingWithTitle:@"删除失败!"];
            }
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self loadingHUDStopLoadingWithTitle:@"请求失败,请重试"];
            
        }];
    
    }else{
        [self loadingHUDStopLoadingWithTitle:@"请求失败,请重试"];

    }
    
    
    
    
    
    
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