//
//  ExclusiveClassFilterViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/7/24.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ExclusiveClassFilterViewController.h"
#import "MJRefresh.h"
#import "TutoriumList.h"
#import "CYLTableViewPlaceHolder.h"
#import "ExclusiveInfoViewController.h"
#import "ExclusiveList.h"

@interface ExclusiveClassFilterViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ExclusiveClassFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.classTableView.delegate = self;
    self.classTableView.dataSource = self;
    
}

- (void)requestClass:(RefreshMode)mode withContentDictionary:( nullable __kindof NSDictionary * )contentDic{
    
    //1.页数赋值
    if (mode==PullToRefresh) {
        self.page= 1;
        
        [self.filterDic setObject:[NSString stringWithFormat:@"%ld",self.page] forKey:@"page"];
        self.classesArray = @[].mutableCopy;
        
        if (self.classTableView.mj_footer.state == MJRefreshStateNoMoreData) {
            self.classTableView.mj_footer.state = MJRefreshStateIdle;
            
        }else{
            
        }
    }else{
        
        self.page++;
        [self.filterDic setObject:[NSString stringWithFormat:@"%ld",self.page] forKey:@"page"];
    }
    
    //2.字典值拼接
    if (mode == PullToRefresh) {
        
        if (contentDic==nil) {
            //首页传值过来的筛选方法
            if ([self.subject isEqualToString:@"全部"]) {
                
                self.filterDic = [NSMutableDictionary dictionaryWithDictionary: @{@"q[grade_eq]":self.grade,
                                                                              @"page":[NSString stringWithFormat:@"%ld",self.page],
                                                                              @"per_page":[NSString stringWithFormat:@"%ld",self.perPage],
                                                                              @"sort_by":@"published_at"}];
            }else{
                //其他科目
                self.filterDic = [NSMutableDictionary dictionaryWithDictionary:@{@"q[subject_eq]":self.subject,
                                                                             @"q[grade_eq]":self.grade,
                                                                             @"page":[NSString stringWithFormat:@"%ld",self.page],
                                                                             @"per_page":[NSString stringWithFormat:@"%ld",self.perPage]}];
            }
        }else{
            //筛选方法
            
            if ([[contentDic allKeys]count]==0) {
                //默认或者说是没有筛选条件的筛选
                
                if (self.filterDic[@"range"]) {
                    [self.filterDic removeObjectForKey:@"range"];
                }else{
                    
                }
                
                
                if (self.filterDic[@"q[status_eq]"]) {
                    [self.filterDic removeObjectForKey:@"q[status_eq]"];
                }else{
                    
                }
                
                if (self.filterDic[@"q[sell_type_eq]"]) {
                    [self.filterDic removeObjectForKey:@"q[sell_type_eq]"];
                }else{
                    
                }

                
            }else{
                //有各种筛选条件的筛选
                
                if (!contentDic[@"range"]) {
                    if (self.filterDic[@"range"]) {
                        [self.filterDic removeObjectForKey:@"range"];
                    }else{
                        
                    }
                }
                
                if (!contentDic[@"q[status_eq]"]) {
                    if (self.filterDic[@"q[status_eq]"]) {
                        [self.filterDic removeObjectForKey:@"q[status_eq]"];
                    }else{
                        
                    }
                }
                
                if (!contentDic[@"q[sell_type_eq]"]) {
                    if (self.filterDic[@"q[sell_type_eq]"]) {
                        [self.filterDic removeObjectForKey:@"q[sell_type_eq]"];
                    }else{
                        
                    }
                }

                
                [self.filterDic addEntriesFromDictionary:contentDic];
            }
        }
    }else{
        //上滑加载更多
        [self.filterDic addEntriesFromDictionary:contentDic];
        
    }
    
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/%@/search",Request_Header,self.course] withHeaderInfo:nil andHeaderfield:nil parameters:self
        .filterDic completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            if ([dic[@"data"] count] !=0) {
                
                /**直播课类型*/
                
                for (NSDictionary *dics in dic[@"data"]) {
                    
                    ExclusiveList *mod = [ExclusiveList yy_modelWithJSON:dics];
                    mod.classID = dics[@"id"];
                    
                    [self.classesArray addObject:mod];
                }
                
                
                if (mode == PullToRefresh) {
                    
                    [self.classTableView.mj_header endRefreshing];
                    //刷新数据
                    [self.classTableView cyl_reloadData];
                }else{
                    [self.classTableView.mj_footer endRefreshing];
                    //刷新数据
                    [self.classTableView cyl_reloadData];
                }
                
            }else{
                //没有数据的情况
                if (mode == PullToRefresh) {
                    //下拉刷新的时候
                    [self.classTableView.mj_header endRefreshing];
                    //刷新数据
                    [self.classTableView cyl_reloadData];
                    
                    
                }else{
                    //上滑的时候
                    
                    [self.classTableView.mj_footer endRefreshingWithNoMoreData];
                }
                
            }
        }else{
            //获取数据失败
            //            [self HUDStopWithTitle:@"加载失败,请重试"];
            if (mode == PullToRefresh) {
                [self.classTableView.mj_header endRefreshing];
                [self.classTableView cyl_reloadData];
                
            }else{
                [self.classTableView.mj_footer endRefreshing];
                self.page--;
                [self.filterDic setObject:[NSString stringWithFormat:@"%ld",self.page] forKey:@"page"];
            }
        }
        
    }failure:^(id  _Nullable erros) {
        //获取数据失败
        [self HUDStopWithTitle:@"请检查网络"];
        if (mode == PullToRefresh) {
            [self.classTableView.mj_header endRefreshing];
            [self.classTableView cyl_reloadData];
            
        }else{
            [self.classTableView.mj_footer endRefreshing];
            self.page--;
            [self.filterDic setObject:[NSString stringWithFormat:@"%ld",self.page] forKey:@"page"];
        }
        
    }];
}
#pragma mark- UITableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.classesArray.count;
    
    
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    ChooseClassTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[ChooseClassTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    if (self.classesArray.count>indexPath.row) {
        cell.exclusiveModel = self.classesArray[indexPath.row];
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
    ExclusiveInfoViewController *controller = [[ExclusiveInfoViewController alloc]initWithClassID:cell.exclusiveModel.classID];
    [self.navigationController pushViewController:controller animated:YES];
    
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
