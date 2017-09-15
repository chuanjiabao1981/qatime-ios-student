//
//  ClassTimeViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ClassTimeViewController.h"

#import "NavigationBar.h"
#import "HMSegmentedControl.h"
#import "ClassTimeTableViewCell.h"
#import "ClassTimeModel.h"
#import "YYModel.h"
#import "MJRefresh.h"
#import "UIViewController+HUD.h"
#import "UIViewController+HUD.h"

#import "AllClassViewController.h"
#import "NotClassView.h"
#import "CYLTableViewPlaceHolder.h"

/* 点击事件 -> 辅导班详情页*/
#import "TutoriumInfoViewController.h"
#import "LivePlayerViewController.h"
#import "UIAlertController+Blocks.h"
#import "HaveNoClassView.h"
#import "UIViewController+AFHTTP.h"
#import "OneOnOneTutoriumInfoViewController.h"
#import <NIMSDK/NIMSDK.h>
#import "VideoClassInfoViewController.h"
#import "InteractionViewController.h"
#import "ExclusiveInfoViewController.h"
#import "UIViewController+Token.h"

#define SCREENWIDTH self.view.frame.size.width
#define SCREENHEIGHT self.view.frame.size.height

//刷新方式
typedef enum : NSUInteger {
    PullToRefresh,
    PushToLoadMore,
} RefreshType;

//课程类型
typedef enum : NSUInteger {
    UnstartClass,
    StartedClass,
} ClassType;

@interface ClassTimeViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIGestureRecognizerDelegate>{
    
    /* 保存未上课数据的数组*/
    __block  NSMutableArray *_unclosedArr;
    
    /* 保存已上课数据的数组*/
    __block  NSMutableArray *_closedArr;
    
    /* 该月份是否有课*/
    BOOL haveClass;
    
    /* 是否登录*/
    BOOL isLogin;
    
    HaveNoClassView *_notLoginView;
    
    NSInteger checkTime;
    
}

@property(nonatomic,strong) NavigationBar *navigationBar ;

@end

@implementation ClassTimeViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

- (void)loadView{
    [super loadView];
    
    [self loadClassView];
    [self makeViews];
    
}

/**课程表未登录的视图*/
- (void)makeViews{
    
    /* 课程表未登录的视图*/
    _notLoginView = ({
        HaveNoClassView *_=[[HaveNoClassView alloc]init];
        _.titleLabel.text = @"登录才能查看!";
        [self.view addSubview:_];
        
        _.sd_layout
        .leftEqualToView(_classTimeView)
        .topEqualToView(_classTimeView)
        .rightEqualToView(_classTimeView)
        .bottomEqualToView(_classTimeView);
        
        UIButton *__ = [[UIButton alloc]init];
        [_ addSubview:__];
        [__ setTitle:@"登录" forState:UIControlStateNormal];
        [__ setTitleColor:TITLERED forState:UIControlStateNormal];
        __.layer.borderColor = TITLERED.CGColor;
        __.layer.borderWidth = 0.8;
        [__ addTarget:self action:@selector(loginAgain) forControlEvents:UIControlEventTouchUpInside];
        __.sd_layout
        .topSpaceToView(_.titleLabel,20)
        .centerXEqualToView(_)
        .heightRatioToView(self.view,0.045)
        .widthRatioToView(self.view,0.2);
        __.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        
        _;
        
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.view.backgroundColor = BACKGROUNDGRAY;
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, Navigation_Height)];
    [self.view addSubview:_navigationBar];
    [_navigationBar.titleLabel setText:@"课程表"];
    [_navigationBar.rightButton setImage:[UIImage imageNamed:@"日历"] forState:UIControlStateNormal];
    [_navigationBar.rightButton addTarget:self action:@selector(calenderViews) forControlEvents:UIControlEventTouchUpInside];
    
    /* 判断是否登录*/
    isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:@"Login"];
    if (isLogin==YES&&[self getToken]&&[self getStudentID]) {
        _notLoginView.hidden = YES;
        //        [self HUDStartWithTitle:nil];
    }else{
        _notLoginView.hidden = NO;
    }
    
    //初始化数据
    _unclosedArr = @[].mutableCopy;
    _closedArr = @[].mutableCopy;
    checkTime = 0;
    
    _classTimeView.notClassView.notClassTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestClassListWithRefreshType:PullToRefresh andClassType:UnstartClass];
    }];
    
    _classTimeView.alreadyClassView.alreadyClassTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestClassListWithRefreshType:PullToRefresh andClassType:StartedClass];
    }];
    
    [_classTimeView.notClassView.notClassTableView.mj_header beginRefreshing];
    
    /* 添加登录成功后的 监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshPage) name:@"UserLoginAgain" object:nil];
    
}


/* 登录成功后加载数据*/
- (void)refreshPage{
    [self getToken];
    _notLoginView.hidden = YES;
    _unclosedArr = @[].mutableCopy;
    _closedArr = @[].mutableCopy;
}

