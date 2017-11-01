//
//  ExclusiveMembersViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/7/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ExclusiveMembersViewController.h"
#import "Members.h"
#import "MJRefresh.h"
#import "UIViewController+Token.h"
#import "UIViewController+AFHTTP.h"
#import "CYLTableViewPlaceHolder.h"
#import "YYModel.h"
#import "MemberListTableViewCell.h"
#import "HaveNoClassView.h"
#import "NSNull+Json.h"

@interface ExclusiveMembersViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    __block NSMutableArray *_membersArr;
    
    NSString *_classID;
    
    //主播老师
    NSString *_owner;
    
}


@end

@implementation ExclusiveMembersViewController

-(instancetype)initWithClassID:(NSString *)classID{
    
    self = [super init];
    if (self) {
        
        _classID = [NSString stringWithFormat:@"%@",classID];
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载基础数据
    [self makeData];
    
    //加载主视图
    [self setupMainView];
    
}

/**加载基础数据*/
- (void)makeData{
    
    _membersArr = @[].mutableCopy;
    
}

/**加载主视图*/
- (void)setupMainView{
    
    _membersTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_membersTableView];
    _membersTableView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    
    _membersTableView.delegate = self;
    _membersTableView.dataSource = self;
    
    _membersTableView.tableFooterView = [UIView new];
    _membersTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _membersArr = @[].mutableCopy;
        [self requestData];
        
    }];
    
    [_membersTableView.mj_header beginRefreshing];
    
}

/**请求数据*/
- (void)requestData{
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/customized_groups/%@/play",Request_Header,_classID] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            //获取数据正常 没问题
            
//            _owner = [NSString stringWithFormat:@"%@",dic[@"data"][@"owner"]];
            NSArray *members = [NSArray arrayWithArray:dic[@"data"][@"customized_group"][@"chat_team"][@"accounts"]];
            
            if (members.count!=0) {
                //有成员
                for (NSDictionary *member in members) {
                    Members *mod = [Members yy_modelWithJSON:member];
                    [_membersArr addObject:mod];
                    
                }
                
                //整理一下成员列表数组,把老师给弄到第一个
                NSMutableArray *sortArr = @[].mutableCopy;
                for (Members *mod in _membersArr) {
                    [sortArr addObject:mod];
                }
//                //加完了学生再加个老师
//                for (Members *mod in _membersArr) {
//                    if ([mod.accid isEqualToString:_owner]) {
//                        //把老师加到第一个里面去
//                        [sortArr insertObject:mod atIndex:0];
//                    }
//                }
                
                //然后再把成员数组重置一下子
                _membersArr = sortArr.mutableCopy;
                
                
                [_membersTableView cyl_reloadData];
                [_membersTableView.mj_header endRefreshing];
                
            }else{
                [_membersTableView cyl_reloadData];
                [_membersTableView.mj_header endRefreshing];
            }
        }else{
            //获取不正常
            [_membersTableView cyl_reloadData];
            [_membersTableView.mj_header endRefreshing];
            
        }
        
    } failure:^(id  _Nullable erros) {
        
        [_membersTableView cyl_reloadData];
        [_membersTableView.mj_header endRefreshing];
        
    }];
    
    
}

#pragma mark- UITabelview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _membersArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdenfier = @"cell";
    MemberListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[MemberListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    if (_membersArr.count>indexPath.row) {
        
        cell.model = _membersArr[indexPath.row];
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        
        //判断老师
        if (indexPath.row == 0) {
            cell.name.textColor = BUTTONRED;
            cell.character.textColor = BUTTONRED;
            cell.character.text = @"老师";
        }else{
            cell.name.textColor = TITLECOLOR;
            cell.character.textColor = TITLECOLOR;
            cell.character.text = @"学生";
            
        }
    }
    
    return  cell;
    
}

#pragma mark- UITableview delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    if (toInterfaceOrientation!=UIInterfaceOrientationPortrait) {
        [_membersTableView sd_clearViewFrameCache];
        [_membersTableView sd_clearAutoLayoutSettings];
        [_membersTableView removeFromSuperview];
        
    }else{
        
        [self.view addSubview:_membersTableView];
        _membersTableView.sd_layout
        .leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .topSpaceToView(self.view, 0)
        .bottomSpaceToView(self.view, 0);
        [_membersTableView updateLayout];
        
    }
    
    
}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    if (fromInterfaceOrientation!=UIInterfaceOrientationPortrait) {
        
        
    }
}



- (UIView *)makePlaceHolderView{
    
    HaveNoClassView *view = [[HaveNoClassView alloc]initWithTitle:@"暂时没有成员加入"];
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
