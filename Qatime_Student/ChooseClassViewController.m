//
//  ChooseClassViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ChooseClassViewController.h"
#import "NavigationBar.h"
#import "UIViewController+AFHTTP.h"
#import "ChooseClassTableViewCell.h"
#import "MJRefresh.h"
#import "ClassSubjectCollectionViewCell.h"
#import "YYModel.h"
#import "TutoriumList.h"
#import "UIViewController+HUD.h"
#import "MultifiltersViewController.h"

//上滑 或 下拉
typedef enum : NSUInteger {
    PullToRefresh,      //下拉刷新
    PushToReadMore      //上滑加载更多
} RefreshMode;


@interface ChooseClassViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    
    NSString *_token;
    NSString *_idNumber;
    
    
    NSString *_grade;
    NSString *_subject;
    NavigationBar *_navigationBar;
    
    //加载课程页数
    NSInteger page;
    //每页条数
    NSInteger perPage;
    
    //弹窗蒙版
    SnailQuickMaskPopups *_pops;
    
    //筛选tag的存放数组
    NSArray *tags ;
    
    //存课程数据的数组
    NSMutableArray *_classesArray;
    
    
    //筛选用的字典
    NSMutableDictionary *_filterDic;
    
}

@end

@implementation ChooseClassViewController

-(instancetype)initWithGrade:(NSString *)grade andSubject:(NSString *)subject{
    
    self = [super init];
    
    if (self) {
        
        _grade = grade;
        _subject = subject;
        
    }
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化数据
    _classesArray = @[].mutableCopy;
    tags = @[@"不限",@"高考",@"中考",@"会考",@"小升初考试",@"高考志愿",@"英语考级",@"奥数竞赛",@"历年真题",@"期中期末试卷",@"自编试题",@"暑假课",@"寒假课",@"周末课",@"国庆假期课",@"基础课",@"巩固课",@"提高课",@"外教",@"冲刺",@"重点难点"];
    page = 1;   //页数是会变的
    perPage = 10;
    
    _filterDic = @{}.mutableCopy;
    
    //导航栏
    [self setupNavigation];
    
    //token
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    //加载tableview
    [self setupMainView];
    
    
}



//下拉加载数据
- (void)requestClass:(RefreshMode)mode withContentDictionary:(nullable NSMutableDictionary * )contentDic{
    
    if (mode==PullToRefresh) {
        
        page = 1;
        _classesArray = @[].mutableCopy;
        
        if (_classTableView.mj_footer.state == MJRefreshStateNoMoreData) {
            _classTableView.mj_footer.state = MJRefreshStateIdle;
            
        }else{
            
        }
    }else{
        
        page++;
    }
    
    if (contentDic==nil) {
        
        if ([_subject isEqualToString:@"全部"]) {
            
            _filterDic = [NSMutableDictionary dictionaryWithDictionary: @{@"grade":_grade,
                                                                          @"page":[NSString stringWithFormat:@"%ld",page],
                                                                          @"per_page":[NSString stringWithFormat:@"%ld",perPage],
                                                                          @"sort_by":@"created_at"}];
        }else{
            
            _filterDic = [NSMutableDictionary dictionaryWithDictionary:@{@"subject":_subject,
                                                                         @"grade":_grade,
                                                                         @"page":[NSString stringWithFormat:@"%ld",page],
                                                                         @"per_page":[NSString stringWithFormat:@"%ld",perPage]}];
        }
    }else{
        
        [_filterDic addEntriesFromDictionary:contentDic];
        
    }
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/courses",Request_Header] withHeaderInfo:nil andHeaderfield:nil parameters:_filterDic completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            if ([dic[@"data"] count] !=0) {
                
                for (NSDictionary *dics in dic[@"data"]) {
                    
                    TutoriumListInfo *mod = [TutoriumListInfo yy_modelWithJSON:dics];
                    mod.classID = dics[@"id"];
                    
                    [_classesArray addObject:mod];
                    
                }
                
                if (mode == PullToRefresh) {
                    
                    [_classTableView.mj_header endRefreshingWithCompletionBlock:^{
                        //刷新数据
                        [_classTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                    }];
                }else{
                    [_classTableView.mj_footer endRefreshingWithCompletionBlock:^{
                        //刷新数据
                        [_classTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];;
                    }];
                }
                
            }else{
                //没有数据的情况
                if (mode == PullToRefresh) {
                    //下拉刷新的时候
                    
                    
                    
                }else{
                    //上滑的时候
                    
                    [_classTableView.mj_footer endRefreshingWithNoMoreData];
                }
                
            }
        }else{
            //获取数据失败
            [self loadingHUDStopLoadingWithTitle:@"加载失败,请重试"];
            [_classTableView.mj_header endRefreshing];
            [_classTableView.mj_footer endRefreshing];
            
            
        }
        
    }];
    
    
    
}



