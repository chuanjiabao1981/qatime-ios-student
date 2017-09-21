//
//  ExclusiveHomeworkViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/8/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ExclusiveHomeworkViewController.h"
#import "NavigationBar.h"
#import "NetWorkTool.h"
#import "HomeworkInfoViewController.h"

typedef NS_ENUM(NSUInteger, RefreshType) {
    PullType,
    PushType,
};

@interface ExclusiveHomeworkViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSString *_classID;
    NSMutableArray <HomeworkManage *>*_homeworkArray;
    NavigationBar *_navBar;
    
    NSInteger _page;
}

@end

@implementation ExclusiveHomeworkViewController

-(instancetype)initWithClassID:(NSString *)classID{
    self = [super init];
    if (self) {
        _classID = classID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeData];
    [self setupViews];
    
}

- (void)makeData{
    
    _homeworkArray = @[].mutableCopy;
    _page = 1;
}

- (void)setupViews{
    _navBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview:_navBar];
    _navBar.titleLabel.text = @"课程作业";
    [_navBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];

    
    _mainView = [[UITableView alloc]init];
    [self.view addSubview:_mainView];
    _mainView.tableFooterView = [UIView new];
    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(_navBar, 0)
    .bottomSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0);
    
    _mainView.dataSource = self;
    _mainView.delegate = self;
    _mainView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        _homeworkArray = @[].mutableCopy;
        [_mainView.mj_footer resetNoMoreData];
        [self requestDataWithRefreshType:PullType];
    }];
    
    _mainView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self requestDataWithRefreshType:PushType];
    }];
    
    [_mainView.mj_header beginRefreshing];
}

- (void)requestDataWithRefreshType:(RefreshType)refreshType{
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/groups/%@/student_homeworks",Request_Header,_classID] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:@{@"page":[NSString stringWithFormat:@"%d",_page],@"per_page":@"10"} withDownloadProgress:^(NSProgress * _Nullable progress) {} completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            if ([dic[@"data"] count]!=0) {
                
                for (NSDictionary *homework in dic[@"data"]) {
                    HomeworkManage *mod = [HomeworkManage yy_modelWithJSON:homework];
                    mod.homeworkID = homework[@"id"];
                    mod.homework = [Homework yy_modelWithJSON:homework[@"homework"]];
                    mod.homework.homeworkID = homework[@"homework"][@"id"];
                    
                    [_homeworkArray addObject:mod];
                }
                if (refreshType == PullType) {
                    [_mainView.mj_header endRefreshingWithCompletionBlock:^{
                        [_mainView cyl_reloadData];
                    }];
                }else{
                    [_mainView.mj_footer endRefreshingWithCompletionBlock:^{
                        [_mainView cyl_reloadData];
                    }];
                }
                
            }else{
                if (refreshType == PullType) {
                    [_mainView .mj_header endRefreshing];
                    [_mainView cyl_reloadData];
                }else{
                    [_mainView.mj_footer endRefreshingWithNoMoreData];
                    [_mainView cyl_reloadData];
                }
            }
        }else{
            //数据不太对
            [self HUDStopWithTitle:@"请稍后重试"];
            
        }
        
    } failure:^(id  _Nullable erros) {
        [self HUDStopWithTitle:@"请检查网络"];
    }];
}

#pragma mark- UITableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _homeworkArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    ClassHomeworkCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[ClassHomeworkCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (_homeworkArray.count>indexPath.row) {
        cell.homeworkModel = _homeworkArray[indexPath.row];
    }
    return  cell;
}


#pragma mark- UITablview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ClassHomeworkCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    HomeworkInfoViewController *controller = [[HomeworkInfoViewController alloc]initWithHomework:cell.homeworkModel];
    [self.navigationController pushViewController:controller animated:YES];
}


- (UIView *)makePlaceHolderView{
    HaveNoClassView *view =[[HaveNoClassView alloc]initWithTitle:@"暂无数据"];
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
