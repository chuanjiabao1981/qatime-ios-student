//
//  AllClassViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/28.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "AllClassViewController.h"
#import "NavigationBar.h"
#import "AllClassView.h"
#import "ClassTimeModel.h"
#import "ClassTimeTableViewCell.h"
#import "YYModel.h"
#import "UIViewController_HUD.h"
#import "UIViewController+HUD.h"

#define SCREENWIDTH self.view.frame.size.width
#define SCREENHEIGHT self.view.frame.size.height


@interface AllClassViewController ()<FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance,UITableViewDelegate,UITableViewDataSource>{
    
    NavigationBar *_navigationBar;
    
    NSString  *_token;
    NSString *_idNumber;
    
    /* 保存未上课数据的数组*/
    NSMutableArray *_unclosedArr;
    NSMutableArray  *_unclosedDateArr;
    
    
    /* 保存已上课数据的数组*/
    NSMutableArray *_closedArr;
    NSMutableArray  *_closedDateArr;
    
    
    /* 保存所有课程数据*/
    
    NSMutableArray  *_allClassArr;
    
    /* 日期选项对应的cell数据保存的数组*/
    NSMutableArray *_dataArr;
    
    
    
    
}




@end

@implementation AllClassViewController


- (void)loadView{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    [self.view addSubview:_navigationBar];
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"leftArrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    
    /* 日历*/
    _allClassView = [[AllClassView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT*2/5)];
    [self.view addSubview:_allClassView];
    //    _allClassView.calendarView.calendarView.calendarHeaderView.backgroundColor = USERGREEN;
    /* 日历的设置*/
    _allClassView.calendarView.calendarView.appearance.headerMinimumDissolvedAlpha = 0;
    _allClassView.calendarView.calendarView.appearance.eventDefaultColor = [UIColor redColor];
    
    
    _classTableView = [[UITableView alloc]init];
    [self.view addSubview:_classTableView];
    _classTableView.sd_layout
    .topSpaceToView(_allClassView, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view,0);
    _classTableView.backgroundColor = [UIColor whiteColor];
    _classTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    
//    _classTableView.tableHeaderView = _allClassView;
//    _classTableView.tableHeaderView.size = CGSizeMake(SCREENWIDTH, SCREENHEIGHT*4/5);
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navigationBar.titleLabel.text = @"全部课程";
    
    _allClassView.calendarView.calendarView.delegate = self;
    _allClassView.calendarView.calendarView.dataSource = self;
    
    _classTableView.delegate = self;
    _classTableView.dataSource = self;
    _classTableView.bounces = NO;
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    /* 初始化*/
    _unclosedArr = @[].mutableCopy;
    _unclosedDateArr = @[].mutableCopy;
    _closedArr = @[].mutableCopy;
    _closedDateArr = @[].mutableCopy;
    _dataArr  = @[].mutableCopy;
    _allClassArr = @[].mutableCopy;
    
    
    /* 请求所有的课程表数据*/
    
    [self requestUnclosedClassList];
    [self requestClosedClassList];
    
    
    
    
    /** table里的默认数据，是当天的课程表
     日历默认显示的是当天，那么table默认显示的就是当天的数据。
     如果为空，数组为空，delegate进行判断。
     */
    /* 在加载完所有数据后，日历更新提醒数据之后进行加载*/
//    [self loadCurrentDay];
    
    
    
    
    
}

/* 加载当天的 数据*/
- (void)loadCurrentDay{
    
    
    [_dataArr removeAllObjects];
    if (_allClassArr) {
        /* 造出包含所有数据的数组*/
        
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *currentDate = [NSDate date];
        
        /* 遍历时间*/
        for (ClassTimeModel *model in _allClassArr) {
          
            if ([model.class_date isEqualToString:[dateFormatter stringFromDate:currentDate]]) {
                
                NSLog(@"%@",model.live_time);
                NSLog(@"%@",[dateFormatter stringFromDate:currentDate]);
                
                [_dataArr addObject:model];
                
            }
            
        }
    }
    NSLog(@"%@",_dataArr);
    /* 在刷新日历table的视图*/

    [self updateTable];
}

- (void)updateTable{
    
    [_classTableView reloadData];
    [_classTableView setNeedsDisplay];
    
    [self  loadingHUDStopLoadingWithTitle:@"加载完成"];

    
}



