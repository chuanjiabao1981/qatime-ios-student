//
//  NoticeListViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/10/30.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "NoticeListViewController.h"
#import "NoticeListTableViewCell.h"
#import "SystemNotice.h"
#import "TutoriumInfoViewController.h"
#import "NetWorkTool.h"

typedef enum : NSUInteger {
    RefreshStatePushLoadMore,
    RefreshStatePullRefresh,
} RefreshState;

@interface NoticeListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    /* 通知信息数组*/
    NSMutableArray *_noticeArray;
    
    /* 是否查看了系统消息*/
    BOOL checkedNotices ;
    
    /* 下拉刷新页数*/
    NSInteger noticePage;
    
    /* 未读消息数组*/
    NSMutableArray *_unreadArr;
}

@end

@implementation NoticeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeData];
    [self setupViews];
}

- (void)makeData{
    
    _noticeArray = @[].mutableCopy;
    _unreadArr = @[].mutableCopy;
    
}

- (void)setupViews{
    self.view.backgroundColor = [UIColor whiteColor];
    _mainView = [[UITableView alloc]init];
    [self.view addSubview:_mainView];
    _mainView.backgroundColor  = [UIColor whiteColor];
    _mainView.tableHeaderView = [[UIView alloc]init];
    _mainView.tableFooterView = [[UIView alloc]init];
    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    _mainView.delegate = self;
    _mainView.dataSource = self;
    typeof(self) __weak weakSelf = self;
    _mainView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestNotices:RefreshStatePullRefresh];
    }];
    
    _mainView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestNotices:RefreshStatePushLoadMore];
    }];
    
    [_mainView.mj_header beginRefreshing];
    
}

