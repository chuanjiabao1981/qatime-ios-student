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
#import "HaveNoClassView.h"
#import "TutoriumInfoViewController.h"
#import "OneOnOneTutoriumInfoViewController.h"
#import "BEMCheckBox.h"

#define Filter_Height 40


@interface ChooseClassViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,BEMCheckBoxDelegate>{
    
//    
    NSString *_grade;
    NSString *_subject;
    NavigationBar *_navigationBar;
//
    //加载课程页数
    NSInteger page;
    //每页条数
    NSInteger perPage;
//
    //弹窗蒙版
    SnailQuickMaskPopups *_pops;
//
    //筛选tag的存放数组
    NSMutableArray *_tags ;
//
    //存课程数据的数组
    NSMutableArray *_classesArray;
//
//    /**
//     三个不同的源,
//     根据课程类型的不同变化三个源
//     */
//    /**直播课的dataArray*/
//    NSMutableArray *_liveClassArray;
//    
//    /**一对一课的dataArray*/
//    NSMutableArray *_interactionClassArray;
//    
//    /**视频课的dataArray*/
//    NSMutableArray *_videoClassArray;
//    
    //筛选用的字典->传入每个childController用
    NSMutableDictionary *_filterDic;
//
//    //是否为初始化下拉
//    __block BOOL isInitPull;
//    
//    //搜索类型
//    SearchType _type;
//    
//    //接口信息
//    NSString *_course;
    
}

/**分段控制器*/
@property (nonatomic, strong) UISegmentedControl *segmentControl ;


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

    _tags = @[].mutableCopy;
    _filterDic = @{}.mutableCopy;
    
    
    //导航栏和主视图参考图
    [self setupNavigation];
    //第一视图
    [self addChildViewController:self.liveClassFilterController];
    [self.liveClassFilterController didMoveToParentViewController:self];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //根据筛选项,获取响应的tag
        [self getTags];
    });
    
    
}

/**切换segment*/
- (void)didSelectedOnSegment:(UISegmentedControl *)segment{
    
    switch (segment.selectedSegmentIndex) {
        case 0:{
            
            [self.view addSubview:self.liveClassFilterController.view];
            [self.liveClassFilterController didMoveToParentViewController:self];
           
            _filterView.mode = LiveClassMode;
            
        }
            break;
            
        case 1:{
            [self.view addSubview:self.interactionClassFilterController.view];
            [self.interactionClassFilterController didMoveToParentViewController:self];
         
            _filterView.mode = InteractionMode;
            
        }
            break;
        case 2:{
            
            [self.view addSubview:self.videoClassFilterController.view];
            [self.videoClassFilterController didMoveToParentViewController:self];
            
            _filterView.mode = VideoMode;
        }
            break;
    }
    
    
}

//获取本地存储的tag数据
- (void)getTags{
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/app_constant/tags",Request_Header] withHeaderInfo:nil andHeaderfield:nil parameters:@{@"cates":[NSString stringWithFormat:@"%@,%@",_grade,_subject]} completeSuccess:^(id  _Nullable responds) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            for (NSDictionary *tag in dic[@"data"]) {
                [_tags addObject:tag[@"name"]];
            }
            
            [_tagsFilterView.tagsCollection reloadData];
            
        }else{
            
        }
        
    }];
    
}

#pragma mark- CheckBox delegate

-(void)didTapCheckBox:(BEMCheckBox *)checkBox{
    
    if (checkBox.on == YES) {
        //筛选免费视频课
        [_videoClassFilterController filteredForFree:YES];
        
    }else{
        //筛选收费视频课
        [_videoClassFilterController filteredForFree:NO];
    }
    
}




