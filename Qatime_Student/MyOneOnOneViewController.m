//
//  MyOneOnOneViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/31.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "MyOneOnOneViewController.h"
#import "NavigationBar.h"
#import "MJRefresh.h"
#import "UITableView+CYLTableViewPlaceHolder.h"
#import "UIViewController+AFHTTP.h"

#import "StartedTableViewCell.h"
#import "EndedTableViewCell.h"

#import "MyTutoriumModel.h"
#import "YYModel.h"

#import "HaveNoClassView.h"
#import "InteractionViewController.h"

#import "Interactive.h"
#import "OneOnOneTutoriumInfoViewController.h"
#import "NTESMeetingViewController.h"
#import "UIViewController+Token.h"
#import "UIViewController+HUD.h"


typedef enum : NSUInteger {
    PullToRefresh,
    PushToLoadMore,
}OneOnOneRefreshType;   //上滑或是下拉

typedef enum : NSUInteger {
    ClassStatusTeaching,
    ClassStatusFinished,
    
} ClassStatus;          //一对一课程筛选状态

@interface MyOneOnOneViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    
    NavigationBar *_navigationBar;
    
    /**学习中 数组*/
    NSMutableArray *_onStudyArray;
    
    /**已结束 数组*/
    NSMutableArray *_finishedArray;
    
    /**页数*/
    NSInteger page;
    
    /**选择"已结束"的次数*/
   __block NSInteger refreshNum;
    
    
    /**课程详情*/
    NSMutableDictionary *_interactiveInfo;
    
}


@end

@implementation MyOneOnOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    page = 1;
    refreshNum = 0;
    
    //获取token
    [self getToken];
    //加载导航栏
    [self setupNavigation];
    
    //加载我的一对一课程
    [self setupViews];
    
    [_myView.onStudyTableView.mj_header beginRefreshing];
    
    
}

- (void)setupNavigation{
    //导航栏
    _navigationBar =({
        NavigationBar *_=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
        [self.view addSubview:_];
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        _.titleLabel.text = @"我的一对一";
        _;
    });
}

/**加载主视图*/
- (void)setupViews{
    
    //主视图
    _myView = ({
        MyOneOnOneView *_ = [[MyOneOnOneView alloc]initWithFrame:CGRectMake(0, Navigation_Height, self.view.width_sd, self.view.height_sd-Navigation_Height)];
        [self.view addSubview:_];
        
        //指定代理
        _.onStudyTableView.delegate = self;
        _.onStudyTableView.dataSource = self;
        _.onStudyTableView.tag = 1;
        _.finishStudyTableView.delegate = self;
        _.finishStudyTableView.dataSource = self;
        _.finishStudyTableView.tag = 2;
        
        _.scrollView.delegate = self;
    
        //上滑下拉刷新
        _.onStudyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [self requestOneOnOneWithRefreshStyle:PullToRefresh andClassStatus:ClassStatusTeaching];
            
        }];
        
        _.onStudyTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestOneOnOneWithRefreshStyle:PushToLoadMore andClassStatus:ClassStatusTeaching];
        }];
        
        
        _.finishStudyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self requestOneOnOneWithRefreshStyle:PullToRefresh andClassStatus:ClassStatusFinished];
        }];
        
        _.finishStudyTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestOneOnOneWithRefreshStyle:PushToLoadMore andClassStatus:ClassStatusFinished];
        }];
        
        _;
    });
    
    //segment切换
    typeof(self) __weak weakSelf = self;
    _myView.segmentControl.indexChangeBlock = ^(NSInteger index) {
        [weakSelf.myView.scrollView scrollRectToVisible:CGRectMake(weakSelf.view.width_sd *index, 0, weakSelf.view.width_sd, weakSelf.view.height_sd - weakSelf.myView.segmentControl.height_sd) animated:YES];
        
        if (refreshNum == 0) {
            [weakSelf.myView.finishStudyTableView.mj_header beginRefreshing];
        }
        
        refreshNum ++;
    };
    
}

