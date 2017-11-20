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
#import "MyExclusiveClassViewController.h"

#import "UIViewController+HUD.h"
#import "UIViewController+HUD.h"
#import "PersonalInfoViewController.h"
#import "UIAlertController+Blocks.h"
#import "UIImageView+WebCache.h"
#import "MyVideoClassViewController.h"
#import "AboutUsViewController.h"
#import "MyAuditionViewController.h"
#import "UIViewController+Token.h"
#import "GuestBindingViewController.h"

#import "MyQuestionViewController.h"

#import "DownloadManagerViewController.h"
#import "MyHomeworkViewController.h"
#import "UIImage+Color.h"
#import "YZSquareMenuCell.h"

#define SCREENWIDTH self.view.frame.size.width
#define SCREENHEIGHT self.view.frame.size.width

@interface PersonalViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    
    LivePlayerViewController *neVideoVC;
    
    ///顶部菜单
    NSArray *_menuName;
    NSArray *_menuImages;
    
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
   
    /* 加载页面方法*/
    [self setupPages];
    
    /* 添加用户登录的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogin:) name:@"UserLoginAgain" object:nil];
    
    /* 如果是充值成功,充值成功后刷新钱包金额*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshAmount) name:@"ChargeSuccess" object:nil];

    
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
    
    /* 菜单名*/
    _settingName = @[@"我的钱包",
                     @"我的订单",
                     @"我的直播课",
                     @"我的一对一",
                     @"我的视频课",
                     @"我的小班课",
                     @"设置"
                     ];
    /* cell的图片*/
    
    _cellImage = @[[[UIImage imageNamed:@"我的钱包"]imageRedrawWithColor:BUTTONRED],
                   [[UIImage imageNamed:@"我的订单"]imageRedrawWithColor:BUTTONRED],
                   [[UIImage imageNamed:@"我的直播课"]imageRedrawWithColor:BUTTONRED],
                   [[UIImage imageNamed:@"我的一对一"]imageRedrawWithColor:BUTTONRED],
                   [[UIImage imageNamed:@"我的视频课"]imageRedrawWithColor:BUTTONRED],
                   [[UIImage imageNamed:@"我的小班课"]imageRedrawWithColor:BUTTONRED],
                   [[UIImage imageNamed:@"系统设置"]imageRedrawWithColor:BUTTONRED]
                   ];
    
    _menuName = @[@"作业",@"提问",@"下载",@"试听"];
    _menuImages = @[[[UIImage imageNamed:@"我的作业"]imageRedrawWithColor:BUTTONRED],
                    [[UIImage imageNamed:@"我的提问"]imageRedrawWithColor:BUTTONRED],
                    [[UIImage imageNamed:@"文件管理"]imageRedrawWithColor:BUTTONRED],
                    [[UIImage imageNamed:@"我的试听课"]imageRedrawWithColor:BUTTONRED],
                    ];
    
    _headView = [[HeadBackView alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, self.view.width_sd*2/5.0)];
    [self.view addSubview:_headView];
    _headView.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .autoHeightRatio(2/5.0);
    [_headView updateLayout];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    _menuCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, _headView.bottom_sd, self.view.width_sd, 60) collectionViewLayout:layout];
    [self.view addSubview:_menuCollection];
    _menuCollection.backgroundColor = [UIColor whiteColor];
    _menuCollection.layer.borderWidth = 0.5;
    _menuCollection.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
    _menuCollection.delegate = self;
    _menuCollection.dataSource = self;
    _menuCollection.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(_headView, 0)
    .heightIs(75);
    [_menuCollection updateLayout];
    [_menuCollection registerClass:[YZSquareMenuCell class] forCellWithReuseIdentifier:@"CellID"];
    
    /* 个人页面菜单*/
    _personalView = [[PersonalView alloc]initWithFrame:CGRectMake(0, _menuCollection.bottom_sd, self.view.width_sd, self.view.height_sd - TabBar_Height - _menuCollection.bottom_sd)];
    [self.view addSubview:_personalView];
    _personalView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(_menuCollection, 0)
    .bottomSpaceToView(self.view, TabBar_Height);
    [_personalView updateLayout];
    
    _personalView.settingTableView.delegate = self;
    _personalView.settingTableView.dataSource = self;
    _personalView.settingTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    _personalView.settingTableView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
    
    /**取出是否是游客*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"is_Guest"]) {
        is_Guest = [[NSUserDefaults standardUserDefaults]boolForKey:@"is_Guest"];
    }
    
    /* 取出用户名*/
    
    if (is_Guest == YES) {
        
        _name = [NSString stringWithFormat:@"%@",[SAMKeychain passwordForService:Qatime_Service account:@"id"]];
                
    }else{
        
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"name"]) {
            _name = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"name"]];
        }
    }
    
    /* 取出头像信息*/
    if (is_Guest==YES) {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"avatar_url"]) {
            _avatarStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"avatar_url"]];
        }else{
            
            _avatarStr = @"";
        }
    }else{
        
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"avatar_url"]) {
            _avatarStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"avatar_url"]];
        }
    }
    
    /* 取出登录状态*/
    login = [[NSUserDefaults standardUserDefaults]boolForKey:@"Login"];
    
    if (login) {
        
        if (is_Guest == YES) {
            
            if (_avatarStr) {
                [_headView.headImageView sd_setImageWithURL:[NSURL URLWithString:_avatarStr]];
                
                
            }else{
                
                [_headView.headImageView setImage:[UIImage imageNamed:@"人"]];
            }
            
            
            if ([_name isEqualToString:[self getStudentID]]) {
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
    [manager.requestSerializer setValue:[self getToken] forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/payment/users/%@/cash",Request_Header,[self getStudentID]] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
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

#pragma mark- collectionview datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"CellID";
    YZSquareMenuCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.iconImage.image = _menuImages[indexPath.row];
    cell.iconTitle.text = _menuName[indexPath.row];
    
    return cell;
}


#pragma mark- collectionview delegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.view.width_sd/4.0-60, self.view.width_sd/4.0-60);
}


-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 40;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    return  UIEdgeInsetsMake(10, 40, 0, 40);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //                case 10:{
    //                    
    //                }
    //                    break;
    //                case 11:{
    //                    controller = [SettingViewController new];
    //                }
    //                    break;
    //                case 12:{
    //                    controller = [AboutUsViewController new];
    //                }
    //                    break;
    //            }
    
    __block UIViewController *controller = nil;

    switch (indexPath.item) {
        case 0:
           controller = [[MyHomeworkViewController alloc]init];
            break;
        case 1:
            controller = [[MyQuestionViewController alloc]init];
            break;
        case 2:
            controller = [[DownloadManagerViewController alloc]init];
            break;
        case 3:
             controller = [[MyAuditionViewController alloc]init];
            break;
    }
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
}


#pragma mark- tableview datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows = 0 ;
    if (section == 0) {
        rows = 2;
    }else if (section == 1){
        rows = 4;
    }else if (section == 2){
        rows = 1;
    }
    return rows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    SettingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[SettingTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    cell.arrow.hidden = YES;
    if (indexPath.section == 0) {
        [cell.logoImage setImage:_cellImage[indexPath.row]];
        cell.settingName.text = _settingName[indexPath.row];
        if (indexPath.row ==0) {
            if (login) {
                cell.balance .hidden = NO;
            }else{
                cell.balance.hidden = YES;
            }
            if (_balance == nil) {
            }else{
                cell.balance.text = [NSString stringWithFormat:@"￥%@",_balance];
            }
        }else{
            cell.balance.hidden = YES;
        }
    }else if (indexPath.section == 1){
        [cell.logoImage setImage:_cellImage[indexPath.row + 2]];
        cell.settingName.text = _settingName[indexPath.row + 2];
        cell.balance.hidden = YES;
    }else if (indexPath.section == 2){
        [cell.logoImage setImage:_cellImage[indexPath.row + 6]];
        cell.settingName.text = _settingName[indexPath.row + 6];
        cell.balance.hidden = YES;
    }
    
    return  cell;
}



#pragma mark- tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50*ScrenScale;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"Login"]) {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"Login"]==YES) {

           __block UIViewController *controller;
            
            switch (indexPath.section) {
                case 0:{
                    switch (indexPath.row) {
                        case 0:{
                            controller = [MyWalletViewController new];
                        }
                            break;
                        case 1:{
                            controller = [MyOrderViewController new];
                        }
                            break;
                    }
                }
                    break;
                    
                case 1:{
                    switch (indexPath.row) {
                        case 0:{
                            controller = [MyClassViewController new];
                        }
                            break;
                        case 1:{
                            controller = [MyOneOnOneViewController new];
                        }
                            break;
                        case 2:{
                            controller = [[MyVideoClassViewController alloc]init];
                        }
                            break;
                        case 3:{
                            controller = [[MyExclusiveClassViewController alloc]init];
                        }
                            break;
                    }
                    
                }
                    break;
                case 2:{
                    controller = [SettingViewController new];
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
