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
#import <NIMSDK/NIMSDK.h>
#import "UIImageView+WebCache.h"
#import "SettingTableViewCell.h"
#import "MyWalletViewController.h"
#import "MyOrderViewController.h"
#import "MyClassViewController.h"
#import "SafeViewController.h"
#import "SettingViewController.h"
#import "MyOrderViewController.h"
#import "MyOneOnOneViewController.h"

#import "UIViewController+HUD.h"
#import "UIViewController+HUD.h"
#import "PersonalInfoViewController.h"
#import "UIAlertController+Blocks.h"
#import "UIImageView+WebCache.h"
#import "MyVideoClassViewController.h"
#import "AboutUsViewController.h"
#import "MyAuditionViewController.h"

#define SCREENWIDTH self.view.frame.size.width
#define SCREENHEIGHT self.view.frame.size.width

@interface PersonalViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>{
    
    
    NSString *_token;
    NSString *_idNumber;
    
    LivePlayerViewController *neVideoVC;
    
    //    NavigationBar *_navigationBar;
    
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
    
    /**是否是游客*/
    BOOL is_Guest;
    
}

@end

@implementation PersonalViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    
    /* 菜单名*/
    _settingName = @[@"我的钱包",@"我的订单",@"我的直播课",@"我的一对一",@"我的视频课",@"我的试听",@"安全管理",@"系统设置",@"关于我们"];
    
    /* cell的图片*/
    _cellImage = @[[UIImage imageNamed:@"我的钱包"],[UIImage imageNamed:@"我的订单"],[UIImage imageNamed:@"我的直播课"],[UIImage imageNamed:@"我的一对一"],[UIImage imageNamed:@"我的视频课"],[UIImage imageNamed:@"我的试听课"],[UIImage imageNamed:@"安全管理"],[UIImage imageNamed:@"系统设置"],[UIImage imageNamed:@"关于我们"]];
    
    _headView = [[HeadBackView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT*2/5)];
    [self.view addSubview:_headView];
    
    /* 个人页面菜单*/
    _personalView = [[PersonalView alloc]initWithFrame:CGRectMake(0, _headView.height_sd, self.view.width_sd, self.view.height_sd-_headView.height_sd-TabBar_Height)];
    [self.view addSubview:_personalView];
    
    _personalView.settingTableView.delegate = self;
    _personalView.settingTableView.dataSource = self;
    
    _personalView.settingTableView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
    
    /* 加载页面方法*/
    [self setupPages];
    
    /* 添加用户登录的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogin:) name:@"UserLoginAgain" object:nil];
    
    /* 如果是充值成功,充值成功后刷新钱包金额*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshAmount) name:@"ChargeSucess" object:nil];
    
    /* 修改个人信息成功后的回调*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeHead:) name:@"ChangeInfoSuccess" object:nil];
    
    /**重新登录后的个人信息改动监听*/
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogin:) name:@"UserLogin" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:@"UserLogin" object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        [self userLogin:note];
    }];
    
    /**监听用户退出登录*/
    [[NSNotificationCenter defaultCenter]addObserverForName:@"userLogOut" object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        [_headView.headImageView setImage:[UIImage imageNamed:@"人"]];
        _headView.name.text = @"未登录";
        SettingTableViewCell *cell = [_personalView.settingTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0 ]];
        cell.balance.text = @"";
        
    }];
    
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
    
    /**取出是否是游客*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"is_Guest"]) {
        is_Guest = [[NSUserDefaults standardUserDefaults]boolForKey:@"is_Guest"];
    }
    
    /* 取出用户名*/
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"name"]) {
        
        _name = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"name"]];
    }
    
    /* 取出头像信息*/
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"is_Guest"]==YES) {
        _avatarStr = @"";
    }else{
        
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"avatar_url"]) {
            _avatarStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"avatar_url"]];
        }
    }
    
    
    /* 取出登录状态*/
    login = [[NSUserDefaults standardUserDefaults]boolForKey:@"Login"];
    
    if (login) {
        
        if (is_Guest == YES) {
            
            [_headView.headImageView setImage:[UIImage imageNamed:@"人"]];
            if ([_name isEqualToString:_idNumber]) {
                _headView.name .text = [NSString stringWithFormat:@"游客%@", _name];
            }else{
                 _headView.name .text = [NSString stringWithFormat:@"%@", _name];
            }
        }else{
            
            [_headView.headImageView sd_setImageWithURL:[NSURL URLWithString:_avatarStr]];
            _headView.name .text = _name;
            
        }
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
            PersonalInfoViewController *personVC = [[PersonalInfoViewController alloc]init];
            personVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:personVC animated:YES];
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
        
        [self loginStates:dic];
        
        if ([dic[@"status"] isEqual:[NSNumber numberWithInteger:1]]) {
            
            /* 在本地保存是否用户设置了支付密码*/
            [[NSUserDefaults standardUserDefaults]setBool:[dic[@"data"][@"has_password"] boolValue] forKey:@"have_paypassword"];
            
            /* 获取cash接口的信息成功*/
            _balance = [NSString stringWithFormat:@"%@",dic[@"data"][@"balance"]];
            
            /**支付密码是否可用*/
            //获取当前时间戳
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a=[dat timeIntervalSince1970];
            NSString *timeString = [NSString stringWithFormat:@"%f", a];//时间戳
            
            
            if ([self compareTwoTime:[dic[@"data"][@"password_set_at"] longLongValue] time2:[timeString longLongValue]]>=24) {
                
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"PayPasswordUseable"];
                
            }else{
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"PayPasswordUseable"];
                
            }
            
            
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
            SettingTableViewCell *cell = [_personalView.settingTableView cellForRowAtIndexPath:indexpath];
            cell.balance.text = [NSString stringWithFormat:@"￥%@",_balance];
            
        }else{
            
            //            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"Login"];
            
            
            /* 获取失败*/
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}


