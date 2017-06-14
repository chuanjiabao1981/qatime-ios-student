//
//  MyWalletViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "MyWalletViewController.h"
#import "NavigationBar.h"
 

#import "PersonalTableViewCell.h"
#import "UIViewController+HUD.h"

#import "CashRecordViewController.h"
#import "ChargeViewController.h"

#import "WithDrawViewController.h"
#import "UIAlertController+Blocks.h"
#import "UIAlertController+Blocks.h"

#import "DCPaymentView.h"

@interface MyWalletViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIGestureRecognizerDelegate>{
    
    
    NavigationBar *_navigationBar;
    
    /* token和id*/
    NSString *_token;
    NSString *_idNumber;
    
    /* 菜单名*/
    NSArray *_menuName;
    
    /**是否是游客*/
    BOOL is_Guest;
    
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

    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    [self.view addSubview:_navigationBar];
    _navigationBar.titleLabel.text = @"我的钱包";
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
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

    
    [self HUDStartWithTitle:@"正在获取数据"];
    
    
    //部分基础数据
    _menuName = @[@"充值记录",@"消费记录",@"退款记录"];
    
    //是否游客
    is_Guest = [[NSUserDefaults standardUserDefaults]valueForKey:@"is_Guest"]?[[NSUserDefaults standardUserDefaults]boolForKey:@"is_Guest"]:NO;
    
    /* 请求钱包数据*/
    [self requestWallet];
    
    
    /* 指定代理*/
    _myWalletView.menuTableView.delegate = self;
    _myWalletView.menuTableView.dataSource = self;
    
    /* 我的订单  充值记录点击时间*/
    [_myWalletView.rechargeButton addTarget:self action:@selector(recharge) forControlEvents:UIControlEventTouchUpInside];
    
    /* 拨打帮助电话*/
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callForHelp)];
    _myWalletView.tips.userInteractionEnabled = YES;
    [_myWalletView.tips addGestureRecognizer:tap];
    
    
    /**监听充值是否成功,是否需要修改余额*/
    [[NSNotificationCenter defaultCenter]addObserverForName:@"ChargeSuccess" object:nil queue:[NSOperationQueue new] usingBlock:^(NSNotification * _Nonnull note) {
        
        [self requestWallet];
        
    }];
    
    /**监听重新登录*/
    [[NSNotificationCenter defaultCenter]addObserverForName:@"LoginSuccess" object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self requestWallet];
    }];
    

}

/* 拨打帮助电话*/
- (void)callForHelp{

    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"0532-34003426"];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}


- (void)requestWallet{
    
    NSString *urlStr =[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/cash",Request_Header,_idNumber];
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        [self loginStates:dic];
        if ([dic[@"status"] isEqual:[NSNumber numberWithInteger:1]]) {
            /* 数据加载成功*/
            _myWalletView.balance.text = [NSString stringWithFormat:@"¥ %@",dic[@"data"][@"balance"]];
            _myWalletView.total.text =[NSString stringWithFormat:@"累计消费：¥ %@",dic[@"data"][@"total_expenditure"]];
            
            /* 余额数据存本地*/
            [[NSUserDefaults standardUserDefaults]setObject:dic[@"data"][@"balance"] forKey:@"balance"];
                        
            [_myWalletView updateLayout];
            
            [self HUDStopWithTitle:@"数据加载成功!"];
        }else{
            
            /* 登录超时*/
            [self.loadingHUD hide:YES];
            [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"登录超时!\n请重新登录!" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                if (buttonIndex!=0) {
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"userLogOut" object:nil];
                }
            }];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        [self HUDStopWithTitle:@"数据获取失败!请重试"];
    }];
    
}

#pragma mark- tableview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _menuName.count;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50*ScrenScale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*ScrenScale;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10*ScrenScale;
}


#pragma mark- 进入充值页面
- (void)recharge{
    
    //用户充值
    ChargeViewController *controller = [ChargeViewController new];
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark- 进入提现页面
//- (void)widthDraw{
//    WithDrawViewController *withVC = [WithDrawViewController new];
//    [self.navigationController pushViewController:withVC animated:YES];
//}

- (void) returnLastPage{
    

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
