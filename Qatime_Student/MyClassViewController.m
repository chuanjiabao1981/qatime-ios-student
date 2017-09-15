//
//  MyClassViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "MyClassViewController.h"

#import "NavigationBar.h"
#import "TutoriumList.h"
#import "UnStartClassTableViewCell.h"
#import "StartedTableViewCell.h"
#import "EndedTableViewCell.h"
#import "ListenTableViewCell.h"
#import "YYModel.h"
#import "HaveNoClassView.h"
#import "UIViewController+HUD.h"
#import "TutoriumInfoViewController.h"
#import "LivePlayerViewController.h"
#import "ChatViewController.h"
#import "UIControl+RemoveTarget.h"
#import "UIViewController+Token.h"
#import "CYLTableViewPlaceHolder.h"
#import "HaveNoClassView.h"
#import "UIViewController+AFHTTP.h"


#define SCREENWIDTH self.view.frame.size.width
#define SCREENHEIGHT self.view.frame.size.height

typedef NS_ENUM(NSUInteger, RefreshType) {
    PullToReload,
    PushTolLoadMore,
};

typedef NS_ENUM(NSUInteger, ClassType) {
    UnstartedClass,
    StartedClass,
    EndedClass,
};

@interface MyClassViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NavigationBar *_navigationBar;
    /* 保存课程数据的数组们*/
    NSMutableArray *_allClassArr;
    
    NSMutableArray *_unStartArr;
    NSMutableArray *_startedArr;
    NSMutableArray *_endedArr;
    NSMutableArray *_listenArr;
    
    //页数
    NSInteger _unStartPage;
    NSInteger _startedPage;
    NSInteger _endedPage;
    
    NSInteger _page;
    
    //course字段
    NSString *_course;
    
}

@end

@implementation MyClassViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self makeData];
    [self setupMainView];

}

- (void)makeData{
    
    /* 所有数据初始化*/
    _allClassArr = @[].mutableCopy;
    _unStartArr = @[].mutableCopy;
    _startedArr = @[].mutableCopy;
    _endedArr = @[].mutableCopy;
    _listenArr = @[].mutableCopy;
    
    _unStartPage = 1;
    _startedPage = 1;
    _endedPage = 1;
    _page = 1;
    
    _course = @"";
    
}

- (void)setupMainView{
    
    _navigationBar  = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, Navigation_Height)];
    [self.view addSubview:_navigationBar];
    _navigationBar.titleLabel.text = @"我的直播课";
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    /* 加载课程视图*/
    _myClassView = [[MyClassView alloc]initWithFrame:CGRectMake(0, Navigation_Height, SCREENWIDTH, SCREENHEIGHT-Navigation_Height)];
    [self.view addSubview:_myClassView];
    
    _myClassView.scrollView .delegate = self;
    
    /* 滑动效果*/
    typeof(self) __weak weakSelf = self;
    [ _myClassView.segmentControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.myClassView.scrollView scrollRectToVisible:CGRectMake(self.view.width_sd * index, 0, CGRectGetWidth(weakSelf.view.bounds), CGRectGetHeight(weakSelf.view.frame)-Navigation_Height-40) animated:YES];
    }];
    [_myClassView.scrollView scrollRectToVisible:CGRectMake(-self.view.width_sd, 0, self.view.width_sd, self.view.height_sd) animated:YES];
    
    [self setupUnstartView];
    [self setupStartedView];
    [self setupEndedView];

}

#pragma mark- 滑动图的几个view的初始化等

/* 加载未开课数据*/
- (void)setupUnstartView{
    _unStartClassView = ({
        UnStartClassView *_ = [[UnStartClassView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-Navigation_Height-40)];
        [_myClassView.scrollView addSubview:_];
        _.classTableView.tag =1;
        _.classTableView.delegate = self;
        _.classTableView.dataSource =self;
        _.classTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _unStartPage = 1;
            _unStartArr = @[].mutableCopy;
            _page= _unStartPage;
            _course = @"published";
            [self requestDataWithRefreshType:PullToReload andClassType:UnstartedClass];
            
        }];
        _.classTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _unStartPage++;
            _course = @"published";
            _page = _unStartPage;
            [_.classTableView.mj_footer resetNoMoreData];
            [self requestDataWithRefreshType:PushTolLoadMore andClassType:UnstartedClass];
            
        }];
        [_.classTableView.mj_header beginRefreshing];
        _;
        
    });
    
}

