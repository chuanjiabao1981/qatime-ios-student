//
//  MultifiltersViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/16.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "MultifiltersViewController.h"
#import "NavigationBar.h"
#import "ClassSubjectCollectionViewCell.h"
#import "UIControl+RemoveTarget.h"

@interface MultifiltersViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
    NavigationBar *_navigationBar;
    
    NSArray *_filters;
    
    NSArray *_filtersCompare;
    
    //传出去的筛选条件
    __block NSMutableDictionary *_filtersDic;
    
    HcdDateTimePickerView *_picker;     //日期选择器
    
    //是否改变了筛选项
    BOOL hasChange;
    
    //一个保存已筛选条件的数组
    NSMutableArray <NSIndexPath *>*_filtedArray;  //只存保存item的indexpath
    
    UILabel *sectionLabel1;
    UILabel *sectionLabel2;
    UILabel *sectionLabel3;
    
}

@end

@implementation MultifiltersViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //筛选条件直接从本地拿
        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"Filter"]) {
            _filtersDic =[[[NSUserDefaults standardUserDefaults]valueForKey:@"Filter"] mutableCopy];
        }else{
            
            _filtersDic = @{}.mutableCopy;
        }
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化数据
    
    _filtedArray = @[].mutableCopy;
    
    _filters = @[
                 @[@"所有",@"近一个月",@"近两个月",@"近三个月",@"近半年",@"近一年"],
//                 @[@"不限",@"招生中",@"开课中"],
                 @[@"不限",@"收费课程",@"免费课程"]
                 ];
    
    _filtersCompare =@[@[@"allTime",@"1_months",@"2_months",@"3_months",@"6_months",@"1_year"],
//                       @[@"allStatus",@"published",@"teaching"],
                       @[@"all",@"charge",@"free"]
                       ];
    
    //如果有数据,加载已选数据
    [self checkFilted];
    
    //加载导航栏
    [self navigation];
    
    //加载视图
    [self setupViews];
    
}

//加载已选数据
- (void)checkFilted{
    
    //如果有数据,加载已选数据
    if (_filtersDic.allKeys.count != 0) {
        
        //转换数据
        [self makeTransfer:_filtersDic];
        
        for (NSString *key in _filtersDic) {
            NSInteger sec = 0;
            for (NSArray *arr in _filtersCompare) {
                NSInteger row = 0;
                for (NSString *value in arr) {
                    if (![key isEqualToString:@"q[class_date_gteq]"]&&![key isEqualToString:@"q[class_date_lt]"]) {
                        if ([_filtersDic[key]isEqualToString:value]) {
                            [_filtedArray addObject:[NSIndexPath indexPathForItem:row inSection:sec]];
                            NSLog(@"%ld,%ld",row,sec);
                        }
                    }
                    
                    row++;
                }
                sec ++;
            }
        }
    }
    
}


//筛选字典转义 :中文转英文
- (void)makeTransfer:(__kindof NSDictionary *)dics{
    
    NSDictionary *filtDic = dics.mutableCopy;
    
    for (NSString *key in filtDic) {
//        if ([key isEqualToString:@"q[status_eq]"]) {
//            if ([filtDic[key] isEqualToString:@"招生中"]) {
//                [_filtersDic setValue:@"published" forKey:key];
//            }else if ([filtDic[key] isEqualToString:@"开课中"]) {
//                [_filtersDic setValue:@"teaching" forKey:key];
//            }
//
//        }else
        if ([key isEqualToString:@"range"]){
            if ([filtDic[key] isEqualToString:@"近一个月"]) {
                [_filtersDic setValue:@"1_months" forKey:key];
            }else if ([filtDic[key] isEqualToString:@"近两个月"]) {
                [_filtersDic setValue:@"2_months" forKey:key];
            }else if ([filtDic[key] isEqualToString:@"近三个月"]) {
                [_filtersDic setValue:@"3_months" forKey:key];
            }else if ([filtDic[key] isEqualToString:@"近半年"]) {
                [_filtersDic setValue:@"6_months" forKey:key];
            }else if ([filtDic[key] isEqualToString:@"近一年"]) {
                [_filtersDic setValue:@"1_year" forKey:key];
            }
        }else if ([key isEqualToString:@"q[sell_type_eq]"]){
            if ([filtDic[key] isEqualToString:@"收费课程"]) {
                [_filtersDic setValue:@"charge" forKey:key];
            }else if ([filtDic[key] isEqualToString:@"免费课程"]) {
                [_filtersDic setValue:@"free" forKey:key];
            }

        }
    }
    
}