/* 请求通知消息*/
- (void)requestNotices:(RefreshState)state{
    
    switch (state) {
        case RefreshStatePullRefresh:{
            noticePage = 1;
            _noticeArray = @[].mutableCopy;
            [_mainView.mj_footer resetNoMoreData];
        }
            break;
        case RefreshStatePushLoadMore:{
            noticePage++;
        }
            break;
    }
    
    _unreadArr = @[].mutableCopy;
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/users/%@/notifications",Request_Header,[self getStudentID]] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:@{@"page":[NSString stringWithFormat:@"%ld",noticePage]} completeSuccess:^(id  _Nullable responds) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            /* 请求成功*/
            NSMutableArray *dataArr = [NSMutableArray arrayWithArray:dic[@"data"]];
            if (dataArr.count == 0) {
                if (state!=RefreshStatePushLoadMore) {
                    [_mainView cyl_reloadData];
                    [_mainView.mj_header endRefreshing];
                }else{
                    [_mainView.mj_footer endRefreshingWithNoMoreData];
                }
                
            }else{

                for (NSDictionary *dics in dataArr) {
                    SystemNotice *notice = [SystemNotice yy_modelWithJSON:dics];
                    //筛掉订单类型的信息
                    if ([notice.notificationable_type isEqualToString:@"payment/order"]||[notice.action_name isEqualToString:@"refund_success"]||[notice.action_name isEqualToString:@"refund_fail"]) {
                    }else{
                        notice.noticeID = dics[@"id"];
                        [_noticeArray addObject:notice];
                    }
                }
              
                for (SystemNotice *notice in _noticeArray) {
                    if (notice.read==NO) {
                        /* 未读消息添加到这个数组*/
                        [_unreadArr addObject:notice.noticeID];
                    }
                }
                if (_unreadArr.count>0) {
                    self.tabBarItem.badgeValue = @"";
                    self.unreadSystemNoticeCountPlus(_unreadArr.count);
                    //全部默认自动标记成已读.请求数据而已
                    NSMutableString *idString = [NSMutableString string];
                    for (NSNumber *ids in _unreadArr) {
                        [idString appendString:[NSString stringWithFormat:@"%@",ids]];
                        [idString appendString:@" "];
                    }
                    
                    [self PUTSessionURL:[NSString stringWithFormat:@"%@/api/v1/users/%@/notifications/batch_read",Request_Header,[self getStudentID]] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:@{@"ids":idString} completeSuccess:^(id  _Nullable responds) {
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
                        if ([dic[@"status"]isEqualToNumber:@1]) {
                            /* 根据不同类型的数据请求方式,加载结果不同,判断hud和数据刷新*/
                            if (state == RefreshStatePullRefresh) {
                                self.unreadSystemNoticeCountMinus(_unreadArr.count);
                            }
                            _unreadArr = @[].mutableCopy;
                        }else{
                            
                        }
                        if (state == RefreshStatePushLoadMore) {
                            [_mainView.mj_footer endRefreshing];
                            [_mainView cyl_reloadData];
                        }else{
                            [self HUDStopWithTitle:nil];
                            [_mainView.mj_header endRefreshing];
                            [_mainView cyl_reloadData];
                      
                        }
                    } failure:^(id  _Nullable erros) {
                        /* 根据不同类型的数据请求方式,加载结果不同,判断hud和数据刷新*/
                        if (state == RefreshStatePushLoadMore) {
                            [_mainView.mj_footer endRefreshing];
                            [_mainView cyl_reloadData];
                        }else{
                            [self HUDStopWithTitle:nil];
                            [_mainView.mj_header endRefreshing];
                            [_mainView cyl_reloadData];
                        }
                    }];
                
                }else{
                    if (state == RefreshStatePushLoadMore) {
                        [_mainView.mj_footer endRefreshing];
                        [_mainView cyl_reloadData];
                    }else{
                        [self HUDStopWithTitle:nil];
                        [_mainView.mj_header endRefreshing];
                        [_mainView cyl_reloadData];
                    }
                }
            }
        }else{
            /* 请求失败*/
            if (state == RefreshStatePushLoadMore) {
                [_mainView.mj_footer endRefreshing];
            }else{
                [_mainView.mj_header endRefreshing];
            }
            [_mainView cyl_reloadData];
//            [self HUDStopWithTitle:@"公告刷新失败,请稍后重试"];
        }
    } failure:^(id  _Nullable erros) {
        if (state == RefreshStatePushLoadMore) {
            [_mainView.mj_header endRefreshing];
        }else{
            [_mainView.mj_header endRefreshing];
        }
        [self HUDStopWithTitle:@"请检查您的网络"];
        [_mainView cyl_reloadData];
    }];
}



#pragma mark- tableview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _noticeArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdenfier = @"cell";
    NoticeListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[NoticeListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (_noticeArray.count>indexPath.row) {
        
        cell.model = _noticeArray[indexPath.row];
        
        if (cell.model.read == YES) {
            cell.content.textColor = [UIColor lightGrayColor];
        }else{
            cell.content.textColor = [UIColor blackColor];
        }
        
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    }
    
    return  cell;
}

#pragma mark- tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SystemNotice *mod = _noticeArray[indexPath.row];
    return  [tableView cellHeightForIndexPath:indexPath model:mod keyPath:@"model" cellClass:[NoticeListTableViewCell class] contentViewWidth:self.view.width_sd];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NoticeListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.model.read == NO) {
        cell.model.read = YES;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    UIViewController *controller ;
    
    if ([cell.model.notificationable_type isEqualToString:@"live_studio/course"]) {
        //教师公告
        
        controller = [[TutoriumInfoViewController alloc]initWithClassID:[cell.model.link substringFromIndex:19]];
        
    }else if ([cell.model.notificationable_type isEqualToString:@"live_studio/lesson"]){
        //辅导班开课通知
        
        controller = [[TutoriumInfoViewController alloc]initWithClassID:[cell.model.link substringFromIndex:19]];
        
    }else if ([cell.model.notificationable_type isEqualToString:@"payment/order"]){
        //订单信息
        
    }
    if (controller) {
        controller.hidesBottomBarWhenPushed = YES;
        self.pushBlock(controller);
    }
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
