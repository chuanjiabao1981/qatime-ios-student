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
#import "WXApi.h"

#import "UIAlertController+Blocks.h"
#import "SetPayPasswordViewController.h"

#import "AuthenticationViewController.h"
#import "SetPayPasswordViewController.h"
#import "UIViewController+AFHTTP.h"

@interface SafeViewController ()<WXApiDelegate>
{
    
    NavigationBar *_navigationBar;
    
    NSString *_token;
    NSString *_idNumber;
    
    
    /* 菜单名称*/
    NSArray *_menuName;
    
    /* content内容*/
    NSMutableArray *_contentArr;
    
    /* 是否绑定了微信*/
    BOOL wechatIsBinding;
    
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
        
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        
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
    
    
    /* 添加一个家长手机修改成功的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeParentPhone) name:@"ChangeParentPhoneSuccess" object:nil];
    
    /* 添加手动绑定微信的监听*/
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RequestToBindingWechat:) name:@"RequestToBindingWechat" object:nil];
    
    /* 添加解绑微信的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeWechatBindingStatus) name:@"RelieveWechat" object:nil];
    
    /* 是否绑定了微信*/
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"openID"]) {
        wechatIsBinding = YES;
    }else{
        wechatIsBinding = NO;
    }
    
    
    
}

/* 如果家长手机修改成功,则在此页面进行修改家长手机*/
- (void)changeParentPhone{
    
    SettingTableViewCell *cell = [_menuTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    cell.balance.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"parent_phone"];
    

    
    
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
        
        [self loginStates:getDic];
        if ([getDic[@"status"] isEqual:[NSNumber numberWithInteger:1]]) {
            
            /* 个人信息存本地*/
            
            NSMutableDictionary * chDic = [NSMutableDictionary dictionaryWithDictionary:getDic[@"data"]];
            
            if (chDic[@"openid"]!=nil&&![chDic[@"openid"] isEqual:[NSNull null]]) {
                [[NSUserDefaults standardUserDefaults]setValue:chDic[@"openid"] forKey:@"openID"];
                wechatIsBinding = YES;
                
            }
            
            
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
            
            /* 菜单初始化*/
            _menuTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64)];
            
            _menuTableView.delegate = self;
            _menuTableView.dataSource = self;
            _menuTableView.bounces = NO;
            _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view addSubview:_menuTableView];
            _menuTableView.backgroundColor = [UIColor clearColor];
            _menuTableView.tableFooterView = [[UIView alloc]init];

//            [_menuTableView reloadData];
            
            
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
            
            
            cell.arrow.hidden = YES;
            switch (indexPath.section) {
                case 0:{
                    
                    cell.settingName.text = _menuName[indexPath.row];
                    cell.balance.text = _contentArr[indexPath.row];
                    
                    if (indexPath.row==2) {
                        
                        if (wechatIsBinding == YES) {
                            cell.balance.text =@" 取消绑定 ";
                            cell.balance.font = [UIFont systemFontOfSize:16*ScrenScale];
                            cell.balance.backgroundColor = [UIColor colorWithRed:0.42 green:0.79 blue:0.15 alpha:1.00];
                            cell.balance.textColor = [UIColor whiteColor];
                        }else{
                            
                            cell.balance.text =@" 马上绑定 ";
                            cell.balance.font = [UIFont systemFontOfSize:16*ScrenScale];
                            cell.balance.backgroundColor = [UIColor colorWithRed:0.42 green:0.79 blue:0.15 alpha:1.00];
                            cell.balance.textColor = [UIColor whiteColor];
                            
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
                    
                    /* 去绑定微信*/
                    if (wechatIsBinding == NO) {
                        
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"BindingWechat" object:nil];
                        
                        /* 拉起微信绑定*/
                        [self sendAuthRequest];
                        
                    }else{
                        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"取消绑定后将不能使用提现等功能，是否取消？" cancelButtonTitle:@"不取消" destructiveButtonTitle:nil otherButtonTitles:@[@"取消"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                           
                            if (buttonIndex!=0) {
                                /* 解绑微信*/
                                [self relieveWechat];
                            }
                        }];
                        
                        
                    }
                    
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
                    
                   [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"新设置或修改后将在24小时内不能使用支付密码,是否继续?" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"继续"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                       if (buttonIndex!=0) {
                           
                           if ([[NSUserDefaults standardUserDefaults]valueForKey:@"have_paypassword"]) {
                               if ([[NSUserDefaults standardUserDefaults]boolForKey:@"have_paypassword"]==YES) {
                                   /* 已经设置过支付密码,更改支付密码*/
                                   SetPayPasswordViewController *setPass = [[SetPayPasswordViewController alloc]initWithPageType:VerifyPassword];
                                   [self.navigationController pushViewController:setPass animated:YES];
                                   
                                   
                               }else if([[NSUserDefaults standardUserDefaults]boolForKey:@"have_paypassword"]==NO){
                                   /* 初次设置支付密码*/
                                   AuthenticationViewController *authentication =[[AuthenticationViewController alloc]init];
                                   [self.navigationController pushViewController:authentication animated:YES];
                                   
                                   
//                                   SetPayPasswordViewController *newpass = [[SetPayPasswordViewController alloc]initWithPageType:VerifyPassword];
//                                   [self.navigationController pushViewController:newpass animated:YES];
                                   
                                   
                               }
                           }
         
                       }
                       
                   }];
                    
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


-(void)sendAuthRequest{
    
//    if ([WXApi isWXAppInstalled]==YES) {
//    }else{
//        
//        [self loadingHUDStopLoadingWithTitle:@"您尚未安装微信"];
//        
//    }
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init ]  ;
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    
    [WXApi sendAuthReq:req viewController:self delegate:self];
    
    
    
}