#pragma mark- tableview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_classesArray.count>0) {
        return _classesArray.count;
    }
    
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    ChooseClassTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[ChooseClassTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    if (_classesArray.count>indexPath.row) {
        
        cell.model = _classesArray[indexPath.row];
        
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        
    }
    
    return  cell;
    
}


#pragma mark- tableview delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
    
}


#pragma mark- collectionview datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return tags.count;
    
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"CollectionCell";
    ClassSubjectCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.subject.text = tags[indexPath.row];
    cell.subject.font = [UIFont systemFontOfSize:14*ScrenScale];
    return cell;
    
    
}

#pragma mark- collectionview delegate
//item间距
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(20, 20, 0, 20);
}

//行距
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 20;
}

//点击选择
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [_filterView.tagsButton setTitle:tags[indexPath.row] forState:UIControlStateNormal];
    
    //蒙版消失之后 ,执行操作
    [_pops dismissWithAnimated:YES completion:^(BOOL finished, SnailQuickMaskPopups * _Nonnull popups) {
        
    }];
    
    
}


//加载主视图
- (void)setupMainView{
    
    _classTableView = ({
        
        UITableView *_ =[[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_filterView.frame), self.view.width_sd, self.view.height_sd-CGRectGetMaxY(_filterView.frame)) style:UITableViewStylePlain];
        [self.view addSubview:_];
        _.backgroundColor = [UIColor whiteColor];
        _.delegate = self;
        _.dataSource = self;
        _.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
        }];
        
        //第一次自动下拉刷新
        [_.mj_header beginRefreshing];
        //自动下拉
        [self requestClass:PullToRefresh withContentDictionary:nil];
        
        _.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            //上滑加载更多
            [self requestClass:PushToReadMore withContentDictionary:nil];
            
        }];
        
        _;
    });
    
}


