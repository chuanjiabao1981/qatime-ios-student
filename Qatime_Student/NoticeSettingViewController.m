//
//  NoticeSettingViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/30.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "NoticeSettingViewController.h"
#import "SettingTableViewCell.h"
#import "NavigationBar.h"
#import "MessageSettingViewController.h"
#import "ClassSettingViewController.h"
#import "RDVTabBarController.h"

@interface NoticeSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    NavigationBar *_navigationBar;
}

@end

@implementation NoticeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
    
    _navigationBar = ({
        
        NavigationBar *_=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
        [self.view addSubview:_];
        
        _.titleLabel.text = @"消息设置";
        
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(returLastPage) forControlEvents:UIControlEventTouchUpInside];
        _;
    
    });
    
    _menuTableView = ({
      
        UITableView * _ = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        _.tableFooterView = [[UIView alloc]init];
        [self.view addSubview:_];
        _.separatorStyle = UITableViewCellSeparatorStyleNone;
        _.bounces = NO;
        _.delegate = self;
        _.dataSource = self;
        _;
        
        
    });
    
    
}

#pragma mark- tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    SettingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[SettingTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
        cell.settingName.sd_layout
        .leftSpaceToView(cell.contentView,20);
        
        switch (indexPath.row) {
            case 0:{
                
                cell.settingName.text =@"系统通知";
                [cell.arrow setImage:[UIImage imageNamed:@"rightArrow"]];
            }
                break;
            case 1:{
                
                cell.settingName.text =@"课程提醒";
                [cell.arrow setImage:[UIImage imageNamed:@"rightArrow"]];
            }
                break;
            
        }
        
    }
    
    return  cell;
}

#pragma mark- tableview delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.view.height_sd*0.07;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:{
            MessageSettingViewController *mVC=[MessageSettingViewController new];
            [self.navigationController pushViewController:mVC animated:YES];
            
        }
            break;
        case 1:{
            ClassSettingViewController *cVC=[ClassSettingViewController new];
            [self.navigationController pushViewController:cVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }
    
    
}




- (void)returLastPage{
    
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
