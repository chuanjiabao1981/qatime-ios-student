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
#import "NotClassView.h"

/* 点击事件 -> 辅导班详情页*/
#import "TutoriumInfoViewController.h"
#import "LivePlayerViewController.h"
#import "UIAlertController+Blocks.h"

#define SCREENWIDTH self.view.frame.size.width
#define SCREENHEIGHT self.view.frame.size.height

@interface ClassTimeViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIGestureRecognizerDelegate>{
    
    NSString  *_token;
    NSString *_idNumber;
    
    /* 保存未上课数据的数组*/
    __block  NSMutableArray *_unclosedArr;
    
    
    /* 保存已上课数据的数组*/
    __block  NSMutableArray *_closedArr;
    
    /* 该月份是否有课*/
    
    BOOL haveClass;
    
    /* 是否登录*/
    BOOL isLogin;
    
    HaveNoClassView *_notLoginView;
    
}

@property(nonatomic,strong) NavigationBar *navigationBar ;

@end

@implementation ClassTimeViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
}

- (void)loadView{
    [super loadView];
    
    [self loadClassView];
    
    /* 课程表的视图*/
    
    _notLoginView = ({
        
        HaveNoClassView *_=[[HaveNoClassView alloc]init];
        _.titleLabel.text = @"登录才能查看!";
        [self.view addSubview:_];
        
        _.sd_layout
        .leftEqualToView(_classTimeView)
        .topEqualToView(_classTimeView)
        .rightEqualToView(_classTimeView)
        .bottomEqualToView(_classTimeView);
        
        UIButton *__ = [[UIButton alloc]init];
        [_ addSubview:__];
        [__ setTitle:@"登录" forState:UIControlStateNormal];
        [__ setTitleColor:TITLERED forState:UIControlStateNormal];
        __.layer.borderColor = TITLERED.CGColor;
        __.layer.borderWidth = 0.8;
        [__ addTarget:self action:@selector(loginAgain) forControlEvents:UIControlEventTouchUpInside];
        __.sd_layout
        .topSpaceToView(_.titleLabel,20)
        .centerXEqualToView(_)
        .heightRatioToView(self.view,0.045)
        .widthRatioToView(self.view,0.2);
        __.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        
        _;
        
    });
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    [self.view addSubview:_navigationBar];
    [_navigationBar.titleLabel setText:@"课程表"];
    
    [_navigationBar.rightButton setImage:[UIImage imageNamed:@"日历"] forState:UIControlStateNormal];
    [_navigationBar.rightButton addTarget:self action:@selector(calenderViews) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark- HUD加载数据
    //
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    /* 判断是否登录*/
    
    isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:@"Login"];
    if (isLogin==YES&&_token&&_idNumber) {
        _notLoginView.hidden = YES;
        [self loadingHUDStartLoadingWithTitle:@"正在加载数据"];
        
        
    }else{
        _notLoginView.hidden = NO;
        
//        _navigationBar.rightButton.hidden = YES;
        
    }
    

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
        
        
    }];
    
    _classTimeView.alreadyClassView.alreadyClassTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadingHUDStartLoadingWithTitle:@"正在刷新"];
        [self requestClosedClassList];
        
    }];
    
    
    /* 添加登录成功后的 监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshPage) name:@"UserLoginAgain" object:nil];
    
    
}

/* 登录成功后加载数据*/
- (void)refreshPage{
    
    _notLoginView.hidden = YES;
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    _unclosedArr = @[].mutableCopy;
    _closedArr = @[].mutableCopy;
    
#pragma mark- 请求未上课课程表数据
    [self requestUnclosedClassList];
    
#pragma mark- 请求已上课课程表数据
    [self requestClosedClassList];

    
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
        [manager GET:[NSString stringWithFormat:@"%@/api/v1/live_studio/students/%@/schedule?state=unclosed&month=2016-10-01",Request_Header,_idNumber] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            [self loginStates:dic];
            
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
                     _unclosedArr = @[].mutableCopy;
                    NSArray *sortArr = [dic[@"data"] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                        NSDictionary *dic1 = obj1;
                        NSDictionary *dic2 = obj2;
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        
                        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
                        
                        NSDate *date1= [dateFormatter dateFromString:dic1[@"date"]];
                        NSDate *date2= [dateFormatter dateFromString:dic2[@"date"]];
                        if (date1 == [date1 earlierDate: date2]) { //不使用intValue比较无效
                            
                            return NSOrderedDescending;//降序
                            
                        }else if (date1 == [date1 laterDate: date2]) {
                            return NSOrderedAscending;//升序
                            
                        }else{  
                            return NSOrderedSame;//相等  
                        }
                        
                        
                    }];
                    
                    NSLog(@"%@", sortArr);
                    
                    for (NSDictionary *classDic in sortArr) {
                        for (NSDictionary *lessons in classDic[@"lessons"]) {
                            ClassTimeModel *mod = [ClassTimeModel yy_modelWithJSON:lessons];
                            mod.classID = lessons[@"id"];
                            
                            [_unclosedArr addObject:mod];
                        }
                        
                    }
                    
                }
                
               
