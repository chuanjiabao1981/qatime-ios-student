//
//  ExclusiveAskViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/8/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ExclusiveAskViewController.h"
#import "NavigationBar.h"
#import "YYModel.h"
#import "Questions.h"
#import "Qatime_Student-Swift.h"
#import "HMSegmentedControl+Category.h"
#import "NewQuestionViewController.h"
#import "NetWorkTool.h"
#import "QuestionInfoViewController.h"

typedef NS_ENUM(NSUInteger, DataType) {
    AllType,
    MineType,
};

typedef NS_ENUM(NSUInteger, RefreshType) {
    PullToReload,
    PushToLoadMore,
};


@interface ExclusiveAskViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NavigationBar *_navigationBar;
    
    NSString *_classID;
    
    NSMutableArray *_allQuestionsArray;
    NSMutableArray *_myQuestionsArray;
    
    NSInteger _allPage;
    NSInteger _myPage;
    NSInteger _page;
    
}

@end

@implementation ExclusiveAskViewController

-(instancetype)initWithClassID:(NSString *)classID{
    self = [super init];
    if (self) {
        
        _classID = classID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self makeData];
    
    [self setupViews];
    
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"Ask" object:nil];
    
}
- (void)refresh{
    [_mainView.allQuestionsList.mj_header beginRefreshing];
    [_mainView.myQuestionsList.mj_header beginRefreshing];
}

- (void)makeData{
    _allQuestionsArray = @[].mutableCopy;
    _myQuestionsArray = @[].mutableCopy;
    _allPage = 1;
    _myPage = 1;
    _page = 1;
}

- (void)setupViews{
    
    //navigation
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview: _navigationBar];
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    _navigationBar.titleLabel.text = @"课程提问";
    [_navigationBar.rightButton setImage:[UIImage imageNamed:@"加"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBar.rightButton addTarget:self action:@selector(newQuestion) forControlEvents:UIControlEventTouchUpInside];
    
    //mainView
    _mainView = [[ExclusiveAskView alloc]init];
    [self.view addSubview:_mainView];
    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(_navigationBar, 0)
    .bottomSpaceToView(self.view, 0);
    
    _mainView.allQuestionsList.delegate = self;
    _mainView.allQuestionsList.dataSource = self;
    _mainView.allQuestionsList.tag = 1;
    _mainView.myQuestionsList.delegate = self;
    _mainView.myQuestionsList.dataSource = self;
    _mainView.myQuestionsList.tag = 2;
    
    _mainView.scrollView.delegate = self;
    
    _mainView.allQuestionsList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _allQuestionsArray = @[].mutableCopy;
        _allPage = 1;
        _page = _allPage;
        [_mainView.allQuestionsList.mj_footer resetNoMoreData];
        [self requestDataWithType:AllType andRefreshType:PullToReload];
    }];
    _mainView.allQuestionsList.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _allPage++;
        _page = _allPage;
        [self requestDataWithType:AllType andRefreshType:PushToLoadMore];
    }];
    _mainView.myQuestionsList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _myQuestionsArray = @[].mutableCopy;
        _myPage = 1;
        _page = _myPage;
        [_mainView.myQuestionsList.mj_footer resetNoMoreData];
        [self requestDataWithType:MineType andRefreshType:PullToReload];
    }];
    _mainView.myQuestionsList.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _myPage++;
        _page = _myPage;
        [self requestDataWithType:MineType andRefreshType:PushToLoadMore];
    }];
    
    [_mainView.allQuestionsList.mj_header beginRefreshing];
    [_mainView.myQuestionsList.mj_header beginRefreshing];

}

