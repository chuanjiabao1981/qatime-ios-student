//
//  ClassTimeViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ClassTimeViewController.h"
#import "RDVTabBarController.h"
#import "NavigationBar.h"
#import "HMSegmentedControl.h"
#import "ClassTimeTableViewCell.h"
#import "ClassTimeModel.h"
#import "YYModel.h"
#import "MJRefresh.h"
#import "UIViewController_HUD.h"
#import "UIViewController+HUD.h"

#import "AllClassViewController.h"



/* 点击事件 -> 辅导班详情页*/
#import "TutoriumInfoViewController.h"


#define SCREENWIDTH self.view.frame.size.width
#define SCREENHEIGHT self.view.frame.size.height

@interface ClassTimeViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>{
    
    NSString  *_token;
    NSString *_idNumber;
    
    /* 保存未上课数据的数组*/
  __block  NSMutableArray *_unclosedArr;
    
    
    /* 保存已上课数据的数组*/
  __block  NSMutableArray *_closedArr;
    
    /* 该月份是否有课*/
    
    BOOL haveClass;
    
    
}

@property(nonatomic,strong) NavigationBar *navigationBar ;

@end

@implementation ClassTimeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;

    self.view.backgroundColor = [UIColor whiteColor];
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    [self.view addSubview:_navigationBar];
    [_navigationBar.titleLabel setText:@"课程表"];
    
    [_navigationBar.rightButton setImage:[UIImage imageNamed:@"日历"] forState:UIControlStateNormal];
    [_navigationBar.rightButton addTarget:self action:@selector(calenderViews) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    #pragma mark- HUD加载数据
    [self loadingHUDStartLoadingWithTitle:@"正在加载数据"];
    
    
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    
    /* 课程表的视图*/
    
    _classTimeView = [[ClassTimeView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64-63)];
    [self.view addSubview:_classTimeView];
    
    typeof(self) __weak weakSelf = self;
    [ _classTimeView.segmentControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.classTimeView.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.view.bounds) * index, 0, CGRectGetWidth(weakSelf.view.bounds), CGRectGetHeight(weakSelf.view.frame)-64-49) animated:YES];
    }];
    
    _classTimeView.scrollView.delegate = self;
    _classTimeView.segmentControl.selectedSegmentIndex =0;
    _classTimeView.segmentControl.selectionIndicatorHeight =2.0f;
    _classTimeView.scrollView.bounces=NO;
    _classTimeView.scrollView.alwaysBounceVertical=NO;
    _classTimeView.scrollView.alwaysBounceHorizontal=NO;
    
    [_classTimeView.scrollView scrollRectToVisible:CGRectMake(-CGRectGetWidth(self.view.bounds), 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) animated:YES];
    
    _classTimeView.notClassView.notClassTableView.delegate = self;
    _classTimeView.notClassView.notClassTableView.dataSource = self;
    _classTimeView.notClassView.notClassTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _classTimeView.notClassView.notClassTableView.tag =1;
    
    _classTimeView.alreadyClassView.alreadyClassTableView.delegate = self;
    _classTimeView.alreadyClassView.alreadyClassTableView.dataSource = self;
    _classTimeView.alreadyClassView.alreadyClassTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _classTimeView.alreadyClassView.alreadyClassTableView.tag = 2;
    
    
#pragma mark- 初始化数据
    _unclosedArr = @[].mutableCopy;
    _closedArr = @[].mutableCopy;
    
    
#pragma mark- 请求未上课课程表数据
    [self requestUnclosedClassList];
    
#pragma mark- 请求已上课课程表数据
    [self requestClosedClassList];
    
    
    
    
    #pragma mark- 下拉刷新方法
    _classTimeView.notClassView.notClassTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadingHUDStartLoadingWithTitle:@"正在刷新"];
        
        [self requestUnclosedClassList];
        [self updateTablesData];
        
    }];
    
    _classTimeView.alreadyClassView.alreadyClassTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadingHUDStartLoadingWithTitle:@"正在刷新"];
        [self requestClosedClassList];
        [self updateTablesData];
    }];
    
    
    
}

- (void)endRefresh{
    
    [_classTimeView.notClassView.notClassTableView.mj_header endRefreshing];
    [_classTimeView.alreadyClassView.alreadyClassTableView.mj_header endRefreshing];
    
    if (haveClass ==NO) {
        
        [self loadingHUDStopLoadingWithTitle:@"本月暂时没有课程!"];
        
    }else{
        [self loadingHUDStopLoadingWithTitle:@"加载完成!"];
    }
}



