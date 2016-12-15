//
//  SafeViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "SafeViewController.h"
#import "SettingTableViewCell.h"
#import "RDVTabBarController.h"
#import "UIViewController+HUD.h"
#import "UIViewController_HUD.h"
#import "ParentViewController.h"
#import "ChangePasswordViewController.h"
#import "ChangePhoneGetCodeViewController.h"

#import "BindingMailViewController.h"

@interface SafeViewController ()
{
    
    NavigationBar *_navigationBar;
    
    NSString *_token;
    NSString *_idNumber;
    
    
    /* 菜单名称*/
    NSArray *_menuName;
    
    /* content内容*/
    NSMutableArray *_contentArr;
    
}

@end

@implementation SafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BACKGROUNDGRAY;
    
    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
    
    _navigationBar = ({
    
        NavigationBar *_ = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
        
        [self.view addSubview:_];
        _.titleLabel.text = @"安全设置";
       
        [_.leftButton setImage:[UIImage imageNamed:@"leftArrow"] forState:UIControlStateNormal];
        
        _;
    
    });
    
     [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    
  
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    
    
    /* 请求个人详细信息*/
    
    [self requestUserInfo];
    
    
    
    /* 初始化容器*/
    
    _menuName = @[@"绑定手机",@"绑定邮箱",@"微信绑定",@"家长手机",@"修改支付密码",@"修改登录密码"];
    
    
    /* 菜单初始化*/
    _menuTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64)];
    
    _menuTableView.delegate = self;
    _menuTableView.dataSource = self;
    _menuTableView.bounces = NO;
    _menuTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_menuTableView];
    _menuTableView.backgroundColor = [UIColor clearColor];
    _menuTableView.tableFooterView = [[UIView alloc]init];
    
    
    /* 添加一个家长手机修改成功的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeParentPhone:) name:@"ChangeParentPhoneSuccess" object:nil];
    
    
    
    
}

/* 如果家长手机修改成功,则在此页面进行修改家长手机*/
- (void)changeParentPhone:(NSNotification *)notification{
    
    if (_contentArr.count !=0 ) {
        
        _contentArr[3] = [notification object];
    }
    

    [_menuTableView reloadData];
    
}

#pragma mark- 请求数据
- (void)requestUserInfo{
    
    _contentArr = @[].mutableCopy;
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/students/%@/info",Request_Header,_idNumber] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableDictionary *getDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([getDic[@"status"] isEqual:[NSNumber numberWithInteger:1]]) {
            
            
            
            /* 个人信息存本地*/
            
            NSMutableDictionary * chDic = [NSMutableDictionary dictionaryWithDictionary:getDic[@"data"]];
            
            
            for (NSInteger i = 0; i< [chDic allKeys].count; i++) {
                
                if ([chDic valueForKey:[chDic allKeys][i]]==nil||[[chDic valueForKey:[chDic allKeys][i]] isEqual:[NSNull null]]) {
                    
                    [chDic setValue:@"未绑定" forKey:[chDic allKeys][i]];
                    
                }
                
               
            }
            
            
            /* 拉取个人信息成功*/
            _contentArr = [NSMutableArray arrayWithArray:@[chDic[@"login_mobile"],chDic[@"email"],@"马上绑定",chDic[@"parent_phone"],@"",@""]];
            
            NSLog(@"%@",chDic);
            
            
            [[NSUserDefaults standardUserDefaults]setObject:chDic[@"login_mobile"] forKey:@"login_mobile"] ;
             [[NSUserDefaults standardUserDefaults]setObject:chDic[@"email"] forKey:@"email"];
//             [NSUserDefaults standardUserDefaults]setObject:getDic[@"data"][[@"login_mobile"] forKey:login_mobile];
             [[NSUserDefaults standardUserDefaults]setObject:chDic[@"parent_phone"] forKey:@"parent_phone"];
            
            NSLog(@"%@",_contentArr);

            
            [_menuTableView reloadData];
            
        }else{
            /* 拉取个人信息失败*/
            [self loadingHUDStopLoadingWithTitle:@"加载失败!"];
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    
}