//加载导航栏
- (void)navigation{
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview:_navigationBar];
    _navigationBar.titleLabel.text = @"筛选";
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    
    UIButton *rightButton = [[UIButton alloc]init];
    [_navigationBar addSubview:rightButton];
    
    [rightButton setTitle:@"重置" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(resetAll) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    rightButton.sd_layout
    .rightSpaceToView(_navigationBar,15)
    .topEqualToView(_navigationBar.leftButton)
    .bottomEqualToView(_navigationBar.leftButton)
    .widthIs(80);
    
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
}


/**
 加载视图
 */
- (void)setupViews{
    
    _multiFiltersView = [[MultiFiltersView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_navigationBar.frame), self.view.width_sd, self.view.height_sd-Navigation_Height)];
    [self.view addSubview:_multiFiltersView];
    _multiFiltersView.backgroundColor = [UIColor whiteColor];
    _multiFiltersView.filtersCollection.dataSource = self;
    _multiFiltersView.filtersCollection.delegate = self;
    
    /* collectionView 注册cell、headerID、footerId*/
    [_multiFiltersView.filtersCollection registerClass:[ClassSubjectCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [_multiFiltersView.filtersCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerId"];
    [_multiFiltersView.filtersCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerId2"];
    [_multiFiltersView.filtersCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerId"];
    [_multiFiltersView.filtersCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerId2"];
    
    
    //立即筛选按钮
    _filterButton = ({
        UIButton *_ =[[UIButton alloc]init];
        [self.view addSubview:_];
        [_ addTarget:self action:@selector(filtered) forControlEvents:UIControlEventTouchUpInside];
        [_ setTitle:@"立即筛选" forState:UIControlStateNormal];
        [_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_ setBackgroundColor:BUTTONRED];
        _.titleLabel.font = TEXT_FONTSIZE;
        _.sd_layout
        .bottomSpaceToView(self.view,20)
        .centerXEqualToView(self.view)
        .widthRatioToView(self.view,1/3.0)
        .heightIs(40.0*ScrenScale);
        
        _;
    });
    
    
}

///立即筛选
- (void)filtered{
    
    [[NSUserDefaults standardUserDefaults]setValue:_filtersDic forKey:@"Filter"];
    
    [self returnLastPage];
    self.componentsBlock(hasChange);
    
}



#pragma mark- collection datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger number = 0;
    NSInteger index = 0;
    for (NSArray *arrs in _filters) {
        if (section == index) {
            number = arrs.count;
        }
        index ++;
    }
    return number;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"cellId";
    ClassSubjectCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (_filters.count>indexPath.section) {
        
        NSInteger index = 0;
        
        for (NSArray *arrs in _filters) {
            
            if (indexPath.section == index) {
                
                cell.subject.text = arrs[indexPath.row];
                
            }
            index++;
        }
    }
    
    if ([[_filtersDic allKeys]count]==0) {
        
        //先全部弄成默认
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                
                cell.subject.layer.borderColor = NAVIGATIONRED.CGColor;
                cell.subject.textColor = NAVIGATIONRED;

            }else{
                
                cell.subject.layer.borderColor = TITLECOLOR.CGColor;
                cell.subject.textColor = TITLECOLOR;
            }
            
        }
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                
                cell.subject.layer.borderColor = NAVIGATIONRED.CGColor;
                cell.subject.textColor = NAVIGATIONRED;
                
            }else{
                
                cell.subject.layer.borderColor = TITLECOLOR.CGColor;
                cell.subject.textColor = TITLECOLOR;
            }
        }
        if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                
                cell.subject.layer.borderColor = NAVIGATIONRED.CGColor;
                cell.subject.textColor = NAVIGATIONRED;
                
            }else{
                
                cell.subject.layer.borderColor = TITLECOLOR.CGColor;
                cell.subject.textColor = TITLECOLOR;
            }
        }
        
    }else{
        //先全部弄成默认
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                
                cell.subject.layer.borderColor = NAVIGATIONRED.CGColor;
                cell.subject.textColor = NAVIGATIONRED;
                
            }else{
                
                cell.subject.layer.borderColor = TITLECOLOR.CGColor;
                cell.subject.textColor = TITLECOLOR;
            }
            
        }
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                
                cell.subject.layer.borderColor = NAVIGATIONRED.CGColor;
                cell.subject.textColor = NAVIGATIONRED;
                
            }else{
                
                cell.subject.layer.borderColor = TITLECOLOR.CGColor;
                cell.subject.textColor = TITLECOLOR;
            }
        }
        if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                
                cell.subject.layer.borderColor = NAVIGATIONRED.CGColor;
                cell.subject.textColor = NAVIGATIONRED;
                
            }else{
                
                cell.subject.layer.borderColor = TITLECOLOR.CGColor;
                cell.subject.textColor = TITLECOLOR;
            }
        }
        
        
        for (NSIndexPath *indexpath in _filtedArray) {
            if ([indexpath isEqual:indexPath]) {
                
                if (indexpath.row!=0) {
                
                    ClassSubjectCollectionViewCell *cell2 = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexpath.section]];
                    cell2.subject.layer.borderColor = TITLECOLOR.CGColor;
                    cell2.subject.textColor = TITLECOLOR;
                }
                
                cell.subject.layer.borderColor = NAVIGATIONRED.CGColor;
                cell.subject.textColor = NAVIGATIONRED;
            }
            
        }
        
    }
    
    //数组里缺少哪个  就补充哪个
    
    return cell;
}