#pragma mark- collectionview datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _tags.count;
    
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"CollectionCell";
    ClassSubjectCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.subject.text = _tags[indexPath.row];
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
    
    [_filterView.tagsButton setTitle:_tags[indexPath.row] forState:UIControlStateNormal];
    
    //蒙版消失之后 ,执行操作
    [_pops dismissWithAnimated:YES completion:^(BOOL finished, SnailQuickMaskPopups * _Nonnull popups) {
        
        
        //发起筛选请求
        switch (_segmentControl.selectedSegmentIndex) {
            case 0:{
                
                [_liveClassFilterController filteredByTages:_tags[indexPath.row]];
            }
                break;
                
            case 1:{
                [_interactionClassFilterController filteredByTages:_tags[indexPath.row]];
            }
                break;
            case 2:{
                [_videoClassFilterController filteredByTages:_tags[indexPath.row]];
            }
                break;
        }

        
    }];
    
}


//加载navigation
- (void)setupNavigation{
    
    _navigationBar = ({
        NavigationBar *_ =[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
        [self.view addSubview:_];
//        NSString *modal;
        //判断类型
//        if (_type == TutoriumType) {
//            modal = [NSString stringWithFormat:@"直播课"];
//        }else if (_type == InteractionType){
//            modal =[NSString stringWithFormat:@"一对一"];
//        }
        
//        _.titleLabel.text = [NSString stringWithFormat:@"%@%@%@",_grade,_subject,modal]
        
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        
        _;
        
    });
    
    //分段控制器
    _segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"直播课",@"一对一",@"视频课"]];
    [_navigationBar addSubview:_segmentControl];
    _segmentControl.apportionsSegmentWidthsByContent = YES;
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.sd_layout
    .leftSpaceToView(_navigationBar.leftButton, 25*ScrenScale)
    .rightSpaceToView(_navigationBar.rightButton, 25*ScrenScale)
    .topEqualToView(_navigationBar.leftButton)
    .bottomEqualToView(_navigationBar.leftButton);
    _segmentControl.tintColor = [UIColor whiteColor];
    [_segmentControl addTarget:self action:@selector(didSelectedOnSegment:) forControlEvents:UIControlEventValueChanged];

    
    //多项筛选栏
    _filterView = [[ClassFilterView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_navigationBar.frame), self.view.width_sd, Filter_Height)];
    
    [self.view addSubview:_filterView];
    
    [_filterView.newestButton setTitleColor:TITLECOLOR forState:UIControlStateNormal];
    [_filterView.newestArrow setImage:[UIImage imageNamed:@"上箭头"]];
    _filterView.mode = LiveClassMode;
    
    _filterView.freeButton.delegate = self;
    
    //主视图参考图
    _chooseView = [[ChooseClassView alloc]init];
    _chooseView.frame = CGRectMake(0, _navigationBar.height_sd+_filterView.height_sd, self.view.width_sd, self.view.height_sd-_navigationBar.height_sd-_filterView.height_sd);
    
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
    
    //根据人气,判断有些按钮是否要显示
//    if (_type == TutoriumSearchType) {
//        
//        _filterView.type = TutoriumType;
//    }else if (_type == InteractionSearchType){
//        
//        _filterView.type = InteractionType;
//    }
    
}

