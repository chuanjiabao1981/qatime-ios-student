//
//  ExclusivePlayerInfoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/7/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ExclusivePlayerInfoViewController.h"
#import "UIViewController+AFHTTP.h"
#import "ClassesListTableViewCell.h"
#import "ExclusiveOfflineClassTableViewCell.h"
#import "UIViewController+Token.h"
#import "MJRefresh.h"
#import "CYLTableViewPlaceHolder.h"
#import "HaveNoClassView.h"
#import "YYModel.h"
#import "Teacher.h"
#import "TutoriumList.h"
#import "ExclusiveLessons.h"
#import "TeachersPublicViewController.h"
#import "ExclusiveInfo.h"
#import "VideoPlayerViewController.h"
#import "UIViewController+HUD.h"

@interface ExclusivePlayerInfoViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *_onlineLessonsArray;
    NSMutableArray *_offlineLessonArray;
    
    
    NSString *_teacherID;
    NSString *_classID;
    
    BOOL _isBought;
    
}

@end

@implementation ExclusivePlayerInfoViewController


-(instancetype)initWithClassID:(NSString *)classID{
    self = [super init];
    if (self) {
        _classID = [NSString stringWithFormat:@"%@",classID];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeData];
    
    [self setupMainView];
    
}

- (void)makeData{
    
    _onlineLessonsArray = @[].mutableCopy;
    _offlineLessonArray = @[].mutableCopy;
    
}

- (void)setupMainView{
    
    _headView = [[ExclusivePlayerInfoView alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 200)];
    [self.view addSubview:_headView];
    [_headView updateLayout];
    
    _mainView = [[UITableView alloc]init];
    _mainView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_mainView];
    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    _mainView.delegate = self;
    _mainView.dataSource = self;
    _mainView.showsVerticalScrollIndicator = NO;
    _mainView.showsHorizontalScrollIndicator = NO;
    _mainView.tableHeaderView = _headView;
    _mainView.tableFooterView = [[UIView alloc]init];
    _mainView.tableHeaderView.height = _headView.autoHeight;
    _mainView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _onlineLessonsArray = @[].mutableCopy;
        _offlineLessonArray = @[].mutableCopy;
        
        [self requestData];
    }];
    _mainView.tableHeaderView = _headView;
    _mainView.tableHeaderView.size = CGSizeMake(self.view.width_sd, _headView.autoHeight);
    
    [_mainView updateLayout];
    self.view.bounds = _mainView.bounds;
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(teacher)];
    _headView.teacherHeadImage.userInteractionEnabled = YES;
    [_headView.teacherHeadImage addGestureRecognizer:tap];
    
    
    [self requestData];
}

- (void)requestData{
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/customized_groups/%@/detail",Request_Header,_classID] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            ExclusiveInfo *mod = [ExclusiveInfo yy_modelWithJSON:dic[@"data"][@"customized_group"]];
            mod.descriptions = dic[@"data"][@"customized_group"][@"description"];
            mod.teacher = [Teacher yy_modelWithJSON:dic[@"data"][@"customized_group"][@"teacher"]];
            _teacherID = [NSString stringWithFormat:@"%@",dic[@"data"][@"customized_group"][@"teacher"][@"id"]];
            _headView.model = mod;
            [_headView updateLayout];
            
            if (dic[@"data"][@"ticket"]) {
                _isBought = YES;
            }
            
            //lessons
            for (NSDictionary *lesson in dic[@"data"][@"customized_group"][@"scheduled_lessons"]) {
                ExclusiveLesson *mod = [ExclusiveLesson yy_modelWithJSON:lesson];
                mod.lessonId = lesson[@"id"];
                [_onlineLessonsArray addObject:mod];
            }
            for (NSDictionary *lesson in dic[@"data"][@"customized_group"][@"offline_lessons"]) {
                ExclusiveLesson *mod = [ExclusiveLesson yy_modelWithJSON:lesson];
                mod.lessonId = lesson[@"id"];
                [_offlineLessonArray addObject:mod];
            }
            
            [_mainView cyl_reloadData];
            [_mainView.mj_header endRefreshing];
            
        }else{
            //数据不行啊
            [_mainView cyl_reloadData];
            [_mainView.mj_header endRefreshing];
            
        }
        
    } failure:^(id  _Nullable erros) {
        //网不行啊
        [_mainView cyl_reloadData];
        [_mainView.mj_header endRefreshing];
        
    }];

}

