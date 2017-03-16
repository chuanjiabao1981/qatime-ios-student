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

@interface MultifiltersViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
    NavigationBar *_navigationBar;
    
    NSArray *_filters;
    
    __block NSMutableDictionary *_filtersDic;
    
    HcdDateTimePickerView *_picker;     //日期选择器
    
}

@end

@implementation MultifiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化数据
    _filtersDic = @{}.mutableCopy;
    _filters = @[
                 @[@"所有",@"近一个月",@"近两个月",@"近三个月",@"近半年",@"近一年"],
                 @[@"不限",@"招生中",@"开课中"],
                 @[@"不限",@"免费试听",@"无试听"]
                 ];
    //加载导航栏
    [self navigation];
    
    //加载视图
    [self setupViews];
    
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
    [_multiFiltersView.filtersCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerId"];
    
    
    //立即筛选按钮
    _filterButton = ({
        UIButton *_ =[[UIButton alloc]init];
        [self.view addSubview:_];
        [_ addTarget:self action:@selector(filtered) forControlEvents:UIControlEventTouchUpInside];
        [_ setTitle:@"立即筛选" forState:UIControlStateNormal];
        [_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_ setBackgroundColor:BUTTONRED];
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
    
    [self returnLastPage];
    
    if (self.componentsBlock!=nil) {
        
        self.componentsBlock(_filtersDic);
    }
    
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
    
    //设置默认值
    if (indexPath.section == 0) {
        if (indexPath.row ==0) {
            cell.subject.layer.borderColor = TITLERED.CGColor;
            cell.subject.textColor = TITLERED;
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row ==0) {
            cell.subject.layer.borderColor = TITLERED.CGColor;
            cell.subject.textColor = TITLERED;
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row ==0) {
            cell.subject.layer.borderColor = TITLERED.CGColor;
            cell.subject.textColor = TITLERED;
        }
    }
    
    
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
    
    NSInteger item = 0;
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
                if (_filtersDic[@"显示范围"]) {
                    [_filtersDic removeObjectForKey:@"显示范围"];
                }
                
            }else{
                
                [_filtersDic setValue:cell.subject.text forKey:@"显示范围"];
            }
        }
            break;
        case 1:{
            if ([cell.subject.text isEqualToString:@"不限"]) {
                [_filtersDic setValue:@"all" forKey:@"status"];
            }else if ([cell.subject.text isEqualToString:@"招生中"]) {
                [_filtersDic setValue:@"published" forKey:@"status"];
            }else if ([cell.subject.text isEqualToString:@"开课中"]) {
                [_filtersDic setValue:@"teaching" forKey:@"status"];
            }
        }
            break;
        case 2:{
            if ([cell.subject.text isEqualToString:@"不限"]) {
                if (_filtersDic[@"试听状态"]) {
                    [_filtersDic removeObjectForKey:@"试听状态"];
                }
                
            }else{
                
                [_filtersDic setValue:cell.subject.text forKey:@"试听状态"];
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
            
            UILabel *label = [[UILabel alloc]init];
            label.text = @"显示范围";
            label.textColor = TITLECOLOR;
            [header addSubview:label];
            label.sd_layout
            .leftSpaceToView(header,20)
            .bottomSpaceToView(header,0)
            .autoHeightRatio(0);
            [label setSingleLineAutoResizeWithMaxWidth:100];
            
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
    if (indexPath.section == 1) {
        //header
        if (kind == UICollectionElementKindSectionHeader){
            UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerId" forIndexPath:indexPath];
            
            UILabel *label = [[UILabel alloc]init];
            label.text = @"status";
            label.textColor = TITLECOLOR;
            [header addSubview:label];
            label.sd_layout
            .leftSpaceToView(header,20)
            .bottomSpaceToView(header,0)
            .autoHeightRatio(0);
            [label setSingleLineAutoResizeWithMaxWidth:100];
            
            view = header;
        }
        
        //footer
        if (kind == UICollectionElementKindSectionFooter){
            UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerId" forIndexPath:indexPath];
            footer.backgroundColor = [UIColor whiteColor];
            view = footer;
        }
        
        
    }
    
    //section 2
    if (indexPath.section == 2) {
        //header
        if (kind == UICollectionElementKindSectionHeader){
            UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerId" forIndexPath:indexPath];
            UILabel *label = [[UILabel alloc]init];
            label.text = @"试听状态";
            label.textColor = TITLECOLOR;
            [header addSubview:label];
            label.sd_layout
            .leftSpaceToView(header,20)
            .bottomSpaceToView(header,0)
            .autoHeightRatio(0);
            [label setSingleLineAutoResizeWithMaxWidth:100];
            
            view = header;
        }
        
        //footer
        if (kind == UICollectionElementKindSectionFooter){
            UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerId" forIndexPath:indexPath];
            footer.backgroundColor = [UIColor whiteColor];
            
            UILabel *label = [[UILabel alloc]init];
            label.text = @"开课时间";
            label.textColor = TITLECOLOR;
            [footer addSubview:label];
            label.sd_layout
            .leftSpaceToView(footer,20)
            .topSpaceToView(footer,40)
            .autoHeightRatio(0);
            [label setSingleLineAutoResizeWithMaxWidth:100];
            
            //开始时间
            UIView *start = [[UIView alloc]init];
            [footer addSubview:start];
            start.layer.borderColor = TITLECOLOR.CGColor;
            start.layer.borderWidth = 1;
            
            start.sd_layout
            .topSpaceToView(label,30)
            .leftSpaceToView(footer,20)
            .heightIs(30)
            .widthIs(self.view.width_sd/2-40);
            
            UIImageView *image1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"礼物"]];
            [start addSubview:image1];
            image1.sd_layout
            .rightSpaceToView(start,10)
            .topSpaceToView(start,5)
            .bottomSpaceToView(start,5)
            .widthEqualToHeight();
            
            _startTime = [[UIButton alloc]init];
            [_startTime setTitle:@"选择开始时间" forState:UIControlStateNormal];
            [_startTime setTitleColor:TITLECOLOR forState:UIControlStateNormal];
            _startTime.titleLabel.font = [UIFont systemFontOfSize:15*ScrenScale];
            [_startTime setEnlargeEdge:20];
            
            [_startTime addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
            [start addSubview:_startTime];
            _startTime.sd_layout
            .leftSpaceToView(start,10)
            .topSpaceToView(start,5)
            .bottomSpaceToView(start,5)
            .rightSpaceToView(image1,10);
            
            //结束时间
            UIView *end = [[UIView alloc]init];
            [footer addSubview:end];
            end.layer.borderColor = TITLECOLOR.CGColor;
            end.layer.borderWidth = 1;
            
            end.sd_layout
            .topEqualToView(start)
            .bottomEqualToView(start)
            .rightSpaceToView(footer,20)
            .widthRatioToView(start,1.0);
            
            UIImageView *image2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"礼物"]];
            [end addSubview:image2];
            image2.sd_layout
            .rightSpaceToView(end,10)
            .topSpaceToView(end,5)
            .bottomSpaceToView(end,5)
            .widthEqualToHeight();
            
            _endTime = [[UIButton alloc]init];
            [_endTime setTitle:@"选择结束时间" forState:UIControlStateNormal];
            [_endTime setTitleColor:TITLECOLOR forState:UIControlStateNormal];
            _endTime.titleLabel.font = [UIFont systemFontOfSize:15*ScrenScale];
            [_endTime setEnlargeEdge:20];
            [_endTime addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
            [end addSubview:_endTime];
            _endTime.sd_layout
            .leftSpaceToView(end,10)
            .topSpaceToView(end,5)
            .bottomSpaceToView(end,5)
            .rightSpaceToView(image2,10);
            
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
    
    return CGSizeMake(self.view.width_sd, 40);
    
}
//footer高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    CGSize size = CGSizeZero;
    
    if (section == 2) {
        size = CGSizeMake(self.view.width_sd, 200);
    }else{
        
        size = CGSizeMake(self.view.height_sd, 20);
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
            
            [_filtersDic setValue:datetimeStr forKey:@"class_date_floor"];
            
        }else if (sender == _endTime){
            
            [_filtersDic setValue:datetimeStr forKey:@"class_date_ceil"];
            
        }
    };
}


//重置功能
- (void)resetAll{
    
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
    
    
    if (_filtersDic[@"显示范围"]) {
        [_filtersDic removeObjectForKey:@"显示范围"];
    }
    if (_filtersDic[@"status"]) {
        [_filtersDic removeObjectForKey:@"status"];
    }
    if (_filtersDic[@"试听状态"]) {
        [_filtersDic removeObjectForKey:@"试听状态"];
    }
    

}


//block
- (void)multiFilters:(multiFilters)components{
    
    self.componentsBlock = components;
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
