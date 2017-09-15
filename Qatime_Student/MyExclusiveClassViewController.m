//
//  MyExclusiveClassViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/7/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "MyExclusiveClassViewController.h"
#import "NavigationBar.h"
#import "UIViewController+Token.h"
#import "UIViewController+AFHTTP.h"
#import "YYModel.h"
#import "MJRefresh.h"
#import "UIViewController+HUD.h"
#import "CYLTableViewPlaceHolder.h"
#import "HaveNoClassView.h"
#import "MyExclusiveClassCell.h"
#import "MyTutoriumModel.h"
#import "ExclusiveInfoViewController.h"
#import "MyExclusiveClass.h"

typedef NS_ENUM(NSUInteger, RefreshType) {
    PullToReload,
    PushToLoadMore,
};


@interface MyExclusiveClassViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NavigationBar *_navigationBar;
    
    NSMutableArray *_publishedArray;
    NSMutableArray *_teachingArray;
    NSMutableArray *_completedArray;
    
    NSInteger _publishedPage;
    NSInteger _teachingPage;
    NSInteger _completedPage;
    
    NSInteger _page;
    
    NSString *_course;
    
}

@end

@implementation MyExclusiveClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeData];
    
    [self setupMainView];
    
}

- (void)makeData{
    _publishedArray = @[].mutableCopy;
    _teachingArray = @[].mutableCopy;
    _completedArray = @[].mutableCopy;
    
    _publishedPage = 1;
    _teachingPage = 1;
    _completedPage = 1;
    
    _page = 1;
    _course = @"";
    
}

- (void)setupMainView{
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview:_navigationBar];
    _navigationBar.titleLabel.text = @"我的专属课";
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    _mainView = [[MyExclusiveClassView alloc]init];
    [self.view addSubview:_mainView];
    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(_navigationBar, 0)
    .bottomSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0);
    
    _mainView.scrollView.delegate = self;
    
    _mainView.publishedView.delegate = self;
    _mainView.publishedView.dataSource = self;
    _mainView.publishedView.tag = 1;
    _mainView.publishedView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _publishedPage = 1;
        _page = _publishedPage;
        _publishedArray = @[].mutableCopy;
        _course = @"published";
        [_mainView.publishedView.mj_footer resetNoMoreData];
        [self requestDataWithRefreshType:PullToReload andClassType:PublisedClass];
    }];
    _mainView.publishedView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _publishedPage++;
        _page = _publishedPage;
        _course = @"published";
        [self requestDataWithRefreshType:PushToLoadMore andClassType:PublisedClass];
    }];
    [_mainView.publishedView.mj_header beginRefreshing];
    
    _mainView.teachingView.delegate = self;
    _mainView.teachingView.dataSource = self;
    _mainView.teachingView.tag = 2;
    _mainView.teachingView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _teachingPage = 1;
        _page = _teachingPage;
        _teachingArray = @[].mutableCopy;
        _course = @"teaching";
        [_mainView.teachingView.mj_footer resetNoMoreData];
        [self requestDataWithRefreshType:PullToReload andClassType:TeachingClass];
    }];
    _mainView.teachingView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _teachingPage++;
        _page = _teachingPage;
        _course = @"teaching";
        [self requestDataWithRefreshType:PushToLoadMore andClassType:TeachingClass];
    }];
    [_mainView.teachingView.mj_header beginRefreshing];
    
    _mainView.completedView.delegate = self;
    _mainView.completedView.dataSource = self;
    _mainView.completedView.tag = 3;
    _mainView.completedView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _completedPage = 1;
        _page = _completedPage;
        _completedArray = @[].mutableCopy;
        _course = @"completed";
        [_mainView.publishedView.mj_footer resetNoMoreData];
        [self requestDataWithRefreshType:PullToReload andClassType:CompletedClass];
    }];
    _mainView.publishedView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _completedPage++;
        _page = _completedPage;
        _course = @"completed";
        [self requestDataWithRefreshType:PushToLoadMore andClassType:CompletedClass];
    }];
    [_mainView.completedView.mj_header beginRefreshing];
    
}

/**
 请求数据方法
 
 @param refreshType 刷新方式
 @param classType 课程数据类型
 */
