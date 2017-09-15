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
#import "UIViewController+HUD.h"
#import "UIViewController+HUD.h"

#import "HaveNoClassView.h"
#import "UIViewController+Token.h"

#import "TutoriumInfoViewController.h"
#import "UITableView+CYLTableViewPlaceHolder.h"
#import "OneOnOneTutoriumInfoViewController.h"
#import "VideoClassInfoViewController.h"

#import "LivePlayerViewController.h"
#import "VideoClassPlayerViewController.h"
#import "InteractionViewController.h"
#import "UIViewController+AFHTTP.h"
#import "ExclusiveInfoViewController.h"

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
    
    //加载导航栏
    [self setupNavigatoin];
    
    //加载日历
    [self setupCalendar];

    //加载主视图
    [self setupMainView];
    
}
/**加载导航栏*/
- (void)setupNavigatoin{
    //导航栏
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, Navigation_Height)];
    [self.view addSubview:_navigationBar];
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    _navigationBar.titleLabel.text = @"全部课程";

}

/**设置日历视图*/
- (void)setupCalendar{
    _calendar = [[FSCalendar alloc]init];
    [self.view addSubview:_calendar];
    _calendar.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, Navigation_Height)
    .heightIs(SCREENHEIGHT*2/5);
    
    //日历的设置
    _calendar.appearance.headerMinimumDissolvedAlpha = 0;
    _calendar.appearance.eventDefaultColor = [UIColor redColor];
    _calendar.appearance.adjustsFontSizeToFitContentSize = NO;
    _calendar.appearance.headerDateFormat = @"yyyy年MM月";
    _calendar.firstWeekday = 2;
    

    
    //创建点击跳转显示上一月和下一月button
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousButton.frame = CGRectMake(self.view.centerX -100, 13*ScrenScale, 20, 20);
    [previousButton setImage:[UIImage imageNamed:@"lastMonth"] forState:UIControlStateNormal];
    [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    [previousButton setEnlargeEdge:20];
    [_calendar addSubview:previousButton];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(self.view.centerX +80, 13*ScrenScale,20, 20);
    [nextButton setImage:[UIImage imageNamed:@"nextMonth"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setEnlargeEdge:20];
    [_calendar addSubview:nextButton];

}


/**设置主课程显示视图*/
- (void)setupMainView{
    
    _classTableView = [[UITableView alloc]init];
    [self.view addSubview:_classTableView];
    _classTableView.sd_layout
    .topSpaceToView(_calendar, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view,0);
    _classTableView.backgroundColor = [UIColor whiteColor];
    _classTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];

    _calendar.delegate = self;
    _calendar.dataSource = self;
    [_calendar selectDate:[NSDate date]];
    
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
    
    NSDate *currentMonth = _calendar.currentPage;
    NSDate *previousMonth = [_calendar dateBySubstractingMonths:1 fromDate:currentMonth];
    [_calendar setCurrentPage:previousMonth animated:YES];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *datestr = [NSString stringWithFormat:@"%@",[formatter stringFromDate:previousMonth]];
    
    _allClassArr = @[].mutableCopy;
    [self requestUnclosedClassListWithMonth:datestr];
    [self requestClosedClassListWithMonth:datestr];
    
    
}

//下一月按钮点击事件
- (void)nextClicked:(id)sender {
    
    NSDate *currentMonth = _calendar.currentPage;
    NSDate *nextMonth = [_calendar dateByAddingMonths:1 toDate:currentMonth];
    [_calendar setCurrentPage:nextMonth animated:YES];
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
                
                [_dataArr addObject:model];
                
            }
            
        }
    }
    /* 在刷新日历table的视图*/
    [_classTableView cyl_reloadData];
    
}

