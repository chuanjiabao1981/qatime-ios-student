//
//  LiveClassFilterViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/10.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "LiveClassFilterViewController.h"
#import "MJRefresh.h"
#import "ChooseClassTableViewCell.h"
#import "TutoriumInfoViewController.h"
#import "CYLTableViewPlaceHolder.h"


@interface LiveClassFilterViewController ()<UITableViewDataSource,UITableViewDelegate,CYLTableViewPlaceHolderDelegate>{
    
}


@end

@implementation LiveClassFilterViewController

/**初始化方法*/
- (instancetype)initWithGrade:(NSString *)grade andSubject:(NSString *)subject andCourse:(NSString *)course{
    self = [super init];
    if (self) {
        
        //初始化数据
        if (!_classesArray) {
            self.classesArray = @[].mutableCopy;
        }
        if (!_filterDic) {
            self.filterDic = @{}.mutableCopy;
        }
        
        self.isInitPull = YES;
        self.page = 1;   //页数是会变的
        self.perPage = 10;
        self.grade = grade;
        self.subject = subject;
        self.course = course;
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //token
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        self.token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        self.idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    //加载视图
    [self setupViews];
    
    
    _isInitPull = NO;
    
    
    [[NSNotificationCenter defaultCenter]addObserverForName:@"Filters" object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        NSDictionary *filter = [note object];
        
        [self requestClass:PullToRefresh withContentDictionary:filter];
        
        
    }];
    
}

/**加载视图*/
- (void)setupViews{
    _classTableView = ({
        UITableView *_ =[[UITableView alloc]init];
        [self.view addSubview:_];
        _.sd_layout
        .leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .topSpaceToView(self.view, 0)
        .bottomSpaceToView(self.view, 0);
        
        _.backgroundColor = [UIColor whiteColor];
        _.separatorStyle = UITableViewCellSeparatorStyleNone;
        _.dataSource = self;
        _.delegate = self;
        _.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            if (_isInitPull == YES) {
                [_.mj_header endRefreshing];
                
            }else{
                [self requestClass:PullToRefresh withContentDictionary:_filterDic];
            }
        }];
        
        //第一次自动下拉刷新
        [_.mj_header beginRefreshing];
        //自动下拉
        [self requestClass:PullToRefresh withContentDictionary:nil];
        
        _.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            //上滑加载更多
            [self requestClass:PushToReadMore withContentDictionary:nil];
            
        }];
        
        _;
    });
    
}

