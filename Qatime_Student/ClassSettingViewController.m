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

#import "UIViewController+HUD.h"
#import "HcdDateTimePickerView.h"
#import "UIAlertController+Blocks.h"
#import "NoticeSwitchTableViewCell.h"
#import "UIColor+HcdCustom.h"



@interface ClassSettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>{
    
    NavigationBar *_navigtionBar;
    
    NSString *_token;
    NSString *_idNumber;
    
    /* 保存设置的数组*/
    NSMutableDictionary *_settingDic;
    
    /* 是否修改了设置*/
    BOOL changeSettings;
    
    /* 时间选择器*/
    
    UIView *_pickerBackGround;
    UIPickerView *_timePicker;
    
    /* 时间数组*/
    NSArray *_hours;
    NSArray *_minutes;
    
    /* 灰色背景*/
    UIVisualEffectView *_effect ;
    
}
@end

@implementation ClassSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _navigtionBar = ({
        NavigationBar *_ = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
        _.titleLabel.text = @"课程提醒";
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
    
    self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
    
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
        [self loginStates:dic];
        
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
        UITableView *_=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64) style:UITableViewStyleGrouped];
        _.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.view addSubview:_];
        _.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
        _.tableFooterView = [[UIView alloc]init];
        _.delegate = self;
        _.dataSource =self;
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
        [self loginStates:dic];
        
        if ([dic[@"status"]isEqualToNumber:@1]) {
            /* 修改成功*/
            [self loadingHUDStopLoadingWithTitle:@"保存成功!"];
            
            [self performSelector:@selector(exit) withObject:nil afterDelay:1];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}



