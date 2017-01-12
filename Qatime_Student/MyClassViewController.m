//
//  MyClassViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "MyClassViewController.h"
#import "RDVTabBarController.h"
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
#import "NELivePlayerViewController.h"





#define SCREENWIDTH self.view.frame.size.width
#define SCREENHEIGHT self.view.frame.size.height


@interface MyClassViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NavigationBar *_navigationBar;
    
    NSString *_token;
    NSString *_idNumber;
    
    
    
    /* 保存课程数据的数组们*/
    
    NSMutableArray *_allClassArr;
    
    
    NSMutableArray *_unStartArr;
    NSMutableArray *_startedArr;
    NSMutableArray *_endedArr;
    NSMutableArray *_listenArr;
    
    
}

@end

@implementation MyClassViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
    _navigationBar  = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    [self.view addSubview:_navigationBar];
    _navigationBar.titleLabel.text = @"我的辅导";
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    /* 加载课程视图*/
    _myClassView = [[MyClassView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
    [self.view addSubview:_myClassView];
    
    _myClassView.scrollView .delegate = self;
    
    
    /* 滑动效果*/
    typeof(self) __weak weakSelf = self;
    [ _myClassView.segmentControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.myClassView.scrollView scrollRectToVisible:CGRectMake(self.view.width_sd * index, 0, CGRectGetWidth(weakSelf.view.bounds), CGRectGetHeight(weakSelf.view.frame)-64-40) animated:YES];
    }];
    [_myClassView.scrollView scrollRectToVisible:CGRectMake(-self.view.width_sd, 0, self.view.width_sd, self.view.height_sd) animated:YES];
    
    
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    
    /* 所有数据初始化*/
    
    _allClassArr = @[].mutableCopy;
    _unStartArr = @[].mutableCopy;
    _startedArr = @[].mutableCopy;
    _endedArr = @[].mutableCopy;
    _listenArr = @[].mutableCopy;
    
    
#pragma mark- 滑动图的几个view的初始化等
    _unStartClassView = ({
        UnStartClassView *_ = [[UnStartClassView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-40)];
        [_myClassView.scrollView addSubview:_];
        _.classTableView.tag =1;
        _.classTableView.delegate = self;
        _.classTableView.dataSource =self;
        _;
        
    });
    _startedClassView = ({
        StartedClassView *_ = [[StartedClassView alloc]initWithFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT-64-40)];
        [_myClassView.scrollView addSubview:_];
        _.classTableView.tag =2;
        _.classTableView.delegate = self;
        _.classTableView.dataSource =self;
        _;
        
    });
    _endedClassView = ({
        EndedClassView *_ = [[EndedClassView alloc]initWithFrame:CGRectMake(SCREENWIDTH*2, 0, SCREENWIDTH, SCREENHEIGHT-64-40)];
        [_myClassView.scrollView addSubview:_];
        _.classTableView.tag =3;
        _.classTableView.delegate = self;
        _.classTableView.dataSource =self;
        _;
        
    });
    _listenClassView = ({
        ListenClassView *_ = [[ListenClassView alloc]initWithFrame:CGRectMake(SCREENWIDTH*3, 0, SCREENWIDTH, SCREENHEIGHT-64-40)];
        [_myClassView.scrollView addSubview:_];
        _.classTableView.tag =4;
        _.classTableView.delegate = self;
        _.classTableView.dataSource =self;
        
     
        
        _;
        
        
        
    });
    
    /* 请求课程数据*/
    
    /* 请求待开课数据*/
    [self requestTutoriumList:@"published"];
    
    /* 请求已开课数据*/
    [self requestTutoriumList:@"teaching"];
    
    /* 请求已结束数据*/
    [self requestTutoriumList:@"completed"];
    
    //    /* 请求视听数据*/
    //     [self requestTutoriumList:@"taste"];
    
    
    //  辅导班状态 published: 待开课; teaching: 已开课; completed: 已结束  试听:taste
    
}

