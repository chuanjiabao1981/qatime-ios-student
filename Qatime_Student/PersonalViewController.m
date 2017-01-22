//
//  PersonalViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "PersonalViewController.h"
#import "NavigationBar.h"
#import "LivePlayerViewController.h"
#import "NIMSDK.h"
#import "UIImageView+WebCache.h"
#import "SettingTableViewCell.h"
#import "MyWalletViewController.h"
#import "MyOrderViewController.h"
#import "MyClassViewController.h"
#import "SafeViewController.h"
#import "SettingViewController.h"
#import "MyOrderViewController.h"

#import "UIViewController_HUD.h"
#import "UIViewController+HUD.h"
#import "PersonalInfoViewController.h"
#import "UIAlertController+Blocks.h"



#define SCREENWIDTH self.view.frame.size.width
#define SCREENHEIGHT self.view.frame.size.width

@interface PersonalViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>{
    
    
    NSString *_token;
    NSString *_idNumber;
    
    LivePlayerViewController *neVideoVC;
    
    NavigationBar *_navigationBar;
    
    /* 菜单名*/
    NSArray *_settingName;
    
    /* 头像地址*/
    NSString *_avatarStr;
    
    /* 余额*/
    NSString *_balance;
    
    /* 图片*/
    NSArray *_cellImage;
    
    /* 用户名*/
    NSString *_name;
    
    /* 是否登录*/
    BOOL login;
    
}

@end

@implementation PersonalViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;

    
    
    
    /* 菜单名*/
    _settingName = @[@"我的钱包",@"我的订单",@"我的辅导",@"安全管理",@"系统设置"];
    
    /* cell的图片*/
    _cellImage = @[[UIImage imageNamed:@"美元"],[UIImage imageNamed:@"订单"],[UIImage imageNamed:@"辅导"],[UIImage imageNamed:@"安全"],[UIImage imageNamed:@"设置"]];
    
    
    
    /* 导航栏*/
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    [self.view addSubview:_navigationBar];
    
    _navigationBar.titleLabel.text = @"个人中心";
    
    _headView = [[HeadBackView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT*2/5)];
    [self.view addSubview:_headView];
    
    /* 个人页面菜单*/
    _personalView = [[PersonalView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64-TabBar_Height)];
    [self.view addSubview:_personalView];
    
    _personalView.settingTableView.delegate = self;
    _personalView.settingTableView.dataSource = self;
    _personalView.settingTableView.tableHeaderView = _headView;
    _personalView.settingTableView.tableHeaderView.size = CGSizeMake(SCREENWIDTH, SCREENHEIGHT*2/5);
    _personalView.settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _personalView.settingTableView.bounces = NO;
    _personalView.settingTableView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
    
    /* 加载页面方法*/
    [self setupPages];
    
    /* 添加用户登录的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogin:) name:@"UserLoginAgain" object:nil];
    
}

/* 页面加载方法*/
- (void)setupPages{
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    /* 取出用户名*/
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"name"]) {
        
        _name = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"name"]];
        
    }

    
    /* 取出头像信息*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"avatar_url"]) {
        
        _avatarStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"avatar_url"]];
        
    }
    
    
    /* 取出登录状态*/
    
    login = [[NSUserDefaults standardUserDefaults]boolForKey:@"Login"];
    

    
    if (login) {
        
        [_headView.headImageView sd_setImageWithURL:[NSURL URLWithString:_avatarStr]];
        
        _headView.name .text = _name;
    }else{
        
        [_headView.headImageView setImage:[UIImage imageNamed:@"人"]];
        _headView.name .text = @"点击头像登录";
        
    }
    
    _headView.headImageView.userInteractionEnabled = YES;
    
    /* 头像加点击事件,直接进入个人信息页面*/
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(personalInfo:)];
    [_headView.headImageView addGestureRecognizer:tap];
    
    /* 获取余额*/
    [self getCash];

}

/* 用户登陆后*/
- (void)userLogin:(NSNotification *)notification{
    
    /* 重新加载页面和数据*/
    [self setupPages];
    
    
}

#pragma mark- 跳到个人信息设置界面
- (void)personalInfo:(id)sender{
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"Login"]) {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"Login"]== NO) {
            
            [self loginAgain];
            
        }else{
            
            PersonalInfoViewController *personVC = [PersonalInfoViewController new];
            [self.navigationController pushViewController:personVC animated:YES];
            [self.rdv_tabBarController setTabBarHidden:YES];
        }
    }else{
        
        [self logOutAlert];
    }

}