#pragma mark- tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows = 0;
    
    switch (section) {
        case 0:
            rows = 2;
            break;
            
        case 1:
            rows = 2;
            break;
            
        case 2:
            rows = 2;
            break;
        case 3:
            rows= 1;
            break;
       
    }
    
    return rows;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [UITableViewCell new];
    
    switch (indexPath.section) {
            
        case 0:{
            
            /**提醒范围*/
            static NSString *cellIdenfier = @"startcell";
            NoticeSwitchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[NoticeSwitchTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"startcell"];
                
                switch (indexPath.row) {
                    case 0:{
                        
                        cell.name.text = @"上课提醒";
                        cell.noticeSwitch.onTintColor = BUTTONRED;
                        if (_settingDic) {
                            
                            //当前设置状态
                            //                            if ([_settingDic[@"message"]boolValue]==YES) {
                            //                                cell.noticeSwitch.selected = YES;
                            //                                cell.noticeSwitch.on = YES;
                            //                            }else{
                            //                                cell.noticeSwitch.selected = NO;
                            //                                cell.noticeSwitch.on = NO;
                            //                            }
                            
                        }
                        cell.noticeSwitch.tag = 1;
                    }
                        
                        break;
                        
                    case 1:{
                        cell.name.text = @"开课提醒";
                        cell.noticeSwitch.onTintColor = BUTTONRED;
                        if (_settingDic) {
                            //                            if ([_settingDic[@"notice"]boolValue]==YES) {
                            //                                cell.noticeSwitch.selected = YES;
                            //                                cell.noticeSwitch.on = YES;
                            //
                            //                            }else{
                            //                                cell.noticeSwitch.selected = NO;
                            //                                cell.noticeSwitch.on = NO;
                            //                            }
                            
                        }
                        cell.noticeSwitch.tag = 2;
                    }
                        break;
                }
                
                [cell.noticeSwitch addTarget:self action:@selector(turnNoticeStatus:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            return cell;
            
        }
            break;
        case 1:{
            /**提醒课程*/
            static NSString *cellIdenfier = @"classcell";
            NoticeSwitchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[NoticeSwitchTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"classcell"];
                
                switch (indexPath.row) {
                    case 0:{
                        
                        cell.name.text = @"直播课";
                        cell.noticeSwitch.onTintColor = BUTTONRED;
                        if (_settingDic) {
                            
                            //当前设置状态
                            //                            if ([_settingDic[@"message"]boolValue]==YES) {
                            //                                cell.noticeSwitch.selected = YES;
                            //                                cell.noticeSwitch.on = YES;
                            //                            }else{
                            //                                cell.noticeSwitch.selected = NO;
                            //                                cell.noticeSwitch.on = NO;
                            //                            }
                            
                        }
                        cell.noticeSwitch.tag = 3;
                    }
                        
                        break;
                        
                    case 1:{
                        cell.name.text = @"一对一";
                        cell.noticeSwitch.onTintColor = BUTTONRED;
                        if (_settingDic) {
                            //                            if ([_settingDic[@"notice"]boolValue]==YES) {
                            //                                cell.noticeSwitch.selected = YES;
                            //                                cell.noticeSwitch.on = YES;
                            //
                            //                            }else{
                            //                                cell.noticeSwitch.selected = NO;
                            //                                cell.noticeSwitch.on = NO;
                            //                            }
                            
                        }
                        cell.noticeSwitch.tag = 4;
                    }
                        break;
                }
                
                [cell.noticeSwitch addTarget:self action:@selector(turnNoticeStatus:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            return cell;
            
        }
            break;
            
        case 2:{
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            NoticeSwitchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[NoticeSwitchTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
                switch (indexPath.row) {
                    case 0:{
                        
                        cell.name.text = @"手机短信提醒";
                        cell.noticeSwitch.onTintColor = BUTTONRED;
                        if (_settingDic) {
                            if ([_settingDic[@"message"]boolValue]==YES) {
                                cell.noticeSwitch.selected = YES;
                                cell.noticeSwitch.on = YES;
                            }else{
                                cell.noticeSwitch.selected = NO;
                                cell.noticeSwitch.on = NO;
                            }
                            
                        }
                        cell.noticeSwitch.tag = 5;
                    }
                        
                        break;
                        
                    case 1:{
                        cell.name.text = @"系统消息提醒";
                        cell.noticeSwitch.onTintColor = BUTTONRED;
                        if (_settingDic) {
                            if ([_settingDic[@"notice"]boolValue]==YES) {
                                cell.noticeSwitch.selected = YES;
                                cell.noticeSwitch.on = YES;
                                
                            }else{
                                cell.noticeSwitch.selected = NO;
                                cell.noticeSwitch.on = NO;
                            }
                            
                        }
                        cell.noticeSwitch.tag = 6;
                    }
                        break;
                }
                
                [cell.noticeSwitch addTarget:self action:@selector(turnNoticeStatus:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            return cell;
            
        }
            break;
        case 3:{
            /* cell的重用队列*/
            static NSString *cellID = @"cellID";
            ClassNoticeTimeSettingTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell==nil) {
                cell=[[ClassNoticeTimeSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
                cell.name .text = @"提醒时间设置";
                cell.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTime:)];
                
                [cell.timeButton addGestureRecognizer:tap];
                
                if (_settingDic) {
                    
                    NSMutableString *beforhours = [NSMutableString stringWithFormat:@"%@",_settingDic[@"before_hours"]];
                    NSMutableString *beforminutes =[NSMutableString stringWithFormat:@"%@",_settingDic[@"before_minutes"]];
                    
                    if (beforhours.length<2) {
                        [beforhours insertString:@"0" atIndex:0];
                    }
                    if (beforminutes.length<2) {
                        [beforminutes insertString:@"0" atIndex:0];
                    }
                    
                    cell.timeButton.text = [NSString stringWithFormat:@"%@小时%@分钟",beforhours,beforminutes];
                    
                }
                
            }
            
            return  cell;
            
            
        }
            break;
            
    }
    
    return cell;
    
}

#pragma mark- tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view;
    
    if (section!=3) {
        
        view = [[UIView alloc]init];
        UILabel *label = [[UILabel alloc]init];
        [view addSubview:label];
        label.sd_layout
        .bottomSpaceToView(view, 9)
        .leftSpaceToView(view,12)
        .rightSpaceToView(view,12)
        .autoHeightRatio(0);
        label.textColor = [UIColor colorWithHexString:@"666666"];
        label.font = [UIFont systemFontOfSize:13];
        if (section == 0) {
            label.text = @"提醒范围";
            
        }else if (section ==1){
            label.text = @"提醒课程";
            
        }else if (section == 2){
            label.text = @"提醒方式";
            
        }
        
    }
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    CGFloat height =0;
    if (section!=3) {
        
        if (section == 0) {
            height = 27*ScrenScale;
        }else{
            
            height = 47*ScrenScale;
        }
    }
    
    return height;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * view ;
    
    if (section == 2) {
        view = [[UIView alloc]init];
        UILabel *label = [[UILabel alloc]init];
        [view addSubview:label];
        label.sd_layout
        .topSpaceToView(view,6)
        .leftSpaceToView(view,12)
        .rightSpaceToView(view,12)
        .autoHeightRatio(0);
        label.text = @"为了您能正常使用此功能，请在“系统设置”>“答疑时间”>“通知”中允许接收通知";
        label.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
        label.font = [UIFont systemFontOfSize:12];
        return view;
    }
    
    return view;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 2) {
        
        return 47*ScrenScale;
    }
    return 0;
}



/* 选择时间段*/
- (void)chooseTime:(UILabel *)sender{
    
    _effect = [[UIVisualEffectView alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, self.view.height_sd)];
    _effect.backgroundColor = [UIColor blackColor];
    _effect.alpha = 0;
    
    //    UIBlurEffect *effec=[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //    _effect.effect = effec;
    UITapGestureRecognizer *effectTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resign)];
    [_effect addGestureRecognizer:effectTap];
    
    [self.view addSubview:_effect];
    
    _hours = @[@"01小时",@"02小时",@"03小时",@"04小时",@"05小时",@"06小时",@"07小时",@"08小时",@"09小时",@"10小时",@"11小时",@"12小时",@"13小时",@"14小时",@"15小时",@"16小时",@"17小时",@"18小时",@"19小时",@"20小时",@"21小时",@"22小时",@"23小时",@"24小时"];
    _minutes = @[@"01分钟",@"02分钟",@"03分钟",@"04分钟",@"05分钟",@"10分钟",@"15分钟",@"20分钟",@"25分钟",@"30分钟",@"40分钟",@"50分钟"];
    
    _pickerBackGround = [[UIView alloc]init];
    _pickerBackGround.frame = CGRectMake(0, self.view.height_sd, self.view.width_sd, self.view.height_sd/5*2);
    _pickerBackGround.backgroundColor = BUTTONRED;
    [self.view addSubview:_pickerBackGround];
    
    _timePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, _pickerBackGround.width_sd, _pickerBackGround.height_sd-40)];
    
    [_pickerBackGround addSubview:_timePicker];
    _timePicker.backgroundColor= [UIColor whiteColor];
    _timePicker.delegate = self;
    _timePicker.dataSource = self;
    
    //    UIView *func = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 40)];
    //    func.backgroundColor = [UIColor blueColor];
    //    [_timePicker addSubview:func];
    
    UIButton *sure = [[UIButton alloc]init];
    sure.userInteractionEnabled = YES;
    [_pickerBackGround addSubview:sure];
    sure.sd_layout
    .topSpaceToView(_pickerBackGround,5)
    .rightSpaceToView(_pickerBackGround,5)
    .heightIs(40)
    .widthIs(80);
    
    
    [sure updateLayout];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sure.enabled = YES;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _effect.alpha = 0.3;
        _pickerBackGround.frame =CGRectMake(0, self.view.height_sd/5*3, self.view.width_sd, self.view.height_sd/5*2);
        //        func.frame =CGRectMake(0, self.view.height_sd/5*3-30, self.view.width_sd, 40);
        
        
    }];
    
    [sure addTarget:self action:@selector(choseTime) forControlEvents:UIControlEventTouchUpInside];
    
    
}

