//
//  ExclusiveCoursewareViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/8/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ExclusiveCoursewareViewController.h"
#import "CourseFile.h"
#import "CourseFileTableViewCell.h"
#import "UIViewController+AFHTTP.h"
#import "YYModel.h"
#import "MJRefresh.h"
#import "CYLTableViewPlaceHolder.h"
#import "HaveNoClassView.h"
#import "UIViewController+Token.h"
#import "NavigationBar.h"
#import "UIViewController+ReturnLastPage.h"
#import "CourseFileInfoViewController.h"

@interface ExclusiveCoursewareViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSString *_classID;
    
    NSMutableArray *_filesArray;
    
    NavigationBar *_navigationBar;
}

@end

@implementation ExclusiveCoursewareViewController

-(instancetype)initWithClassID:(NSString *)classID{
    
    self = [super init];
    if (self) {
        
        _classID = classID;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeData];
    
    [self setupMainView];
    
}

- (void)makeData{
    
    _filesArray = [NSMutableArray array];
    
}

- (void)setupMainView{
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview:_navigationBar];
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    _navigationBar.titleLabel.text = @"课件文件";
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    _mainView = [[UITableView alloc]init];
    [self.view addSubview:_mainView];
    _mainView.tableFooterView = [[UIView alloc]init];
    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(_navigationBar, 0)
    .bottomSpaceToView(self.view, 0);
    
    _mainView.delegate = self;
    _mainView.dataSource = self;
    
    _mainView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _filesArray = [NSMutableArray array];
        [self requestFiles];
        
    }];
    [_mainView.mj_header beginRefreshing];
}


/**
 请求数据
 */
- (void)requestFiles{
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/groups/%@/files",Request_Header,_classID] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            for (NSDictionary *file in dic[@"data"]) {
                CourseFile *mod = [CourseFile yy_modelWithJSON:file];
                mod.fileID = file[@"id"];
                
                if (!_filesArray) {
                    _filesArray = @[].mutableCopy;
                }
                [_filesArray addObject:mod];
            }
            
            [_mainView.mj_header endRefreshing];
            [_mainView cyl_reloadData];
            
        }else{
            
            
        }
        
    } failure:^(id  _Nullable erros) {
        
    }];
    
}


#pragma mark- UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _filesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    CourseFileTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[CourseFileTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    if (_filesArray.count>indexPath.row) {
        
        cell.model = _filesArray[indexPath.row];
    }
    
    return  cell;
    
}


#pragma mark- UITablView delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CourseFileInfoViewController *controller = [[CourseFileInfoViewController alloc]initWithFile:_filesArray[indexPath.row]];
    [self.navigationController pushViewController:controller animated:YES];
}

- (UIView *)makePlaceHolderView{
    HaveNoClassView *view = [[HaveNoClassView alloc]initWithTitle:@"暂无课件"];
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
