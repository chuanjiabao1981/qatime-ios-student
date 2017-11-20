//
//  SearchViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/6/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "SearchViewController.h"
#import "NavigationBar.h"
#import "IndexPageViewController.h"
#import "UIViewController+AFHTTP.h"
#import "ClassSearch.h"
#import "TeachersSearch.h"
#import "CYLTableViewPlaceHolder.h"
#import "HaveNoClassView.h"
#import "YYModel.h"
#import "MJRefresh.h"
#import "SearchingClassesTableViewCell.h"
#import "SearchingTeachersTableViewCell.h"
#import "UIViewController+HUD.h"

#import "TutoriumInfoViewController.h"
#import "VideoClassInfoViewController.h"
#import "InteractionClassInfoViewController.h"
#import "ExclusiveInfoViewController.h"

#import "TeachersPublicViewController.h"
#import "AllTeachersViewController.h"
#import "ChooseClassViewController.h"
#import "ChooseGradeAndSubjectViewController.h"

//下拉刷新方式
typedef enum : NSUInteger {
    DefaultLoad,    //默认没有上下拉动作,直接刷新,只在初始化的时候用一次
    PullToReload,   //下拉重载
    PushToLoadMore, //上滑加载更多
} RefreshType;

//搜索分类
typedef enum : NSUInteger {
    DefaultSearch,  //两种类型数据都加载,只在初始化的时候用一次
    SearchClasses,  //搜索课程
    SearchTeachers, //搜索教师
} RequestType;

@interface SearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NavigationBar *_navigationBar;
    
    //搜索框
    UITextField *_searchText;
    
    //搜索关键字
    NSString *_searchKeyStr;
    
    //搜索结果
    NSMutableArray *_classesArr;
    NSMutableArray *_teachersArr;
    
    //搜索结果数量
    NSInteger _classesCount;
    NSInteger _teachersCount;
    
    
    //课程页数
    NSInteger _classesPage;
    //教师页数
    NSInteger _teachersPage;
    
    
    
}

@end

@implementation SearchViewController

-(instancetype)initWithSearchKey:(NSString *)searchKey{
    
    self = [super init];
    if (self) {
        
        _searchKeyStr = [NSString stringWithFormat:@"%@",searchKey];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化数据
    [self makeData];
    //加载导航栏
    [self navigation];
    //加载主视图
    [self setupMainView];
    //请求数据
    [self requestSearchDataWithType:DefaultSearch andRefreshType:DefaultLoad];
    
}

- (void)makeData{
    
    _classesArr = @[].mutableCopy;
    _teachersArr = @[].mutableCopy;
    
    _classesPage = 1;
    _teachersPage = 1;
    
    _classesCount = 0;
    _teachersCount = 0;
}

/**加载导航栏*/
- (void)navigation{
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview:_navigationBar];
    [_navigationBar.rightButton setTitle:@"取消" forState:UIControlStateNormal];
    [_navigationBar.rightButton setupAutoSizeWithHorizontalPadding:5 buttonHeight:30*ScrenScale];
    [_navigationBar.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_navigationBar.rightButton addTarget:self action:@selector(cancelSearchAction) forControlEvents:UIControlEventTouchUpInside];
    _navigationBar.rightButton.sd_resetLayout
    .rightSpaceToView(_navigationBar.contentView, 10*ScrenScale)
    .topEqualToView(_navigationBar.leftButton)
    .bottomEqualToView(_navigationBar.leftButton);
    [_navigationBar.rightButton setupAutoSizeWithHorizontalPadding:5 buttonHeight:_navigationBar.leftButton.height_sd];
    [_navigationBar.rightButton updateLayout];
    
    //放一个能打字的搜索框上去
    UIView *searchView = [[UIView alloc]init];
    searchView.backgroundColor = [UIColor whiteColor];
    [_navigationBar addSubview:searchView];
    searchView.sd_layout
    .topEqualToView(_navigationBar.rightButton)
    .bottomEqualToView(_navigationBar.rightButton)
    .rightSpaceToView(_navigationBar.rightButton, 10*ScrenScale)
    .leftSpaceToView(_navigationBar, 10*ScrenScale);
    searchView.sd_cornerRadiusFromHeightRatio = @0.5;
    
    //放大镜
    UIImageView *scope = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scope"]];
    [searchView addSubview:scope];
    scope.sd_layout
    .leftSpaceToView(searchView, 10)
    .centerYEqualToView(searchView)
    .heightRatioToView(searchView, 0.5)
    .widthEqualToHeight();
    
    //输入框
    _searchText = [[UITextField alloc]init];
    _searchText.returnKeyType = UIReturnKeySearch;
    [searchView addSubview:_searchText];
    _searchText.delegate = self;
    _searchText.placeholder = @"搜索课程/教师";
    _searchText.font = TEXT_FONTSIZE;
    _searchText.sd_layout
    .leftSpaceToView(scope, 10)
    .rightSpaceToView(searchView, 10)
    .topSpaceToView(searchView, 0)
    .bottomSpaceToView(searchView, 0);
    _searchText.text = _searchKeyStr;

}

