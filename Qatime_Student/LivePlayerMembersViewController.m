//
//  LivePlayerMembersViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/10/23.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "LivePlayerMembersViewController.h"
#import "Members.h"
#import "NetWorkTool.h"
#import "MemberListTableViewCell.h"

@interface LivePlayerMembersViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    NSString *_classID;
    __block NSMutableArray *_members;
}

@end

@implementation LivePlayerMembersViewController

-(instancetype)initWithClassID:(NSString *)classID{
    self = [super init];
    if (self ) {
        _classID = classID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeData];
    
    _memeberList = [[UITableView alloc]init];
    [self.view addSubview:_memeberList];
    _memeberList.delegate = self;
    _memeberList.dataSource = self;
    _memeberList.tableHeaderView = [[UIView alloc]init];;
    _memeberList.tableFooterView = [[UIView alloc]init];
    _memeberList.backgroundColor = [UIColor whiteColor];
    _memeberList.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0);
    
    _memeberList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _members = @[].mutableCopy;
        [self getData];
    }];
    [_memeberList.mj_header beginRefreshing];
    
}

- (void)makeData{
    _members = @[].mutableCopy;
}

- (void)getData{
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/courses/%@/play_info",Request_Header,_classID] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil withDownloadProgress:^(NSProgress * _Nullable progress) {} completeSuccess:^(id  _Nullable responds) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            if (dic[@"data"][@"chat_team"]) {
                for (NSDictionary *members in dic[@"data"][@"chat_team"][@"accounts"]) {
                    Members *mod = [Members yy_modelWithJSON:members];
                    [_members addObject:mod];
                }
            }
            [_memeberList.mj_header endRefreshing];
            [_memeberList cyl_reloadData];
        }else{
            [_memeberList.mj_header endRefreshing];
            [self HUDStopWithTitle:@"请稍后重试"];
        }
        
    } failure:^(id  _Nullable erros) {
        [_memeberList.mj_header endRefreshing];
        [self HUDStopWithTitle:@"请检查网络"];
    }];
    
}


#pragma mark- tableview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _members.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    MemberListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[MemberListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (_members.count>indexPath.row) {
        cell.model = _members[indexPath.row];
        if (indexPath.row == 0) {
            cell.character.text = @"老师";
            cell.name.textColor = BUTTONRED;
            cell.character.textColor = BUTTONRED;
        }else{
            cell.character.text = @"学生";
            
        }
    }
    
    return  cell;
}

#pragma mark- tablview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UIView *)makePlaceHolderView{
    HaveNoClassView *view = [[HaveNoClassView alloc]initWithTitle:@"暂无成员"];
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