#pragma mark- 请求所有课程数据
- (void)requestTutoriumList:(NSString *)status{
    
    
    NSString *requestURL;
    
    if (_token&&_idNumber) {
        
        requestURL = [NSString stringWithFormat:@"%@/api/v1/live_studio/students/%@/courses?status=%@",Request_Header,_idNumber,status];
        
//        [self loadingHUDStartLoadingWithTitle:@"正在加载"];
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
        [manager GET:requestURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            /* 回复数据正确的情况下*/
            if ([dic[@"status"] isEqual:[NSNumber numberWithInt:1]]) {
                
                NSLog(@"%@",dic[@"data"]);
                
                if ([dic[@"data"]count]!=0) {
                    
                    for (NSDictionary *classDic in dic[@"data"]) {
                        //
                        MyTutoriumModel *mod = [MyTutoriumModel yy_modelWithJSON:classDic];
                        mod.classID = classDic[@"id"];
                        
                        /* 如果摄像头的拉流地址不是空，那么就是“我的试听”项目里的*/
                        if (mod.is_tasting == YES) {
                            
                            [_listenArr addObject:mod];
                            
                        }
                        
                        /* 根据不同的状态，写不同的数组*/
                        if ([status isEqualToString:@"published"]) {
                            
                            /* 未开课的*/
                            if (_unStartArr) {
                                [_unStartArr addObject:mod];
                            }
                            
                            
                        }else if ([status isEqualToString:@"teaching"]) {
                            /* 已开课的*/
                            if (_startedArr) {
                                [_startedArr addObject:mod];
                            }
                            
                            
                        }else if ([status isEqualToString:@"completed"]) {
                            /* 已结束的*/
                            if (_endedArr) {
                                [_endedArr addObject:mod];
                            }
                            
                            
                        }
                        
                    }
                    
                    /* 如果有空数据,那么该项所在页面添加占位图*/
                    if (_unStartArr.count == 0) {
                        
                        HaveNoClassView *noview = [[HaveNoClassView alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, _unStartClassView.height_sd)];
                        noview.titleLabel.text  = @"没有课程";
                        [_unStartClassView addSubview:noview];
                        
                    }
                    if (_startedArr.count ==0) {
                        
                        HaveNoClassView *noview = [[HaveNoClassView alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, _startedClassView.height_sd)];
                        noview.titleLabel.text  = @"没有课程";
                        [_startedClassView addSubview:noview];
                        
                    }
                    if (_endedArr.count ==0) {
                        
                        HaveNoClassView *noview = [[HaveNoClassView alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, _endedClassView.height_sd)];
                        noview.titleLabel.text  = @"没有课程";
                        [_endedClassView addSubview:noview];
                        
                    }
                    
                    [self loadingHUDStopLoadingWithTitle:@"加载完成"];
                    
                }else{
                    
                    
                }
                
                
                
                NSLog(@"%@",_allClassArr);
                /* 筛选课程类型和分组*/
                //                [self filterAndGroup];
                
                
                
            }else{
                
                /* 回复数据不正确*/
            }
            
            //            [self updateTablesData];
            //            [self endRefresh];
            /* 刷新table视图*/
            [self updateTableView];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }else{
        
        /* 登录报错*/
        
    }
    
    //     NSLog(@"%@",_unclosedArr);
    
    
    
}



#pragma mark- 刷新tableview视图
- (void)updateTableView{
    
    [_unStartClassView.classTableView reloadData];
    
    [_startedClassView.classTableView reloadData];
    
    [_endedClassView.classTableView reloadData];
    
    [_listenClassView.classTableView reloadData];
    
    
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
            if (_unStartArr.count!= 0) {
                cell.model = _unStartArr[indexPath.row];
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                
                
                
                
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
            if (_startedArr.count!= 0) {
                cell.model = _startedArr[indexPath.row];
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                
                if (cell.canTaste == YES) {
                    cell.enterButton.hidden = NO;
                    [cell.enterButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                    cell.enterButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
                }else{
                    
                    cell.enterButton.hidden = YES;
                }
                
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
            if (_endedArr.count!= 0) {
                cell.model = _endedArr[indexPath.row];
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            
            
            
            
            }
            
            return  cell;
            
        }
            break;
            
        case 4:{
            
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            ListenTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[ListenTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
                
            }
            if (_listenArr.count!= 0) {
                cell.model = _listenArr[indexPath.row];
                
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                
                 [cell.enterButton addTarget:self action:@selector(enterListen:) forControlEvents:UIControlEventTouchUpInside];
                cell.enterButton.tag = indexPath.row+1000;
            }
            
            return  cell;
        }
            break;
            
            
    }
    
    return cell;
}


#pragma mark- tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return self.view.height_sd*0.15;
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
            EndedTableViewCell *cell = [_startedClassView.classTableView cellForRowAtIndexPath:indexPath];
            TutoriumInfoViewController *info = [[TutoriumInfoViewController alloc]initWithClassID:cell.model.classID];
            [self.navigationController pushViewController:info animated:YES];
        }
            
            break;
        case 4:{
            ListenTableViewCell *cell = [_startedClassView.classTableView cellForRowAtIndexPath:indexPath];
            TutoriumInfoViewController *info = [[TutoriumInfoViewController alloc]initWithClassID:cell.model.classID];
            [self.navigationController pushViewController:info animated:YES];
        }
            
            break;

    }

    
}

/* 进入试听*/
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
    
    
    
    
    NELivePlayerViewController *listen = [[NELivePlayerViewController alloc]initWithClassID:classID];
    [self.navigationController pushViewController:listen animated:YES];
   
    
    
    
}


- (void)returnLastPage{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.rdv_tabBarController setTabBarHidden:NO];
    
}






// segment的滑动代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    
    if (scrollView == _myClassView.scrollView) {
        
        
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [_myClassView.segmentControl setSelectedSegmentIndex:page animated:YES];
    
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
