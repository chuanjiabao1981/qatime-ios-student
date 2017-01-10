//
//  PersonalInfoEditViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/1/10.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "PersonalInfoEditViewController.h"
#import "NavigationBar.h"
#import "MMPickerView.h"
#import "UIImageView+WebCache.h"

@interface PersonalInfoEditViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NavigationBar *_navigationBar;
    
    /*保存个人信息数据的字典*/
    
    NSMutableDictionary *_infoDic;
    
    /* 是否修改头像了*/
    BOOL changeImage;
    
    /* 年级必填*/
    BOOL grade;
    
    /* 是不是改了生日*/
    BOOL changeBirthday;
    
    
    /* 注册页面初始化传值的变量*/
    NSString *_userName;
    NSString *_userGrade;
    UIImage *_userImage;
    
    /* 是否传值过来的?*/
    BOOL WriteMore;
    
    /* 上传头像用的数据流*/
    NSData *_avatar;
    
    
}

@end

@implementation PersonalInfoEditViewController

/* 初始化加载个人信息*/
-(instancetype)initWithInfo:(NSDictionary *)info{
    self = [super init];
    if (self) {
        
        _infoDic = [NSMutableDictionary dictionaryWithDictionary:_infoDic];
        
    }
    return self;
    
}

/* 注册页面传来的完善信息*/
-(instancetype)initWithName:(NSString *)name andGrade:(NSString *)chosegrade andHeadImage:(UIImage *)headImage withImageChange:(BOOL)imageChange{
    
    self = [super init];
    if (self) {
        
        if (name!=nil) {
            
            _userName = [NSString stringWithFormat:@"%@",name];
        }
        if (chosegrade!=nil) {
            
            _userGrade = [NSString stringWithFormat:@"%@",chosegrade];
        }
        if (headImage!=nil) {
            if (imageChange == YES) {
                
                _userImage = [[UIImage alloc]init];
                _userImage  = headImage;
                
                /* 直接赋值照片data*/
                _avatar = UIImageJPEGRepresentation(_userImage,0.8);
                
                changeImage = YES;
                
            }else{
                
            }
        }
        
        /* 是"完善更多场景"*/
        
        WriteMore = YES;
        
    }
    return self;
}


- (void)loadView{
    [super loadView];
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
    [self.view addSubview:_navigationBar];
    
    _editTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd , self.view.height_sd-64) style:UITableViewStylePlain];
    [self.view addSubview:_editTableView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    _navigationBar.titleLabel.text = @"修改个人信息";
    
    /* 指定列表代理*/
    _editTableView.delegate = self;
    _editTableView.dataSource = self;
    
    
    
}

#pragma mark- tableview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =  [UITableViewCell new];
    
    switch (indexPath.row) {
        case 0:{
            
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            EditHeadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[EditHeadTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
            }
            /* 如果是在"完善更多"的前提下*/
            if (WriteMore == YES) {
                
                /* 如果传来的图片不为nil*/
                if (changeImage==YES) {
                    [cell.headImage setImage:_userImage];
                }else{
                    [cell.headImage setImage:[UIImage imageNamed:@"人"]];
                }
                
                /* 如果是在个人信息中心完善更多信息*/
            }else{
                
                if (_infoDic[@"avatar_url"]) {
                    if (![_infoDic[@"avatar_url"]isEqual:[NSNull null]]) {
                        
                        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:_infoDic[@"avatar_url"]]];
                    }else{
                        [cell.headImage setImage:[UIImage imageNamed:@"人"]];
                    }
                }
                
            }
            
            
            return  cell;
            
        }
            break;
        case 1:{
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            EditNameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[EditNameTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            }
            
            
            
            return  cell;
            
        }
            break;
        case 2:{
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            EditGenderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[EditGenderTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
                
                
                
            }
            
            return  cell;
            
        }
            break;
        case 3:{
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            EditBirthdayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[EditBirthdayTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
                cell.name.text = @"生日";
                
                
            }
            
            return  cell;
            
        }
            break;
        case 4:{
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            EditBirthdayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[EditBirthdayTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
                cell.name.text = @"年级";
                
                
            }
            
            return  cell;
            
        }
            break;
        case 5:{
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            EditNameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[EditNameTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
                cell.name.text = @"简介";
                cell.nameText.placeholder = @"一句话介绍自己";
            }
            
            return  cell;
            
        }
            break;
    }
    
    return cell;
}
#pragma mark- tableview datesource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger height = 0;
    
    if (indexPath.row == 0) {
        height =  self.view.height_sd*0.15;
    }else{
        height = self.view.height_sd*0.07;
    }
    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 3:{
            HcdDateTimePickerView *datePicker = [[HcdDateTimePickerView alloc]initWithDatePickerMode:DatePickerDateMode defaultDateTime:[NSDate date]];
            [self.view addSubview:datePicker];
            [datePicker showHcdDateTimePicker];
            typeof(self) __weak weakSelf = self;
            datePicker.clickedOkBtn = ^(NSString *dateTimeStr){
                
                EditBirthdayTableViewCell *cell= [weakSelf.editTableView cellForRowAtIndexPath:indexPath];
                cell.content.text = dateTimeStr;
                
            };
            
        }
            break;
            
        case 4:{
            [MMPickerView showPickerViewInView:self.view withStrings:[[NSUserDefaults standardUserDefaults]objectForKey:@"grade"] withOptions:@{NSFontAttributeName:[UIFont systemFontOfSize:22]} completion:^(NSString *selectedString) {
                
                EditBirthdayTableViewCell *cell= [_editTableView cellForRowAtIndexPath:indexPath];
                cell.content.text = selectedString;
                
            }];
            
        }
            break;
    }
    
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
