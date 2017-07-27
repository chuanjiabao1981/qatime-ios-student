//
//  ExclusivenNoticeViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/7/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ExclusivenNoticeViewController.h"
#import "NoticeTableViewCell.h"
#import "InteractionNotice.h"
#import "UIViewController+Token.h"
#import "UIViewController+AFHTTP.h"
#import "YYModel.h"
#import "CYLTableViewPlaceHolder.h"
#import "HaveNoClassView.h"
#import "MJRefresh.h"
#import "AppDelegate.h"

@interface ExclusivenNoticeViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    /**保存公告的数组*/
    __block NSMutableArray *_noticeArr;
    
    NSString *_classID;

}

@end

@implementation ExclusivenNoticeViewController

-(instancetype)initWithClassID:(NSString *)classID{
    
    
    self = [super init];
    if (self) {
        
        _classID = [NSString stringWithFormat:@"%@",classID];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化基础数据
    [self makeData];
    
    //加载视图
    [self setupMainView];
    
    //请求一下课程公告信息
    //    [self requestData];
    
}

/**初始化基础数据*/
- (void)makeData{
    
    _noticeArr = @[].mutableCopy;
}


/**加载视图*/
- (void)setupMainView{
    
    _noticeTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_noticeTableView];
    _noticeTableView.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0);
    
    _noticeTableView.delegate = self;
    _noticeTableView.dataSource = self;
    _noticeTableView.tableFooterView = [UIView new];
    _noticeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _noticeArr = @[].mutableCopy;
        [self requestData];
        
    }];
    
    [_noticeTableView.mj_header beginRefreshing];
    
}



/**请求公告数据*/
- (void)requestData{
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/courses/%@/realtime",Request_Header,_classID] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            //这就是有数据  没毛病
            
            NSArray *notices = [NSArray arrayWithArray:dic[@"data"][@"announcements"]];
            
            if (notices.count!=0) {
                //有公告
                for (NSDictionary *notice in notices) {
                    
                    InteractionNotice *mod = [InteractionNotice yy_modelWithJSON:notice];
                    [_noticeArr addObject:mod];
                    
                }
                
                [_noticeTableView cyl_reloadData];
                [_noticeTableView.mj_header endRefreshing];
                
            }else{
                //没公告
                [_noticeTableView cyl_reloadData];
                [_noticeTableView.mj_header endRefreshing];
            }
            
        }else{
            
            [_noticeTableView cyl_reloadData];
            [_noticeTableView.mj_header endRefreshing];
        }
        
    } failure:^(id  _Nullable erros) {
        
    }];
    
}

#pragma mark- UITableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _noticeArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdenfier = @"cell";
    NoticeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[NoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    if (_noticeArr.count>indexPath.row) {
        
        cell.interactionNoticeModel = _noticeArr[indexPath.row];
        
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        
        [cell.contentView updateLayout];
    }
    
    return  cell;
    
}

#pragma mark- UITableView delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //cell自动高度
    return [tableView cellHeightForIndexPath:indexPath model:_noticeArr[indexPath.row] keyPath:@"interactionNoticeModel" cellClass:[NoticeTableViewCell class] contentViewWidth:self.view.width_sd];
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    if (toInterfaceOrientation!=UIInterfaceOrientationPortrait) {
        [_noticeTableView sd_clearViewFrameCache];
        [_noticeTableView sd_clearAutoLayoutSettings];
        [_noticeTableView removeFromSuperview];
        
    }else{
        
        [self.view addSubview:_noticeTableView];
        _noticeTableView.sd_layout
        .leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .topSpaceToView(self.view, 0)
        .bottomSpaceToView(self.view, 0);
        [_noticeTableView updateLayout];
        [_noticeTableView cyl_reloadData];
        
    }

}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    if (fromInterfaceOrientation!=UIInterfaceOrientationPortrait) {
        
        //        [_noticeTableView setNeedsDisplay];
        //        [_noticeTableView setNeedsLayout];
        //        if ([[UIDevice currentDevice]orientation] == UIDeviceOrientationPortrait) {
        //
        //            for (NoticeTableViewCell *cell in _noticeTableView.visibleCells ) {
        //
        //                [cell.contentView layoutIfNeeded ];
        //
        //                [cell.contentView setNeedsDisplay];
        //                [cell.contentView setNeedsLayout];
        //                [cell.contentView updateLayout];
        //            }
        //
        //        } ;
    }
}



- (UIView *)makePlaceHolderView{
    
    HaveNoClassView *view = [[HaveNoClassView alloc]initWithTitle:@"当前暂无公告"];
    return view;
}


- (BOOL)enableScrollWhenPlaceHolderViewShowing{
    
    return YES;
    
}

-(BOOL)shouldAutorotate{
    
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
