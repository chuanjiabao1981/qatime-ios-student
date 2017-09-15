//
//  MyHomeworkViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/9/8.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "MyHomeworkViewController.h"
#import "ClassHomework.h"
#import "NetWorkTool.h"
#import "NavigationBar.h"
#import "CYLTableViewPlaceHolder.h"
#import "HomeworkManage.h"
#import "HomeworkInfoViewController.h"

typedef NS_ENUM(NSUInteger, RefreshType) {
    PullToReload,
    PushToLoadMore,
};

typedef NS_ENUM(NSUInteger, HomeWorkType) {
    UnHand_InType,
    Handed_InType,
    CheckedType,
};

@interface MyHomeworkViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    __block NSMutableArray *_unhandedArray;
    
    __block NSMutableArray *_handedArray;
    
    __block NSMutableArray *_checkedArray;
    
    NavigationBar *_navBar;
    
    __block NSInteger _page;
    
    __block NSInteger _unhandedPage;
    __block NSInteger _handedPage;
    __block NSInteger _checkedPage;
    
}

@end

@implementation MyHomeworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self makeData];
    
    [self setupView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"HomeworkDone" object:nil];
    
}

- (void)makeData{
    
    _unhandedArray = @[].mutableCopy;
    _handedArray = @[].mutableCopy;
    _checkedArray = @[].mutableCopy;
    _checkedPage = 1;
    _unhandedPage = 1;
    _handedPage = 1;
    
}

- (void)refresh{
    [_mainView.unhandedList.mj_header beginRefreshing];
    [_mainView.handedList.mj_header beginRefreshing];
}

- (void)setupView{
    typeof(self) __weak weakSelf = self;
    _navBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview:_navBar];
    _navBar.titleLabel.text = @"我的作业";
    [_navBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    _mainView = [[MyHomeworkView alloc]init];
    [self.view addSubview:_mainView];
    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(_navBar, 0)
    .bottomSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0);
    
    _mainView.unhandedList.tag = 1;
    _mainView.unhandedList.delegate = self;
    _mainView.unhandedList.dataSource = self;
    _mainView.unhandedList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.mainView.unhandedList.mj_footer resetNoMoreData];
        _unhandedArray = @[].mutableCopy;
        _unhandedPage = 1;
        _page = _unhandedPage;
        [self requestDataWithRefreshType:PullToReload andDataType:UnHand_InType];
        
    }];
    [_mainView.unhandedList.mj_header beginRefreshing];
    
    _mainView.unhandedList.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _unhandedPage ++;
        _page = _unhandedPage;
        [self requestDataWithRefreshType:PushToLoadMore andDataType:UnHand_InType];
    }];
    
    _mainView.handedList.tag = 2;
    _mainView.handedList.dataSource = self;
    _mainView.handedList.delegate = self;
    _mainView.handedList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.mainView.handedList.mj_footer resetNoMoreData];
        _handedArray = @[].mutableCopy;
        _handedPage = 1;
        _page = _handedPage;
        [self requestDataWithRefreshType:PullToReload andDataType:Handed_InType];
    }];
    
    [_mainView.handedList.mj_header beginRefreshing];
    
    _mainView.handedList.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _handedPage ++;
        _page = _handedPage;
        [self requestDataWithRefreshType:PushToLoadMore andDataType:Handed_InType];
    }];
    
    _mainView.checkedList.tag = 3;
    _mainView.checkedList.delegate = self;
    _mainView.checkedList.dataSource = self;
    _mainView.checkedList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.mainView.checkedList.mj_footer resetNoMoreData];
        _checkedArray = @[].mutableCopy;
        _checkedPage = 1;
        _page = _checkedPage;
        [self requestDataWithRefreshType:PullToReload andDataType:CheckedType];
    }];
    
    [_mainView.checkedList.mj_header beginRefreshing];
    
    _mainView.checkedList.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _checkedPage ++;
        _page = _checkedPage;
        [self requestDataWithRefreshType:PushToLoadMore andDataType:CheckedType];
    }];
    
}


