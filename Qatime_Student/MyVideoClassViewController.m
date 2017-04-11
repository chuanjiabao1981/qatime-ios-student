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
    
    _myVideoClassView.boughtClassTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self requestMyVideoClassDataWithClassType:MyVideoClassRequestTypeBought andRefreshType:PushToLoadMore];
    }];
    
    _myVideoClassView.freeClasstableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestMyVideoClassDataWithClassType:MyVideoClassRequestTypeFree andRefreshType:PullToRefresh];
    }];
    
    _myVideoClassView.freeClasstableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
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
    }else{
        page ++;
    }
    
}


#pragma mark- UITableView datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    StartedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[StartedTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    return  cell;
}


#pragma mark- UITableView delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 100;
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
