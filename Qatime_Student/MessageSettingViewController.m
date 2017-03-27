//
//  MessageSettingViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/30.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "MessageSettingViewController.h"
#import "NoticeSettingTableViewCell.h"
 
#import "ClassNoticeSettingTableViewCell.h"
#import <NIMSDK/NIMSDK.h>

#import "NoticeSwitchTableViewCell.h"
#import "NoticeWaysTableViewCell.h"

@interface MessageSettingViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NavigationBar *_navigtionBar;
    
//    BOOL allowVoice;
//    BOOL allowAlert;
    BOOL allowNotification;
}

@end

@implementation MessageSettingViewController

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
    
    _menuTableView = ({
        UITableView *_=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64)];
        [self.view addSubview:_];
        _.delegate = self;
        _.dataSource =self;
        _.separatorStyle = UITableViewCellSeparatorStyleNone;
        _.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:0.97];
        _.bounces=NO;
        _;
    });
    
    
    /* 读取本地保存的按钮和开关状态*/

    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"IMNotification"]) {
        allowNotification =[[NSUserDefaults standardUserDefaults]boolForKey:@"IMNotification"];
    }else{
        allowNotification = YES;
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"IMNotification"];
    }
    
    
}

#pragma mark- tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    static NSString *cellID = @"cellID";
    
    switch (indexPath.row) {
        case 0:{
            NoticeWaysTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[NoticeWaysTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                cell.name.text = @"通知方式";
                cell.content.text = @"已跟随手机设置";
            }
            return  cell;
        }
            break;
            
        case 1:{
            NoticeSwitchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell==nil) {
                cell=[[NoticeSwitchTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
                cell.noticeSwitch.onTintColor = BUTTONRED;
                [cell.noticeSwitch addTarget:self action:@selector(switchNotice:) forControlEvents:UIControlEventTouchUpInside];
                cell.name.text = @"接收辅导班消息通知";
               [cell.noticeSwitch setOn:allowNotification==YES?YES:NO];
                
            }
            return cell;
        }
            break;
    }
    
    return  cell;
    

}
/* 开启和关闭消息推送*/
- (void)switchNotice:(UISwitch *)sender{
    
    NIMPushNotificationSetting *setting =  [[[NIMSDK sharedSDK] apnsManager] currentSetting];
    /* 如果要打开开关*/
    if (sender.on==YES) {
        /* 开启聊天消息推送*/
        setting.noDisturbing = NO;
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"IMNotification"];
        [[[NIMSDK sharedSDK] apnsManager] updateApnsSetting:setting
                                                 completion:^(NSError *error) {}];
        
    }else{
        /* 关闭消息推送*/
        setting.noDisturbing = YES;
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"IMNotification"];
        [[[NIMSDK sharedSDK] apnsManager] updateApnsSetting:setting
                                                 completion:^(NSError *error) {}];
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification" object:sender];
    
}



#pragma mark- tableview delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * view = [[UIView alloc]init];
    
    view.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00]
    ;
    
//    UIView *line = [[UIView alloc]init];
//    line.backgroundColor = SEPERATELINECOLOR;
//    [view addSubview:line];
//    line.sd_layout
//    .leftEqualToView(view)
//    .rightEqualToView(view)
//    .bottomEqualToView(view)
//    .heightIs(0.5);
    
    UILabel *label = [[UILabel alloc]init];
    [view addSubview:label];
    label.sd_layout
    .topSpaceToView(view,6)
    .leftSpaceToView(view,12)
    .rightSpaceToView(view,12)
    .autoHeightRatio(0);
    label.text = @"为了您能正常使用此功能，请在“系统设置”>“答疑时间”>“通知”中允许接收通知";
    label.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
    label.font = [UIFont systemFontOfSize:12*ScrenScale];
    return view;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 46;
}


- (void)returnLastPage{
    
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