#pragma mark- 请求数据方法

/**
 请求数据
 
 @param refreshType 刷新方式
 @param classtype 课程类型
 */
- (void)requestClassListWithRefreshType:(RefreshType)refreshType andClassType:(ClassType)classtype{
    
    [self getToken];
    NSString *classTypes;
    
    //暂时预留上滑操作 只做下拉刷新
    if (refreshType == PullToRefresh) {
        
        if (classtype == UnstartClass) {
            _unclosedArr = @[].mutableCopy;
            classTypes = @"unclosed";
        }else if (classtype == StartedClass){
            _closedArr = @[].mutableCopy;
            classTypes = @"closed";
        }
    }else if (refreshType == PushToLoadMore){
        
    }
    
    //2017-09-11 v2版本接口
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v2/live_studio/students/%@/schedule_data",Request_Header,[self getStudentID]] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:@{@"state":classTypes} completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            if ([dic[@"data"]count]!=0) {
                
                NSArray *sortArr = [dic[@"data"] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    NSDictionary *dic1 = obj1;
                    NSDictionary *dic2 = obj2;
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
                    NSDate *date1= [dateFormatter dateFromString:dic1[@"date"]];
                    NSDate *date2= [dateFormatter dateFromString:dic2[@"date"]];
                    if (date1 == [date1 earlierDate: date2]) { //不使用intValue比较无效
                        return NSOrderedDescending;//降序
                    }else if (date1 == [date1 laterDate: date2]) {
                        return NSOrderedAscending;//升序
                    }else{
                        return NSOrderedSame;//相等
                    }
                }];
                
                
                if (classtype == UnstartClass) {
                    
                    for (NSDictionary *classDic in sortArr) {
                        for (NSDictionary *lessons in classDic[@"lessons"]) {
                            ClassTimeModel *mod = [ClassTimeModel yy_modelWithJSON:lessons];
                            mod.classID = lessons[@"id"];
                            [_unclosedArr addObject:mod];
                        }
                    }
                    [_classTimeView.notClassView.notClassTableView cyl_reloadData];
                    [_classTimeView.notClassView.notClassTableView.mj_header endRefreshing];
                }else if (classtype == StartedClass){
                    
                    for (NSDictionary *classDic in sortArr) {
                        for (NSDictionary *lessons in classDic[@"lessons"]) {
                            ClassTimeModel *mod = [ClassTimeModel yy_modelWithJSON:lessons];
                            mod.classID = lessons[@"id"];
                            [_closedArr addObject:mod];
                        }
                    }
                    [_classTimeView.alreadyClassView.alreadyClassTableView cyl_reloadData];
                    [_classTimeView.alreadyClassView.alreadyClassTableView.mj_header endRefreshing];
                }
                
            }else{
                
                if (classtype == UnstartClass) {
                    [_classTimeView.notClassView.notClassTableView cyl_reloadData];
                    [_classTimeView.notClassView.notClassTableView.mj_header endRefreshing];
                }else if (classtype == StartedClass){
                    [_classTimeView.alreadyClassView.alreadyClassTableView cyl_reloadData];
                    [_classTimeView.alreadyClassView.alreadyClassTableView.mj_header endRefreshing];
                }
                
            }
            
        }else{
            
            if (classtype == UnstartClass) {
                if (refreshType == PullToRefresh) {
                    
                    [_classTimeView.notClassView.notClassTableView.mj_header endRefreshing];
                    
                }else{
                    [_classTimeView.notClassView.notClassTableView.mj_footer endRefreshing];
                }
            }else{
                if (refreshType == PullToRefresh) {
                    
                    [_classTimeView.alreadyClassView.alreadyClassTableView.mj_header endRefreshing];
                    
                }else{
                    
                    [_classTimeView.alreadyClassView.alreadyClassTableView.mj_footer endRefreshing];
                }
            }
        }
        
    }failure:^(id  _Nullable erros) {
        
        [self HUDStopWithTitle:@"请检查网络"];
        if (classtype == UnstartClass) {
            if (refreshType == PullToRefresh) {
                
                [_classTimeView.notClassView.notClassTableView.mj_header endRefreshing];
                [_classTimeView.notClassView.notClassTableView cyl_reloadData];
                
            }else{
                [_classTimeView.notClassView.notClassTableView.mj_footer endRefreshing];
            }
        }else{
            if (refreshType == PullToRefresh) {
                
                [_classTimeView.alreadyClassView.alreadyClassTableView.mj_header endRefreshing];
                [_classTimeView.alreadyClassView.alreadyClassTableView cyl_reloadData];
                
            }else{
                
                [_classTimeView.alreadyClassView.alreadyClassTableView.mj_footer endRefreshing];
            }
        }

    }];
    
}