#pragma mark- 请求未上课课程表数据
- (void)requestUnclosedClassListWithMonth:(NSString * _Nullable)date{
    
    NSString *dateString = @"".mutableCopy;
    
    if (date == nil) {
        dateString = @"";
    }else{
        
    }
    
    if (_token&&_idNumber) {
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
        [manager GET:[NSString stringWithFormat:@"%@/api/v2/live_studio/students/%@/schedule_data",Request_Header,_idNumber] parameters:@{@"date":dateString,@"state":@"unclosed"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
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
                
                /* 在所有课程中添加该数组*/
                [_allClassArr addObjectsFromArray:_unclosedArr];
                /* 加载一次日历Table的数据*/
                [self loadCurrentDay];
                
                [_calendar reloadData];
                
            }else{
                
                /* 回复数据不正确*/
            }
            
            /* 日历刷新*/
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }else{
        
        /* 登录报错*/
        
    }
    
}

- (void)requestClosedClassListWithMonth:(NSString * _Nullable)date{
    
    NSString *dateString = @"".mutableCopy;
    
    if (date == nil) {
        dateString = @"";
    }else{
        
    }
    if (_token&&_idNumber) {
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
        [manager GET:[NSString stringWithFormat:@"%@/api/v1/live_studio/students/%@/schedule_data",Request_Header,_idNumber] parameters:@{@"date":dateString,@"state":@"closed"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
            
            /* 在所有数据的数组中，添加该数组*/
            [_allClassArr addObjectsFromArray:_closedArr];
            
            /* 加载一次日历Table的数据*/
            [self loadCurrentDay];
            
            /* 日历刷新*/
            [_calendar reloadData];
            
            
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }else{
        
        /* 登录报错*/
        
    }
    
}



#pragma mark- Calendar delegate

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
    
    [_classTableView cyl_reloadData];
    
}

#pragma mark- calendar datasource
-(void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    
    if (monthPosition!=FSCalendarMonthPositionCurrent) {
        cell.hidden = YES;
    }else{
        
        cell.hidden = NO;
    }
}


#pragma mark- TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows = 0;
    
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
        
    }
    if (_dataArr.count!=0) {
        
        cell.model = _dataArr[indexPath.row];
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        cell.enterButton.tag = indexPath.row;
        [cell.enterButton addTarget:self action:@selector(enterStudy:) forControlEvents:UIControlEventTouchUpInside];
        [cell showTasteState:cell.model.taste];
        
    }
    
    return  cell;
}

#pragma mark- tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120*ScrenScale;;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIViewController *controller;
    
    ClassTimeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.model.model_name isEqualToString:@"LiveStudio::Course"]) {
        //直播课
        controller= [[TutoriumInfoViewController alloc]initWithClassID:cell.model.course_id];
    }else if ([cell.model.model_name isEqualToString:@"LiveStudio::VideoCourse"]){
        //视频课
        controller = [[VideoClassInfoViewController alloc]initWithClassID:cell.model.course_id];
    }else if ([cell.model.model_name isEqualToString:@"LiveStudio::InteractiveCourse"]){
        //一对一
        controller = [[OneOnOneTutoriumInfoViewController alloc]initWithClassID:cell.model.course_id];
    }else{
        //专属课
        controller = [[ExclusiveInfoViewController alloc]initWithClassID:cell.model.course_id];
    }
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
}

/** 进入学习 */
- (void)enterStudy:(UIButton *)sender{
    
    ClassTimeTableViewCell *cell = [_classTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    __block UIViewController *controller;
    if ([cell.model.model_name isEqualToString:@"LiveStudio::Lesson"]) {
        //直播课
        controller= [[LivePlayerViewController alloc]initWithClassID:cell.model.course_id];
         [self.navigationController pushViewController:controller animated:YES];
    }else if ([cell.model.model_name isEqualToString:@"LiveStudio::VideoLesson"]){
        //视频课
        //先获取视频课程的详情吧
        [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/video_courses/%@",Request_Header,cell.model.classID] withHeaderInfo:nil andHeaderfield:nil parameters:nil completeSuccess:^(id  _Nullable responds) {
           
        } failure:^(id  _Nullable erros) {
            
        }];
     
    }else if ([cell.model.model_name isEqualToString:@"LiveStudio::InteractiveLesson"]){
        //一对一
        //加工数据
        //1.聊天室
        NIMChatroom *chatroom = [[NIMChatroom alloc]init];
        chatroom.roomId = cell.model.course_id;
        //2.lessonname
        __block NSString *lessonName ;
        [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/interactive_courses/%@/detail",Request_Header,cell.model.course_id] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
            if ([dic[@"status"]isEqualToNumber:@1]) {
                
                for (NSDictionary *lesson in dic[@"data"][@"interactive_course"][@"interactive_lessons"]) {
                    if ([lesson[@"status"]isEqualToString:@"teaching"]) {
                        lessonName = lesson[@"name"];
                    }
                }
                
                controller = [[InteractionViewController alloc]initWithChatroom:chatroom andClassID:cell.model.course_id andChatTeamID:cell.model.course_id andLessonName:lessonName==nil?@"暂无直播":lessonName];
                 [self.navigationController pushViewController:controller animated:YES];
            }else{
                [self HUDStopWithTitle:@"网络繁忙,请稍后重试"];
            }
            
        } failure:^(id  _Nullable erros) {
            [self HUDStopWithTitle:@"请检查网络"];
        }];
        
    }
    
}

#pragma mark- UITableView Plachholder delegate

- (UIView *)makePlaceHolderView{
    
    HaveNoClassView *view = [[HaveNoClassView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    view.titleLabel.text = @"当日无课程";

    view.sd_layout
    .topEqualToView(_classTableView)
    .bottomEqualToView(_classTableView)
    .leftEqualToView(_classTableView)
    .rightEqualToView(_classTableView);
    

    return view;
}


- (BOOL)enableScrollWhenPlaceHolderViewShowing{
    return YES;
}



- (void)returnLastPage{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