- (void)requestDataWithRefreshType:(RefreshType)refreshType andDataType:(HomeWorkType)homeworkType{
    
    __block NSString *status ;
    if (homeworkType == UnHand_InType) {
        status = @"pending";
    }else if (homeworkType == Handed_InType){
        status = @"submitted";
    }else if (homeworkType == CheckedType){
        status = @"resolved";
    }
    
    typeof(self) __weak weakSelf = self;
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/students/%@/student_homeworks",Request_Header,[self getStudentID]] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:@{@"status":status,@"page":[NSString stringWithFormat:@"%ld",_page],@"per_page":@"10"} withDownloadProgress:^(NSProgress * _Nullable progress) {} completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            if ([dic[@"data"]count]!=0) {
                
                for (NSDictionary *homework in dic[@"data"]) {
                    HomeworkManage *mod = [HomeworkManage yy_modelWithJSON:homework];
                    mod.homeworkID = homework[@"id"];
                    mod.homework = [Homework yy_modelWithJSON:homework[@"homework"]];
                    mod.homework.homeworkID = homework[@"homework"][@"id"];
                    
                    if (mod) {
                        if (homeworkType == UnHand_InType) {
                            [_unhandedArray addObject:mod];
                        }else if (homeworkType == Handed_InType){
                            [_handedArray addObject:mod];
                        }else if (homeworkType == CheckedType){
                            [_checkedArray addObject:mod];
                        }
                    }
                }
                
                if (refreshType == PullToReload) {
                    if (homeworkType == UnHand_InType) {
                        [_mainView.unhandedList.mj_header endRefreshingWithCompletionBlock:^{
                            [weakSelf.mainView.unhandedList cyl_reloadData];
                        }];
                    }else if (homeworkType == Handed_InType){
                        [_mainView.handedList.mj_header endRefreshingWithCompletionBlock:^{
                            [weakSelf.mainView.handedList cyl_reloadData];
                        }];
                    }else if (homeworkType == CheckedType){
                       [_mainView.checkedList.mj_header endRefreshingWithCompletionBlock:^{
                           [weakSelf.mainView.checkedList cyl_reloadData];
                       }];
                    }
                    
                }else{
                    if (homeworkType == UnHand_InType) {
                        [_mainView.unhandedList.mj_footer endRefreshingWithCompletionBlock:^{
                            [weakSelf.mainView.unhandedList cyl_reloadData];
                        }];
                    }else if (homeworkType == Handed_InType){
                        [_mainView.handedList.mj_footer endRefreshingWithCompletionBlock:^{
                            [weakSelf.mainView.handedList cyl_reloadData];
                        }];
                    }else if (homeworkType == CheckedType){
                        [_mainView.checkedList.mj_footer endRefreshingWithCompletionBlock:^{
                            [weakSelf.mainView.checkedList cyl_reloadData];
                        }];
                    }
                }
                
            }else{
                if (refreshType == PullToReload) {
                    if (homeworkType == UnHand_InType) {
                        [_mainView.unhandedList.mj_header endRefreshing];
                    }else if (homeworkType == Handed_InType){
                        [_mainView.handedList.mj_header endRefreshing];
                    }else if (homeworkType == CheckedType){
                        [_mainView.checkedList.mj_header endRefreshing];
                    }
                    
                }else{
                    if (homeworkType == UnHand_InType) {
                        [_mainView.unhandedList.mj_footer endRefreshingWithNoMoreData];
                    }else if (homeworkType == Handed_InType){
                        [_mainView.handedList.mj_footer endRefreshingWithNoMoreData];
                    }else if (homeworkType == CheckedType){
                        [_mainView.checkedList.mj_footer endRefreshingWithNoMoreData];
                    }
                }

            }
            
        }else{
            
            [self HUDStopWithTitle:@"请稍后重试"];
            if (refreshType == PullToReload) {
                if (homeworkType == UnHand_InType) {
                    [_mainView.unhandedList.mj_header endRefreshing];
                }else if (homeworkType == Handed_InType){
                    [_mainView.handedList.mj_header endRefreshing];
                }else if (homeworkType == CheckedType){
                    [_mainView.checkedList.mj_header endRefreshing];
                }
                
            }else{
                if (homeworkType == UnHand_InType) {
                    [_mainView.unhandedList.mj_footer endRefreshingWithNoMoreData];
                }else if (homeworkType == Handed_InType){
                    [_mainView.handedList.mj_footer endRefreshingWithNoMoreData];
                }else if (homeworkType == CheckedType){
                    [_mainView.checkedList.mj_footer endRefreshingWithNoMoreData];
                }
            }

        }
        
    } failure:^(id  _Nullable erros) {
        
        [self HUDStopWithTitle:@"请检查网络"];
        if (refreshType == PullToReload) {
            if (homeworkType == UnHand_InType) {
                [_mainView.unhandedList.mj_header endRefreshing];
            }else if (homeworkType == Handed_InType){
                [_mainView.handedList.mj_header endRefreshing];
            }else if (homeworkType == CheckedType){
                [_mainView.checkedList.mj_header endRefreshing];
            }
            
        }else{
            if (homeworkType == UnHand_InType) {
                [_mainView.unhandedList.mj_footer endRefreshingWithNoMoreData];
            }else if (homeworkType == Handed_InType){
                [_mainView.handedList.mj_footer endRefreshingWithNoMoreData];
            }else if (homeworkType == CheckedType){
                [_mainView.checkedList.mj_footer endRefreshingWithNoMoreData];
            }
        }

    }];
    
}



#pragma mark- UITablView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger row = 0;
    
    if (tableView.tag == 1) {
        row = _unhandedArray.count;
    }else if (tableView.tag == 2){
        row = _handedArray.count;
    }else if (tableView.tag == 3){
        row = _checkedArray.count;
    }
    
    return row;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    MyHomewoekTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[MyHomewoekTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (tableView.tag == 1) {
        if (_unhandedArray.count>indexPath.row) {
            cell.model = _unhandedArray[indexPath.row];
        }
        
    }else if (tableView.tag == 2){
        if (_handedArray.count>indexPath.row) {
            cell.model = _handedArray[indexPath.row];
        }
        
    }else if (tableView.tag == 3){
        if (_checkedArray.count>indexPath.row) {
            cell.model = _checkedArray[indexPath.row];
        }
        
    }
    
    return  cell; 
    
}


#pragma mark- UITableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyHomewoekTableViewCell *cell = (MyHomewoekTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];

    HomeworkInfoViewController *controller = [[HomeworkInfoViewController alloc]initWithHomework:cell.model];
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (UIView *)makePlaceHolderView{
    HaveNoClassView *view = [[HaveNoClassView alloc]initWithTitle:@"暂无数据"];
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