#pragma mark- colelction delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return _filters.count;
    
}

//item间距
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(20, 20, 0, 20);
}

//行距
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 20;
}

//选择item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //遍历section内所有item,变成未选
    
    hasChange = YES;
    
    NSInteger item = 0;
    //同一section全变成未选
    for (NSString *title in _filters[indexPath.section]) {
        
        ClassSubjectCollectionViewCell *cell = (ClassSubjectCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:indexPath.section]];
        cell.subject.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
        cell.subject.textColor = TITLECOLOR;
        item ++;
    }
    
    
    ClassSubjectCollectionViewCell *cell = (ClassSubjectCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.subject.layer.borderColor = TITLERED.CGColor;
    cell.subject.textColor = TITLERED;
    
    switch (indexPath.section) {
        case 0:{
            if ([cell.subject.text isEqualToString:@"所有"]) {
                if (_filtersDic[@"range"]) {
                    [_filtersDic removeObjectForKey:@"range"];
                }
            }else if([cell.subject.text isEqualToString:@"近一个月"]){
                [_filtersDic setValue:@"1_months" forKey:@"range"];
                
            }else if([cell.subject.text isEqualToString:@"近两个月"]){
                [_filtersDic setValue:@"2_months" forKey:@"range"];
                
            }else if([cell.subject.text isEqualToString:@"近三个月"]){
                [_filtersDic setValue:@"3_months" forKey:@"range"];
                
            }else if([cell.subject.text isEqualToString:@"近半年"]){
                [_filtersDic setValue:@"6_months" forKey:@"range"];
                
            }else if([cell.subject.text isEqualToString:@"近一年"]){
                [_filtersDic setValue:@"1_year" forKey:@"range"];
                
            }
        }
            break;
//        case 1:{
//            if ([cell.subject.text isEqualToString:@"不限"]) {
//                [_filtersDic removeObjectForKey:@"q[status_eq]"];
//            }else if ([cell.subject.text isEqualToString:@"招生中"]) {
//                [_filtersDic setValue:@"published" forKey:@"q[status_eq]"];
//            }else if ([cell.subject.text isEqualToString:@"开课中"]) {
//                [_filtersDic setValue:@"teaching" forKey:@"q[status_eq]"];
//            }
//        }
//            break;
        case 1:{
            if ([cell.subject.text isEqualToString:@"不限"]) {
                if (_filtersDic[@"q[sell_type_eq]"]) {
                    [_filtersDic removeObjectForKey:@"q[sell_type_eq]"];
                }
            }else if ([cell.subject.text isEqualToString:@"收费课程"]){
                [_filtersDic setValue:@"charge" forKey:@"q[sell_type_eq]"];
            }else if ([cell.subject.text isEqualToString:@"免费课程"]){
                [_filtersDic setValue:@"free" forKey:@"q[sell_type_eq]"];
            }
            
        }
            break;
    }
    
}