- (void)requestDataWithRefreshType:(RefreshType)refreshType andClassType:(ClassType)classType{
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/students/%@/customized_groups",Request_Header,[self getStudentID]] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:@{@"page":[NSString stringWithFormat:@"%ld",_page],@"per_page":@"10",@"status":_course} completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            if (classType == PublisedClass) {
                if ([dic[@"data"]count]!=0) {
                    for (NSDictionary *classes in dic[@"data"]) {
                        MyExclusiveClass *mod = [MyExclusiveClass yy_modelWithJSON:classes];
                        mod.classID = classes[@"id"];
                        mod.customized_group = [ExclusiveInfo yy_modelWithJSON:classes[@"customized_group"]];
                        mod.customized_group.classID = classes[@"customized_group"][@"id"];
                        [_publishedArray addObject:mod];
                    }
                    if (refreshType == PullToReload) {
                        [_mainView.publishedView.mj_header endRefreshing];
                    }else{
                        [_mainView.publishedView.mj_footer endRefreshing];
                    }
                }else{
                    if (refreshType == PullToReload) {
                        [_mainView.publishedView.mj_header endRefreshing];
                    }else{
                        [_mainView.publishedView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
                [_mainView.publishedView cyl_reloadData];
                
            }else if (classType == TeachingClass){
                if ([dic[@"data"]count]!=0) {
                    for (NSDictionary *classes in dic[@"data"]) {
                        MyExclusiveClass *mod = [MyExclusiveClass yy_modelWithJSON:classes];
                        mod.classID = classes[@"id"];
                        mod.customized_group = [ExclusiveInfo yy_modelWithJSON:classes[@"customized_group"]];
                        mod.customized_group.classID = classes[@"customized_group"][@"id"];
                        [_teachingArray addObject:mod];
                    }
                    if (refreshType == PullToReload) {
                        [_mainView.teachingView.mj_header endRefreshing];
                    }else{
                        [_mainView.teachingView.mj_footer endRefreshing];
                    }
                }else{
                    if (refreshType == PullToReload) {
                        [_mainView.teachingView.mj_header endRefreshing];
                    }else{
                        [_mainView.teachingView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
                [_mainView.teachingView cyl_reloadData];
                
            }else{
                if ([dic[@"data"]count]!=0) {
                    for (NSDictionary *classes in dic[@"data"]) {
                        MyExclusiveClass *mod = [MyExclusiveClass yy_modelWithJSON:classes];
                        mod.classID = classes[@"id"];
                        mod.customized_group = [ExclusiveInfo yy_modelWithJSON:classes[@"customized_group"]];
                        mod.customized_group.classID = classes[@"customized_group"][@"id"];
                        [_completedArray addObject:mod];
                    }
                    if (refreshType == PullToReload) {
                        [_mainView.completedView.mj_header endRefreshing];
                    }else{
                        [_mainView.completedView.mj_footer endRefreshing];
                    }
                }else{
                    if (refreshType == PullToReload) {
                        [_mainView.completedView.mj_header endRefreshing];
                    }else{
                        [_mainView.completedView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
                [_mainView.completedView cyl_reloadData];
            }
            
        }else{
            [self HUDStopWithTitle:@"加载失败"];
            if (refreshType == PullToReload) {
                if (classType == PublisedClass) {
                    [_mainView.publishedView.mj_header endRefreshing];
                }else if (classType == TeachingClass){
                    [_mainView.teachingView.mj_header endRefreshing];
                }else{
                    [_mainView.completedView.mj_header endRefreshing];
                }
            }else{
                if (classType == PublisedClass) {
                    [_mainView.publishedView.mj_footer endRefreshing];
                }else if (classType == TeachingClass){
                    [_mainView.teachingView.mj_footer endRefreshing];
                }else{
                    [_mainView.completedView.mj_footer endRefreshing];
                }
            }
        }
        
    } failure:^(id  _Nullable erros) {
        [self HUDStopWithTitle:@"请检查网络"];
        if (refreshType == PullToReload) {
            if (classType == PublisedClass) {
                [_mainView.publishedView.mj_header endRefreshing];
            }else if (classType == TeachingClass){
                [_mainView.teachingView.mj_header endRefreshing];
            }else{
                [_mainView.completedView.mj_header endRefreshing];
            }
        }else{
            if (classType == PublisedClass) {
                [_mainView.publishedView.mj_footer endRefreshing];
            }else if (classType == TeachingClass){
                [_mainView.teachingView.mj_footer endRefreshing];
            }else{
                [_mainView.completedView.mj_footer endRefreshing];
            }
        }
        
    }];
}


#pragma mark- UITableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows;
    if (tableView.tag == 1) {
        rows = _publishedArray.count;
    }else if (tableView.tag == 2){
        rows = _teachingArray.count;
    }else {
        rows = _completedArray.count;
    }
    return rows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tableCell;
    if (tableView.tag == 1) {
        /* cell的重用队列*/
        static NSString *cellIdenfier = @"cell";
        MyExclusiveClassCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
        if (cell==nil) {
            cell=[[MyExclusiveClassCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        if (_publishedArray.count>indexPath.row) {
            cell.model = _publishedArray[indexPath.row];
            cell.classType = PublisedClass;
        }
        
        tableCell = cell;
    }else if (tableView.tag == 2){
        /* cell的重用队列*/
        static NSString *cellIdenfier = @"cell";
        MyExclusiveClassCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
        if (cell==nil) {
            cell=[[MyExclusiveClassCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        if (_teachingArray.count>indexPath.row) {
            cell.model = _teachingArray[indexPath.row];
            cell.classType = TeachingClass;
        }
        tableCell = cell;
        
    }else{
        /* cell的重用队列*/
        static NSString *cellIdenfier = @"cell";
        MyExclusiveClassCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
        if (cell==nil) {
            cell=[[MyExclusiveClassCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        if (_completedArray.count>indexPath.row) {
            cell.model = _completedArray[indexPath.row];
            cell.classType = CompletedClass;
        }
        
        tableCell = cell;
    }
    
    return  tableCell;
}

#pragma mark- UITableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120*ScrenScale;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyExclusiveClassCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ExclusiveInfoViewController *controller = [[ExclusiveInfoViewController alloc]initWithClassID:cell.model.customized_group.classID];
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark- UIScrollView delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _mainView.scrollView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger pages = scrollView.contentOffset.x / pageWidth;
        [_mainView.segmentControl setSelectedSegmentIndex:pages animated:YES];
    }
}

- (UIView *)makePlaceHolderView{
    
    HaveNoClassView *view = [[HaveNoClassView alloc]initWithTitle:@"暂无课程"];
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
