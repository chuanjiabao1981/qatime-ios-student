//
//  ReplayViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/6/21.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ReplayViewController.h"
#import "NavigationBar.h"
#import "MJRefresh.h"
#import "UIViewController+AFHTTP.h"
#import "CYLTableViewPlaceHolder.h"
#import "HaveNoClassView.h"
#import "ReplayLesson.h"
#import "YYModel.h"
#import "ReplayTableViewCell.h"
#import "ReplayLessonsViewController.h"


typedef enum : NSUInteger {
    PullToReload,
    PushToLoadMore,
} RefreshType;

@interface ReplayViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NavigationBar *_navigationBar;
    
    NSInteger page;
    
    NSMutableDictionary *_filterDic;
    
    NSMutableArray *_replaysArr;
}

@end

@implementation ReplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //初始化数据
    [self makeData];
    
    //加载导航栏
    [self setupNavigation];
    
    //加载主视图
    [self setupMainView];
    
    //
    
}

/**初始化数据*/
- (void)makeData{
    
    page = 1;
    
    _filterDic = @{@"page":[NSString stringWithFormat:@"%ld",page],@"per_page":@"10"}.mutableCopy;
    
    _replaysArr = @[].mutableCopy;
}

/**加载导航栏*/
- (void)setupNavigation{
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview:_navigationBar];
    
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    _navigationBar.titleLabel.text = @"精彩回放";
    
}

/**加载主视图*/
- (void)setupMainView{
    
    //筛选栏
    _filterView = [[ReplayFilterView alloc]init];
    [self.view addSubview:_filterView];
    _filterView.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(_navigationBar, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(40);
    
    //主视图
    _mainView = [[UITableView alloc]init];
    _mainView.backgroundColor = BACKGROUNDGRAY;
    _mainView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_mainView];
    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(_filterView, 0)
    .bottomSpaceToView(self.view, 0);
    
    _mainView.delegate = self;
    _mainView.dataSource = self;
    
    _mainView.mj_header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
        
        [self requestDataWithRefreshType:PullToReload];
    }];
    
    _mainView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self requestDataWithRefreshType:PushToLoadMore];
    }];
    
    [_mainView.mj_header beginRefreshing];
    
    //target action
    [_filterView.newestBtn addTarget:self action:@selector(newestAction:) forControlEvents:UIControlEventTouchUpInside];
    [_filterView.popularityBtn addTarget:self action:@selector(popularAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

/**请求数据 ,传入个下拉/上滑方式就行了*/
- (void)requestDataWithRefreshType:(RefreshType)refreshType{
    
    if (refreshType == PullToReload) {
        page =  1;
        [_replaysArr removeAllObjects];
        [_mainView.mj_footer resetNoMoreData];
    }else{
        page++;
    }
    [_filterDic setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/home/replays",Request_Header] withHeaderInfo:nil andHeaderfield:nil parameters:_filterDic completeSuccess:^(id  _Nullable responds) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            if ([dic[@"data"]count]==0) {
                [_mainView.mj_footer endRefreshingWithNoMoreData];
            }else{
                
                for (NSDictionary *dics in dic[@"data"]) {
                    ReplayLesson *mod = [ReplayLesson yy_modelWithJSON:dics];
                    mod.classID = dics[@"id"];
                    
                    if ([dics[@"target_type"]isEqualToString:@"LiveStudio::Lesson"]) {
                        mod.live_studio_lesson = [Live_studio_lesson yy_modelWithJSON:dics[@"live_studio_lesson"]];
                        
                    }else if ([dics[@"target_type"]isEqualToString:@"LiveStudio::InteractiveLesson"]){
                        mod.live_studio_interactive_lesson = [Live_studio_interactive_lesson yy_modelWithJSON:dics[@"live_studio_interactive_lesson"]];
                    }else if ([dics[@"target_type"]isEqualToString:@"LiveStudio::ScheduledLesson"]){
                        mod.live_studio_scheduled_leddson = [Live_studio_scheduled_lesson yy_modelWithJSON:dics[@"live_studio_scheduled_lesson"]];
                    }
                    
                    [_replaysArr addObject:mod];
                }
                
                if (refreshType == PullToReload) {
                    [_mainView.mj_header endRefreshing];
                }else{
                    [_mainView.mj_footer endRefreshing];
                }
            }
            
            [_mainView cyl_reloadData];
            
        }else{
            [_mainView cyl_reloadData];
        }
        
    } failure:^(id  _Nullable erros) {
        [_mainView cyl_reloadData];
    }];
    
}