/**加载主视图*/

- (void)setupMainView{
    
    _mainView = [[SearchView alloc]init];
    [self.view addSubview:_mainView];
    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(_navigationBar, 0)
    .bottomSpaceToView(self.view, 0);
    _mainView.scrollView.delegate = self;
    _mainView.classSearchResultView.delegate = self;
    _mainView.classSearchResultView.dataSource = self;
    _mainView.classSearchResultView.tag = 1;
    _mainView.teacherSearchResultView.delegate = self;
    _mainView.teacherSearchResultView.dataSource = self;
    _mainView.teacherSearchResultView.tag = 2;
    
    //下拉上滑
    _mainView.classSearchResultView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestClassesWithRefreshType:PullToReload];
    }];
    
    _mainView.classSearchResultView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self requestClassesWithRefreshType:PushToLoadMore];
    }];
    
    _mainView.teacherSearchResultView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [self requestTeachersWithRefreshType:PullToReload];
    }];
    
    _mainView.teacherSearchResultView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
       
        [self requestTeachersWithRefreshType:PushToLoadMore];
    }];
    
    //转起来
    [self HUDStartWithTitle:nil];
}
/**请求搜索数据*/
- (void)requestSearchDataWithType:(RequestType)requestType andRefreshType:(RefreshType)refreshType {
    
    //数据类型
//    NSString *course;
    if (requestType == DefaultSearch &&refreshType == DefaultLoad) {
        _classesPage = 1;
        _teachersPage = 1;
        [self requestClassesWithRefreshType:DefaultLoad];
        [self requestTeachersWithRefreshType:DefaultLoad];
    }
    
}


/**
 搜索课程

 @param refreshType 刷新方式
 */
- (void)requestClassesWithRefreshType:(RefreshType)refreshType{
    
    if (refreshType!=PushToLoadMore) {
        _classesArr = @[].mutableCopy;
        _classesPage = 1;
    }else{
        _classesPage++;
    }
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/home/search",Request_Header] withHeaderInfo:nil andHeaderfield:nil parameters:@{@"search_cate":@"course",@"search_key":_searchKeyStr,@"page":[NSString stringWithFormat:@"%ld",_classesPage],@"per_page":@"10"} completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            //搜索数据成功
            for (NSDictionary *classes in dic[@"data"]) {
                
                ClassSearch *mod = [ClassSearch yy_modelWithJSON:classes[@"product"]];
                mod.classID = classes[@"product"][@"id"];
                mod.product_type = classes[@"product_type"];
                [_classesArr addObject:mod];
            }
            if ([dic[@"data"]count]<10) {
                [_mainView.classSearchResultView.mj_footer  endRefreshingWithNoMoreData];
            }
            
            _classesCount = _classesArr.count;
            if (refreshType == PullToReload) {
                
                [_mainView.classSearchResultView.mj_header endRefreshing];
                
            }else if (refreshType == PushToLoadMore){
                
                [_mainView.classSearchResultView.mj_footer endRefreshing];
                
            }else if (refreshType == DefaultLoad){
                
            }
            
            [self HUDStopWithTitle:nil];
            [_mainView.classSearchResultView cyl_reloadData];
            //此时回传查询出来的数量有多少
            [self refreshSegment];
            
        }else{
            
        }
        
    } failure:^(id  _Nullable erros) {
        
    }];
}


/**
 搜索教师

 @param refreshType 刷新类型
 */