- (void)teacher{
    TeachersPublicViewController *controller = [[TeachersPublicViewController alloc]initWithTeacherID:_teacherID];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark- UItableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows;
    
    if (section == 0) {
        rows = _onlineLessonsArray.count;
    }else{
        rows = _offlineLessonArray.count;
    }
    return rows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tableCell;
    if (indexPath.section == 0) {
        /* cell的重用队列*/
        static NSString *cellIdenfier = @"cells";
        ClassesListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
        if (cell==nil) {
            cell=[[ClassesListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cells"];
        }
        if (_onlineLessonsArray.count>indexPath.row) {
            cell.exclusiveModel = _onlineLessonsArray[indexPath.row];
            if ([cell.exclusiveModel.status isEqualToString:@"closed"]||[cell.exclusiveModel.status isEqualToString:@"billing"]||[cell.exclusiveModel.status isEqualToString:@"finished"]||[cell.exclusiveModel.status isEqualToString:@"completed"]) {
                
                if (_isBought == YES) {
                    if (cell.exclusiveModel.replayable == YES) {
                        cell.status.text = @"观看回放";
                        cell.status.textColor = BUTTONRED;
                    }else{
                        [cell switchStatus:cell.exclusiveModel];
                    }
                    
                }else{
                    [cell switchStatus:cell.exclusiveModel];
                    
                }
                
            }

        }
        
        tableCell = cell;
    }else{
        /* cell的重用队列*/
        static NSString *cellIdenfier = @"cell";
        ExclusiveOfflineClassTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
        if (cell==nil) {
            cell=[[ExclusiveOfflineClassTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        if (_offlineLessonArray.count>indexPath.row) {
            cell.model = _offlineLessonArray[indexPath.row];
        }
        
        tableCell = cell;
    }
    return tableCell;
}

#pragma mark- UITableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_offlineLessonArray.count>0) {
        return 2;
    }else{
        return 1;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 0){
        return @"线上直播";
    }else{
        return @"线下讲课";
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height;
    
    if (indexPath.section == 0) {
        height = [tableView cellHeightForIndexPath:indexPath model:_onlineLessonsArray[indexPath.row] keyPath:@"exclusiveModel" cellClass:[ClassesListTableViewCell class] contentViewWidth:self.view.width_sd];
    }else{
        height = [tableView cellHeightForIndexPath:indexPath model:_offlineLessonArray[indexPath.row] keyPath:@"model" cellClass:[ExclusiveOfflineClassTableViewCell class] contentViewWidth:self.view.width_sd];
    }
    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        ClassesListTableViewCell *cell = (ClassesListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (_isBought ==YES) {
            if (cell.exclusiveModel.replayable == YES) {
                [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/scheduled_lessons/%@/replay",Request_Header,cell.exclusiveModel.lessonId] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
                    
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
                    
                    if ([dic[@"status"]isEqualToNumber:@1]) {
                        
                        if ([dic[@"data"][@"replayable"]boolValue]== YES) {
                            if (dic[@"data"][@"replay"]==nil) {
                                
                            }else{
                                NSMutableArray *decodeParm = [[NSMutableArray alloc] init];
                                [decodeParm addObject:@"software"];
                                [decodeParm addObject:@"videoOnDemand"];
                                
                                VideoPlayerViewController *video  = [[VideoPlayerViewController alloc]initWithURL:[NSURL URLWithString:dic[@"data"][@"replay"][@"orig_url"]] andDecodeParm:decodeParm andTitle:dic[@"data"][@"name"]];
                                [self presentViewController:video animated:YES completion:^{
                                    
                                }];
                            }
                            
                        }else{
                            [self HUDStopWithTitle:@"服务器繁忙"];
                        }
                        
                    }else{
                        [self HUDStopWithTitle:@"暂无回放视频"];
                    }
                    
                }failure:^(id  _Nullable erros) {
                    
                }];
            }else{
                
                
            }
            
            
        }else{
            
        }
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