/**筛选最新按钮*/
- (void)newestAction:(UIButton *)sender{
    
    //先把另外一个按钮变成默认的
    [_filterView.popularityBtn setTitleColor:TITLECOLOR forState:UIControlStateNormal];
    [_filterView.popularityArrow setImage:nil];
    
    //再把自己给弄成红色的
    [sender setTitleColor:BUTTONRED forState:UIControlStateNormal];
    [_filterView.newestArrow setImage:[UIImage imageNamed:@"下箭头红"]];
    
    //箭头冲下是默认顺序 ,箭头反过来就是倒序
    if (_filterDic) {
        if (_filterDic[@"s"]) {
            if ([_filterDic[@"s"] isEqualToString:@"updated_at desc"]) {
                [_filterView.newestArrow setImage:[UIImage imageNamed:@"上箭头红"]];
                [_filterDic setObject:@"updated_at asc" forKey:@"s"];
                [_mainView.mj_header beginRefreshing];
            }else if ([_filterDic[@"s"] isEqualToString:@"updated_at asc"]){
                [_filterView.newestArrow setImage:[UIImage imageNamed:@"下箭头红"]];
                [_filterDic setObject:@"updated_at desc" forKey:@"s"];
                [_mainView.mj_header beginRefreshing];
            }else{
                //筛选过别的条件
                [_filterView.newestArrow setImage:[UIImage imageNamed:@"下箭头红"]];
                [_filterDic setObject:@"updated_at desc" forKey:@"s"];
                [_mainView.mj_header beginRefreshing];
            }
            
        }else{
            //没有就是默认刚进来
            [_filterView.newestArrow setImage:[UIImage imageNamed:@"上箭头红"]];
            [_filterDic setObject:@"updated_at asc" forKey:@"s"];
            [_mainView.mj_header beginRefreshing];
        }
    }
    
}

/**最多观看按钮*/
- (void)popularAction:(UIButton *)sender{
    
    //先把另外一个按钮变成默认的
    [_filterView.newestBtn setTitleColor:TITLECOLOR forState:UIControlStateNormal];
    [_filterView.newestArrow setImage:nil];
    
    //再把自己给弄成红色的
    [sender setTitleColor:BUTTONRED forState:UIControlStateNormal];
    [_filterView.popularityArrow setImage:[UIImage imageNamed:@"下箭头红"]];
    
    //replay_times desc
    //replay_times asc
    
    //箭头冲下是默认顺序 ,箭头反过来就是倒序
    if (_filterDic) {
        if (_filterDic[@"s"]) {
            if ([_filterDic[@"s"] isEqualToString:@"replay_times desc"]) {
                [_filterView.popularityArrow setImage:[UIImage imageNamed:@"上箭头红"]];
                [_filterDic setObject:@"replay_times asc" forKey:@"s"];
                [_mainView.mj_header beginRefreshing];
            }else if ([_filterDic[@"s"] isEqualToString:@"replay_times asc"]){
                [_filterView.popularityArrow setImage:[UIImage imageNamed:@"下箭头红"]];
                [_filterDic setObject:@"replay_times desc" forKey:@"s"];
                [_mainView.mj_header beginRefreshing];
            }else{
                [_filterView.popularityArrow setImage:[UIImage imageNamed:@"下箭头红"]];
                [_filterDic setObject:@"replay_times desc" forKey:@"s"];
                [_mainView.mj_header beginRefreshing];
            }
            
        }else{
            //没有就是默认刚进来
            [_filterView.popularityArrow setImage:[UIImage imageNamed:@"下箭头红"]];
            [_filterDic setObject:@"replay_times desc" forKey:@"s"];
            [_mainView.mj_header beginRefreshing];
        }
    }

}

#pragma mark- UITableView datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _replaysArr.count;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    ReplayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[ReplayTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    if (_replaysArr.count>indexPath.row) {
        cell.model = _replaysArr[indexPath.row];
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    }
    
    return  cell;
    
}

#pragma mark- UITableView delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 140;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ReplayTableViewCell  *cell = [tableView cellForRowAtIndexPath:indexPath];
    ReplayLessonsViewController *controller = [[ReplayLessonsViewController alloc]initWithLesson:cell.model];
    [self.navigationController pushViewController:controller animated:YES];
    
}


- (UIView *)makePlaceHolderView{
    
    HaveNoClassView *view = [[HaveNoClassView alloc]initWithTitle:@"暂无回放课程"];
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