//下拉加载数据
- (void)requestClass:(RefreshMode)mode withContentDictionary:( nullable __kindof NSDictionary * )contentDic{
    
    //1.页数赋值
    if (mode==PullToRefresh) {
        _page = 1;
        
        [_filterDic setObject:[NSString stringWithFormat:@"%ld",_page] forKey:@"page"];
        _classesArray = @[].mutableCopy;
        
        if (_classTableView.mj_footer.state == MJRefreshStateNoMoreData) {
            _classTableView.mj_footer.state = MJRefreshStateIdle;
            
        }else{
            
        }
    }else{
        
        _page++;
        [_filterDic setObject:[NSString stringWithFormat:@"%ld",_page] forKey:@"page"];
    }
    
    //2.字典值拼接
    if (mode == PullToRefresh) {
        
        if (contentDic==nil) {
            //首页传值过来的筛选方法
            if ([_subject isEqualToString:@"全部"]) {
                
                _filterDic = [NSMutableDictionary dictionaryWithDictionary: @{@"q[grade_eq]":_grade,
                                                                              @"page":[NSString stringWithFormat:@"%ld",_page],
                                                                              @"per_page":[NSString stringWithFormat:@"%ld",_perPage],
                                                                              @"sort_by":@"published_at"}];
            }else{
                //其他科目
                _filterDic = [NSMutableDictionary dictionaryWithDictionary:@{@"q[subject_eq]":_subject,
                                                                             @"q[grade_eq]":_grade,
                                                                             @"page":[NSString stringWithFormat:@"%ld",_page],
                                                                             @"per_page":[NSString stringWithFormat:@"%ld",_perPage]}];
            }
        }else{
            //筛选方法
            
            if ([[contentDic allKeys]count]==0) {
                //默认或者说是没有筛选条件的筛选
                
                if (_filterDic[@"range"]) {
                    [_filterDic removeObjectForKey:@"range"];
                }else{
                    
                }
                
                
                if (_filterDic[@"q[status_eq]"]) {
                    [_filterDic removeObjectForKey:@"q[status_eq]"];
                }else{
                    
                }
                
                
            }else{
                //有各种筛选条件的筛选
                
                if (!contentDic[@"range"]) {
                    if (_filterDic[@"range"]) {
                        [_filterDic removeObjectForKey:@"range"];
                    }else{
                        
                    }
                }
                
                if (!contentDic[@"q[status_eq]"]) {
                    if (_filterDic[@"q[status_eq]"]) {
                        [_filterDic removeObjectForKey:@"q[status_eq]"];
                    }else{
                        
                    }
                }
                
                [_filterDic addEntriesFromDictionary:contentDic];
            }
        }
    }else{
        //上滑加载更多
        [_filterDic addEntriesFromDictionary:contentDic];
        
    }
    
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/%@/search",Request_Header,_course] withHeaderInfo:nil andHeaderfield:nil parameters:_filterDic completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            if ([dic[@"data"] count] !=0) {
                
                /**直播课类型*/
                
                for (NSDictionary *dics in dic[@"data"]) {
                    
                    TutoriumListInfo *mod = [TutoriumListInfo yy_modelWithJSON:dics];
                    mod.classID = dics[@"id"];
                    
                    [_classesArray addObject:mod];
                }
                
                
                if (mode == PullToRefresh) {
                    
                    [_classTableView.mj_header endRefreshing];
                    //刷新数据
                    [_classTableView cyl_reloadData];
                }else{
                    [_classTableView.mj_footer endRefreshing];
                    //刷新数据
                    [_classTableView cyl_reloadData];
                }
                
            }else{
                //没有数据的情况
                if (mode == PullToRefresh) {
                    //下拉刷新的时候
                    [_classTableView.mj_header endRefreshing];
                    //刷新数据
                    [_classTableView cyl_reloadData];
                    
                    
                }else{
                    //上滑的时候
                    
                    [_classTableView.mj_footer endRefreshingWithNoMoreData];
                }
                
            }
        }else{
            //获取数据失败
            //            [self HUDStopWithTitle:@"加载失败,请重试"];
            if (mode == PullToRefresh) {
                [_classTableView.mj_header endRefreshing];
                [_classTableView cyl_reloadData];
                
            }else{
                [_classTableView.mj_footer endRefreshing];
                _page--;
                [_filterDic setObject:[NSString stringWithFormat:@"%ld",_page] forKey:@"page"];
            }
        }
        
    }failure:^(id  _Nullable erros) {
        //获取数据失败
        [self HUDStopWithTitle:@"请检查网络"];
        if (mode == PullToRefresh) {
            [_classTableView.mj_header endRefreshing];
            [_classTableView cyl_reloadData];
            
        }else{
            [_classTableView.mj_footer endRefreshing];
            _page--;
            [_filterDic setObject:[NSString stringWithFormat:@"%ld",_page] forKey:@"page"];
        }
        
    }];
}


#pragma mark- UITableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _classesArray.count;
    
    
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    ChooseClassTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[ChooseClassTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    if (_classesArray.count>indexPath.row) {
        cell.model = _classesArray[indexPath.row];
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    }
    
    return  cell;
    
}

#pragma mark- tableview delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120*ScrenScale;
    
}

//点击 进入辅导班详情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChooseClassTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIViewController *controller = [[TutoriumInfoViewController alloc]initWithClassID:cell.model.classID];
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark- 筛选方法
- (void)filterdByFilterDic:( __kindof NSMutableDictionary *)filterdDic{
    
    NSDictionary *dic = _filterDic.mutableCopy;
    
    for (NSString *key in dic) {
        for (NSString *keys in filterdDic) {
            if ([key isEqualToString:keys]) {
                [_filterDic removeObjectForKey:key];
            }
        }
    }
    [_filterDic addEntriesFromDictionary:filterdDic];
    
    [_classTableView.mj_header beginRefreshing];
    
    [self requestClass:PullToRefresh withContentDictionary:_filterDic];
    
}

//标签筛选
- (void)filteredByTages:(NSString *)tag{
    
    [_filterDic setObject:tag forKey:@"tags"];
    
    [_classTableView.mj_header beginRefreshingWithCompletionBlock:^{
        
        [self requestClass:PullToRefresh withContentDictionary:_filterDic];
        
    }];
    
}


-(UIView *)makePlaceHolderView{
    
    HaveNoClassView *view = [[HaveNoClassView alloc]initWithFrame:_classTableView.frame];
    
    view.titleLabel.text = @"没有相关课程";
    return view;
}
-(BOOL)enableScrollWhenPlaceHolderViewShowing{
    
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