/* 加载已开课数据*/
- (void)setupStartedView{
    _startedClassView = ({
        StartedClassView *_ = [[StartedClassView alloc]initWithFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT-Navigation_Height-40)];
        [_myClassView.scrollView addSubview:_];
        _.classTableView.tag =2;
        _.classTableView.delegate = self;
        _.classTableView.dataSource =self;
        
        _.classTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _startedPage = 1;
            _startedArr = @[].mutableCopy;
            _page = _startedPage;
            _course = @"teaching";
            [_.classTableView.mj_footer resetNoMoreData];
            [self requestDataWithRefreshType:PullToReload andClassType:StartedClass];
            
        }];
        
        _.classTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _startedPage++;
            _page = _startedPage;
            _course = @"teaching";
            [self requestDataWithRefreshType:PushTolLoadMore andClassType:StartedClass];
            
        }];
        [_.classTableView.mj_header beginRefreshing];

        _;
        
    });
    
}
/* 加载已结束视图*/
- (void)setupEndedView{
    
    _endedClassView = ({
        EndedClassView *_ = [[EndedClassView alloc]initWithFrame:CGRectMake(SCREENWIDTH*2, 0, SCREENWIDTH, SCREENHEIGHT-Navigation_Height-40)];
        [_myClassView.scrollView addSubview:_];
        _.classTableView.tag =3;
        _.classTableView.delegate = self;
        _.classTableView.dataSource =self;
        
        _.classTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _endedPage = 1;
            _page = _endedPage;
            _endedArr = @[].mutableCopy;
            _course = @"completed";
            [_.classTableView.mj_footer resetNoMoreData];
            [self requestDataWithRefreshType:PullToReload andClassType:EndedClass];
            
        }];
        
        _.classTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _endedPage++;
            _page = _endedPage;
            _course = @"completed";
            [self requestDataWithRefreshType:PushTolLoadMore andClassType:EndedClass];
            
        }];
        [_.classTableView.mj_header beginRefreshing];
        _;
        
    });
}

/* 加载试听视图*/
- (void)setupListenView{
    
}


#pragma mark- 请求待开课数据
- (void)requestDataWithRefreshType:(RefreshType)refreshType andClassType:(ClassType)classType{
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/students/%@/courses",Request_Header,[self getStudentID]] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:@{@"page":[NSString stringWithFormat:@"%ld",_page ],@"per_page":@"10",@"status":_course} completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            if (classType == UnstartedClass) {
                if ([dic[@"data"]count]!=0){
                    for (NSDictionary *classes in dic[@"data"]) {
                        MyTutoriumModel *mod = [MyTutoriumModel yy_modelWithJSON:classes];
                        mod.classID = classes[@"id"];
                        [_unStartArr addObject:mod];
                    }
                    if (refreshType == PushTolLoadMore) {
                        [_unStartClassView.classTableView.mj_footer endRefreshing];
                    }else{
                        [_unStartClassView.classTableView.mj_header endRefreshing];
                    }

                }else{
                    if (refreshType == PushTolLoadMore) {
                        [_unStartClassView.classTableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [_unStartClassView.classTableView.mj_header endRefreshing];
                    }
                }
                [_unStartClassView.classTableView cyl_reloadData];
            }else if (classType == StartedClass){
             
                if ([dic[@"data"]count]!=0){
                    
                    for (NSDictionary *classes in dic[@"data"]) {
                        MyTutoriumModel *mod = [MyTutoriumModel yy_modelWithJSON:classes];
                        mod.classID = classes[@"id"];
                        [_startedArr addObject:mod];
                    }
                    if (refreshType == PushTolLoadMore) {
                        [_startedClassView.classTableView.mj_footer endRefreshing];
                    }else{
                        [_startedClassView.classTableView.mj_header endRefreshing];
                    }
                }else{
                    if (refreshType == PushTolLoadMore) {
                        [_startedClassView.classTableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [_startedClassView.classTableView.mj_header endRefreshing];
                    }
                }
                
                [_startedClassView.classTableView cyl_reloadData];
            }else{
                if ([dic[@"data"]count]!=0){
                    
                    for (NSDictionary *classes in dic[@"data"]) {
                        MyTutoriumModel *mod = [MyTutoriumModel yy_modelWithJSON:classes];
                        mod.classID = classes[@"id"];
                        [_endedArr addObject:mod];
                    }
                    if (refreshType == PushTolLoadMore) {
                        [_endedClassView.classTableView.mj_footer endRefreshing];
                    }else{
                        [_endedClassView.classTableView.mj_header endRefreshing];
                    }
                    
                }else{
                    if (refreshType == PushTolLoadMore) {
                        [_endedClassView.classTableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [_endedClassView.classTableView.mj_header endRefreshing];
                    }
                }
                [_endedClassView.classTableView cyl_reloadData];
            }
            
        }else{
            [self HUDStopWithTitle:@"请稍后重试"];
            if (refreshType == PullToReload) {
                if (classType == UnstartedClass) {
                    [_unStartClassView.classTableView.mj_header endRefreshing];
                }else if (classType == StartedClass){
                    [_startedClassView.classTableView.mj_header endRefreshing];
                }else{
                    [_endedClassView.classTableView.mj_header endRefreshing];
                }
                
            }else{
                if (classType == UnstartedClass) {
                    [_unStartClassView.classTableView.mj_footer endRefreshing];
                }else if (classType == StartedClass){
                    [_startedClassView.classTableView.mj_footer endRefreshing];
                }else{
                    [_endedClassView.classTableView.mj_footer endRefreshing];
                }
            }
            
        }
        
    } failure:^(id  _Nullable erros) {
        [self HUDStopWithTitle:@"请检查网络"];
        if (refreshType == PullToReload) {
            if (classType == UnstartedClass) {
                [_unStartClassView.classTableView.mj_header endRefreshing];
            }else if (classType == StartedClass){
                [_startedClassView.classTableView.mj_header endRefreshing];
            }else{
                [_endedClassView.classTableView.mj_header endRefreshing];
            }
            
        }else{
            if (classType == UnstartedClass) {
                [_unStartClassView.classTableView.mj_footer endRefreshing];
            }else if (classType == StartedClass){
                [_startedClassView.classTableView.mj_footer endRefreshing];
            }else{
                [_endedClassView.classTableView.mj_footer endRefreshing];
            }
        }

    }];
}