//加载navigation
- (void)setupNavigation{
    
    _navigationBar = ({
        NavigationBar *_ =[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
        [self.view addSubview:_];
        
        _.titleLabel.text = [NSString stringWithFormat:@"%@%@",_grade,_subject];
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        
        _;
        
    });
    
    //多项筛选栏
    _filterView = [[ClassFilterView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_navigationBar.frame), self.view.width_sd, 40)];
    
    [self.view addSubview:_filterView];
    
    [_filterView.newestButton setTitleColor:TITLECOLOR forState:UIControlStateNormal];
    [_filterView.newestArrow setImage:[UIImage imageNamed:@"下箭头"]];
    
    //tag
    [_filterView.tagsButton addTarget:self action:@selector(chooseTags:) forControlEvents:UIControlEventTouchUpInside];
    
    //多项筛选
    [_filterView.filterButton addTarget:self action:@selector(multiFilters) forControlEvents:UIControlEventTouchUpInside];
    
    //单项条件筛选
    
    //最新
    [_filterView.newestButton addTarget:self action:@selector(newestFilter:) forControlEvents:UIControlEventTouchUpInside];
    
    //价格
    [_filterView.priceButton addTarget:self action:@selector(priceFilter:) forControlEvents:UIControlEventTouchUpInside];
    
    //人气
    [_filterView.popularityButton addTarget:self action:@selector(countFilter:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

//选择标签按钮
- (void)chooseTags:(UIButton *)sender{
    
    _pops = [SnailQuickMaskPopups popupsWithMaskStyle:MaskStyleBlackTranslucent aView:self.tagsFilterView];
    
    //已选过 和未选过的情况
    if (![sender.titleLabel.text isEqualToString:@"标签"]) {
        //把tag选项表的所有按钮遍历成未选中状态
        NSInteger index = 0;
        for (NSString *title in tags) {
            
            if ([sender.titleLabel.text isEqualToString:title]) {
                
                ClassSubjectCollectionViewCell *cell = (ClassSubjectCollectionViewCell *)[_tagsFilterView.tagsCollection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
                
                cell.subject.textColor = [UIColor whiteColor];
                cell.subject.backgroundColor = [UIColor orangeColor];
                cell.subject.layer.borderColor = [UIColor orangeColor].CGColor;
                
            }else{
                ClassSubjectCollectionViewCell *cell = (ClassSubjectCollectionViewCell *)[_tagsFilterView.tagsCollection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
                
                cell.subject.textColor = TITLECOLOR;
                cell.subject.backgroundColor = [UIColor whiteColor];
                cell.subject.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
                
            }
            
            index ++;
        }
        
    }else{
        
        ClassSubjectCollectionViewCell *cell = (ClassSubjectCollectionViewCell *)[_tagsFilterView.tagsCollection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        cell.subject.textColor = [UIColor whiteColor];
        cell.subject.backgroundColor = [UIColor orangeColor];
        cell.subject.layer.borderColor = [UIColor orangeColor].CGColor;
        
    }
    
    [_pops presentWithAnimated:self completion:^(BOOL finished, SnailQuickMaskPopups * _Nonnull popups) {
        
    }];
}

//单项筛选

/**
 筛选最新
 */
- (void)newestFilter:(UIButton *)sender{
    NSDictionary *dic;
    //重置所有按钮
    [self filterButtonTurnReset];
    [sender setTitleColor:TITLECOLOR forState:UIControlStateNormal];
    //如果已有sort_by字段
    if (_filterDic[@"sort_by"]) {
        //如果是价格筛选字段 正序或倒序
        if ([_filterDic[@"sort_by"] isEqualToString:@"created_at.asc"]||[_filterDic[@"sort_by"] isEqualToString:@"created_at"]) {
            //正序
            if ([_filterDic[@"sort_by"] isEqualToString:@"created_at.asc"]) {
                [_filterDic removeObjectForKey:@"sort_by"];
                //改成倒序
                dic = @{@"sort_by":@"created_at"};
                [_filterView.newestArrow setImage:[UIImage imageNamed:@"上箭头"]];
                
            }else if ([_filterDic[@"sort_by"] isEqualToString:@"created_at"]){
                //如果是倒序
                [_filterDic removeObjectForKey:@"sort_by"];
                //改成正序
                dic = @{@"sort_by":@"created_at.asc"};
                [_filterView.newestArrow setImage:[UIImage imageNamed:@"下箭头"]];
                
            }
            
        }else{
            //如果不是价格筛选字段
            //重置所有单选button
            [self filterButtonTurnReset];
            //按钮和箭头变化
            [sender setTitleColor:TITLECOLOR forState:UIControlStateNormal];
            [_filterView.newestArrow setImage:[UIImage imageNamed:@"下箭头"]];
            
            [_filterDic removeObjectForKey:@"sort_by"];
            //去掉后,改为正序
            dic = @{@"sort_by":@"created_at.asc"};
            
        }
        
    }else{
        //如果没有筛选字段
        dic = @{@"sort_by":@"created_at.asc"};
         [_filterView.newestArrow setImage:[UIImage imageNamed:@"下箭头"]];
    }
    
    //发起筛选请求
    [_classTableView.mj_header beginRefreshingWithCompletionBlock:^{
        
        [self requestClass:PullToRefresh withContentDictionary:dic.mutableCopy];
    }];
    
}



/**
 按价格筛选
 */
- (void)priceFilter:(UIButton *)sender{
    
    NSDictionary *dic;
    //重置所有按钮
    [self filterButtonTurnReset];
    
    [sender setTitleColor:TITLECOLOR forState:UIControlStateNormal];
    //如果已有sort_by字段
    if (_filterDic[@"sort_by"]) {
        //如果是价格筛选字段 正序或倒序
        if ([_filterDic[@"sort_by"] isEqualToString:@"price.asc"]||[_filterDic[@"sort_by"] isEqualToString:@"price"]) {
            //正序
            if ([_filterDic[@"sort_by"] isEqualToString:@"price.asc"]) {
                [_filterDic removeObjectForKey:@"sort_by"];
                //改成倒序
                dic = @{@"sort_by":@"price"};
                [_filterView.priceArrow setImage:[UIImage imageNamed:@"上箭头"]];
                
            }else if ([_filterDic[@"sort_by"] isEqualToString:@"price"]){
                //如果是倒序
                [_filterDic removeObjectForKey:@"sort_by"];
                //改成正序
                dic = @{@"sort_by":@"price.asc"};
                [_filterView.priceArrow setImage:[UIImage imageNamed:@"下箭头"]];
                
            }
            
        }else{
            //如果不是价格筛选字段
            [_filterDic removeObjectForKey:@"sort_by"];
            
            //重置所有单选button
            [self filterButtonTurnReset];
            //按钮和箭头变化
            [sender setTitleColor:TITLECOLOR forState:UIControlStateNormal];
            [_filterView.priceArrow setImage:[UIImage imageNamed:@"下箭头"]];

            //去掉后,改为正序
            dic = @{@"sort_by":@"price.asc"};
            
        }
        
    }else{
        //如果没有筛选字段
        dic = @{@"sort_by":@"price.asc"};
        [_filterView.priceArrow setImage:[UIImage imageNamed:@"下箭头"]];
        
    }
    
    //发起筛选请求
    [_classTableView.mj_header beginRefreshingWithCompletionBlock:^{
        
        [self requestClass:PullToRefresh withContentDictionary:dic.mutableCopy];
    }];
    
    
}


/**
 按人气筛选
 */
- (void)countFilter:(UIButton *)sender{
    
    NSDictionary *dic;
    
    [sender setTitleColor:TITLECOLOR forState:UIControlStateNormal];
    
    //如果已有sort_by字段
    if (_filterDic[@"sort_by"]) {
        //如果是人气筛选字段
        if ([_filterDic[@"sort_by"] isEqualToString:@"buy_count.asc"]||[_filterDic[@"sort_by"] isEqualToString:@"buy_count"]) {
            //正序
            if ([_filterDic[@"sort_by"] isEqualToString:@"buy_count.asc"]) {
                [_filterDic removeObjectForKey:@"sort_by"];
                //改成倒序
                dic = @{@"sort_by":@"buy_count"};
                [_filterView.popularityArrow setImage:[UIImage imageNamed:@"上箭头"]];
                
            }else if ([_filterDic[@"sort_by"] isEqualToString:@"buy_count"]){
                //如果是倒序
                [_filterDic removeObjectForKey:@"sort_by"];
                //改成正序
                dic = @{@"sort_by":@"buy_count.asc"};
                [_filterView.popularityArrow setImage:[UIImage imageNamed:@"下箭头"]];
                
            }
            
        }else{
            //如果不是人气筛选字段
            [_filterDic removeObjectForKey:@"sort_by"];
            //去掉后,改为正序
            dic = @{@"sort_by":@"buy_count.asc"};
            
            //重置所有单选button
            [self filterButtonTurnReset];
            //按钮和箭头变化
            [sender setTitleColor:TITLECOLOR forState:UIControlStateNormal];
            [_filterView.popularityArrow setImage:[UIImage imageNamed:@"下箭头"]];
            
        }
        
    }else{
        //如果没有筛选字段
        dic = @{@"sort_by":@"buy_count.asc"};
        [_filterView.popularityArrow setImage:[UIImage imageNamed:@"下箭头"]];
    }
    
    //发起筛选请求
    [_classTableView.mj_header beginRefreshingWithCompletionBlock:^{
        
        [self requestClass:PullToRefresh withContentDictionary:dic.mutableCopy];
    }];
    
    
}

//reset三个单项筛选按钮
- (void)filterButtonTurnReset{
    
    [_filterView.newestButton setTitleColor:SEPERATELINECOLOR forState:UIControlStateNormal];
    [_filterView.priceButton setTitleColor:SEPERATELINECOLOR forState:UIControlStateNormal];
    [_filterView.popularityButton setTitleColor:SEPERATELINECOLOR forState:UIControlStateNormal];
    
    [_filterView.newestArrow setImage:nil];
    [_filterView.priceArrow setImage:nil];
    [_filterView.popularityArrow setImage:nil];
    
}



//多项筛选
- (void)multiFilters{
    
    MultifiltersViewController *controller = [[MultifiltersViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
    
    
    /**
     多项筛选页面pop后传值回来
     
     @param component 筛选项目字典
     @return void
     */
    [controller multiFilters:^(NSMutableDictionary *component) {
        //多项筛选方法
        [self multiFiltersRequest:component];
        
    }];
    
}


//多项筛选
- (void)multiFiltersRequest:(NSMutableDictionary *)filterDic{
    
    if (filterDic) {
        [_classTableView.mj_header beginRefreshingWithCompletionBlock:^{
            
            [self requestClass:PullToRefresh withContentDictionary:filterDic];
        }];
        
    }else{
        
        [_classTableView.mj_header beginRefreshingWithCompletionBlock:^{
            [self requestClass:PushToReadMore withContentDictionary:nil];
            
        }];
    }
    
}



//懒加载标签筛选列表
-(TagsFilterView *)tagsFilterView{
    
    if (!_tagsFilterView) {
        
        _tagsFilterView = [[TagsFilterView alloc]initWithFrame:CGRectMake(40, 120, self.view.width_sd-80, (self.view.width_sd-80)*1.6)];
        _tagsFilterView.backgroundColor = [UIColor whiteColor];
        
        _tagsFilterView.tagsCollection.delegate = self;
        _tagsFilterView.tagsCollection.dataSource = self;
        
        [_tagsFilterView.tagsCollection registerClass:[ClassSubjectCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
        
    }
    
    return _tagsFilterView;
    
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