/* 加载视图*/
- (void)loadClassView{
    
    _classTimeView = ({
        ClassTimeView *_ = [[ClassTimeView alloc]initWithFrame:CGRectMake(0, Navigation_Height, SCREENWIDTH, SCREENHEIGHT-Navigation_Height-TabBar_Height)];
        [self.view addSubview:_];
        _.scrollView.delegate = self;
        _.segmentControl.selectedSegmentIndex =0;
        _.segmentControl.selectionIndicatorHeight =2.0f;
        _.scrollView.bounces=NO;
        _.scrollView.alwaysBounceVertical=NO;
        _.scrollView.alwaysBounceHorizontal=NO;
        
        [_.scrollView scrollRectToVisible:CGRectMake(-self.view.width_sd, 0, self.view.width_sd, self.view.height_sd) animated:YES];
        
        typeof(self) __weak weakSelf = self;
        [_.segmentControl setIndexChangeBlock:^(NSInteger index) {
            [weakSelf.classTimeView.scrollView scrollRectToVisible:CGRectMake(self.view.width_sd * index, 0, CGRectGetWidth(weakSelf.view.bounds), CGRectGetHeight(weakSelf.view.frame)-Navigation_Height-TabBar_Height) animated:YES];
            if (index ==1) {
                if (checkTime == 0) {
                    [_classTimeView.alreadyClassView.alreadyClassTableView.mj_header beginRefreshing];
                    checkTime ++;
                }
            }
        }];
        _.notClassView.notClassTableView.delegate = self;
        _.notClassView.notClassTableView.dataSource = self;
        _.notClassView.notClassTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _.notClassView.notClassTableView.tag =1;
        
        _.alreadyClassView.alreadyClassTableView.delegate = self;
        _.alreadyClassView.alreadyClassTableView.dataSource = self;
        _.alreadyClassView.alreadyClassTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _.alreadyClassView.alreadyClassTableView.tag = 2;
        
        _;
    });
    
}




#pragma mark- 当月无课程的情况
- (void)noClassThisMonth{
    
    ClassTimeModel *mod = [ClassTimeModel new];
    
    _unclosedArr = [NSMutableArray arrayWithArray:@[mod]];
    _closedArr = [NSMutableArray arrayWithArray:@[mod]];
    
}


#pragma mark- 加载数据后，更新table的数据和视图