#pragma mark- 请求未上课课程表数据
- (void)requestUnclosedClassList{
    
    if (_token&&_idNumber) {
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
        [manager GET:[NSString stringWithFormat:@"%@/api/v1/live_studio/students/%@/schedule?state=unclosed",Request_Header,_idNumber] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            /* 回复数据正确的情况下*/
            if ([dic[@"status"] isEqual:[NSNumber numberWithInt:1]]) {
                
                NSLog(@"%@",dic[@"data"]);
                
                
                if ([dic[@"data"] count] ==0) {
                    
                    haveClass = NO;
                    /* 弹窗警告*/
                    [self noClassThisMonth];
                    _classTimeView.notClassView.haveNoClassView .hidden= NO;
                    
                }else{
                    
                    haveClass = YES;
                    
                    for (NSDictionary *classDic in dic[@"data"]) {
                        
                        for (NSDictionary *lessons in classDic[@"lessons"]) {
                            
                            
                            ClassTimeModel *mod = [ClassTimeModel yy_modelWithJSON:lessons];
                            mod.classID = lessons[@"id"];
                            
                            
                            [_unclosedArr addObject:mod];
                        }
                        
                    }
                    
                    
                    NSLog(@"%@",_unclosedArr);
                }
                
            }else{
                
                /* 回复数据不正确*/
            }
            
            [self updateTablesData];
            [self endRefresh];
            
        
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }else{
        
        /* 登录报错*/
        
    }
    

    
    
    
}

- (void)requestClosedClassList{
    if (_token&&_idNumber) {
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
        [manager GET:[NSString stringWithFormat:@"%@/api/v1/live_studio/students/%@/schedule?state=closed",Request_Header,_idNumber] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            /* 回复数据正确的情况下*/
            if ([dic[@"status"] isEqual:[NSNumber numberWithInt:1]]) {
                
                NSLog(@"%@",dic[@"data"]);
                
                if ([dic[@"data"] count] == 0) {
                    
                    haveClass = NO;
                    [self noClassThisMonth];
                    
                    _classTimeView.alreadyClassView.haveNoClassView.hidden = NO;
                    
                }else{
                    
                    haveClass = YES;
                    
                    for (NSDictionary *classDic in dic[@"data"]) {
                        
                        for (NSDictionary *lessons in classDic[@"lessons"]) {
                            
                            
                            ClassTimeModel *mod = [ClassTimeModel yy_modelWithJSON:lessons];
                            mod.classID = lessons[@"id"];
                            
                            
                            [_closedArr addObject:mod];
                        }
                        
                    }
                    
                }
                
                
                NSLog(@"%@",_closedArr);
                
            }else{
                
                /* 回复数据不正确*/
                
                
            }
            [self updateTablesData];
            [self endRefresh];
            
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }else{
        
        /* 登录报错*/
        
    }
    
    
}

#pragma mark- 当月无课程的情况
- (void)noClassThisMonth{
    
    ClassTimeModel *mod = [ClassTimeModel new];
    
    _unclosedArr = [NSMutableArray arrayWithArray:@[mod]];
     _closedArr = [NSMutableArray arrayWithArray:@[mod]];
    
    
    
    
}


#pragma mark- 加载数据后，更新table的数据和视图
- (void)updateTablesData{
    
    [_classTimeView.notClassView.notClassTableView reloadData];
    [_classTimeView.notClassView.notClassTableView setNeedsDisplay];
    
    
    [_classTimeView.alreadyClassView.alreadyClassTableView reloadData];
    [_classTimeView.alreadyClassView.alreadyClassTableView setNeedsDisplay];
    
    
}


#pragma mark- tableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows=0;
    
    if (haveClass==NO) {
        
        rows = 1;
    }else{
        
        if (tableView.tag ==1) {
            
            
            if (_unclosedArr.count !=0) {
                
                rows = _unclosedArr.count;
            }
        }
        
        if (tableView.tag == 2) {
            if (_closedArr.count !=0) {
                
                rows = _closedArr.count;
            }
        }
    }
    
    
    
    return rows ;
    
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    

    if (haveClass==NO) {
        
    }else{
        
        /* 未上课列表*/
        if (tableView.tag ==1) {
            
            static NSString *cellIdenfier = @"cell";
            ClassTimeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                
                cell=[[ClassTimeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
                cell.sd_tableView = tableView;
                
                
                if (_unclosedArr.count!=0) {
                    
                    cell.model =_unclosedArr[indexPath.row];
                    
                }
                
            }
            
            return  cell;
        }
        
        if (tableView.tag ==2) {
            
            static NSString *cellID = @"CellID";
            ClassTimeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell==nil) {
                
                cell=[[ClassTimeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellID"];
                
                cell.sd_tableView = tableView;
                
                
                if (_closedArr.count!=0) {
                    
                    cell.model =_closedArr[indexPath.row];
                    
                }
                
            }
            
            return cell;
        }
    }
    
    
    
    
    return [[UITableViewCell alloc]init];
    
    
    
}

#pragma mark- tableView delegate

-  (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    CGFloat height = 0;
    
 
    if (tableView.tag ==1) {
        
        if (_unclosedArr.count !=0) {
            
            
            height = 120;
            
        }
    }
    if (tableView.tag ==2) {
        
        if (_closedArr.count !=0) {
            
            
            height = 120;
            
        }
    }

    
    
    return height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *classID;
    
    if (haveClass == NO) {
        
    }else{
        
        if (tableView.tag ==1) {
            
            if (_unclosedArr.count!=0) {
                
                classID  = [NSString stringWithFormat:@"%@",[_unclosedArr[indexPath.row] valueForKeyPath:@"course_id"]];
                
            }
            
        }
        if (tableView.tag ==2) {
            
            if (_unclosedArr.count!=0) {
                
                classID  = [NSString stringWithFormat:@"%@",[_unclosedArr[indexPath.row] valueForKeyPath:@"course_id"]];
                
            }
            
        }
        
        NSLog(@"%@",classID);
        
        TutoriumInfoViewController *infoVC= [[TutoriumInfoViewController alloc]initWithClassID:classID];
        
        [self.navigationController pushViewController:infoVC animated:YES];
        
    }
    
    
    
    
    
}





// segment的滑动代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == _classTimeView.scrollView) {
        
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        
        [_classTimeView.segmentControl setSelectedSegmentIndex:page animated:YES];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}



- (void)calenderViews{
    
    
    AllClassViewController *allClassVC = [[AllClassViewController alloc]init];
    [self.navigationController pushViewController:allClassVC animated:YES];
    
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