/* 选择时间完成后确认*/
- (void)choseTime{
    
    [UIView animateWithDuration:0.3 animations:^{
        _effect.alpha = 0;
        _pickerBackGround.frame = CGRectMake(0, self.view.height_sd, self.view.width_sd, self.view.height_sd/5*2);
        
        
    }];
}

#pragma mark- pickerview datasource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 2;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    NSInteger rows = 0;
    switch (component) {
        case 0:
            rows =  _hours.count;
            break;
            
        case 1:
            rows = _minutes.count;
            break;
    }
    
    return rows;
}

#pragma mark- pickerview delegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *title = nil;
    if (component == 0){
        title = [NSString stringWithFormat:@"%@", _hours[row]];
        
    }
    
    if (component == 1){
        title = [NSString stringWithFormat:@"%@",_minutes[row]];
    }
    
    return title;
    
    
}

/* 选择器确定选择*/
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    ClassNoticeTimeSettingTableViewCell *cell = [_menuTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    NSMutableString *str =[NSMutableString stringWithFormat:@"%@",cell.timeButton.text];
    
    if (component==0) {
        [str replaceCharactersInRange:NSMakeRange(0, 4) withString:_hours[row]];
        
        cell.timeButton.text = str;
        
        [_settingDic setValue:[_hours[row] substringWithRange:NSMakeRange(0, 2)] forKey:@"before_hours"];
        
        
    }else if (component==1) {
        
        [str replaceCharactersInRange:NSMakeRange(4, 4) withString:_minutes[row]];
        
        cell.timeButton.text = str;
        
        [_settingDic setValue:[_minutes[row] substringWithRange:NSMakeRange(0, 2)] forKey:@"before_minutes"];
    }
    
}