/** 请求数据 */
- (void)requestDataWithType:(DataType)dataType andRefreshType:(RefreshType)refreshType{
   
    NSDictionary *formDic ;
    if (dataType == AllType) {
        formDic = @{@"page":[NSString stringWithFormat:@"%ld",_page],@"per_page":@"10"};
    }else if (dataType ==MineType){
        formDic = @{@"page":[NSString stringWithFormat:@"%ld",_page],@"per_page":@"10",@"user_id":[self getStudentID]};
    }
    typeof(self) __weak weakSelf = self;
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/groups/%@/questions",Request_Header,_classID] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:formDic withDownloadProgress:^(NSProgress * _Nullable progress) {} completeSuccess:^(id  _Nullable responds) {
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            //有数
            if ([dic[@"data"] count]!=0) {
                
                for (NSDictionary *question in dic[@"data"]) {
                    Questions *mod = [Questions yy_modelWithJSON:question];
                    mod.questionID = question[@"id"];
                    if (![question[@"answer"] isEqual:[NSNull null]]) {
                        if ([question[@"answer"]count]!=0) {
                            mod.answer = [Answers yy_modelWithJSON:question[@"answer"]];
                        }
                    }
                    
                    if (dataType == AllType) {
                        [_allQuestionsArray addObject:mod];
                    }else{
                        [_myQuestionsArray addObject:mod];
                    }
                }
                
                if (dataType == AllType) {
                    if (refreshType == PullToReload) {
                        [_mainView.allQuestionsList.mj_header endRefreshingWithCompletionBlock:^{
                            [weakSelf.mainView.allQuestionsList cyl_reloadData];
                        }];
                    }else{
                        [_mainView.allQuestionsList.mj_footer endRefreshingWithCompletionBlock:^{
                            [weakSelf.mainView.myQuestionsList cyl_reloadData];
                        }];
                    }
                }else{
                    if (refreshType == PullToReload) {
                        [_mainView.myQuestionsList.mj_header endRefreshingWithCompletionBlock:^{
                            [weakSelf.mainView.myQuestionsList cyl_reloadData];
                        }];
                    }else{
                        [_mainView.myQuestionsList.mj_footer endRefreshingWithCompletionBlock:^{
                            [weakSelf.mainView.myQuestionsList cyl_reloadData];
                        }];
                    }
                }
            }else{
                if (refreshType == PullToReload) {
                    if (dataType == AllType) {
                        [_mainView.allQuestionsList.mj_header endRefreshingWithCompletionBlock:^{
                            [weakSelf.mainView.allQuestionsList cyl_reloadData];
                        }];
                    }else{
                        [_mainView.myQuestionsList.mj_header endRefreshingWithCompletionBlock:^{
                            [weakSelf.mainView.myQuestionsList cyl_reloadData];
                        }];
                    }
                }else{
                    if (dataType == AllType) {
                        [_mainView.allQuestionsList.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [_mainView.myQuestionsList.mj_footer endRefreshingWithNoMoreData];
                    }
                }
                
            }
        }else{
            [self HUDStopWithTitle:@"请稍后重试"];
            
        }
    } failure:^(id  _Nullable erros) {
        [self HUDStopWithTitle:@"请检查网络"];
    }];
    
}



#pragma mark- UITableview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    if (tableView.tag == 1) {
        row = _allQuestionsArray.count;
    }else{
        row = _myQuestionsArray.count;
    }
    return row;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    QuestionsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[QuestionsTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    if (tableView.tag == 1) {
        if (_allQuestionsArray.count>indexPath.row) {
            [cell setModelWithQuestion:_allQuestionsArray[indexPath.row]];
        }
        
    }else{
        if (_myQuestionsArray.count>indexPath.row) {
            [cell setModelWithQuestion:_myQuestionsArray[indexPath.row]];
        }
       
    }
    
    return  cell;
}


#pragma mark- UITableView delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 130;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QuestionsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    QuestionInfoViewController *controller = [[QuestionInfoViewController alloc]initWithQuestion:cell.model];
    [self.navigationController pushViewController:controller animated:YES];
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == _mainView.scrollView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger pages = scrollView.contentOffset.x / pageWidth;
        
        [self.mainView.segmentControl setSelectedSegmentIndex:pages animated:YES];
        
    }
}

/** 添加新问题 */
- (void)newQuestion{
    
    NewQuestionViewController *controller = [[NewQuestionViewController alloc]initWithClassID:_classID];
    [self.navigationController pushViewController:controller animated:YES];
}


- (UIView *)makePlaceHolderView{
    HaveNoClassView *view = [[HaveNoClassView alloc]initWithTitle:@"暂无数据"];
    return  view;
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