/* 绑定微信*/
- (void)RequestToBindingWechat:(NSNotification *)notification{
    
    [self loadingHUDStartLoadingWithTitle:@"正在绑定"];
    NSString *wechatCode = [notification object];
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager POST:[NSString stringWithFormat:@"%@/api/v1/users/%@/wechat",Request_Header,_idNumber] parameters:@{@"code":wechatCode} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        /* <# State #>*/
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        [self loginStates:dic];
        
        if ([dic[@"status"]isEqualToNumber:@1]) {
            /* 绑定成功*/
            
            [self loadingHUDStopLoadingWithTitle:@"绑定成功!"];
            
            /* 绑定成功*/
            [self bindingSuccess:wechatCode];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"BindingWechat"];
            
            
        }else{
            [self loadingHUDStopLoadingWithTitle:@"绑定失败!"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self loadingHUDStopLoadingWithTitle:@"绑定失败!"];
    }];
    
}

/* 绑定成功*/
- (void)bindingSuccess:(NSString *)code{
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:2 inSection:0];
    SettingTableViewCell *cell = [_menuTableView cellForRowAtIndexPath:index];
    cell.balance.text = @" 取消绑定 ";
    
    wechatIsBinding = YES;
    
    /*绑定成功后,请求一下个人信息,获取openid*/
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/students/%@/info",Request_Header,_idNumber] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        [self loginStates:dic];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            if (dic[@"data"][@"openid"]) {
                
                [[NSUserDefaults standardUserDefaults]setValue:dic[@"data"][@"openid"] forKey:@"openID"];
            
            }
        }
    }];
        
}

/* 解绑微信*/
- (void)relieveWechat{
    
    [self loadingHUDStartLoadingWithTitle:@"正在请求解绑"];
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager DELETE:[NSString stringWithFormat:@"%@/api/v1/users/%@/wechat",Request_Header,_idNumber] parameters:@{@"openid":[[NSUserDefaults standardUserDefaults]valueForKey:@"openID"]} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"status"]isEqualToNumber:@1]) {
            if ([dic[@"data"]isEqualToString:@"ok"]) {
                /* 解绑成功*/
                [self loadingHUDStopLoadingWithTitle:@"解绑成功!"];
                
                wechatIsBinding = NO;
               
                [[NSNotificationCenter defaultCenter]postNotificationName:@"RelieveWechat" object:nil];
                
            }else{
                /* 解绑失败*/
                [self loadingHUDStopLoadingWithTitle:@"解绑失败!"];
            }
            
            
        }else{
            [self loadingHUDStopLoadingWithTitle:@"解绑失败!"];
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}

/* 解绑后的页面变化*/
- (void)changeWechatBindingStatus{
    
     [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"openID"];
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:2 inSection:0];
    SettingTableViewCell *cell = [_menuTableView cellForRowAtIndexPath:indexpath];
    
    cell.balance.text = @" 马上绑定 ";
    wechatIsBinding = NO;
    
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
