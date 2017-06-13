//
//  MyVideoClassViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/11.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "MyVideoClassViewController.h"
#import "NavigationBar.h"
#import "MyVideoClassView.h"
#import "CYLTableViewPlaceHolder.h"
#import "HaveNoClassView.h"
#import "UIViewController+AFHTTP.h"
#import "StartedTableViewCell.h"
#import "MJRefresh.h"
#import "UIViewController+AFHTTP.h"
#import "UITableView+CYLTableViewPlaceHolder.h"
#import "VideoClassInfo.h"
#import "YYModel.h"
#import "HaveNoClassView.h"
#import "MyVideoClassTableViewCell.h"
#import "VideoClassInfoViewController.h"
#import "UIControl+RemoveTarget.h"
#import "VideoClassPlayerViewController.h"
//#import "VideoClass.h"
#import "MyVideoClassList.h"
#import "UIViewController+Token.h"

typedef enum : NSUInteger {
    PullToRefresh,  //下拉刷新
    PushToLoadMore, //上滑加载
} RefreshType;

//课程类型
typedef enum : NSUInteger {
    MyVideoClassRequestTypeBought,  //已购买的课程
    MyVideoClassRequestTypeFree,    //免费课程
    
} MyVideoClassRequestType;

@interface MyVideoClassViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    
    NavigationBar *_navigationBar;
    
    /**已购课程的数据*/
    NSMutableArray *_boughtClassArray;
    /**免费课程的数据*/
    NSMutableArray *_freeClassArray;
    
    /**页码*/
    NSInteger page;
    /**每页条数*/
    NSInteger per_page;
    
    /**segment item2的刷新次数*/
   __block NSInteger refreshNum;
    
    
    //传值用的数组
    NSMutableArray *_boughtVideoArray;
    NSMutableArray *_freeVideoArray;
    
    //教师
    Teacher *_teacher;
    
    /**课程详情*/
    
    
}
/**我的视频课 主视图*/
@property (nonatomic, strong) MyVideoClassView *myVideoClassView ;

@end

@implementation MyVideoClassViewController

/**加载导航栏*/
- (void)setupNavigation{
    
    _navigationBar = ({
        NavigationBar *_ =[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
        [self.view addSubview:_];
        
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        _.titleLabel.text = @"我的视频课";
        _;
    });
    
}

/**加载主视图*/
- (void)setupMainView{
    
    self.view.backgroundColor  = [UIColor whiteColor];
    _myVideoClassView = [[MyVideoClassView alloc]initWithFrame:CGRectMake(0, Navigation_Height, self.view.width_sd, self.view.height_sd-Navigation_Height)];
    [self.view addSubview:_myVideoClassView];
    
    _myVideoClassView.boughtClassTableView.delegate = self;
    _myVideoClassView.boughtClassTableView.dataSource = self;
    _myVideoClassView.boughtClassTableView.tag = 1;
    
    _myVideoClassView.freeClasstableView.delegate = self;
    _myVideoClassView.freeClasstableView.dataSource = self;
    _myVideoClassView.freeClasstableView.tag = 2;
    
    _myVideoClassView.scrollView.delegate = self;
    _myVideoClassView.scrollView.tag = 3;
    
    //滑动
    typeof(self) __weak weakSelf = self;
    _myVideoClassView.segmentControl.indexChangeBlock = ^(NSInteger index) {
        [weakSelf.myVideoClassView.scrollView scrollRectToVisible:CGRectMake(weakSelf.view.width_sd*index, 0, weakSelf.view.width_sd, weakSelf.myVideoClassView.scrollView.height_sd) animated:YES];
        
        if (refreshNum == 0) {
            [weakSelf.myVideoClassView.freeClasstableView.mj_header beginRefreshing];
            refreshNum++;
        }
        
    };
    
    //header和footer
    _myVideoClassView.boughtClassTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self requestMyVideoClassDataWithClassType:MyVideoClassRequestTypeBought andRefreshType:PullToRefresh];
        
    }];
    
    _myVideoClassView.boughtClassTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestMyVideoClassDataWithClassType:MyVideoClassRequestTypeBought andRefreshType:PushToLoadMore];
    }];
    
    _myVideoClassView.freeClasstableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestMyVideoClassDataWithClassType:MyVideoClassRequestTypeFree andRefreshType:PullToRefresh];
    }];
    
    _myVideoClassView.freeClasstableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestMyVideoClassDataWithClassType:MyVideoClassRequestTypeFree andRefreshType:PushToLoadMore];
    }];
    
    
    //先下拉刷新一次
    [_myVideoClassView.boughtClassTableView.mj_header beginRefreshing];
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    page = 1;
    per_page = 10;
    refreshNum = 0;
    _boughtClassArray = @[].mutableCopy;
    _freeClassArray = @[].mutableCopy;
    
    _boughtVideoArray = @[].mutableCopy;
    _freeVideoArray = @[].mutableCopy;
    
    //加载导航栏
    [self setupNavigation];
    
    //主视图
    [self setupMainView];
    
}