/**
 比较两个时间戳的差
 
 @param time1 设置时间戳
 @param time2 当前时间戳
 @return 时差
 */
- (NSInteger)compareTwoTime:(long long)time1 time2:(long long)time2{
    
    NSTimeInterval balance = time2 - time1;
    
    NSString*timeString = [[NSString alloc]init];
    
    timeString = [NSString stringWithFormat:@"%f",balance /3600];
    
    timeString = [timeString substringToIndex:timeString.length-7];
    
    NSInteger hour = [timeString intValue];
    
    
    
    return hour;
    
}

/* 刷新余额*/
- (void)refreshAmount{
    
    [self getCash];
}



#pragma mark- tableview datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _settingName.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    SettingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[SettingTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
        [cell.logoImage setImage:_cellImage[indexPath.row]];
        cell.settingName.text = _settingName[indexPath.row];
        cell.arrow.hidden = YES;
        
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
        }else{
            cell.arrow.hidden = YES;
            
        }
        
        if (indexPath.row ==5) {
            cell.arrow.hidden = YES;
            
        }
    }
    
    return  cell;
    
}



#pragma mark- tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55*ScrenScale;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"Login"]) {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"Login"]==YES) {
            
            UIViewController *controller;
            switch (indexPath.row) {
                case 0:{
                    controller = [MyWalletViewController new];
                }
                    break;
                case 1:{
                    
                    controller = [MyOrderViewController new];
                }
                    break;
                case 2:{
                    controller = [MyClassViewController new];
                }
                    break;
                case 3:{
                    
                    //                    [self HUDStopWithTitle:@"正在开发中,敬请期待"];
                    
                    /**
                     该版本暂时改为提示
                     */
                    controller = [MyOneOnOneViewController new];
                }
                    break;
                case 4:{
                    
                    controller = [[MyVideoClassViewController alloc]init];
                    
                }
                    break;
                case 5:{
                    
                    controller = [[MyAuditionViewController alloc]init];
                    
                }
                    break;
                case 6:{
                    controller = [SafeViewController new];
                    
                }
                    break;
                case 7:{
                    controller = [SettingViewController new];
                }
                    break;
                case 8:{
                    controller = [AboutUsViewController new];
                }
                    break;
            }
            
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
            
        }else{
            
            [self logOutAlert];
        }
    }
    
}

/**用户是否登录*/
-(BOOL)userLogin{
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"Login"]) {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"Login"]==YES) {
            return  YES;
        }else{
            return NO;
        }
    }else{
        
        return NO;
    }
    
}

#pragma mark- UIScrollView delegate
//头部放大效果
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    //获取偏移量
    //    CGPoint offset = scrollView.contentOffset;
    //    //判断是否改变
    //    if (offset.y < 0) {
    //        CGRect rect = _personalView.settingTableView.tableHeaderView.frame;
    //        //我们只需要改变图片的y值和高度即可
    //        rect.origin.y = offset.y;
    //        rect.size.height = 200 - offset.y;
    //        _headView.backGroundView.frame = rect;
    //    }
}

/* 修改个人信息成功后的回调*/
- (void)changeHead:(NSNotification *)notification{
    
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:notification.object];
    
    [_headView.headImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"data"][@"avatar_url"]]
     ];
    _headView.name.text = dic[@"data"][@"name"]==nil?@"":dic[@"data"][@"name"];
    
    
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

-(BOOL)automaticallyAdjustsScrollViewInsets{
    
    return NO;
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