//选择标签按钮
- (void)chooseTags:(UIButton *)sender{
    
    _pops = [SnailQuickMaskPopups popupsWithMaskStyle:MaskStyleBlackTranslucent aView:self.tagsFilterView];
    
    //已选过 和未选过的情况
    if (![sender.titleLabel.text isEqualToString:@"标签"]) {
        //把tag选项表的所有按钮遍历成未选中状态
        NSInteger index = 0;
        for (NSString *title in _tags) {
            
            if ([sender.titleLabel.text isEqualToString:title]) {
                
                ClassSubjectCollectionViewCell *cell = (ClassSubjectCollectionViewCell *)[_tagsFilterView.tagsCollection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
                
                cell.subject.textColor = BUTTONRED;
                cell.subject.layer.borderColor = BUTTONRED.CGColor;
                
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

/**
 筛选最新
 */
- (void)newestFilter:(UIButton *)sender{
    page = 1;
    [_filterDic setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    //重置所有按钮
    [self filterButtonTurnReset];
    [sender setTitleColor:TITLECOLOR forState:UIControlStateNormal];
    //如果已有sort_by字段
    if (_filterDic[@"sort_by"]) {
        //如果是价格筛选字段 正序或倒序
        if ([_filterDic[@"sort_by"] isEqualToString:@"published_at.asc"]||[_filterDic[@"sort_by"] isEqualToString:@"published_at"]) {
            //正序
            if ([_filterDic[@"sort_by"] isEqualToString:@"published_at.asc"]) {
                [_filterDic removeObjectForKey:@"sort_by"];
                //改成倒序
                _filterDic = @{@"sort_by":@"published_at"}.mutableCopy;
                [_filterView.newestArrow setImage:[UIImage imageNamed:@"上箭头"]];
                
            }else if ([_filterDic[@"sort_by"] isEqualToString:@"published_at"]){
                //如果是倒序
                [_filterDic removeObjectForKey:@"sort_by"];
                //改成正序
                _filterDic = @{@"sort_by":@"published_at.asc"}.mutableCopy;
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
            _filterDic = @{@"sort_by":@"published_at.asc"}.mutableCopy;
            
        }
        
    }else{
        //如果没有筛选字段
        _filterDic =@{@"sort_by":@"published_at.asc"}.mutableCopy;
        [_filterView.newestArrow setImage:[UIImage imageNamed:@"下箭头"]];
    }
    
    //发起筛选请求

    switch (_segmentControl.selectedSegmentIndex) {
        case 0:{
            
            [_liveClassFilterController filterdByFilterDic:_filterDic];
        }
            break;
            
        case 1:{
            [_interactionClassFilterController filterdByFilterDic:_filterDic];
        }
            break;
        case 2:{
            [_videoClassFilterController filterdByFilterDic:_filterDic];
        }
            break;
    }
    
    
}



/**
 按价格筛选
 */
- (void)priceFilter:(UIButton *)sender{
    
    page = 1;
    [_filterDic setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    //重置所有按钮
    [self filterButtonTurnReset];
    
    [sender setTitleColor:TITLECOLOR forState:UIControlStateNormal];
    
    NSString *sort_by = @"".mutableCopy;
    NSString *sort_by_asc = @"".mutableCopy;
    switch (_segmentControl.selectedSegmentIndex) {
        case 0:
            sort_by = @"left_price";
            sort_by_asc = @"left_price.asc";
            break;
        case 1:
            sort_by = @"price";
            sort_by_asc = @"price.asc";
            break;
        case 2:
            sort_by = @"price";
            sort_by_asc = @"price.asc";
            break;
    }
    
    //如果已有sort_by字段
    if (_filterDic[@"sort_by"]) {
        //如果是价格筛选字段 正序或倒序
        if ([_filterDic[@"sort_by"] isEqualToString:sort_by_asc]||[_filterDic[@"sort_by"] isEqualToString:sort_by]) {
            //正序
            if ([_filterDic[@"sort_by"] isEqualToString:sort_by_asc]) {
                [_filterDic removeObjectForKey:@"sort_by"];
                //改成倒序
                _filterDic = @{@"sort_by":sort_by}.mutableCopy;
                [_filterView.priceArrow setImage:[UIImage imageNamed:@"上箭头"]];
                
            }else if ([_filterDic[@"sort_by"] isEqualToString:sort_by]){
                //如果是倒序
                [_filterDic removeObjectForKey:@"sort_by"];
                //改成正序
                _filterDic = @{@"sort_by":sort_by_asc}.mutableCopy;
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
            _filterDic = @{@"sort_by":sort_by_asc}.mutableCopy;
        }
        
    }else{
        //如果没有筛选字段
        _filterDic = @{@"sort_by":sort_by_asc}.mutableCopy;
        [_filterView.priceArrow setImage:[UIImage imageNamed:@"下箭头"]];
    }
    
    //发起筛选请求
    switch (_segmentControl.selectedSegmentIndex) {
        case 0:{
            
            [_liveClassFilterController filterdByFilterDic:_filterDic];
        }
            break;
            
        case 1:{
            [_interactionClassFilterController filterdByFilterDic:_filterDic];
        }
            break;
        case 2:{
            [_videoClassFilterController filterdByFilterDic:_filterDic];
        }
            break;
    }
}


/**
 按人气筛选
 */
- (void)countFilter:(UIButton *)sender{
    
    page = 1;
    [_filterDic setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    [sender setTitleColor:TITLECOLOR forState:UIControlStateNormal];
    //重置所有按钮
    [self filterButtonTurnReset];
    //如果已有sort_by字段
    if (_filterDic[@"sort_by"]) {
        //如果是人气筛选字段
        if ([_filterDic[@"sort_by"] isEqualToString:@"buy_tickets_count.asc"]||[_filterDic[@"sort_by"] isEqualToString:@"buy_tickets_count"]) {
            //正序
            if ([_filterDic[@"sort_by"] isEqualToString:@"buy_tickets_count.asc"]) {
                [_filterDic removeObjectForKey:@"sort_by"];
                //改成倒序
                _filterDic = @{@"sort_by":@"buy_tickets_count"}.mutableCopy;
                [_filterView.popularityArrow setImage:[UIImage imageNamed:@"上箭头"]];
                
            }else if ([_filterDic[@"sort_by"] isEqualToString:@"buy_tickets_count"]){
                //如果是倒序
                [_filterDic removeObjectForKey:@"sort_by"];
                //改成正序
                _filterDic = @{@"sort_by":@"buy_tickets_count.asc"}.mutableCopy;
                [_filterView.popularityArrow setImage:[UIImage imageNamed:@"下箭头"]];
                
            }
            
        }else{
            //如果不是人气筛选字段
            [_filterDic removeObjectForKey:@"sort_by"];
            //去掉后,改为正序
            _filterDic = @{@"sort_by":@"buy_tickets_count.asc"}.mutableCopy;
            
            //重置所有单选button
            [self filterButtonTurnReset];
            //按钮和箭头变化
            [sender setTitleColor:TITLECOLOR forState:UIControlStateNormal];
            [_filterView.popularityArrow setImage:[UIImage imageNamed:@"下箭头"]];
            
        }
        
    }else{
        //如果没有筛选字段
        _filterDic = @{@"sort_by":@"buy_tickets_count.asc"}.mutableCopy;
        _filterDic =@{@"sort_by":@"buy_tickets_count.asc"}.mutableCopy;
        [_filterView.popularityArrow setImage:[UIImage imageNamed:@"下箭头"]];
    }
    
    //发起筛选请求
    switch (_segmentControl.selectedSegmentIndex) {
        case 0:{
            
            [_liveClassFilterController filterdByFilterDic:_filterDic];
        }
            break;
            
        case 1:{
            [_interactionClassFilterController filterdByFilterDic:_filterDic];
        }
            break;
        case 2:{
            [_videoClassFilterController filterdByFilterDic:_filterDic];
        }
            break;
    }
    
}

//reset三个单项筛选按钮
- (void)filterButtonTurnReset{
    
    [_filterView.newestButton setTitleColor:SEPERATELINECOLOR_2 forState:UIControlStateNormal];
    [_filterView.priceButton setTitleColor:SEPERATELINECOLOR_2 forState:UIControlStateNormal];
    [_filterView.popularityButton setTitleColor:SEPERATELINECOLOR_2 forState:UIControlStateNormal];
    
    [_filterView.newestArrow setImage:nil];
    [_filterView.priceArrow setImage:nil];
    [_filterView.popularityArrow setImage:nil];
    
}






//多项筛选
- (void)multiFilters{
    
    NSArray *arr = @[@"range",@"q[status_eq]",@"试听状态"];
    
    NSMutableDictionary *filters = _filterDic.mutableCopy;
    
    //去掉其他的筛选条件
    for (NSString *key in _filterDic) {
        if (![arr containsObject:key]) {
            [filters removeObjectForKey:key];
        }
    }
    
    
    MultifiltersViewController *controller = [[MultifiltersViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
    
    
    /**
     多项筛选页面pop后传值回来
     
     @param component 筛选项目字典
     @return void
     */
    
    [controller multiFilters:^(BOOL changed) {
        
        if (changed == YES) {
            
            NSMutableDictionary *dics = [[NSUserDefaults standardUserDefaults]valueForKey:@"Filter"];
            [_filterDic setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
            
            [self multiFiltersRequest:dics];
        }else{
            
            
        }
        
    }];
    
}


//多项筛选
- (void)multiFiltersRequest:(NSMutableDictionary *)filterDic{
    
    NSMutableDictionary *filter = filterDic.mutableCopy;
    
    //加工数据
    if ([filterDic[@"range"]isEqualToString:@"allTime"]) {
        [filter setValue:@"" forKey:@"range"];
    }
    if ([filterDic[@"q[status_eq]"]isEqualToString:@"allStatus"]) {
        [filter setValue:@"" forKey:@"q[status_eq]"];
    }
    if ([filterDic[@"试听状态"]isEqualToString:@"all"]) {
        [filter setValue:@"" forKey:@"试听状态"];
    }
    
    if (filter) {
//        [_classTableView.mj_header beginRefreshingWithCompletionBlock:^{
        
//            [self requestClass:PullToRefresh withContentDictionary:filter];
//        }];
        
    }else{
        
//        [_classTableView.mj_header beginRefreshingWithCompletionBlock:^{
//            [self requestClass:PushToReadMore withContentDictionary:nil];
            
//        }];
    }
    
}

#pragma mark- GET Method 
//三个子controller
-(LiveClassFilterViewController *)liveClassFilterController{
    
    if (!_liveClassFilterController) {
        _liveClassFilterController = [[LiveClassFilterViewController alloc]initWithGrade:_grade andSubject:_subject andCourse:@"courses"];
        [self addChildViewController:_liveClassFilterController];
        [self.view addSubview:_liveClassFilterController.view];
        _liveClassFilterController.view.sd_layout
        .leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .topSpaceToView(_filterView, 0)
        .bottomSpaceToView(self.view, 0);
        
    }
    
    return _liveClassFilterController;
}

-(InteractionClassFilterViewController *)interactionClassFilterController{
    
    if (!_interactionClassFilterController) {
        _interactionClassFilterController  = [[InteractionClassFilterViewController alloc]initWithGrade:_grade andSubject:_subject andCourse:@"interactive_courses"];
        [self addChildViewController:_interactionClassFilterController];
        [self.view addSubview:_interactionClassFilterController.view];
        _interactionClassFilterController.view.sd_layout
        .leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .topSpaceToView(_filterView, 0)
        .bottomSpaceToView(self.view, 0);
        
    }
    return _interactionClassFilterController;
}

-(VideoClassFilterViewController *)videoClassFilterController{
    
    if (!_videoClassFilterController) {
        
        _videoClassFilterController = [[VideoClassFilterViewController alloc]initWithGrade:_grade andSubject:_subject andCourse:@"video_courses"];
        [self addChildViewController:_videoClassFilterController];
        [self.view addSubview:_videoClassFilterController.view];
        _videoClassFilterController.view.sd_layout
        .leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .topSpaceToView(_filterView, 0)
        .bottomSpaceToView(self.view, 0);
    }
    
    return _videoClassFilterController;
}




//懒加载标签筛选列表
-(TagsFilterView *)tagsFilterView{
    
    //获取所有tags
    //    [self getTags];
    
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
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Filter"];
    
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
