//
//  MyAuditionViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "MyAuditionViewController.h"
#import "MyAuditionView.h"
#import "MJRefresh.h"
#import "UITableView+CYLTableViewPlaceHolder.h"
#import "MyAudioClassTableViewCell.h"
#import "MyAudioClass.h"

#import "NavigationBar.h"
#import "Teacher.h"
#import "YYModel.h"
#import "HaveNoClassView.h"
#import "UIViewController+AFHTTP.h"
#import "UIViewController+HUD.h"

#import "TutoriumInfoViewController.h"
#import "VideoClassInfoViewController.h"


typedef enum : NSUInteger {
    PullToRefresh,  //下拉刷新
    PushToLoadMore, //上滑加载
} RefreshType;

//课程类型
typedef enum : NSUInteger {
    LiveClassType,  //直播课
    VideoClassType,    //视频课
    
} AudioClassType;

@interface MyAuditionViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    NavigationBar *_navigationBar;
    
    NSString *_token;
    NSString *_idNumber;
    
    /**直播课程的数据*/
    NSMutableArray *_liveClassArray;
    
    /**视频课程的数据*/
    NSMutableArray *_videoClassArray;
    
    
    /**页码*/
    NSInteger page;
    /**每页条数*/
    NSInteger per_page;
    
    /**segment item2的刷新次数*/
    __block NSInteger refreshNum;
    

    
    //教师
    Teacher *_teacher;
    
    /**课程详情*/
    
}

@property (nonatomic, strong) MyAuditionView *myAudioView ;

@end

@implementation MyAuditionViewController
/**加载导航栏*/
- (void)setupNavigation{
    
    _navigationBar = ({
        NavigationBar *_ =[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
        [self.view addSubview:_];
        
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        _.titleLabel.text = @"我的试听";
        _;
    });
    
}

/**加载主视图*/
- (void)setupMainView{
    
    self.view.backgroundColor  = [UIColor whiteColor];
    _myAudioView = [[MyAuditionView alloc]initWithFrame:CGRectMake(0, Navigation_Height, self.view.width_sd, self.view.height_sd-Navigation_Height)];
    [self.view addSubview:_myAudioView];
    
    _myAudioView.liveClassList.delegate = self;
    _myAudioView.liveClassList.dataSource = self;
    _myAudioView.liveClassList.tag = 1;
    
    _myAudioView.videoClassList.delegate = self;
    _myAudioView.videoClassList.dataSource = self;
    _myAudioView.videoClassList.tag = 2;
    
    _myAudioView.scrollView.delegate = self;
    _myAudioView.scrollView.tag = 3;
    
    
    
    //header和footer
    _myAudioView.liveClassList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self requestMyVideoClassDataWithClassType:LiveClassType andRefreshType:PullToRefresh];
        
    }];
    
    _myAudioView.liveClassList.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestMyVideoClassDataWithClassType:LiveClassType andRefreshType:PushToLoadMore];
    }];
    
    _myAudioView.videoClassList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestMyVideoClassDataWithClassType:VideoClassType andRefreshType:PullToRefresh];
    }];
    
    _myAudioView.videoClassList.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestMyVideoClassDataWithClassType:VideoClassType andRefreshType:PushToLoadMore];
    }];
    
    //先下拉刷新一次
    [_myAudioView.liveClassList.mj_header beginRefreshing];
    
    //滑动
    typeof(self) __weak weakSelf = self;
    _myAudioView.segmentControl.indexChangeBlock = ^(NSInteger index) {
        [weakSelf.myAudioView.scrollView scrollRectToVisible:CGRectMake(weakSelf.view.width_sd*index, 0, weakSelf.view.width_sd, weakSelf.myAudioView.scrollView.height_sd) animated:YES];
        
        if (refreshNum == 0) {
            [weakSelf.myAudioView.videoClassList.mj_header beginRefreshing];
            refreshNum++;
        }
        
    };
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    page = 1;
    per_page = 10;
    refreshNum = 0;
    
    _liveClassArray = @[].mutableCopy;
    _videoClassArray = @[].mutableCopy;
    
    [self getToken];
    
    //加载导航栏
    [self setupNavigation];
    
    //主视图
    [self setupMainView];
    
}

- (void)getToken{
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
}

/**
 加载我的视频课数据
 
 @param classType 课程类型
 @param refreshType 刷新方式
 */