#pragma mark- tableview datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (tableView.tag) {
        case 1:{
            if (_unStartArr.count!=0) {
                
                return _unStartArr.count;
            }
        }
            break;
        case 2:{
            if (_startedArr.count!=0) {
                
                return _startedArr.count;
            }
            
        }
            break;
        case 3:{
            if (_endedArr.count!=0) {
                
                return _endedArr.count;
            }
            
        }
            break;
        case 4:{
            if (_listenArr.count!=0) {
                
                return _listenArr.count;
            }
            
        }
            break;
            
    }
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell  = [[UITableViewCell alloc]init];
    
    switch (tableView.tag) {
        case 1:{
            
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            UnStartClassTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[UnStartClassTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
            }
            if (_unStartArr.count>indexPath.row) {
                cell.model = _unStartArr[indexPath.row];
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                
                /* 已购买的*/
                if (cell.model.is_bought == YES) {
                    cell.status.hidden = YES;
                    
                    [cell.className sd_clearAutoLayoutSettings];
                    cell.className.sd_resetLayout
                    .leftSpaceToView(cell.classImage,10)
                    .topSpaceToView(cell.content,10)
                    .autoHeightRatio(0)
                    .rightSpaceToView(cell.content,10);
                    [cell.className setMaxNumberOfLinesToShow:1];
                    [cell.className updateLayout];
                    
                }else{
                    cell.status.hidden = NO;
                    
                    [cell.className sd_clearAutoLayoutSettings];
                    cell.className.sd_resetLayout
                    .leftSpaceToView(cell.status,2)
                    .topEqualToView(cell.status)
                    .bottomEqualToView(cell.status)
                    .rightSpaceToView(cell.content,10);
                    [cell.className setMaxNumberOfLinesToShow:1];
                    [cell.className updateLayout];
                    
                    cell.status.text = @" 试听中 ";
                }
                [cell.enterButton removeAllTargets];
                cell.enterButton.enabled = YES;
                [cell.enterButton addTarget:self action:@selector(enterChat:) forControlEvents:UIControlEventTouchUpInside];
                cell.enterButton.tag = indexPath.row;
            }
            
            return  cell;
        }
            break;
        case 2:{
            
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            StartedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[StartedTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            }
            cell.enterButton.hidden = YES;
            if (_startedArr.count>indexPath.row) {
                cell.model = _startedArr[indexPath.row];
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                
                if (cell.model.is_bought == YES) {
                    
                    cell.enterButton.hidden = NO;
                    cell.enterButton.layer.borderColor = BUTTONRED.CGColor;
                    [cell.enterButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
                    
                    [cell.className sd_clearAutoLayoutSettings];
                    cell.className.sd_resetLayout
                    .leftSpaceToView(cell.classImage,10)
                    .topSpaceToView(cell.content,10)
                    .autoHeightRatio(0)
                    .rightSpaceToView(cell.content,10);
                    [cell.className setMaxNumberOfLinesToShow:1];
                    [cell.className updateLayout];
                }else{
                    
                    cell.enterButton.hidden = NO;
                    cell.enterButton.layer.borderColor = BUTTONRED.CGColor;
                    [cell.enterButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
                    
                    [cell.className sd_clearAutoLayoutSettings];
                    cell.className.sd_layout
                    .leftSpaceToView(cell.classImage,10)
                    .topSpaceToView(cell.content, 10)
                    .rightSpaceToView(cell.content,10)
                    .autoHeightRatio(0);
                    [cell.className setMaxNumberOfLinesToShow:1];
                    [cell.className updateLayout];
                    
                }
                [cell.enterButton removeAllTargets];
                [cell.enterButton addTarget:self action:@selector(enterListen:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.enterButton.tag = indexPath.row+100;
            }
            
            return  cell;
        }
            break;
            
        case 3:{
            
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            EndedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[EndedTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
                
            }
            if (_endedArr.count>indexPath.row) {
                cell.model = _endedArr[indexPath.row];
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                [cell.className setMaxNumberOfLinesToShow:1];
            }
            
            return  cell;
            
        }
            break;
    }
    
    return cell;
}


#pragma mark- tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120*ScrenScale;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (tableView.tag) {
        case 1:{
            UnStartClassTableViewCell *cell = [_unStartClassView.classTableView cellForRowAtIndexPath:indexPath];
            
            TutoriumInfoViewController *info = [[TutoriumInfoViewController alloc]initWithClassID:cell.model.classID];
            [self.navigationController pushViewController:info animated:YES];
        }
            
            break;
        case 2:{
            StartedTableViewCell *cell = [_startedClassView.classTableView cellForRowAtIndexPath:indexPath];
            TutoriumInfoViewController *info = [[TutoriumInfoViewController alloc]initWithClassID:cell.model.classID];
            [self.navigationController pushViewController:info animated:YES];
            
        }
            break;
        case 3:{
            EndedTableViewCell *cell = [_endedClassView.classTableView cellForRowAtIndexPath:indexPath];
            TutoriumInfoViewController *info = [[TutoriumInfoViewController alloc]initWithClassID:cell.model.classID];
            [self.navigationController pushViewController:info animated:YES];
        }
            
            break;
            //        case 4:{
            //            ListenTableViewCell *cell = [_listenClassView.classTableView cellForRowAtIndexPath:indexPath];
            //            TutoriumInfoViewController *info = [[TutoriumInfoViewController alloc]initWithClassID:cell.model.classID];
            //            [self.navigationController pushViewController:info animated:YES];
            //        }
            //            break;
    }
}

/**进入聊天*/
- (void)enterChat:(UIButton *)sender{
    
    MyTutoriumModel *mod = _unStartArr[sender.tag];
    TutoriumListInfo *info = [TutoriumListInfo yy_modelWithJSON:[self returnToDictionaryWithModel:mod]];
    
    ChatViewController *controller = [[ChatViewController alloc]initWithClass:info andClassType:LiveCourseType];
    [self.navigationController pushViewController:controller animated:YES];
    
}

/**进入试听*/
- (void)enterListen:(UIButton *)sender{
    
    NSString *classID = nil;
    /* 如果是在已开课列表*/
    if (sender.tag>=100&&sender.tag<1000) {
        MyTutoriumModel *mod =_startedArr[sender.tag-100];
        classID = [NSString stringWithFormat:@"%@",mod.classID];
    }else if (sender.tag>=1000){
        MyTutoriumModel *mod = _listenArr[sender.tag - 1000];
        classID = [NSString stringWithFormat:@"%@",mod.classID];
    }
    LivePlayerViewController *listen = [[LivePlayerViewController alloc]initWithClassID:classID];
    [self.navigationController pushViewController:listen animated:YES];
}



/**
 反解析model

 @param model 我的直播课类型的model
 @return 解析字典
 */
-(NSMutableDictionary *)returnToDictionaryWithModel:(MyTutoriumModel *)model
{
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([MyTutoriumModel class], &count);
    for (int i = 0; i < count; i++) {
        const char *name = property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id propertyValue = [model valueForKey:propertyName];
        if (propertyValue) {
            [userDic setObject:propertyValue forKey:propertyName];
        }
    }
    free(properties);
    return userDic;
}


- (void)returnLastPage{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


// segment的滑动代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == _myClassView.scrollView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        
        [_myClassView.segmentControl setSelectedSegmentIndex:page animated:YES];
        
    }
}

- (UIView *)makePlaceHolderView{
    
    HaveNoClassView *view = [[HaveNoClassView alloc]initWithTitle:@"当前无课程"];
    return view;
}


- (BOOL)enableScrollWhenPlaceHolderViewShowing{
    
    return NO;
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