#pragma mark- 请求已上课课程表数据
                
                [_classTimeView.notClassView.notClassTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            }else{
                
                /* 数据错误*/
                
            }
            
            
            [self endRefresh];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }else{
        
        /* 登录错误*/
        
        _notLoginView.hidden = NO;
        
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
            
            [self loginStates:dic];
            /* 回复数据正确的情况下*/
            if ([dic[@"status"] isEqual:[NSNumber numberWithInt:1]]) {
                
                NSLog(@"%@",dic[@"data"]);
                
                if ([dic[@"data"] count] == 0) {
                    
                    haveClass = NO;
                    [self noClassThisMonth];
                    
                    _classTimeView.alreadyClassView.haveNoClassView.hidden = NO;
                    
                }else{
                    
                    haveClass = YES;
                     _closedArr = @[].mutableCopy;
                    
                    NSArray *sortArr = [dic[@"data"] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                        NSDictionary *dic1 = obj1;
                        NSDictionary *dic2 = obj2;
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        
                        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
                        
                        NSDate *date1= [dateFormatter dateFromString:dic1[@"date"]];
                        NSDate *date2= [dateFormatter dateFromString:dic2[@"date"]];
                        if (date1 == [date1 earlierDate: date2]) { //不使用intValue比较无效
                            
                            return NSOrderedAscending;//升序
                            
                        }else if (date1 == [date1 laterDate: date2]) {
                            return NSOrderedDescending;//降序
                            
                        }else{
                            return NSOrderedSame;//相等
                        }
                        
                        
                    }];
                    
                    NSLog(@"%@", sortArr);

                    
                    for (NSDictionary *classDic in sortArr) {
                        
                        for (NSDictionary *lessons in classDic[@"lessons"]) {
                            
                            
                            ClassTimeModel *mod = [ClassTimeModel yy_modelWithJSON:lessons];
                            mod.classID = lessons[@"id"];
                            
                            
                            [_closedArr addObject:mod];
                        }
                        
                    }
                    
                }
                
                
//                [self loadClassView];
                
                [_classTimeView.alreadyClassView.alreadyClassTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            }else{
                
                /* 回复数据不正确*/
                
                
            }
                        
            
            [self endRefresh];
            
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }else{
        
        /* 登录报错*/
        
        [self.view addSubview:_notLoginView];
        _notLoginView.frame = _classTimeView.frame;
        _notLoginView.hidden = NO;
        
    }
    
    
}

/* 加载视图*/
- (void)loadClassView{
    
    _classTimeView = ({
        ClassTimeView *_ = [[ClassTimeView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64-49)];
        [self.view addSubview:_];
        _.scrollView.delegate = self;
        _.segmentControl.selectedSegmentIndex =0;
        _.segmentControl.selectionIndicatorHeight =2.0f;
        _.scrollView.bounces=NO;
        _.scrollView.alwaysBounceVertical=NO;
        _.scrollView.alwaysBounceHorizontal=NO;
        
        [_.scrollView scrollRectToVisible:CGRectMake(-self.view.width_sd, 0, self.view.width_sd, self.view.height_sd) animated:YES];
        
        typeof(self) __weak weakSelf = self;
        [_.segmentControl setIndexChangeBlock:^(NSInteger index) {
            [weakSelf.classTimeView.scrollView scrollRectToVisible:CGRectMake(self.view.width_sd * index, 0, CGRectGetWidth(weakSelf.view.bounds), CGRectGetHeight(weakSelf.view.frame)-64-49) animated:YES];
        }];
        _.notClassView.notClassTableView.delegate = self;
        _.notClassView.notClassTableView.dataSource = self;
        _.notClassView.notClassTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _.notClassView.notClassTableView.tag =1;
        
        _.alreadyClassView.alreadyClassTableView.delegate = self;
        _.alreadyClassView.alreadyClassTableView.dataSource = self;
        _.alreadyClassView.alreadyClassTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _.alreadyClassView.alreadyClassTableView.tag = 2;
        
        _;
    });

    
}




