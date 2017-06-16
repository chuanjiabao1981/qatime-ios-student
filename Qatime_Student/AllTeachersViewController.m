//
//  AllTeachersViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/6/16.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "AllTeachersViewController.h"
#import "NavigationBar.h"
#import "ClassSubjectCollectionViewCell.h"
#import "TeachersSearch.h"
#import "SearchingTeachersTableViewCell.h"
#import "MJRefresh.h"
#import "UIViewController+AFHTTP.h"
#import "CYLTableViewPlaceHolder.h"
#import "HaveNoClassView.h"
#import "YYModel.h"
#import "UIViewController+HUD.h"
#import "TeachersPublicViewController.h"
#import "SnailPopupController.h"

typedef enum : NSUInteger {
    PullToRefresh,
    PushToLoadMore,
} RefreshType;


@interface AllTeachersViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>{
    
    NavigationBar *_navigationBar;
    
    //全部科目
    NSArray *_allSubjectArr ;
    //高中科目
    NSArray *_highSubjectArr ;
    //初中科目
    NSArray *_middleSubjectArr ;
    //小学科目
    NSArray *_primarySubjectArr ;
    
    
    //教师数组
    NSMutableArray *_teachersArr;
    
    //页数
    NSInteger _teachersPage;
    
    //筛选条件字典
    NSMutableDictionary *_filterDic;
    
    //科目切换数组
    NSMutableArray *_subjectsArr;
    
    //科目菜单选择
    BOOL subjecteMenuShow;
    
}

@end

@implementation AllTeachersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view .backgroundColor = [UIColor whiteColor];
    
    
    //初始化数据
    [self makeData];
    
    //加载导航栏
    [self setupNavigation];
    
    //加载筛选栏
    [self setupFilterView];
    
    //加载主视图
    [self setupMainView];
    
    //科目筛选栏
    [self setupSubjectFilterView];
    
    //请求数据(默认请求一次全部数据)
    [self requestTeachersWithLoadType:PullToRefresh];
    
    //旋转吧,菊花
    [self HUDStartWithTitle:nil];
}

/**初始化数据*/
- (void)makeData{
    
    _allSubjectArr  = @[@"全科",@"语文",@"数学",@"英语",@"物理",@"化学",@"生物",@"地理",@"历史",@"政治",@"科学"];
    _highSubjectArr  = @[@"全科",@"语文",@"数学",@"英语",@"物理",@"化学",@"生物",@"地理",@"历史",@"政治"];
    _middleSubjectArr = @[@"全科",@"语文",@"数学",@"英语",@"物理",@"化学",@"生物",@"地理",@"历史",@"政治"];
    _primarySubjectArr = @[@"全科",@"语文",@"数学",@"英语",@"科学"];
    
    _teachersArr = @[].mutableCopy;
    _teachersPage = 1;
    
    _filterDic = @{}.mutableCopy;
    
    _subjectsArr = _allSubjectArr.mutableCopy;
    
    _filterDic = @{@"page":[NSString stringWithFormat:@"%ld",_teachersPage],@"per_page":@"10"}.mutableCopy;
    
    subjecteMenuShow = NO;
    
}

/**加载导航栏*/
- (void)setupNavigation{
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview:_navigationBar];
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    _navigationBar.titleLabel.text = @"全部老师";
    
}


/**加载筛选栏*/
- (void)setupFilterView{
    
    _filterView = [[AllteachersFilterView alloc]init];
    [self.view addSubview:_filterView];
    _filterView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(_navigationBar, 0)
    .heightIs(40);
    
    //target action
    for (UIButton *btn in _filterView.allBtnsArr) {
        [btn addTarget:self action:@selector(chooseCategory:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [_filterView.subjectBtn addTarget:self action:@selector(subjectMenu) forControlEvents:UIControlEventTouchUpInside];
    
    [_filterView.allBtnsArr[0] setTitleColor:BUTTONRED forState:UIControlStateNormal];
    
}

/**加载主视图*/
- (void)setupMainView{
    
    _mainView = [[UITableView alloc]init];
    [self.view addSubview:_mainView];
    _mainView.delegate = self;
    _mainView.dataSource = self;
    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(_filterView, 0)
    .bottomSpaceToView(self.view, 0);
    _mainView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self requestTeachersWithLoadType:PullToRefresh];
    }];
    
    _mainView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self requestTeachersWithLoadType:PushToLoadMore];
    }];
    
}

