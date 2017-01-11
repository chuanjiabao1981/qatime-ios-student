//
//  ClassSettingViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/30.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ClassSettingViewController.h"
#import "NavigationBar.h"
#import "ClassNoticeSettingTableViewCell.h"
#import "ClassNoticeTimeSettingTableViewCell.h"
#import "RDVTabBarController.h"
#import "UIViewController+HUD.h"
#import "HcdDateTimePickerView.h"
#import "UIAlertController+Blocks.h"


@interface ClassSettingViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
     NavigationBar *_navigtionBar;
    
    NSString *_token;
    NSString *_idNumber;
    
    /* 保存设置的数组*/
    NSMutableDictionary *_settingDic;
    
    /* 是否修改了设置*/
    BOOL changeSettings;
}
@end

@implementation ClassSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navigtionBar = ({
        NavigationBar *_ = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
        _.titleLabel.text = @"提醒设置";
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_];
        _;
    });
    
   
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }

    
    /* 向服务器请求消息提醒设置*/
    [self requestNoticeSetting];
    
    
}

/* 向服务器请求消息设置*/
- (void)requestNoticeSetting{
    [self loadingHUDStartLoadingWithTitle:@"加载设置"];
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/users/%@/notifications/settings",Request_Header,_idNumber] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"%@", dic);
        
        if ([dic[@"status"]isEqualToNumber:@1]) {
            /* 请求数据成功*/
            
            _settingDic = [NSMutableDictionary dictionaryWithDictionary:dic[@"data"]];
            
            /* 加载设置列表*/
            [self loadSettingView];
            
            [self loadingHUDStopLoadingWithTitle:nil];
            
        }else{
            /* 请求数据失败*/
            [self loadingHUDStopLoadingWithTitle:@"加载失败!"];
            [self performSelector:@selector(returnLastPage) withObject:nil afterDelay:1];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

/* 加载设置*/
- (void)loadSettingView{
    /* 设置列表*/
    _menuTableView = ({
        UITableView *_=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64)];
        [self.view addSubview:_];
        _.delegate = self;
        _.dataSource =self;
        _.separatorStyle = UITableViewCellSeparatorStyleNone;
        _.bounces=NO;
        _;
    });
    
   
    
}

/* 保存设置*/
- (void)saveSettings{
    
    [self loadingHUDStartLoadingWithTitle:@"保存中"];
    NSMutableDictionary *saveDic = _settingDic;
    [saveDic removeObjectForKey:@"owner_id"];
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager PUT:[NSString stringWithFormat:@"%@/api/v1/users/%@/notifications/settings",Request_Header,_idNumber] parameters:saveDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"status"]isEqualToNumber:@1]) {
            /* 修改成功*/
            [self loadingHUDStopLoadingWithTitle:@"保存成功!"];
            
            [self performSelector:@selector(exit) withObject:nil afterDelay:1];
            
        }
        
        /* 修改成功*/
        [self loadingHUDStopLoadingWithTitle:@"保存失败!"];
        
        [self performSelector:@selector(exit) withObject:nil afterDelay:1];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}



#pragma mark- tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [UITableViewCell new];
    
    
    switch (indexPath.row) {
            
        case 0:{
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            ClassNoticeSettingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[ClassNoticeSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
                cell.name.text = @"提醒方式";
                cell.leftLabel.text = @"短信通知";
                cell.rightLabel.text = @"系统通知";
                cell.leftButton.tag = 1;
                cell.rightButton.tag = 2;
                
                if (_settingDic) {
                    if ([_settingDic[@"message"]boolValue]==YES) {
                        cell.leftButton.selected = NO;
                    }else{
                        cell.leftButton.selected = YES;
                    }
                    [self turnNoticeStatus:cell.leftButton];
                    
                    if ([_settingDic[@"notice"]boolValue]==YES) {
                        cell.rightButton.selected = NO;
                    }else{
                        cell.rightButton.selected = YES;
                    }
                    [self turnNoticeStatus:cell.rightButton];
                    
                }
                                
                [cell.leftButton addTarget:self action:@selector(turnNoticeStatus:) forControlEvents:UIControlEventTouchUpInside];
                [cell.rightButton addTarget:self action:@selector(turnNoticeStatus:) forControlEvents:UIControlEventTouchUpInside];
            }
            return cell;
            
        }
            break;
        case 1:{
            /* cell的重用队列*/
            static NSString *cellID = @"cellID";
            ClassNoticeTimeSettingTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell==nil) {
                cell=[[ClassNoticeTimeSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
                cell.name .text = @"设置时间";
                [cell.timeButton addTarget:self action:@selector(chooseTime:) forControlEvents:UIControlEventTouchUpInside];
                if (_settingDic) {
                    
                    [cell.timeButton setTitle:[NSString stringWithFormat:@"%@小时%@分钟",_settingDic[@"before_hours"],_settingDic[@"before_minutes"]] forState:UIControlStateNormal];
                    
                }
                
            }
            
            return  cell;

            
        }
            break;
            
    }
    
    return cell;
    
}