#pragma mark- Request data

/**
 请求一对一数据
 
 @param type 下拉/刷新 方式
 */
- (void)requestOneOnOneWithRefreshStyle:(OneOnOneRefreshType)type andClassStatus:(ClassStatus)status{
    
    //筛选状态
    NSString *state = status==ClassStatusTeaching?@"teaching":@"completed";
    
    //页码变化
    switch (type) {
        case PullToRefresh:
            page = 1;
            break;
            
        case PushToLoadMore:
            page++;
            break;
    }
    
    //数据只请求一次,请求回来数据之后,在根据不同情况进行数据分配
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/students/%@/interactive_courses/list",Request_Header,[self getStudentID]] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:@{@"status":state,@"page":[NSString stringWithFormat:@"%ld",page],@"per_page":@"10"} completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        
        [self loginStates:dic];
        
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            //1.判断是学习中的还是已学完的
            switch (status) {
                    //学习中的
                case ClassStatusTeaching:{
                    //2.判断是下拉还是上滑
                    switch (type) {
                            //下拉刷新
                        case PullToRefresh:{
                            _onStudyArray = @[].mutableCopy;
                            if ([dic[@"data"]count]==0) {
                                
                                
                            }else{
                                for (NSDictionary *dics in dic[@"data"]) {
                                    Interactive *mod = [Interactive yy_modelWithJSON:dics];
                                    mod.interactive_course = [InteractiveCourse yy_modelWithJSON:dics[@"interactive_course"]];
                                    mod.interactive_course.classID =dics[@"interactive_course"][@"id"];
                                    mod.classID = dics[@"id"];
                                    [_onStudyArray addObject:mod];
                                }
                                
                            }
                            [_myView.onStudyTableView.mj_header endRefreshingWithCompletionBlock:^{
                                
                                [_myView.onStudyTableView cyl_reloadData];
                            }];
                        }
                            break;
                            //上滑加载更多
                        case PushToLoadMore:{
                            
                            if ([dic[@"data"]count]==0) {
                                
                                [_myView.onStudyTableView.mj_footer endRefreshingWithNoMoreData];
                            }else{
                                for (NSDictionary *dics in dic[@"data"]) {
                                    MyTutoriumModel *mod = [MyTutoriumModel yy_modelWithJSON:dics];
                                    mod.classID = dics[@"id"];
                                    [_onStudyArray addObject:mod];
                                }
                                
                            }
                            [_myView.onStudyTableView.mj_header endRefreshingWithCompletionBlock:^{
                                
                                [_myView.onStudyTableView cyl_reloadData];
                            }];
                        }
                            break;
                    }
                    
                }
                    break;
                    
                    //学完的
                case ClassStatusFinished:{
                    
                    //2.判断是下拉还是上滑
                    switch (type) {
                            //下拉刷新
                        case PullToRefresh:{
                            _finishedArray = @[].mutableCopy;
                            if ([dic[@"data"]count]==0) {
                                
                                
                            }else{
                                for (NSDictionary *dics in dic[@"data"]) {
                                    MyTutoriumModel *mod = [MyTutoriumModel yy_modelWithJSON:dics];
                                    mod.classID = dics[@"id"];
                                    [_finishedArray addObject:mod];
                                }
                                
                            }
                            [_myView.finishStudyTableView.mj_header endRefreshingWithCompletionBlock:^{
                                
                                [_myView.finishStudyTableView cyl_reloadData];
                            }];
                        }
                            
                            
                            break;
                            //上滑加载更多
                        case PushToLoadMore:{
                            if ([dic[@"data"]count]==0) {
                                
                                [_myView.finishStudyTableView.mj_footer endRefreshingWithNoMoreData];
                            }else{
                                for (NSDictionary *dics in dic[@"data"]) {
                                    MyTutoriumModel *mod = [MyTutoriumModel yy_modelWithJSON:dics];
                                    mod.classID = dics[@"id"];
                                    [_finishedArray addObject:mod];
                                }
                                
                            }
                            [_myView.finishStudyTableView.mj_header endRefreshingWithCompletionBlock:^{
                                
                                [_myView.finishStudyTableView cyl_reloadData];
                            }];
                            
                            
                        }
                            break;
                    }
                }
            }
        }else{
            //获取数据失败
//            [_myView.onStudyTableView.mj_header endRefreshingWithCompletionBlock:^{
//                
//                [_myView.onStudyTableView cyl_reloadData];
//            }];
            
        }
        
    }failure:^(id  _Nullable erros) {
        
//        [_myView.onStudyTableView.mj_header endRefreshingWithCompletionBlock:^{
//            
//            [_myView.onStudyTableView cyl_reloadData];
//        }];
        
    }];
    
}


