//
//  MyWalletViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "MyWalletViewController.h"
#import "NavigationBar.h"
#import "RDVTabBarController.h"

#import "PersonalTableViewCell.h"
#import "UIViewController+HUD.h"

#import "CashRecordViewController.h"
#import "ChargeViewController.h"

@interface MyWalletViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>{
    
    
    NavigationBar *_navigationBar;
    
    /* token和id*/
    NSString *_token;
    NSString *_idNumber;
    
    /* 菜单名*/
    NSArray *_menuName;
    
}

@end

@implementation MyWalletViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    [self.rdv_tabBarController setTabBarHidden:YES];
    
    
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    [self.view addSubview:_navigationBar];
    _navigationBar.titleLabel.text = @"我的钱包";
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"leftArrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    
    _myWalletView = [[MyWalletView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64)];
    [self.view addSubview:_myWalletView];
    
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }

    
    [self loadingHUDStartLoadingWithTitle:@"正在获取数据"];
    
    _menuName = @[@"充值记录",@"提现记录",@"消费记录",];
    
    /* 请求钱包数据*/
    [self requestWallet];
    
    
    
    /* 指定代理*/
    _myWalletView.menuTableView.delegate = self;
    _myWalletView.menuTableView.dataSource = self;
    
    [_myWalletView.rechargeButton addTarget:self action:@selector(recharge) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
}




- (void)requestWallet{
    
    NSString *urlStr =[NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/payment/users/%@/cash",_idNumber];
    
//    NSString *urlString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
//    NSLog(@"%@",urlString);
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"] isEqual:[NSNumber numberWithInteger:1]]) {
            /* 数据加载成功*/
            _myWalletView.balance.text = [NSString stringWithFormat:@"¥%@",dic[@"data"][@"balance"]];
            _myWalletView.total.text =[NSString stringWithFormat:@"¥%@",dic[@"data"][@"total_expenditure"]];
            
            [_myWalletView updateLayout];
            
            [self loadingHUDStopLoadingWithTitle:@"数据加载成功!"];
        }else{
            
            /* 登录超时*/
            
            [self loadingHUDStopLoadingWithTitle:@"登录超时"];
            sleep(2);
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"userLogOut" object:nil];
            
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        [self loadingHUDStopLoadingWithTitle:@"数据获取失败!请重试"];
    }];
    
    
    
    
    
}

#pragma mark- tableview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    PersonalTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[PersonalTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
        
        cell.name.text = _menuName[indexPath.row];
        
        
    }
    
    return  cell;
    
    
}


#pragma mark- tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CashRecordViewController *cashVC = [[CashRecordViewController alloc]initWithSelectedItem:indexPath.row];
    
    [self.navigationController pushViewController:cashVC animated:YES];
    
    
    
}



#pragma mark- 进入充值页面
- (void)recharge{
    
    ChargeViewController *cVC = [ChargeViewController new];
    
    [self.navigationController pushViewController:cVC animated:YES];
    
}



- (void) returnLastPage{
    

    [self.navigationController popViewControllerAnimated:YES];
    [self.rdv_tabBarController setTabBarHidden:NO];
    
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
