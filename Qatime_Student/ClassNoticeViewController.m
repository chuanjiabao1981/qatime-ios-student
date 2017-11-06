//
//  ClassNoticeViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/10/23.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ClassNoticeViewController.h"
#import "NetWorkTool.h"

@interface ClassNoticeViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSString *_classID;
    NSMutableArray *_noticeArray;
    
}

@end

@implementation ClassNoticeViewController

-(instancetype)initWithClassID:(NSString *)classID{
    self = [super init];
    if (self) {
        _classID = classID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _noticeArray = @[].mutableCopy;
    
    _noticeList = [[UITableView alloc]init];
    [self.view addSubview:_noticeList];
    _noticeList.tableHeaderView = [[UIView alloc]init];
    _noticeList.tableFooterView = [[UIView alloc]init];
    _noticeList.backgroundColor = [UIColor whiteColor];
    
    _noticeList.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    
    _noticeList.delegate = self;
    _noticeList.dataSource = self;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newNotice) name:@"NewNotice" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newNotice) name:@"NewChatNotice" object:nil];
    
    _noticeList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _noticeArray = @[].mutableCopy;
        [self getNoticeData];
    }];
    [_noticeList.mj_header beginRefreshing];
    
}

/** 加载公告数据 . 列表 */
- (void)getNoticeData{
    _noticeArray = @[].mutableCopy;
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/courses/%@/realtime",Request_Header,_classID] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil withDownloadProgress:^(NSProgress * _Nullable progress) {} completeSuccess:^(id  _Nullable responds) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            //成功了嘛
            for (NSDictionary *notices in dic[@"data"][@"announcements"]) {
                Notice *mod = [Notice yy_modelWithJSON:notices];
                if (mod.lastest) {
                    [_noticeArray addObject:mod];
                }
            }
            [_noticeList.mj_header endRefreshingWithCompletionBlock:^{
                [_noticeList cyl_reloadData];
            }];
            
        }else{
            [_noticeList.mj_header endRefreshing];
            [self HUDStopWithTitle:@"请稍后再试"];
        }
        
    } failure:^(id  _Nullable erros) {
        [_noticeList.mj_header endRefreshing];
        [self HUDStopWithTitle:@"请检查网络"];
    }];
}


#pragma mark- tablview datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _noticeArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    NoticeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[NoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    if (_noticeArray.count>indexPath.row) {
        cell.model = _noticeArray[indexPath.row];
    }
    return  cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:self.view.width_sd tableView:tableView];
}

//收到信公告消息.
- (void)newNotice{
    [self getNoticeData];
}

- (UIView *)makePlaceHolderView{
    
    HaveNoClassView *view = [[HaveNoClassView alloc]initWithTitle:@"暂无公告"];
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
