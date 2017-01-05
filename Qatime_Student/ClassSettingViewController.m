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


@interface ClassSettingViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
     NavigationBar *_navigtionBar;
}
@end

@implementation ClassSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navigtionBar = ({
        NavigationBar *_ = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
        _.titleLabel.text = @"消息提醒";
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

    
    
}


#pragma mark- tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [UITableViewCell new];
    
    
    if (indexPath.row!=2) {
        
        /* cell的重用队列*/
        static NSString *cellIdenfier = @"cell";
        ClassNoticeSettingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
        if (cell==nil) {
            cell=[[ClassNoticeSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            
            switch (indexPath.row) {
                case 0:{
                    cell.name.text = @"课程范围";
                    cell.leftButton.tag = 0;
                    cell.leftLabel.text = @"辅导班课程";
                    cell.rightButton.tag = 1;
                    cell.rightLabel.text = @"公开课课程";
                    [cell.leftButton addTarget:self action:@selector(turnNoticeStatus:) forControlEvents:UIControlEventTouchUpInside];
                     [cell.rightButton addTarget:self action:@selector(turnNoticeStatus:) forControlEvents:UIControlEventTouchUpInside];
                }
                    break;
                    
                case 1:{
                    cell.name.text = @"提醒方式";
                    cell.leftButton.tag = 2;
                    cell.leftLabel.text = @"短信通知";
                    cell.rightButton.tag = 3;
                    cell.rightLabel.text = @"系统通知";
                    [cell.leftButton addTarget:self action:@selector(turnNoticeStatus:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.rightButton addTarget:self action:@selector(turnNoticeStatus:) forControlEvents:UIControlEventTouchUpInside];
                }
                    
                    break;
                    
            }
        
        }
        
        return  cell;
    }
    if(indexPath.row ==2){
        
        /* cell的重用队列*/
        static NSString *cellID = @"cellID";
        ClassNoticeTimeSettingTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell=[[ClassNoticeTimeSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
            
            cell.name .text = @"设置时间";
            
        }
        
        return  cell;
        
        
    }
    
    return cell;
    
}

- (void)turnNoticeStatus:(UIButton *)sender{
    
    switch (sender.tag) {
        case 0:{
            /* 关闭/开启提醒声音*/
            [self switchSender:sender];
            
            /* 开启/关闭推送声音的通知*/
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"NotificationSound" object:sender];
            
            
            
        }
            break;
        case 1:{
            /* 关闭/开启提醒震动*/
            [self switchSender:sender];
            
            /* 开启/关闭推送声音的通知*/
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"NotificationAlert" object:sender];
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
        
    }else if (sender.selected ==NO){
        sender.layer.borderWidth =0;
        sender.backgroundColor = [UIColor colorWithRed:0.84 green:0.33 blue:0.6 alpha:1.00];
        [sender setImage:[UIImage imageNamed:@"right_button"] forState:UIControlStateNormal];
        sender.selected = YES;
    }
    
    
    
}



#pragma mark- tableview delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}


- (void)returnLastPage{
    
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