- (void)requestMyVideoClassDataWithClassType:(AudioClassType)classType andRefreshType:(RefreshType)refreshType{
    
    NSMutableDictionary *dics;
    
    if (refreshType == PullToRefresh) {
        page = 1;
        
        if (classType == LiveClassType) {
            
            _liveClassArray = @[].mutableCopy;
            
        }else if (classType == VideoClassType){
            
            _videoClassArray = @[].mutableCopy;
        }
        
    }else{
        page ++;
    }
    
    NSString *sellType = nil;
    
    if (classType == LiveClassType) {
        sellType = @"charge";
    }else if (classType == VideoClassType){
        sellType = @"free";
    }
    
    if (classType == LiveClassType) {
        dics = @{@"cate":@"taste",
                 @"page":[NSString stringWithFormat:@"%ld",page],
                 @"per_page":[NSString stringWithFormat:@"%ld",per_page]}.mutableCopy;
        
        //我的试听->直播课
        [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/students/%@/courses",Request_Header,_idNumber] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:dics completeSuccess:^(id  _Nullable responds) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
            if ([dic[@"status"]isEqualToNumber:@1]) {
                
                if ([dic[@"data"]count]!=0) {
                    
                    for (NSDictionary *classes in dic[@"data"]) {
                        MyAudioClass *mod = [MyAudioClass yy_modelWithJSON:classes];
                        mod.classID = classes[@"id"];
                        [_liveClassArray addObject:mod];
                    }
                    [_myAudioView.liveClassList cyl_reloadData];
                    [_myAudioView.liveClassList.mj_header endRefreshing];
                    [_myAudioView.liveClassList.mj_footer resetNoMoreData];
                }else{
                    if (refreshType == PullToRefresh) {
                        [_myAudioView.liveClassList.mj_header endRefreshingWithCompletionBlock:^{
                            [_myAudioView.liveClassList cyl_reloadData];
                        }];
                    }else{
                        [_myAudioView.liveClassList.mj_footer endRefreshingWithNoMoreData];
                    }
                }
            }else{
                [self HUDStopWithTitle:@"请稍后重试"];
                [_myAudioView.liveClassList.mj_header endRefreshing];
                [_myAudioView.liveClassList.mj_footer endRefreshing];
                
            }
            
        }];
        
    }else if (classType == VideoClassType){
        
        dics = @{@"page":[NSString stringWithFormat:@"%ld",page],
                 @"per_page":[NSString stringWithFormat:@"%ld",per_page]}.mutableCopy;
        
        //我的试听 -> 视频课
        [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/students/%@/video_courses/tasting",Request_Header,_idNumber] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:dics completeSuccess:^(id  _Nullable responds) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
            if ([dic[@"status"]isEqualToNumber:@1]) {
                
                if ([dic[@"data"]count]!=0) {
                    
                    for (NSDictionary *classes in dic[@"data"]) {
                        MyAudioClass *mod = [MyAudioClass yy_modelWithJSON:classes];
                        mod.classID = classes[@"id"];
                        [_videoClassArray addObject:mod];
                    }
                    [_myAudioView.videoClassList cyl_reloadData];
                    [_myAudioView.videoClassList.mj_header endRefreshing];
                    [_myAudioView.videoClassList.mj_footer resetNoMoreData];
                }else{
                    if (refreshType == PullToRefresh) {
                        [_myAudioView.videoClassList.mj_header endRefreshingWithCompletionBlock:^{
                            [_myAudioView.videoClassList cyl_reloadData];
                        }];
                    }else{
                        [_myAudioView.videoClassList.mj_footer endRefreshingWithNoMoreData];
                    }
                }
            }else{
                [self HUDStopWithTitle:@"请稍后重试"];
                [_myAudioView.videoClassList.mj_header endRefreshing];
                [_myAudioView.videoClassList.mj_footer endRefreshing];
            }
            
        }];
    }
    
}

#pragma mark- UITableView datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger num ;
    if (tableView.tag == 1) {
        num = _liveClassArray.count;
    }else {
        num = _videoClassArray.count;
    }
    
    return num;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tableCell;
    if (tableView.tag == 1) {
        
        /* cell的重用队列*/
        static NSString *cellIdenfier = @"cell";
        MyAudioClassTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
        if (cell==nil) {
            cell=[[MyAudioClassTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        
        if (_liveClassArray.count >indexPath.row) {
            cell.model = _liveClassArray[indexPath.row];
            cell.status.hidden = NO;
        }
        
        
        tableCell = cell;
    }else{
        /* cell的重用队列*/
        static NSString *cellIdenfier = @"tablecell";
        MyAudioClassTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
        if (cell==nil) {
            cell=[[MyAudioClassTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"tablecell"];
        }
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        if (_videoClassArray.count>indexPath.row) {
            cell.model = _videoClassArray[indexPath.row];
            cell.status.hidden = YES;
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
    
    MyAudioClassTableViewCell *cell = (MyAudioClassTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIViewController *controller ;
    if (tableView.tag == 1) {
        controller = [[TutoriumInfoViewController alloc]initWithClassID:cell.model.classID];
    }else if (tableView.tag == 2){
        controller = [[VideoClassInfoViewController alloc]initWithClassID:cell.model.classID];
    }
    [self.navigationController pushViewController:controller animated:YES];
    
}


#pragma mark- UIScrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 3) {
        
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger pages = scrollView.contentOffset.x / pageWidth;
        
        [_myAudioView.segmentControl setSelectedSegmentIndex:pages animated:YES];
        if (refreshNum == 0) {
            [_myAudioView.videoClassList.mj_header beginRefreshing];
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