/**
 加载我的视频课数据

 @param classType 课程类型
 @param refreshType 刷新方式
 */
- (void)requestMyVideoClassDataWithClassType:(MyVideoClassRequestType)classType andRefreshType:(RefreshType)refreshType{
    
    NSMutableDictionary *dics;
    
    if (refreshType == PullToRefresh) {
        page = 1;
        
        if (classType == MyVideoClassRequestTypeBought) {
            
            _boughtClassArray = @[].mutableCopy;
            
        }else if (classType == MyVideoClassRequestTypeFree){
            
            _freeClassArray = @[].mutableCopy;
        }
        
        
    }else{
        page ++;
    }
    
    NSString *sellType = nil;
    
    if (classType == MyVideoClassRequestTypeBought) {
        sellType = @"charge";
    }else if (classType == MyVideoClassRequestTypeFree){
        sellType = @"free";
    }
    
    dics = @{@"sell_type":sellType,
             @"page":[NSString stringWithFormat:@"%ld",page],
             @"per_page":[NSString stringWithFormat:@"%ld",per_page]}.mutableCopy;
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/students/%@/video_courses/list",Request_Header,[self getStudentID]] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:dics completeSuccess:^(id  _Nullable responds) {
       
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            if ([dic[@"data"]count]!=0) {
                
                if (classType == MyVideoClassRequestTypeBought) {
                    //已购课程下拉刷新
                    for (NSDictionary *dicsdata in dic[@"data"]) {
                        MyVideoClassList *mod = [MyVideoClassList yy_modelWithJSON:dicsdata];
                        mod.video_course = [Video_course yy_modelWithJSON:dicsdata[@"video_course"]];
                        mod.video_course.classID =dicsdata[@"video_course"][@"id"];
                        [_boughtClassArray addObject:mod];
                        
                    }
                    
                    [_myVideoClassView.boughtClassTableView cyl_reloadData];
                    
                    [_myVideoClassView.boughtClassTableView.mj_header endRefreshing];
                     [_myVideoClassView.boughtClassTableView.mj_footer resetNoMoreData];
                }else if (classType == MyVideoClassRequestTypeFree){
                    
                    for (NSDictionary *dicsdata in dic[@"data"]) {
                        MyVideoClassList *mod = [MyVideoClassList yy_modelWithJSON:dicsdata];
                        mod.video_course = [Video_course yy_modelWithJSON:dicsdata[@"video_course"]];
                        mod.video_course.classID =dicsdata[@"video_course"][@"id"];
                        [_freeClassArray addObject:mod];
                        
                    }
                    
                    [_myVideoClassView.freeClasstableView cyl_reloadData];
                    [_myVideoClassView.freeClasstableView.mj_header endRefreshing];
                    [_myVideoClassView.freeClasstableView.mj_footer resetNoMoreData];
                }
            }else{
                if (classType == MyVideoClassRequestTypeBought) {
                    if (refreshType == PullToRefresh) {
                        [_myVideoClassView.boughtClassTableView.mj_header endRefreshingWithCompletionBlock:^{
                            [_myVideoClassView.boughtClassTableView cyl_reloadData];
                        }];
                    }else{
                        [_myVideoClassView.boughtClassTableView.mj_footer endRefreshingWithNoMoreData];
                        
                    }
                    
                }else if (classType == MyVideoClassRequestTypeFree){
                    
                    if (refreshType == PullToRefresh) {
                        
                        [_myVideoClassView.freeClasstableView.mj_header endRefreshingWithCompletionBlock:^{
                            [_myVideoClassView.freeClasstableView cyl_reloadData];
                        }];
                    }else{
                        [_myVideoClassView.freeClasstableView.mj_footer endRefreshingWithNoMoreData];
                    }
                   
                }
            }
            
        }else{
            
            
        }
        
    }];
    
}
/**进入视频课程播放*/
- (void)enterClass:(UIButton *)sender{
    
    VideoClassPlayerViewController *controller;
    MyVideoClassTableViewCell *cell;
    
    if (sender.tag>=100&&sender.tag<200) {
        //购买的课程
        cell = (MyVideoClassTableViewCell *)[_myVideoClassView.boughtClassTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag-100 inSection:0]];
        //课程数组
        for (NSDictionary *dics  in cell.model.video_lessons) {
            VideoClass *mod = [VideoClass yy_modelWithJSON:dics];
            mod.classID = dics[@"id"];
            
            [_boughtVideoArray addObject:mod];
            
        }
        
        //教师
        _teacher = [Teacher yy_modelWithJSON:cell.model.teacher];
        _teacher.teacherID = cell.model.teacher[@"id"];
        
        controller = [[VideoClassPlayerViewController alloc]initWithClasses:_boughtVideoArray andTeacher:_teacher andVideoClassInfos:cell.model andURLString:nil andIndexPath:nil];
    }else if (sender.tag>=200){
        
        cell = (MyVideoClassTableViewCell *)[_myVideoClassView.freeClasstableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag-200 inSection:0]];
        //课程数组
        for (NSDictionary *dics  in cell.model.video_lessons) {
            VideoClass *mod = [VideoClass yy_modelWithJSON:dics];
            mod.classID = dics[@"id"];
            
            [_freeVideoArray addObject:mod];
            
        }
        
        //教师
        _teacher = [Teacher yy_modelWithJSON:cell.model.teacher];
        _teacher.teacherID = cell.model.teacher[@"id"];
        
        controller = [[VideoClassPlayerViewController alloc]initWithClasses:_freeVideoArray andTeacher:_teacher andVideoClassInfos:cell.model andURLString:nil andIndexPath:nil];
        
    }
    
    [self.navigationController pushViewController:controller animated:YES];

}