//section header and footer
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *view;
    
    //section 0
    if (indexPath.section == 0) {
        //header
        if (kind == UICollectionElementKindSectionHeader){
            UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerId" forIndexPath:indexPath];
            
            sectionLabel1 = [[UILabel alloc]init];
            sectionLabel1.text = @"显示范围";
            sectionLabel1.textColor = TITLECOLOR;
            sectionLabel1.font = TEXT_FONTSIZE;
            [header addSubview:sectionLabel1];
            sectionLabel1.sd_layout
            .leftSpaceToView(header,20*ScrenScale)
            .bottomSpaceToView(header,0)
            .autoHeightRatio(0);
            [sectionLabel1 setSingleLineAutoResizeWithMaxWidth:100];
            
            view = header;
        }
        //footer
        if (kind == UICollectionElementKindSectionFooter){
            UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerId" forIndexPath:indexPath];
            footer.backgroundColor = [UIColor whiteColor];
            view = footer;
        }
        
    }
    
    //section 1
//    if (indexPath.section == 1) {
//        //header
//        if (kind == UICollectionElementKindSectionHeader){
//            UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerId" forIndexPath:indexPath];
//
//            sectionLabel2 = [[UILabel alloc]init];
//            sectionLabel2.text = @"课程状态";
//            sectionLabel2.font = TEXT_FONTSIZE;
//            sectionLabel2.textColor = TITLECOLOR;
//            [header addSubview:sectionLabel2];
//            sectionLabel2.sd_layout
//            .leftSpaceToView(header,20*ScrenScale)
//            .bottomSpaceToView(header,0)
//            .autoHeightRatio(0);
//            [sectionLabel2 setSingleLineAutoResizeWithMaxWidth:100];
//
//            view = header;
//        }
//        if (kind == UICollectionElementKindSectionFooter){
//            UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerId" forIndexPath:indexPath];
//            footer.backgroundColor = [UIColor whiteColor];
//            view = footer;
//        }
//    }
    
    //section 2
    if (indexPath.section == 1) {
        //header
        if (kind == UICollectionElementKindSectionHeader){
            UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerId2" forIndexPath:indexPath];
            UILabel *label = [[UILabel alloc]init];
            label.font = TEXT_FONTSIZE;
            label.text = @"课程费用";
            label.textColor = TITLECOLOR;
            [header addSubview:label];
            label.sd_layout
            .leftSpaceToView(header,20*ScrenScale)
            .bottomSpaceToView(header,0)
            .autoHeightRatio(0);
            [label setSingleLineAutoResizeWithMaxWidth:100];
            
            view = header;
        }
        //footer
        if (kind == UICollectionElementKindSectionFooter){
            UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerId2" forIndexPath:indexPath];
            footer.backgroundColor = [UIColor whiteColor];
            sectionLabel3 = [[UILabel alloc]init];
            sectionLabel3.font = TEXT_FONTSIZE;
            sectionLabel3.text = @"开课时间";
            sectionLabel3.textColor = TITLECOLOR;
            [footer addSubview:sectionLabel3];
            sectionLabel3.sd_layout
            .leftSpaceToView(footer,20*ScrenScale)
            .topSpaceToView(footer,40*ScrenScale)
            .autoHeightRatio(0);
            [sectionLabel3 setSingleLineAutoResizeWithMaxWidth:100];
            
            //开始时间
            UIView *start = [[UIView alloc]init];
            [footer addSubview:start];
            start.layer.borderColor = TITLECOLOR.CGColor;
            start.layer.borderWidth = 1;
            
            start.sd_layout
            .topSpaceToView(sectionLabel3,30*ScrenScale)
            .leftSpaceToView(footer,20*ScrenScale)
            .heightIs(30*ScrenScale)
            .widthIs(self.view.width_sd/2-40*ScrenScale);
            
            UIImageView *image1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"日历灰"]];
            [start addSubview:image1];
            image1.sd_layout
            .rightSpaceToView(start,10*ScrenScale)
            .topSpaceToView(start,5*ScrenScale)
            .bottomSpaceToView(start,5*ScrenScale)
            .widthEqualToHeight();
            
            _startTime = [[UIButton alloc]init];
            [_startTime setTitle:@"选择开始时间" forState:UIControlStateNormal];
            [_startTime setTitleColor:TITLECOLOR forState:UIControlStateNormal];
            _startTime.titleLabel.font = [UIFont systemFontOfSize:15*ScrenScale];
            [_startTime removeAllTargets];
            [_startTime addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
            [start addSubview:_startTime];
            start.userInteractionEnabled = YES;
            _startTime.sd_layout
            .leftSpaceToView(start,10*ScrenScale)
            .topSpaceToView(start,5*ScrenScale)
            .bottomSpaceToView(start,5*ScrenScale)
            .rightSpaceToView(image1,10*ScrenScale);
            [_startTime setEnlargeEdge:20];
            _startTime.titleLabel.font = TEXT_FONTSIZE_MIN;
            //结束时间
            UIView *end = [[UIView alloc]init];
            [footer addSubview:end];
            end.layer.borderColor = TITLECOLOR.CGColor;
            end.layer.borderWidth = 1;
            end.sd_layout
            .topEqualToView(start)
            .bottomEqualToView(start)
            .rightSpaceToView(footer,20*ScrenScale)
            .widthRatioToView(start,1.0);
            
            UIImageView *image2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"日历灰"]];
            [end addSubview:image2];
            
            image2.sd_layout
            .rightSpaceToView(end,10*ScrenScale)
            .topSpaceToView(end,5*ScrenScale)
            .bottomSpaceToView(end,5*ScrenScale)
            .widthEqualToHeight();
            
            _endTime = [[UIButton alloc]init];
            [_endTime setTitle:@"选择结束时间" forState:UIControlStateNormal];
            [_endTime setTitleColor:TITLECOLOR forState:UIControlStateNormal];
            _endTime.titleLabel.font = [UIFont systemFontOfSize:15*ScrenScale];
            [_endTime removeAllTargets];
            [_endTime addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
            [end addSubview:_endTime];
            end.userInteractionEnabled = YES;
            _endTime.titleLabel.font = TEXT_FONTSIZE_MIN;
            _endTime.sd_layout
            .leftSpaceToView(end,10*ScrenScale)
            .topSpaceToView(end,5*ScrenScale)
            .bottomSpaceToView(end,5*ScrenScale)
            .rightSpaceToView(image2,10*ScrenScale);
//            [_endTime setEnlargeEdge:20];
            
            //杠
            UILabel *dots = [[UILabel alloc]init];
            [footer addSubview:dots];
            dots.text = @"-";
            dots.sd_layout
            .leftSpaceToView(start,0)
            .rightSpaceToView(end,0)
            .topEqualToView(start)
            .bottomEqualToView(start);
            
            view = footer;
        }

    }
    
    return view;
    
}