/* 设置消息提醒*/
- (void)turnNoticeStatus:(UISwitch *)sender{
    
    //有接口了之后再添加方法
    if (sender.selected ==YES) {
        sender.selected = NO;
        changeSettings =YES;
        
        if (sender.tag == 1) {
            
        }else if (sender.tag == 2){
            
        }else if (sender.tag == 3){
            
        }else if (sender.tag == 4){
            
        }else if (sender.tag == 5) {
            [_settingDic setValue:@"0" forKey:@"message"];
        }else if (sender.tag ==2){
            [_settingDic setValue:@"0" forKey:@"notice"];
        }
        
    }else if (sender.selected ==NO){
        sender.selected = YES;
        changeSettings =YES;
        
        if (sender.tag == 1) {
            
        }else if (sender.tag == 2){
            
        }else if (sender.tag == 3){
            
        }else if (sender.tag == 4){
            
        }else if (sender.tag == 6) {
            [_settingDic setValue:@"1" forKey:@"message"];
        }else if (sender.tag ==2){
            [_settingDic setValue:@"1" forKey:@"notice"];
        }
    }
    
}



#pragma mark- tableview delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}


- (void)returnLastPage{
    
    /* 保存设置*/
    [self saveSettings];
    
}

- (void)exit{
    [self.navigationController popViewControllerAnimated: YES];
    
    
}

- (void)resign{
    [UIView animateWithDuration:0.3 animations:^{
        
        _effect.alpha = 0;
        _pickerBackGround.frame = CGRectMake(0, self.view.height_sd, self.view.width_sd, self.view.height_sd/5*2);
    }];
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _effect.alpha = 0;
        _pickerBackGround.frame = CGRectMake(0, self.view.height_sd, self.view.width_sd, self.view.height_sd/5*2);
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
