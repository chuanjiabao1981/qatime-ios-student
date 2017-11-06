//
//  LivePlayerClassInfoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/10/23.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "LivePlayerClassInfoViewController.h"
#import "Classes.h"
#import "ClassesListTableViewCell.h"
#import "NetWorkTool.h"
#import "LiveClassInfo.h"
#import "Teacher.h"
#import "NSString+ChangeYearsToChinese.h"
#import "VideoPlayerViewController.h"

@interface LivePlayerClassInfoViewController ()<UITableViewDataSource,UITableViewDelegate,TTGTextTagCollectionViewDelegate>{
    
    NSString *_classID;
    NSMutableArray *_classArray;
    
    NSString *_teacherID;
    
    LiveClassInfo *_videoClassInfo;
    
    Teacher *_teacher;
    
    NSDictionary *_classInfoDic;
    
    
}

@end

@implementation LivePlayerClassInfoViewController

-(instancetype)initWithClassID:(NSString *)classID{
    
    self = [super init];
    if (self) {
        _classID = classID;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self makeData];
    
    _headerView = [[InfoHeaderView alloc]init];
    _headerView.classTagsView.delegate = self;
    
    _classList=[[UITableView alloc]init];
    [self.view addSubview:_classList];
    _classList.backgroundColor = [UIColor whiteColor];
    _classList.delegate = self;
    _classList.dataSource = self;
    
    _classList.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    _classList.tableHeaderView = _headerView;
    
    _classList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //获取和加工数据
        [self getClassInfoData];
    }];
    [_classList.mj_header beginRefreshing];
}

- (void)makeData{
    
    _classArray = @[].mutableCopy;
}

/** 获取和加工数据 */
- (void)getClassInfoData{
    
    _classArray = @[].mutableCopy;
    _videoClassInfo = nil;
    _teacher = nil;
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/courses/%@/play_info",Request_Header,_classID] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil withDownloadProgress:^(NSProgress * _Nullable progress) {} completeSuccess:^(id  _Nullable responds) {
        
        //加工好多种数据吧.
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            [self loginStates:dic];
            _classInfoDic = [dic[@"data"] mutableCopy];
            _teacherID = [NSString stringWithFormat:@"%@",dic[@"data"][@"teacher"][@"id"]];
            //使用yymodel解出老师
            Teacher *teacher = [Teacher yy_modelWithJSON:dic[@"data"][@"teacher"]];
            teacher.teacherID =dic[@"data"][@"teacher"][@"id"];
            teacher.accid = dic[@"data"][@"teacher"][@"chat_account"][@"accid"];
            teacher.icon =dic[@"data"][@"teacher"][@"chat_account"][@"icon"];
            
            /* 解析 课程 数据*/
            _videoClassInfo = [LiveClassInfo yy_modelWithDictionary:dic[@"data"]];
            _videoClassInfo.classID= dic[@"data"][@"id"];
            _videoClassInfo.classDescription = [NSString  stringWithFormat:@"%@",[dic[@"data"] valueForKey:@"description"]];
            
            /* 添加课程简介的富文本方法*/
            _videoClassInfo.attributedDescription =[[NSAttributedString alloc] initWithData:[[dic[@"data"] valueForKey:@"description"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            _headerView.model = _videoClassInfo;
            
            for (NSDictionary *lessons in dic[@"data"][@"lessons"]) {
                Classes *mod = [Classes yy_modelWithJSON:lessons];
                mod.classID = lessons[@"id"];
                [_classArray addObject:mod];
            }
            
            [_classList cyl_reloadData];
            
            //单独获取教师信息
            [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/teachers/%@/profile",Request_Header,_teacherID] withHeaderInfo:nil andHeaderfield:nil parameters:nil withProgress:^(NSProgress * _Nullable progress) {} completeSuccess:^(id  _Nullable responds) {
                
                NSDictionary *teacherDic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
                if ([teacherDic[@"status"]isEqualToNumber:@1]) {
                    
                    /* 解析 教师 数据*/
                    _teacher = [Teacher yy_modelWithDictionary:teacherDic[@"data"]];
                    _teacher.teacherID = _teacherID;
                    /* 教师简介,增加富文本*/
                    _teacher.attributedDescription = [[NSAttributedString alloc]initWithData:[_teacher.desc dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                    
                    _headerView.teacher = _teacher;
                    [_headerView updateLayout];
                    [_classList .mj_header endRefreshing];
                }else{
                    /* 获取数据失败*/
                    [self HUDStopWithTitle:@"获取教师信息失败"];
                }
                
            } failure:^(id  _Nullable erros) {
                
            }];
            
        }else{
            //网络错误嘛
            [_classList.mj_header endRefreshing];
            /* 请求错误*/
            if (dic[@"error"]) {
                if ([dic[@"error"][@"code"] isEqual:[NSNumber numberWithInteger:1001]]) {
                    /* 登录错误*/
                    [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"登录错误!\n是否重新登录?" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                        if (buttonIndex!=0) {
                            [self loginAgain];
                        }
                    }];
                }
            }
        }
    } failure:^(id  _Nullable erros) {
        [_classList.mj_header endRefreshing];
        [self HUDStopWithTitle:@"请检查网络"];
    }];
}

#pragma mark- tableview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  _classArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    ClassesListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[ClassesListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    if (_classArray.count>indexPath.row) {
        cell.classModel = _classArray[indexPath.row];
        /* 用总的信息来判断,是否显示可以试听的按钮*/
        if (_classInfoDic) {
            if (_classInfoDic[@"is_bought"]) {
                if ([_classInfoDic[@"is_bought"]boolValue]==YES) {
                    if (cell.model.replayable == YES) {
                        cell.replay.hidden = NO;
                    }else{
                        cell.replay.hidden = YES;
                    }
                }else{
                    cell.replay.hidden = YES;
                }
            }else{
                cell.replay.hidden = YES;
            }
        }
    }
    return  cell;
}


#pragma mark- tablview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:self.view.width_sd tableView:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ClassesListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([_classInfoDic[@"is_bought"]boolValue]==YES) {
        /* 已购买*/
        [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/lessons/%@/replay",Request_Header,cell.classModel.classID] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
            
            if ([dic[@"status"]isEqualToNumber:@1]) {
                
                if ([dic[@"data"][@"replayable"]boolValue]== YES) {
                    
                    if ([dic[@"data"][@"left_replay_times"]integerValue]>0) {
                        
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
                        [self HUDStopWithTitle:@"回放次数已耗尽"];
                    }
                    
                }else{
                    [self HUDStopWithTitle:@"暂无回放视频"];
                }
            }else{
                [self HUDStopWithTitle:@"服务器正忙,请稍后再试"];
            }
            
        }failure:^(id  _Nullable erros) {
        }];
        
    }else{
        //            [self HUDStopWithTitle:@"您尚未购买该课程!"];
    }
}

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView updateContentSize:(CGSize)contentSize{
    
    if (textTagCollectionView == _headerView.classTagsView) {
        [textTagCollectionView clearAutoHeigtSettings];
        textTagCollectionView.sd_layout
        .heightIs(contentSize.height);
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    if (fromInterfaceOrientation == UIInterfaceOrientationPortrait) {
        
    }else{
        
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
