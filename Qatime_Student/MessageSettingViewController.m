//
//  MessageSettingViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/30.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "MessageSettingViewController.h"
#import "NoticeSettingTableViewCell.h"
#import "RDVTabBarController.h"
#import "ClassNoticeSettingTableViewCell.h"
#import "NIMSDK.h"
#import "NoticeSwitchTableViewCell.h"

@interface MessageSettingViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NavigationBar *_navigtionBar;
    
    BOOL allowVoice;
    BOOL allowAlert;
    BOOL allowNotification;
}

@end

@implementation MessageSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
    
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
        _.bounces=NO;
        _;
    });
    
    
    /* 读取本地保存的按钮和开关状态*/
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"NotificationVoice"]) {
        allowVoice =[[NSUserDefaults standardUserDefaults]boolForKey:@"NotificationVoice"];
    }else{
        allowVoice = YES;
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"NotificationVoice"];
    }
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"NotificationAlert"]) {
        allowAlert =[[NSUserDefaults standardUserDefaults]boolForKey:@"NotificationAlert"];
    }else{
        allowAlert = YES;
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"NotificationAlert"];
    }
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
            ClassNoticeSettingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[ClassNoticeSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
                cell.name.text = @"通知方式";
                cell.leftLabel.text = @"声音";
                cell.rightLabel.text = @"震动";
                
                cell.leftButton.tag = 0;
                [cell.leftButton addTarget:self action:@selector(turnNoticeStatus:) forControlEvents:UIControlEventTouchUpInside];
                if (allowVoice==NO) {
                    
                    [self senderTurnUnSelected:cell.leftButton];
                    
                }else{
                    [self senderTurnSelected:cell.leftButton];

                }
                
                cell.rightButton.tag = 1;
                [cell.rightButton addTarget:self action:@selector(turnNoticeStatus:) forControlEvents:UIControlEventTouchUpInside];
                
                if (allowAlert==NO) {
                    
                    [self senderTurnUnSelected:cell.rightButton];
                    
                }else{
                    [self senderTurnSelected:cell.rightButton];

                }

            }
            return  cell;
        }
            break;
            
        case 1:{
            NoticeSwitchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell==nil) {
                cell=[[NoticeSwitchTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
                
                [cell.noticeSwitch addTarget:self action:@selector(switchNotice:) forControlEvents:UIControlEventTouchUpInside];
                
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

/* 改变通知方式*/
- (void)turnNoticeStatus:(UIButton *)sender{
    
    switch (sender.tag) {
        case 0:{
            /* 关闭/开启提醒声音*/
            [self switchSender:sender];
            
            [[NSUserDefaults standardUserDefaults]setBool:sender.selected forKey:@"NotificationVoice"];
            
            /* 开启/关闭推送声音的通知*/
            [[NSNotificationCenter defaultCenter]postNotificationName:@"NotificationSound" object:sender];
            
        }
            break;
        case 1:{
            /* 关闭/开启提醒震动*/
             [self switchSender:sender];
            
             [[NSUserDefaults standardUserDefaults]setBool:sender.selected forKey:@"NotificationAlert"];
            
            /* 开启/关闭推送声音的通知*/
            [[NSNotificationCenter defaultCenter]postNotificationName:@"NotificationAlert" object:sender];
        }
            break;
  
    }
    
}

#pragma mark- 声音和震动的开关方法
- (void)switchSender:(UIButton *)sender{
    
    if (sender.selected ==YES) {
        
        [self senderTurnUnSelected:sender];

    }else if (sender.selected ==NO){
        [self senderTurnSelected:sender];
        
    }
    
}

/* 按钮变成选中状态*/
- (void)senderTurnSelected:(UIButton *)sender{
    
    sender.layer.borderWidth =0;
    sender.backgroundColor = [UIColor colorWithRed:0.84 green:0.33 blue:0.6 alpha:1.00];
    [sender setImage:[UIImage imageNamed:@"right_button"] forState:UIControlStateNormal];
    sender.selected = YES;
    
}

/* 按钮变成未选中状态*/
- (void)senderTurnUnSelected:(UIButton *)sender{
    
    sender.layer.borderColor = [UIColor lightGrayColor].CGColor;
    sender.layer.borderWidth =2;
    sender.backgroundColor = [UIColor clearColor];
    [sender setImage:nil forState:UIControlStateNormal];
    sender.selected = NO;

    
}



#pragma mark- tableview delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.view.height_sd*0.07;
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