#pragma mark- collection flowlayout
//header高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(self.view.width_sd, 40*ScrenScale);
    
}
//footer高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    CGSize size = CGSizeZero;
    
    if (section == 1) {
        size = CGSizeMake(self.view.width_sd, 200*ScrenScale);
    }else{
        
        size = CGSizeMake(self.view.height_sd, 20*ScrenScale);
    }
    
    return size;
    
}

//选择时间
- (void)selectTime:(UIButton *)sender{
    
    _picker = [[HcdDateTimePickerView alloc]initWithDatePickerMode:DatePickerDateMode defaultDateTime:[NSDate date]];
    [_picker setMinYear:2014];
    [_picker setMaxYear:2018];
    [_picker showHcdDateTimePicker];
    if (_picker) {
        [self.view addSubview:_picker];
        [_picker showHcdDateTimePicker];
    }
    
    _picker.clickedOkBtn =  ^(NSString * datetimeStr){
        
        [sender setTitle:datetimeStr forState:UIControlStateNormal];
        
        if (sender == _startTime) {
            
            [_filtersDic setValue:datetimeStr forKey:@"q[class_date_gteq]"];
            
        }else if (sender == _endTime){
            
            [_filtersDic setValue:datetimeStr forKey:@"q[class_date_lt]"];
            
        }
    };
}


//重置功能
- (void)resetAll{
    
    hasChange = YES;
    
    NSInteger section = 0;
    NSInteger row = 0;
    for (NSArray *arr in _filters) {
        
        for (NSString *title in arr) {
            ClassSubjectCollectionViewCell *cell = (ClassSubjectCollectionViewCell *)[_multiFiltersView.filtersCollection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:row inSection:section]];
            
            cell.subject.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
            cell.subject.textColor = TITLECOLOR;
            
            row++;
        }
        ClassSubjectCollectionViewCell *cell= (ClassSubjectCollectionViewCell *)[_multiFiltersView.filtersCollection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        
        cell.subject.layer.borderColor = BUTTONRED.CGColor;
        cell.subject.textColor = BUTTONRED;
        
        section ++;
        row =0;
    }
    
    [_startTime setTitle:@"选择开始时间" forState:UIControlStateNormal];
    [_endTime setTitle:@"选择结束时间" forState:UIControlStateNormal];
    
    _filtersDic = @{}.mutableCopy;
    
}


//block
- (void)multiFilters:(multiFilters)changed{
    
    self.componentsBlock = changed;
}


//返回上一页
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
