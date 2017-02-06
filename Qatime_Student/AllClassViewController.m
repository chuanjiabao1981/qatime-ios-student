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

#import "HaveNoClassView.h"
#import "RDVTabBarController.h"
#import "TutoriumInfoViewController.h"

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
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    
    /* 日历*/
    _allClassView = [[AllClassView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT*2/5)];
    [self.view addSubview:_allClassView];
    //    _allClassView.calendarView.calendarView.calendarHeaderView.backgroundColor = USERGREEN;
    /* 日历的设置*/
    _allClassView.calendarView.calendarView.appearance.headerMinimumDissolvedAlpha = 0;
    _allClassView.calendarView.calendarView.appearance.eventDefaultColor = [UIColor redColor];
    _allClassView.calendarView.calendarView.appearance.adjustsFontSizeToFitContentSize = NO;
    _allClassView.calendarView.calendarView.appearance.headerDateFormat = @"yyyy年MM月";
    _allClassView.calendarView.calendarView.firstWeekday = 2;
    
    //创建点击跳转显示上一月和下一月button
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousButton.frame = CGRectMake(self.view.centerX -100, 13*ScrenScale, 20, 20);
    [previousButton setImage:[UIImage imageNamed:@"lastMonth"] forState:UIControlStateNormal];
    [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    [previousButton setEnlargeEdge:20];
    [_allClassView.calendarView.calendarView addSubview:previousButton];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(self.view.centerX +80, 13*ScrenScale,20, 20);
       [nextButton setImage:[UIImage imageNamed:@"nextMonth"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setEnlargeEdge:20];
    [_allClassView.calendarView.calendarView addSubview:nextButton];
    
    
    
    
    _classTableView = [[UITableView alloc]init];
    [self.view addSubview:_classTableView];
    _classTableView.sd_layout
    .topSpaceToView(_allClassView, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view,0);
    _classTableView.backgroundColor = [UIColor whiteColor];
    _classTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    _haveNoClassView = [[HaveNoClassView alloc]init];
    _haveNoClassView.titleLabel.text = @"当日无课程";
    
    [self.view addSubview:_haveNoClassView];
    _haveNoClassView.sd_layout
    .topEqualToView(_classTableView)
    .bottomEqualToView(_classTableView)
    .leftEqualToView(_classTableView)
    .rightEqualToView(_classTableView);
    
    _haveNoClassView.hidden = NO;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    
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
    
    [self requestUnclosedClassListWithMonth:nil];
    [self requestClosedClassListWithMonth:nil];
    
    
    
    
    /** table里的默认数据，是当天的课程表
     日历默认显示的是当天，那么table默认显示的就是当天的数据。
     如果为空，数组为空，delegate进行判断。
     */
    /* 在加载完所有数据后，日历更新提醒数据之后进行加载*/
//    [self loadCurrentDay];
    
   
    
}

//上一月按钮点击事件
- (void)previousClicked:(id)sender {
    
    NSDate *currentMonth = _allClassView.calendarView.calendarView.currentPage;
    NSDate *previousMonth = [_allClassView.calendarView.calendarView dateBySubstractingMonths:1 fromDate:currentMonth];
    [_allClassView.calendarView.calendarView setCurrentPage:previousMonth animated:YES];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *datestr = [NSString stringWithFormat:@"%@",[formatter stringFromDate:previousMonth]];
    
    _allClassArr = @[].mutableCopy;
    [self requestUnclosedClassListWithMonth:datestr];
    [self requestClosedClassListWithMonth:datestr];
    
    
}

//下一月按钮点击事件
- (void)nextClicked:(id)sender {
    
    NSDate *currentMonth = _allClassView.calendarView.calendarView.currentPage;
    NSDate *nextMonth = [_allClassView.calendarView.calendarView dateByAddingMonths:1 toDate:currentMonth];
    [_allClassView.calendarView.calendarView setCurrentPage:nextMonth animated:YES];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *datestr = [NSString stringWithFormat:@"%@",[formatter stringFromDate:nextMonth]];
    
    _allClassArr = @[].mutableCopy;
    [self requestUnclosedClassListWithMonth:datestr];
    [self requestClosedClassListWithMonth:datestr];

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

/* 跟新tableview*/
- (void)updateTable{
    
    [_classTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
   
    
    [self  loadingHUDStopLoadingWithTitle:@"加载完成"];

    
}



#pragma mark- 请求未上课课程表数据
- (void)requestUnclosedClassListWithMonth:(NSString * _Nullable)date{
    
    NSString *dateString = @"".mutableCopy;
    
    if (date == nil) {
        dateString = @"";
    }else{
        dateString = [NSString stringWithFormat:@"&month=%@",date];
    }
    
    if (_token&&_idNumber) {
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
        [manager GET:[NSString stringWithFormat:@"%@/api/v1/live_studio/students/%@/schedule?state=unclosed%@",Request_Header,_idNumber,dateString] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            _unclosedArr = @[].mutableCopy;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            [self loginStates:dic];
            
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

- (void)requestClosedClassListWithMonth:(NSString * _Nullable)date{
    
    NSString *dateString = @"".mutableCopy;
    
    if (date == nil) {
        dateString = @"";
    }else{
        dateString = [NSString stringWithFormat:@"&month=%@",date];
    }

    
    if (_token&&_idNumber) {
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
        [manager GET:[NSString stringWithFormat:@"%@/api/v1/live_studio/students/%@/schedule?state=closed%@",Request_Header,_idNumber,dateString] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            _closedArr = @[].mutableCopy;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            [self loginStates:dic];
            
            /* 回复数据正确的情况下*/
            if ([dic[@"status"] isEqual:[NSNumber numberWithInt:1]]) {
                
                
                
                for (NSDictionary *classDic in dic[@"data"]) {
                    
                    for (NSDictionary *lessons in classDic[@"lessons"]) {
                        
                        
                        ClassTimeModel *mod = [ClassTimeModel yy_modelWithJSON:lessons];
                        mod.classID = lessons[@"id"];
                        
                        
                        [_closedArr addObject:mod];
                        
                        [_closedDateArr addObject:mod.class_date];
                    }
                    
                }
                
                
                
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
    
    if (_allClassArr.count!=0) {
        
        for (ClassTimeModel *mod in _allClassArr) {
            
            if ([dateStr isEqualToString:mod.class_date]) {
                
                [_dataArr addObject:mod];
                
                
            }else{
                
                
                
            }
        }
        
    }else{
        
        
    }
    
    if (_dataArr.count>0) {
        
        _haveNoClassView.hidden = YES;
        
    }else{
        _haveNoClassView.hidden = NO;
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
        
        
    }
    if (_dataArr.count!=0) {
        
        cell.model = _dataArr[indexPath.row];
        
        
    }
    
    return  cell;
}

#pragma mark- tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ClassTimeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    TutoriumInfoViewController *infoVC= [[TutoriumInfoViewController alloc]initWithClassID:cell.model.course_id];
    
    [self.navigationController pushViewController:infoVC animated:YES];
    
    
}



- (void)returnLastPage{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