#pragma mark- tableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows=0;
    
    if (tableView.tag ==1) {
        
        rows = _unclosedArr.count;
    }
    
    if (tableView.tag == 2) {
        rows = _closedArr.count;
    }
    
    return rows ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tableCell;
    
    /* 未上课列表*/
    if (tableView.tag ==1) {
        
        static NSString *cellIdenfier = @"cell";
        ClassTimeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
        if (!cell) {
            
            cell=[[ClassTimeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        if (_unclosedArr.count>indexPath.row) {
            
            cell.model =_unclosedArr[indexPath.row];
            [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            /** 不能进入观看*/
            
            if (cell.canUse == NO){
                cell.enterButton.hidden = YES;
            }else{
                cell.enterButton.hidden = NO;
            }
            
            [cell showTasteState:cell.model.taste];
            
            cell.enterButton.tag = indexPath.row+10;
            [cell.enterButton addTarget:self action:@selector(enterLive:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        tableCell = cell;
    }
    
    if (tableView.tag ==2) {
        
        static NSString *cellID = @"CellID";
        ClassTimeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell=[[ClassTimeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellID"];
        }
        if (_closedArr.count>indexPath.row) {
            [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            cell.model =_closedArr[indexPath.row];
            cell.enterButton.hidden = YES;
            [cell showTasteState:cell.model.taste];
        }
        
        tableCell = cell;
    }
    
    return tableCell;
    
}

#pragma mark- tableView delegate

-  (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CGFloat height = 0;
    
    
    if (tableView.tag ==1) {
        
        if (_unclosedArr.count !=0) {
            
            height = 120*ScrenScale;
            
        }
    }
    if (tableView.tag ==2) {
        
        if (_closedArr.count !=0) {
            
            height = 120*ScrenScale;
            
        }
    }
    
    
    return height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *classID;
    
    UIViewController *controller ;
    
    if (tableView.tag ==1) {
        
        if (_unclosedArr.count!=0) {
            
            ClassTimeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            classID = cell.model.course_id;
            
            if ([cell.model.model_name isEqualToString:@"LiveStudio::Lesson"]) {
                //直播课
                controller= [[TutoriumInfoViewController alloc]initWithClassID:cell.model.course_id];
            }else if ([cell.model.model_name isEqualToString:@"LiveStudio::VideoLesson"]){
                //视频课
                controller = [[VideoClassInfoViewController alloc]initWithClassID:cell.model.course_id];
            }else if ([cell.model.model_name isEqualToString:@"LiveStudio::InteractiveLesson"]){
                //一对一
                controller = [[OneOnOneTutoriumInfoViewController alloc]initWithClassID:cell.model.course_id];
            }else{
                //专属课
                controller = [[ExclusiveInfoViewController alloc]initWithClassID:cell.model.course_id];
            }
        }
    }
    if (tableView.tag ==2) {
        if (_closedArr.count!=0) {
            ClassTimeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            classID = cell.model.course_id;
            
        }
    }
    
    
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
    
    
    
}



/* 进入直播*/
- (void)enterLive:(UIButton *)sender{
    
    ClassTimeTableViewCell *cell = [_classTimeView.notClassView.notClassTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    __block UIViewController *controller;
    if ([cell.model.model_name isEqualToString:@"LiveStudio::Lesson"]) {
        //直播课
        controller= [[LivePlayerViewController alloc]initWithClassID:cell.model.product_id];
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([cell.model.model_name isEqualToString:@"LiveStudio::VideoLesson"]){
        //视频课
        //先获取视频课程的详情吧
        [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/video_courses/%@",Request_Header,cell.model.course_id] withHeaderInfo:nil andHeaderfield:nil parameters:nil completeSuccess:^(id  _Nullable responds) {
            
        } failure:^(id  _Nullable erros) {
            
        }];
        
    }else if ([cell.model.model_type isEqualToString:@"LiveStudio::InteractiveLesson"]){
        //一对一
        //加工数据
        //1.聊天室
        NIMChatroom *chatroom = [[NIMChatroom alloc]init];
        chatroom.roomId = cell.model.course_id;
        //2.lessonname
        __block NSString *lessonName ;
        [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/interactive_courses/%@/detail",Request_Header,cell.model.course_id] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
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


// segment的滑动代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == _classTimeView.scrollView) {
        
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        
        [_classTimeView.segmentControl setSelectedSegmentIndex:page animated:YES];
        
        if (_classTimeView.segmentControl.selectedSegmentIndex == 1) {
            
            if (checkTime == 0) {
                [_classTimeView.alreadyClassView.alreadyClassTableView.mj_header beginRefreshing];
            }
        }
        
    }
}


- (void)calenderViews{
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"Login"]) {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"Login"]==YES) {
            
            AllClassViewController *allClassVC = [[AllClassViewController alloc]init];
            allClassVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:allClassVC animated:YES];
        }else{
            
            [self loginAgain];
            
        }
    }else{
        
        [self loginAgain];
        
    }
    
}


- (UIView *)makePlaceHolderView{
    
    HaveNoClassView *view = [[HaveNoClassView alloc]initWithTitle:@"本周暂无课程"];
    return view;
}

- (BOOL)enableScrollWhenPlaceHolderViewShowing{
    return YES;
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
