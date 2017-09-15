//
//  MyQuestion_UnresolvedViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/8/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//



#import "MyQuestion_UnresolvedViewController.h"
#import "NetWorkTool.h"
#import "Questions.h"
#import "QuestionInfoViewController.h"

typedef NS_ENUM(NSUInteger, RefreshType) {
    PullToReload,
    PushToLoadMore,
};
@interface MyQuestion_UnresolvedViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray *_questionsArray;
    
    NSInteger _page;
    
}

@end

@implementation MyQuestion_UnresolvedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeData];
    [self setupView];
    
}

- (void)makeData{

    _questionsArray = @[].mutableCopy;
    _page = 1;
    
    _course = @"pending";
}

- (void)setupView{
    _mainView = [[UITableView alloc]init];
    [self.view addSubview:_mainView];
    _mainView.tableFooterView = [UIView new];
    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    _mainView.delegate = self;
    _mainView.dataSource = self;
    _mainView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _questionsArray = @[].mutableCopy;
        _page = 1;
        [_mainView.mj_footer resetNoMoreData];
        [self requestDataWithRefreshType:PullToReload];
        
    }];
    _mainView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self requestDataWithRefreshType:PushToLoadMore];
    }];
    
    [_mainView.mj_header beginRefreshing];
    
}
- (void)requestDataWithRefreshType:(RefreshType)refreshType{
    typeof(self) __weak weakSelf = self;
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/students/%@/questions",Request_Header,[self getStudentID]] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:@{@"status":_course,@"page":[NSString stringWithFormat:@"%ld",_page],@"per_page":@"10"} withDownloadProgress:^(NSProgress * _Nullable progress) {} completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if([dic[@"status"]isEqualToNumber:@1]) {
            if ([dic[@"data"]count]!=0) {
                
                for (NSDictionary *ques in dic[@"data"]) {
                    Questions *mod = [Questions yy_modelWithJSON:ques];
                    mod.questionID = ques[@"id"];
                    if (![ques[@"answer"] isEqual:[NSNull null]]) {
                        mod.answer = [Answers yy_modelWithJSON:ques[@"answer"]];
                    }
                    [_questionsArray addObject:mod];
                }
                if (refreshType == PullToReload) {
                    [_mainView.mj_header endRefreshingWithCompletionBlock:^{
                        [weakSelf.mainView cyl_reloadData];
                    }];
                }else{
                    [_mainView.mj_footer endRefreshingWithCompletionBlock:^{
                        [weakSelf.mainView cyl_reloadData];
                    }];
                }
            }else{
                //没数据了操
                if (refreshType == PullToReload) {
                    [_mainView.mj_header endRefreshingWithCompletionBlock:^{
                        [weakSelf.mainView cyl_reloadData];
                    }];
                }else{
                    [_mainView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }else{
            [self HUDStopWithTitle:@"请稍后重试"];
        }
    } failure:^(id  _Nullable erros) {
        [self HUDStopWithTitle:@"请检查网络"];
    }];
}

#pragma mark- tablview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _questionsArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    MyQuestionsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[MyQuestionsTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    if (_questionsArray.count>indexPath.row) {
        [cell myQuestionsModelWithQuestion:_questionsArray[indexPath.row]];
    }
    
    return  cell;
}

#pragma mark- tablview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //查看详情吧
    MyQuestionsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    QuestionInfoViewController *controller = [[QuestionInfoViewController alloc]initWithQuestion:cell.model];
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