/* 选择时间段*/
- (void)chooseTime:(UIButton *)sender{
    
    HcdDateTimePickerView *timePicker = [[HcdDateTimePickerView alloc]initWithDatePickerMode:DatePickerHourMinuteMode defaultDateTime:[NSDate date]];
    
    [self.view addSubview:timePicker];
    [timePicker showHcdDateTimePicker];
    timePicker.clickedOkBtn = ^(NSString *dateTimeStr){
        
        [sender setTitle:[NSString stringWithFormat:@"%@小时%@分钟",[dateTimeStr substringWithRange:NSMakeRange(0, 2)],[dateTimeStr substringWithRange:NSMakeRange(3, 2)]] forState:UIControlStateNormal];
        
        [_settingDic setValue:[dateTimeStr substringWithRange:NSMakeRange(0, 2)] forKey:@"before_hours"];
        
        [_settingDic setValue:[dateTimeStr substringWithRange:NSMakeRange(3, 2)] forKey:@"before_minutes"];
        changeSettings =YES;
        
    } ;
    
    
}


/* 设置消息提醒*/
- (void)turnNoticeStatus:(UIButton *)sender{
    
    switch (sender.tag) {
        case 1:{
            /* 开关短信通知*/
            [self switchSender:sender];
            
        }
            break;
        case 2:{
            /* 开关系统通知*/
            [self switchSender:sender];
 
        }
            break;
            
    }
    
}

#pragma mark- 声音和震动的开关方法
- (void)switchSender:(UIButton *)sender{
    
    if (sender.selected ==YES) {
        sender.layer.borderColor = [UIColor lightGrayColor].CGColor;
        sender.layer.borderWidth =2;
        sender.backgroundColor = [UIColor clearColor];
        [sender setImage:nil forState:UIControlStateNormal];
        sender.selected = NO;
        changeSettings =YES;
        if (sender.tag == 1) {
            [_settingDic setValue:@"0" forKey:@"message"];
        }else if (sender.tag ==2){
            [_settingDic setValue:@"0" forKey:@"notice"];
        }
        
        
        
    }else if (sender.selected ==NO){
        sender.layer.borderWidth =0;
        sender.backgroundColor = [UIColor colorWithRed:0.84 green:0.33 blue:0.6 alpha:1.00];
        [sender setImage:[UIImage imageNamed:@"right_button"] forState:UIControlStateNormal];
        sender.selected = YES;
        changeSettings =YES;
        if (sender.tag == 1) {
            [_settingDic setValue:@"1" forKey:@"message"];
        }else if (sender.tag ==2){
            [_settingDic setValue:@"1" forKey:@"notice"];
        }
    }
    
    
    
}



#pragma mark- tableview delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}


- (void)returnLastPage{
    
    if (changeSettings == YES) {
        
        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"是否保存设置?" cancelButtonTitle:@"不保存" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex==0) {
                [self exit];
            }else{
               /* 保存设置*/
                [self saveSettings];
            }
            
        }];
        
    }else{
        [self exit];
    }
    
    
}

- (void)exit{
    [self.navigationController popViewControllerAnimated: YES];
    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];

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