- (void)requestTeachersWithRefreshType:(RefreshType)refreshType{
    if (refreshType!=PushToLoadMore) {
        _teachersArr = @[].mutableCopy;
        _teachersPage = 1;
    }else{
        _teachersPage++;
    }
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/home/search",Request_Header] withHeaderInfo:nil andHeaderfield:nil parameters:@{@"search_cate":@"teacher",@"search_key":_searchKeyStr,@"page":[NSString stringWithFormat:@"%ld",_teachersPage],@"per_page":@"10"} completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            //搜索数据成功
            for (NSDictionary *teachers in dic[@"data"]) {
                
                TeachersSearch *mod = [TeachersSearch yy_modelWithJSON:teachers];
                mod.teacherID = teachers[@"id"];
                [_teachersArr addObject:mod];
            }
            
            if ([dic[@"data"] count]<10) {
                [_mainView.teacherSearchResultView.mj_footer  endRefreshingWithNoMoreData];
            }
            
            if (refreshType == PullToReload) {
                _teachersCount = _teachersArr.count;
                [_mainView.teacherSearchResultView.mj_header endRefreshing];
                
            }else if (refreshType == PushToLoadMore){
                _teachersCount += _teachersArr.count;
                [_mainView.teacherSearchResultView.mj_footer endRefreshing];
                
            }else if (refreshType == DefaultLoad){
                _teachersCount = _teachersArr.count;
            }
            
            
            [_mainView.teacherSearchResultView cyl_reloadData];
            //此时回传查询出来的数量有多少
            [self refreshSegment];
            
        }else{
            
        }
        
    } failure:^(id  _Nullable erros) {
        
    }];

    
}

/**刷新segment的字符字段*/
- (void)refreshSegment{
    
    NSString *classTitle ;
    NSString *teachersTitle ;
    
    if (_classesCount==0) {
        classTitle = @"课程";
    }else{
        classTitle  = [NSString stringWithFormat:@"课程(%ld)",_classesCount];
    }
    
    if (_teachersCount == 0) {
        teachersTitle = @"教师";
    }else{
        
        teachersTitle = [NSString stringWithFormat:@"教师(%ld)",_teachersCount];
    }
    
    _mainView.segmentControl.sectionTitles = @[classTitle,teachersTitle];
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([textField.text isEqualToString:@""]) {
        [self HUDStopWithTitle:@"请输入搜索内容"];
    }else{
        _searchKeyStr = textField.text;
        [self HUDStartWithTitle:nil];
        [self requestSearchDataWithType:DefaultSearch andRefreshType:DefaultLoad];
    }
    
    return [self.view endEditing:YES];
}



#pragma mark- UITableView datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows ;
    if (tableView.tag == 1) {
        rows = _classesArr.count;
    }else{
        rows = _teachersArr.count;
    }
    
    return rows;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    if (tableView.tag == 1) {
    
        static NSString *cellIdenfier = @"classcell";
        SearchingClassesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
        if (cell==nil) {
            cell=[[SearchingClassesTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        
        if (_classesArr.count>indexPath.row) {
            cell.model = _classesArr[indexPath.row];
        }
        
        return  cell;
        
    } else if(tableView.tag == 2) {
        
        static NSString *cellIdenfier = @"teachercell";
        SearchingTeachersTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
        if (cell==nil) {
            cell=[[SearchingTeachersTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        if (_teachersArr.count>indexPath.row) {
            cell.model = _teachersArr[indexPath.row];
        }
        
        return  cell;
        

        
    }
    
    return  cell;
    
}


#pragma mark- UITableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100*ScrenScale;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    UIViewController *controller;
    if (tableView.tag == 1) {
        SearchingClassesTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell.model.product_type isEqualToString:@"LiveStudio::Course"]) {
            //直播课
            controller  = [[TutoriumInfoViewController alloc]initWithClassID:cell.model.classID];
        }else if ([cell.model.product_type isEqualToString:@"LiveStudio::InteractiveCourse"]){
            //一对一
            controller = [[TutoriumInfoViewController alloc]initWithClassID:cell.model.classID];
        }else if ([cell.model.product_type isEqualToString:@"LiveStudio::VideoCourse"]){
            //视频课
            controller = [[VideoClassInfoViewController alloc]initWithClassID:cell.model.classID];
        }else{
            
            controller = [[ExclusiveInfoViewController alloc]initWithClassID:cell.model.classID];
        }
        
        
    }else{
        SearchingTeachersTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        controller = [[TeachersPublicViewController alloc]initWithTeacherID:cell.model.teacherID];
    }
    
    [self.navigationController pushViewController:controller animated:YES];
    
}





// 滑动代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == _mainView.scrollView) {
        
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        
        [_mainView.segmentControl setSelectedSegmentIndex:page animated:YES];
        
    }
}


/**退出搜索*/
- (void)cancelSearchAction{
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isMemberOfClass:[AllTeachersViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isMemberOfClass:[ChooseGradeAndSubjectViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isMemberOfClass:[ChooseClassViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isMemberOfClass:[IndexPageViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    
}


#pragma mark- UITableView reload delegate

- (UIView *)makePlaceHolderView{
    HaveNoClassView *view = [[HaveNoClassView alloc]initWithTitle:@"暂无此项内容"];
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