/* 获取余额信息*/

- (void)getCash{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/cash",Request_Header,_idNumber] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"status"] isEqual:[NSNumber numberWithInteger:1]]) {
            
            /* 在本地保存是否用户设置了支付密码*/
            [[NSUserDefaults standardUserDefaults]setBool:[dic[@"data"][@"has_password"] boolValue] forKey:@"have_paypassword"];
            
            
            /* 获取cash接口的信息成功*/
            _balance = [NSString stringWithFormat:@"%@",dic[@"data"][@"balance"]];
            
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
            [_personalView.settingTableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
            
        }else{
            
//            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"Login"];
            
            
            /* 获取失败*/
            
        }
        
        NSIndexPath *num = [NSIndexPath indexPathForRow:0 inSection:0];
        [_personalView.settingTableView reloadRowsAtIndexPaths:@[num] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}



#pragma mark- tableview datasouce

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    NSInteger rows = 1;
    
    if (section == 0) {
        rows = 3;
    }else if (section ==1){
        
        rows =2;
    }
    
    
    return rows;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    SettingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[SettingTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
        switch (indexPath.section) {
            case 0:{
                
                [cell.logoImage setImage:_cellImage[indexPath.row]];
                  cell.settingName.text = _settingName[indexPath.row];
                cell.arrow.hidden = YES;
                
            }
                break;
            case 1:{
                
                [cell.logoImage setImage:_cellImage[indexPath.row+3]];
                cell.settingName.text = _settingName[indexPath.row+3];
                cell.arrow.hidden = YES;
            }
                
                break;
                
        }
        
        if (indexPath.section ==0) {
            
            if (indexPath.row ==0) {
                cell.arrow.hidden = YES;
                
                if (login) {
                    
                    cell.balance .hidden = NO;
                    
                }else{
                    
                }
                
                if (_balance == nil) {
                    
                }else{
                    
                    cell.balance.text = [NSString stringWithFormat:@"￥%@",_balance];
                }
            }
            if (indexPath.row ==2) {
                cell.arrow.hidden = YES;
//                cell.separateLine.hidden = YES;
            }
        }if (indexPath.section ==1) {
            if (indexPath.row ==1) {
                cell.arrow.hidden = YES;
//                cell.separateLine.hidden = YES;
            }
        }
        
    }
    
    return  cell;
    
}


#pragma mark- tableview delegate


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    NSInteger height = 0;
    if (section ==1) {
        return 10;
    }
    
    return height;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger height = CGRectGetHeight(self.view.frame)/12;
    
    
    if (indexPath.section ==1) {
        if (indexPath.row==1) {

            
        }
    }
    
    
    return height;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"Login"]) {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"Login"]==YES) {
            switch (indexPath.section) {
                case 0:{
                    switch (indexPath.row) {
                        case 0:{
                            MyWalletViewController *mwVC = [MyWalletViewController new];
                            [self.navigationController pushViewController:mwVC animated:YES];
                            [self.rdv_tabBarController setTabBarHidden:YES];
                        }
                            break;
                        case 1:{
                            
                            MyOrderViewController *moVC = [MyOrderViewController new];
                            [self.navigationController pushViewController:moVC animated:YES];
                            [self.rdv_tabBarController setTabBarHidden:YES];
                        }
                            break;
                        case 2:{
                            MyClassViewController *mcVC = [MyClassViewController new];
                            [self.navigationController pushViewController:mcVC animated:YES];
                            [self.rdv_tabBarController setTabBarHidden:YES];
                        }
                            break;
                            
                            
                    }
                    
                }
                    break;
                case 1:{
                    switch (indexPath.row) {
                            
                        case 0:{
                            SafeViewController *sVC = [SafeViewController new];
                            [self.navigationController pushViewController:sVC animated:YES];
                            [self.rdv_tabBarController setTabBarHidden:YES];
                            
                        }
                            break;
                        case 1:{
                            SettingViewController *settingVC = [SettingViewController new];
                            [self.navigationController pushViewController:settingVC animated:YES];
                            [self.rdv_tabBarController setTabBarHidden:YES];
                        }
                            break;
                    }
                }
                    break;
            }
        }else{
            
            [self logOutAlert];
        }
    }
    
}


/* 登录超时弹窗*/
- (void)logOutAlert{
    
    [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"登录超时!\n请重新登录!" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
       
        if (buttonIndex==0) {
            
        }else{
            
            [self loginAgain];
        }
        
    }];
    
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