#pragma mark- 请求未上课课程表数据
- (void)requestUnclosedClassList{
    
    if (_token&&_idNumber) {
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
        [manager GET:[NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/live_studio/students/%@/schedule?state=unclosed",_idNumber] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            /* 回复数据正确的情况下*/
            if ([dic[@"status"] isEqual:[NSNumber numberWithInt:1]]) {
                
                NSLog(@"%@",dic[@"data"]);
                
                for (NSDictionary *classDic in dic[@"data"]) {
                    
                    for (NSDictionary *lessons in classDic[@"lessons"]) {
                        
                        
                        ClassTimeModel *mod = [ClassTimeModel yy_modelWithJSON:lessons];
                        mod.classID = lessons[@"id"];
                        
                        
                        [_unclosedArr addObject:mod];
                        
                        /* 多加了一个保存课程时间的数组*/
                        [_unclosedDateArr addObject:mod.class_date];
                        
                        
                    }
                    
                }
                
                NSLog(@"%@",_unclosedArr);
                
                /* 在所有课程中添加该数组*/
                
                [_allClassArr addObjectsFromArray:_unclosedArr];
                /* 加载一次日历Table的数据*/
                [self loadCurrentDay];
                
                [_allClassView.calendarView.calendarView reloadData];
                
            }else{
                
                /* 回复数据不正确*/
            }
            
            //            [self updateTablesData];
            //            [self endRefresh];
            
            /* 日历刷新*/
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }else{
        
        /* 登录报错*/
        
    }
    
    //     NSLog(@"%@",_unclosedArr);
    
    
    
}

- (void)requestClosedClassList{
    if (_token&&_idNumber) {
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
        [manager GET:[NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/live_studio/students/%@/schedule?state=closed",_idNumber] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            /* 回复数据正确的情况下*/
            if ([dic[@"status"] isEqual:[NSNumber numberWithInt:1]]) {
                
                NSLog(@"%@",dic[@"data"]);
                
                for (NSDictionary *classDic in dic[@"data"]) {
                    
                    for (NSDictionary *lessons in classDic[@"lessons"]) {
                        
                        
                        ClassTimeModel *mod = [ClassTimeModel yy_modelWithJSON:lessons];
                        mod.classID = lessons[@"id"];
                        
                        
                        [_closedArr addObject:mod];
                        
                        [_closedDateArr addObject:mod.class_date];
                    }
                    
                }
                
                NSLog(@"%@",_closedArr);
                
            }else{
                
                /* 回复数据不正确*/
                
            }
            //            [self updateTablesData];
            //            [self endRefresh];
            
            
            /* 在所有数据的数组中，添加该数组*/
            [_allClassArr addObjectsFromArray:_closedArr];
            
            /* 加载一次日历Table的数据*/
            [self loadCurrentDay];
            
            /* 日历刷新*/
            [_allClassView.calendarView.calendarView reloadData];
            
            
            
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }else{
        
        /* 登录报错*/
        
    }
    
}



#pragma mark- Calendar 的代理

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    NSMutableArray *dateArr = [NSMutableArray arrayWithArray:_unclosedDateArr];
    [dateArr addObjectsFromArray:_closedDateArr];
    
    if (dateArr.count!=0) {
        
        for (int i = 0; i<dateArr.count; i++) {
            
            if (date == [dateFormatter dateFromString:dateArr[i]]) {
                
                return 1;
            }
            
        }
        
        
    }else{
        
        /* 数据错误*/
    }
    
    
    return 0;
    
}


/* 选中日期*/
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date{
    
    [_dataArr removeAllObjects];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    for (ClassTimeModel *mod in _allClassArr) {
        
        if ([dateStr isEqualToString:mod.class_date]) {
            
            
            [_dataArr addObject:mod];
            
        }
        
        
    }
    
    [self updateTable];
    
    
}


#pragma mark- TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows = 1;
    
    if (_dataArr.count!=0) {
        rows = _dataArr.count;
    }
    
    
    
    return rows;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    ClassTimeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[ClassTimeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
        cell.sd_tableView = tableView;
        
        NSLog(@"%ld",_dataArr.count);
        
    }
    if (_dataArr.count!=0) {
        
        cell.model = _dataArr[indexPath.row];
        
        NSLog(@"%@",[cell.model course_name]);
    }
    
    return  cell;
}

#pragma mark- tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
    
}



- (void)returnLastPage{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