#pragma mark- UITableview datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger row = 0;
    
    switch (tableView.tag) {
        case 1:{
            if (_onStudyArray.count==0) {
            }else{
                row = _onStudyArray.count;
            }
        }
            break;
        case 2:{
            if (_finishedArray.count == 0) {
            }else{
                row = _finishedArray.count;
            }
        }
            break;
    }
    return row;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tableCell = nil;
    
    switch (tableView.tag) {
        case 1:{
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            StartedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[StartedTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            }
            if (_onStudyArray.count>indexPath.row) {
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                cell.interactiveModel = _onStudyArray[indexPath.row];
                cell.enterButton.tag = indexPath.row+10;
                [cell.enterButton addTarget:self action:@selector(enterInteractive:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            
            tableCell = cell;
            
        }
            break;
            
        case 2:{
            
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            EndedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[EndedTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            }
            if (_finishedArray.count>indexPath.row) {
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                cell.interactiveModel = _finishedArray[indexPath.row];
            }
            tableCell = cell;
        }
            break;
    }
    
    return tableCell;
}

#pragma mark- UITableveiw delgate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StartedTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    OneOnOneTutoriumInfoViewController *controller = [[OneOnOneTutoriumInfoViewController alloc]initWithClassID:cell.interactiveModel.interactive_course.classID];
    [self.navigationController pushViewController:controller animated:YES];
    
    
    
}

/**进入一对一互动直播*/
- (void)enterInteractive:(UIButton *)sender{
    [self HUDStartWithTitle:nil];
    Interactive *mod = _onStudyArray[sender.tag-10];
    //取一次chat_team_id
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/interactive_courses/%@",Request_Header,mod.interactive_course.classID] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            [self stopHUD];
            
            NIMChatroom *chatroom = [[NIMChatroom alloc]init];
            InteractionViewController *controller = [[InteractionViewController alloc]initWithChatroom:chatroom andClassID:mod.interactive_course.classID andChatTeamID:dic[@"data"][@"chat_team_id"]];
            [self.navigationController pushViewController:controller animated:YES];
            
        }else{
         //服务器正忙,稍后再试
            [self HUDStopWithTitle:@"服务器正忙,请稍后再试"];
        }
    } failure:^(id  _Nullable erros) {
        [self HUDStopWithTitle:@"网络不给力,请稍后再试"];
    }];
    
    
 
}


#pragma mark- scrollview delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == _myView.scrollView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger pages = scrollView.contentOffset.x / pageWidth;
        
        [_myView.segmentControl setSelectedSegmentIndex:pages animated:YES];
        
        if (refreshNum == 0) {
            [_myView.finishStudyTableView.mj_header beginRefreshing];
        }
        
        refreshNum ++;
    }
}

/**
 无数据时候的占位图
 
 @return view
 */
- (UIView *)makePlaceHolderView{
    
    HaveNoClassView *view;
    
    view = [[HaveNoClassView alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, _myView.scrollView.height_sd)];
    view.titleLabel.text = @"没有相关课程";
    
    return view;
    
}

/**
 列表无数据的时候是否可以下拉
 
 @return bool
 */
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