#pragma mark- UITableView datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger num ;
    if (tableView.tag == 1) {
        num = _boughtClassArray.count;
    }else {
        num = _freeClassArray.count;
    }
    
    return num;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tableCell;
    if (tableView.tag == 1) {
        
        /* cell的重用队列*/
        static NSString *cellIdenfier = @"cell";
        MyVideoClassTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
        if (cell==nil) {
            cell=[[MyVideoClassTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        
        if (_boughtClassArray.count >indexPath.row) {
            cell.myVideoClassListModel = _boughtClassArray[indexPath.row];
            cell.enterButton.tag = indexPath.row+100;
            [cell.enterButton removeAllTargets];
            [cell.enterButton addTarget:self action:@selector(enterClass:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        tableCell = cell;
    }else{
        /* cell的重用队列*/
        static NSString *cellIdenfier = @"tablecell";
        MyVideoClassTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
        if (cell==nil) {
            cell=[[MyVideoClassTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"tablecell"];
        }
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        if (_freeClassArray.count>indexPath.row) {
            cell.myVideoClassListModel = _freeClassArray[indexPath.row];
            cell.enterButton.tag = indexPath.row+200;
            [cell.enterButton removeAllTargets];
            [cell.enterButton addTarget:self action:@selector(enterClass:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        tableCell = cell;
    }
    
    return  tableCell;
}


#pragma mark- UITableView delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100 *ScrenScale;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyVideoClassTableViewCell *cell = (MyVideoClassTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    VideoClassInfoViewController *controller = [[VideoClassInfoViewController alloc]initWithClassID:cell.myVideoClassListModel.video_course.classID];
    [self.navigationController pushViewController:controller animated:YES];
    
}



#pragma mark- UIScrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 3) {
        
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger pages = scrollView.contentOffset.x / pageWidth;
        
        [_myVideoClassView.segmentControl setSelectedSegmentIndex:pages animated:YES];
        
        if (refreshNum == 0) {
            [_myVideoClassView.freeClasstableView.mj_header beginRefreshing];
        }
        
        refreshNum ++;
    }

}
- (UIView *)makePlaceHolderView{
    
    HaveNoClassView *view = [[HaveNoClassView alloc]init];
    view.titleLabel.text = @"当前无相关课程";
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