/**加载科目筛选栏*/
- (void)setupSubjectFilterView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(self.view.width_sd/4-1, 40);
    layout.minimumLineSpacing = 0;
    layout.minimumLineSpacing = 0;
    _subjectFilterView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:_subjectFilterView];
    _subjectFilterView.backgroundColor = [UIColor whiteColor];
    _subjectFilterView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, -100)
    .heightIs(100);
    
    _subjectFilterView.delegate = self;
    _subjectFilterView.dataSource = self;
    
    // collectionView 注册cell
    [_subjectFilterView registerClass:[ClassSubjectCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    
}

#pragma mark- 请求数据方法

/**
 请求数据方法
 
 @param refreshType 下拉还是上滑
 */
- (void)requestTeachersWithLoadType:(RefreshType)refreshType{
    
    if (refreshType == PullToRefresh) {
        [_teachersArr removeAllObjects];
        [_mainView.mj_footer resetNoMoreData];
        _teachersPage = 1;
    }else if (refreshType == PushToLoadMore){
        _teachersPage++;
    }
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/home/teachers",Request_Header] withHeaderInfo:nil andHeaderfield:nil parameters:_filterDic completeSuccess:^(id  _Nullable responds) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            for (NSDictionary *teacher in dic[@"data"]) {
                TeachersSearch *mod = [TeachersSearch yy_modelWithJSON:teacher];
                mod.teacherID = teacher[@"id"];
                [_teachersArr addObject:mod];
            }
            if ([dic[@"data"]count]==0) {
                [_mainView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self HUDStopWithTitle:nil];
            if (refreshType == PullToRefresh) {
                [_mainView.mj_header endRefreshing];
            }else if (refreshType == PushToLoadMore){
                [_mainView.mj_footer endRefreshing];
            }
            [_mainView cyl_reloadData];
        }
        
    } failure:^(id  _Nullable erros) {
        
    }];
    
}



#pragma mark- UITableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _teachersArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    SearchingTeachersTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[SearchingTeachersTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    if (_teachersArr.count>indexPath.row) {
        
        cell.model = _teachersArr[indexPath.row];
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    }
    
    return  cell;
    
}

#pragma mark- UITableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    SearchingTeachersTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    TeachersPublicViewController *controller = [[TeachersPublicViewController alloc]initWithTeacherID:cell.model.teacherID];
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark- UICollectionView datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _subjectsArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"cellId";
    ClassSubjectCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.subject.layer.borderWidth = 0;
    cell.subject.text = _subjectsArr[indexPath.row];
    
    return cell;

}


#pragma mark- UICollectionView delegate


#pragma mark- Target Action
- (void)chooseCategory:(UIButton *)sender{
    
    //先变默认再变红
    for (UIButton *btn in _filterView.allBtnsArr) {
        [btn setTitleColor:TITLECOLOR forState:UIControlStateNormal];
    }
    [sender setTitleColor:BUTTONRED forState:UIControlStateNormal];
    
    //按照分类进行筛选
    [self HUDStartWithTitle:nil];
    if ([sender.titleLabel.text isEqualToString:@"全部"]) {
        [_filterDic removeObjectForKey:@"category_eq"];
        
    }else{
        [_filterDic setValue:sender.titleLabel.text forKey:@"category_eq"];
        
    }
    
    [_mainView.mj_header beginRefreshing];
    
}

/**科目选择菜单*/
- (void)subjectMenu{
    
    if (subjecteMenuShow == NO) {
        
        UIView *maskView = [[UIView alloc]initWithFrame:_mainView.frame];
        maskView.alpha = 0;
        [self.view addSubview:maskView];
        maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskHide:)];
        [maskView addGestureRecognizer:tap];
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 1;
        }];
        
    }else{
        
        
    }
    
}


/**蒙版和菜单双双消失*/
- (void)maskHide:(UITapGestureRecognizer *)tap{
    
    [UIView animateWithDuration:0.3 animations:^{
        tap.view.alpha = 0;
        
        
    }];
    
    [self performSelector:@selector(maskhide:) withObject:tap.view afterDelay:0.5];
    
}
- (void)maskhide:(UIView *)view{
    view.hidden = YES;
}






#pragma mark- UITableView empty delegate

- (UIView *)makePlaceHolderView{
    HaveNoClassView *view = [[HaveNoClassView alloc]initWithTitle:@"暂无合适条件的老师"];
    return view;
}


- (BOOL)enableScrollWhenPlaceHolderViewShowing{
    return YES;
}





- (void)returnLastPage{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
