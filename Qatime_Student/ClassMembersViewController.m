//
//  ClassMembersViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/9/18.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ClassMembersViewController.h"
#import "MemberListTableViewCell.h"
#import "NavigationBar.h"
#import "NetWorkTool.h"

@interface ClassMembersViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray *_membersArray;
    
    NavigationBar *_navBar;
    
    NSString *_classID;
    
}

@end

@implementation ClassMembersViewController

-(instancetype)initWithClassID:(NSString *)classID{
    self = [super init];
    if (self) {
        _classID = classID;
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _membersArray = @[].mutableCopy;
    
    [self setupView];
    
}

- (void)setupView{
    
    _navBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview:_navBar];
    [_navBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    _navBar.titleLabel.text = @"成员列表";
    
    _mainView = [[UITableView alloc]init];
    [self.view addSubview:_mainView];
    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(_navBar, 0)
    .bottomSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0);
    _mainView.tableFooterView = [[UIView alloc]init];
    _mainView.delegate = self;
    _mainView.dataSource = self;
    _mainView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _membersArray = @[].mutableCopy;
        [self requestData];
    }];
    
    [_mainView.mj_header beginRefreshing];
}

- (void)requestData{
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/customized_groups/%@/play",Request_Header,_classID] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil withProgress:^(NSProgress * _Nullable progress) {
        
    } completeSuccess:^(id  _Nullable responds) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            for (NSDictionary *member in dic[@"data"][@"customized_group"][@"chat_team"][@"accounts"]) {
                Members *mod = [Members yy_modelWithJSON:member];
                [_membersArray addObject:mod];
            }
            [_mainView.mj_header endRefreshingWithCompletionBlock:^{
                [_mainView cyl_reloadData];
            }];
            
        }else{
            [self HUDStopWithTitle:@"请稍后重试"];
            [_mainView.mj_header endRefreshing];
        }
        
    } failure:^(id  _Nullable erros) {
        [self HUDStopWithTitle:@"请检查网络"];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _membersArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    MemberListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[MemberListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (_membersArray.count>indexPath.row) {
        cell.model = _membersArray[indexPath.row];
    }
    
    return  cell;
}

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