#pragma mark- 当月无课程的情况
- (void)noClassThisMonth{
    
    ClassTimeModel *mod = [ClassTimeModel new];
    
    _unclosedArr = [NSMutableArray arrayWithArray:@[mod]];
    _closedArr = [NSMutableArray arrayWithArray:@[mod]];
    
}


#pragma mark- 加载数据后，更新table的数据和视图



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
            if (!cell) {
                
                cell=[[ClassTimeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            }
            if (_unclosedArr.count>indexPath.row) {
                
                cell.model =_unclosedArr[indexPath.row];
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                /* 不能进入观看*/
                
//                if (cell.model.status isEqualToString:@"") {
//                    
//                }
                
                if (cell.canUse == NO){
                    cell.enterButton.hidden = YES;
                }else{
                    cell.enterButton.hidden = NO;
                }

                cell.enterButton.tag = indexPath.row+10;
                [cell.enterButton addTarget:self action:@selector(enterLive:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            return  cell;
        }
        
        if (tableView.tag ==2) {
            
            static NSString *cellID = @"CellID";
            ClassTimeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell=[[ClassTimeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellID"];
            }
            if (_closedArr.count>indexPath.row) {
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                cell.model =_closedArr[indexPath.row];
                cell.enterButton.hidden = YES;
                
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
            
            height = self.view.height_sd*0.15;
            
        }
    }
    if (tableView.tag ==2) {
        
        if (_closedArr.count !=0) {
            
            height = self.view.height_sd*0.15;
            
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
                
                classID  = [NSString stringWithFormat:@"%@",[_unclosedArr[indexPath.row] valueForKeyPath:@"classID"]];
                
            }
            
        }
        if (tableView.tag ==2) {
            
            if (_unclosedArr.count!=0) {
                
                classID  = [NSString stringWithFormat:@"%@",[_closedArr[indexPath.row] valueForKeyPath:@"classID"]];
                
            }
            
        }
        
        NSLog(@"%@",classID);
        
        TutoriumInfoViewController *infoVC= [[TutoriumInfoViewController alloc]initWithClassID:classID];
        
        [self.navigationController pushViewController:infoVC animated:YES];
        
    }
    
}



/* 进入直播*/
- (void)enterLive:(UIButton *)sender{
    
    NSIndexPath *indePath=[NSIndexPath indexPathForRow:sender.tag-20 inSection:0];
    
    ClassTimeTableViewCell *cell = [_classTimeView.notClassView.notClassTableView cellForRowAtIndexPath:indePath];
    
    LivePlayerViewController *controller = [[LivePlayerViewController alloc]initWithClassID:cell.model.course_id];
    [self.navigationController pushViewController:controller animated:YES];
    
}





// segment的滑动代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == _classTimeView.scrollView) {
        
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        
        [_classTimeView.segmentControl setSelectedSegmentIndex:page animated:YES];
    }
    
}




- (void)calenderViews{
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"Login"]) {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"Login"]==YES) {
            
            AllClassViewController *allClassVC = [[AllClassViewController alloc]init];
            [self.navigationController pushViewController:allClassVC animated:YES];
        }else{
//            [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"登录后才能查看!" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
//               
//                if (buttonIndex!=0) {
                    [self loginAgain];
//                }
//            }];
            
        }
    }else{
//        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"登录后才能查看!" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
//            
//            if (buttonIndex!=0) {
                [self loginAgain];
//            }
//        }];

    }
    
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
