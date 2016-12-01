//
//  PersonalViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "PersonalViewController.h"
#import "NavigationBar.h"
#import "NELivePlayerViewController.h"
#import "NIMSDK.h"
#import "UIImageView+WebCache.h"
#import "SettingTableViewCell.h"
#import "MyWalletViewController.h"
#import "MyOrderViewController.h"
#import "MyClassViewController.h"
#import "SafeViewController.h"
#import "SettingViewController.h"

#import "UIViewController_HUD.h"
#import "UIViewController+HUD.h"



#define SCREENWIDTH self.view.frame.size.width
#define SCREENHEIGHT self.view.frame.size.width

@interface PersonalViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    
    NSString *_token;
    NSString *_idNumber;
    
    NELivePlayerViewController *neVideoVC;
    
    NavigationBar *_navigationBar;
    
    /* 菜单名*/
    NSArray *_settingName;
    
    /* 头像地址*/
    NSString *_avatarStr;
    
    /* 余额*/
    NSString *_balance;
    
    
}

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    /* 菜单名*/
    _settingName = @[@"我的钱包",@"我的订单",@"我的辅导",@"安全管理",@"系统设置"];
    
    
    
    /* 取出头像信息*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"avatar_url"]) {
        
        _avatarStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"avatar_url"]];
        
    }
    
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }

    
    
    /* 导航栏*/
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    [self.view addSubview:_navigationBar];
    
    _navigationBar.titleLabel.text = @"个人中心";
    
    _headView = [[HeadBackView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT*2/5)];
    [self.view addSubview:_headView];
    [_headView.headImageView sd_setImageWithURL:[NSURL URLWithString:_avatarStr]];
    
    /* 个人页面菜单*/
    _personalView = [[PersonalView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64-63)];
    [self.view addSubview:_personalView];
    
    _personalView.settingTableView.delegate = self;
    _personalView.settingTableView.dataSource = self;
    _personalView.settingTableView.tableHeaderView = _headView;
    _personalView.settingTableView.tableHeaderView.size = CGSizeMake(SCREENWIDTH, SCREENHEIGHT*2/5);

    _personalView.settingTableView.bounces = NO;
    _personalView.settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
         
    
    /* 测试用按钮2*/
    
    UIButton *playerButton2=({
        
        UIButton *_ = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetHeight(self.view.frame)-40, CGRectGetWidth(self.view.frame)-40,40 )];
        
        _.backgroundColor = [UIColor orangeColor];
        
        [_ setTitle:@"播放视频2" forState:UIControlStateNormal];
        
        [self.view addSubview:_];
        
        _;
    });
    [ playerButton2 addTarget:self action:@selector(playVideo2) forControlEvents:UIControlEventTouchUpInside];
   
    /* 获取余额*/
    [self getCash];

}

- (void)getCash{
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/payment/users/%@/cash",_idNumber] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"] isEqual:[NSNumber numberWithInteger:1]]) {
            /* 获取cash接口的信息成功*/
            _balance = [NSString stringWithFormat:@"%@",dic[@"data"][@"balance"]];
            
        }else{
            
            /* 获取失败*/
            [self loadingHUDStopLoadingWithTitle:@"获取余额信息失败"];
            
        }
        
        NSIndexPath *num = [NSIndexPath indexPathForRow:0 inSection:0];
        [_personalView.settingTableView reloadRowsAtIndexPaths:@[num] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}



#pragma mark- tableview datasouce

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return 5;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    SettingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[SettingTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
        cell.settingName.text = _settingName[indexPath.row];
        
        if (indexPath.row ==0) {
            cell.balance .hidden = NO;
            
            if (_balance == nil) {
                
            }else{
            
                cell.balance.text = [NSString stringWithFormat:@"￥%@",_balance];
            }
        }
        
    }
    
    return  cell;
    

}


#pragma mark- tableview delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 60;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:{
            MyWalletViewController *mwVC = [MyWalletViewController new];
            [self.navigationController pushViewController:mwVC animated:YES];
        }
            break;
        case 1:{
            
            MyOrderViewController *moVC = [MyOrderViewController new];
            [self.navigationController pushViewController:moVC animated:YES];
        }
            break;
        case 2:{
            MyClassViewController *mcVC = [MyClassViewController new];
            [self.navigationController pushViewController:mcVC animated:YES];
        }
            break;
        case 3:{
            SafeViewController *sVC = [SafeViewController new];
            [self.navigationController pushViewController:sVC animated:YES];
            
        }
            break;
        case 4:{
            SettingViewController *settingVC = [SettingViewController new];
            [self.navigationController pushViewController:settingVC animated:YES];
        }
            break;
            
       
    }
    
    
    
    
}




- (void)playVideo2{
    
    neVideoVC =[[NELivePlayerViewController alloc]initWithClassID:@"34"];
    
     [self.navigationController pushViewController:neVideoVC animated:YES];
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