#pragma mark- tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return 4;
            break;
            
        case 1:
            return 2;
       
            break;
    }
    
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [UITableViewCell new];
    
    
    if (_contentArr.count!=0) {
        
        /* cell的重用队列*/
        static NSString *cellIdenfier = @"cell";
        SettingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
        if (cell==nil) {
            cell=[[SettingTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            
            
            cell.settingName.sd_layout
            .leftSpaceToView(cell.contentView,20);
            
            
            
            cell.balance.hidden = NO;
            
            if (![_contentArr[indexPath.row] isKindOfClass:[NSString class]]) {
                
                _contentArr[indexPath.row] = @"未绑定";
                //                cell.balance.textColor = [UIColor redColor];
                
                
            }
            switch (indexPath.section) {
                case 0:{
                    
                    cell.settingName.text = _menuName[indexPath.row];
                    cell.balance.text = _contentArr[indexPath.row];
                    
                    if (indexPath.row==2) {
                        
                        if ([cell.balance.text isEqualToString:@"马上绑定"]) {
                            cell.balance.text =@" 马上绑定 ";
                            cell.balance.font = [UIFont systemFontOfSize:16];
                            cell.balance.backgroundColor = [UIColor colorWithRed:0.42 green:0.79 blue:0.15 alpha:1.00];
                            cell.balance.textColor = [UIColor whiteColor];
                            
                        }else{
                            
                        }
                    }
                    
                }
                    break;
                    
                case 1:{
                    cell.settingName.text = _menuName[indexPath.row+4];
                    cell.balance.text = _contentArr[indexPath.row+4];
                    
                    switch (indexPath.row) {
                            
                        case 0:{
                            cell.balance.hidden = YES;
                        }
                            break;
                        case 1:{
                            cell.balance.hidden = YES;
                            
                        }
                            break;
                            
                    }
                    
                }
                    break;
            }
            
        }
        
        return  cell;
    }else{
        
        
    }
    
    
    return cell;
}

#pragma mark- tableview delegate

#pragma mark- 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:{
            
            switch (indexPath.row) {
                case 0:{
                    
                    ChangePhoneGetCodeViewController *phoneVC = [ChangePhoneGetCodeViewController new];
                    [self.navigationController pushViewController:phoneVC animated:YES];
                    
                }
                    break;
                case 1:{
                    BindingMailViewController *binVC = [[BindingMailViewController alloc]init];
                    [self.navigationController pushViewController:binVC animated:YES];
                    
                    
                }
                    break;
                case 2:{
                    
                }
                    break;
                case 3:{
                    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"parent_phone"]) {
                        
                        ParentViewController *pareVC = [[ParentViewController alloc]initWithPhone:[[NSUserDefaults standardUserDefaults]objectForKey:@"parent_phone"]];
                        [self.navigationController pushViewController:pareVC animated:YES];
                    }
                    else if (![[NSUserDefaults standardUserDefaults]objectForKey:@"parent_phone"]||[[[NSUserDefaults standardUserDefaults]objectForKey:@"parent_phone"]isEqualToString:@""]||[[NSUserDefaults standardUserDefaults]objectForKey:@"parent_phone"]==nil){
                        ParentViewController *pareVC = [[ParentViewController alloc]initWithPhone:@"未绑定家长手机"];
                        [self.navigationController pushViewController:pareVC animated:YES];
                        
                    }
                    
                }
                    break;
            }
        }
            
            break;
            
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    
                }
                    break;
                case 1:{
                   
                    ChangePasswordViewController *changVC = [ChangePasswordViewController new];
                    [self.navigationController pushViewController:changVC animated:YES];
                    
                    
                }
                    break;
            }
            
        }
            break;
    }
    
    
    
    
}







-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    CGFloat height = 0;
    switch (section) {
        case 0:
            height = 0;
            break;
            
        case 1:
            height = 15;
            break;
    }
    return height;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGRectGetHeight(self.view.frame)/12.0;
}



- (void)returnLastPage{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.rdv_tabBarController setTabBarHidden:NO animated:NO];
    
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