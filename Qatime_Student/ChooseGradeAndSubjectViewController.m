//
//  ChooseGradeAndSubjectViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ChooseGradeAndSubjectViewController.h"
#import "NavigationBar.h"
#import "ChooseGradeAndSubjectDelegate.h"
#import "ChooseClassViewController.h"

#import "ClassSubjectCollectionViewCell.h"
#import "UIViewController+AFHTTP.h"

#import "SearchTipsViewController.h"


@interface ChooseGradeAndSubjectViewController ()<ChooseGradeAndSubjectDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    
    NavigationBar *_navigationBar;
    
    NSMutableArray *subjects;
    
    NSString *_selectedGrade;
}


@end

@implementation ChooseGradeAndSubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    
    //加载视图
    [self setupViews];
    //基本信息(全部)
    subjects = @[@"全部",@"语文",@"数学",@"英语",@"历史",@"物理",@"政治",@"地理",@"生物",@"化学"].mutableCopy;
    
    [_chooseView.subjectCollection reloadData];
    
    //是否是前一页传来的年级
    if (_selectedFilterGrade) {
        
        for (UIButton *button in _chooseView.gradeButtons) {
            if ([_selectedFilterGrade isEqualToString:button.titleLabel.text]) {
                
                [_chooseView selected:button];
            }
        }
    }
    
    
    if (_selectedGrade == nil) {
        _selectedGrade = @"高三";
        [self chooseFilterGrade:[NSNotification notificationWithName:@"" object:@"高三"]];
        [_chooseView.subjectCollection reloadData];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //干掉筛选信息
        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"Filter"]) {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Filter"];
        }
        
        //加载所有的 tag
        [self getTags];
        
    });
    
}

//首页选择年级后的监听 ->初始化之后的方法 , 初始化之前在appdelegate里用set方法
- (void)chooseFilterGrade:(NSNotification *)notification{
    
    if ([notification object]!=nil) {
        
        for (UIButton *button in _chooseView.gradeButtons) {
            
            button.selected = NO;
            [button setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor clearColor]];
            
            if ([[notification object] isEqualToString:button.titleLabel.text]) {
                
                button.selected = YES;
                [button setTitleColor:BUTTONRED forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor whiteColor]];
            }
        }
        
        subjects = @[].mutableCopy;
        
        //课程表变化
        
        if ([[notification object] isEqualToString:@"初三"]) {
            //        语、数、英、物、化、政、历
            subjects = @[@"全部",@"语文",@"数学",@"英语",@"物理",@"化学",@"政治",@"历史"].mutableCopy;
        }else if ([[notification object] isEqualToString:@"初二"]){
            //        语、数、英、物、政、历、生、地
            subjects = @[@"全部",@"语文",@"数学",@"英语",@"物理",@"政治",@"历史",@"生物",@"地理"].mutableCopy;
        }else if ([[notification object] isEqualToString:@"初一"]){
            subjects = @[@"全部",@"语文",@"数学",@"英语",@"政治",@"历史",@"地理"].mutableCopy;
        }else if ([[notification object] isEqualToString:@"六年级"]||[[notification object] isEqualToString:@"五年级"]||[[notification object] isEqualToString:@"四年级"]||[[notification object] isEqualToString:@"三年级"]){
            //        语、数、英、科学
            subjects = @[@"全部",@"语文",@"数学",@"英语",@"科学"].mutableCopy;
        }else if ([[notification object] isEqualToString:@"一年级"]||[[notification object] isEqualToString:@"二年级"]){
            subjects = @[@"全部",@"语文",@"数学",@"英语"].mutableCopy;
        }else {
            subjects = @[@"全部",@"语文",@"数学",@"英语",@"历史",@"物理",@"政治",@"地理",@"生物",@"化学"].mutableCopy;
        }
        
        [_chooseView.subjectCollection reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }
    
}


- (void)setSelectedFilterGrade:(NSString *)selectedFilterGrade{
    
    _selectedFilterGrade = selectedFilterGrade;
}


- (void)setupViews{
    
    _navigationBar = ({
        NavigationBar *_=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
        _.titleLabel.text = @"选课";
        [_.rightButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        [_.rightButton addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_];
        _;
    });
    
    _chooseView = ({
        ChooseGradeAndSubjectView *_ = [[ChooseGradeAndSubjectView alloc]initWithFrame:CGRectMake(0, Navigation_Height, self.view.width_sd, self.view.height_sd-Navigation_Height-TabBar_Height)];
        _.delegate = self;
        _.subjectCollection.dataSource = self;
        _.subjectCollection.delegate = self;
        [self.view addSubview:_];
        _;
        
    });
    
    //注册类
    [_chooseView.subjectCollection registerClass:[ClassSubjectCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    
    
}

//获取所有tag
- (void)getTags{
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/app_constant/tags",Request_Header] withHeaderInfo:nil andHeaderfield:nil parameters:nil completeSuccess:^(id  _Nullable responds) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
        }else{
            
        }
        
        
    }failure:^(id  _Nullable erros) {
    }];
    
}


#pragma mark- collection datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return subjects.count ;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"cellID";
    ClassSubjectCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (subjects.count>indexPath.row) {
        
        cell.subject.text = subjects[indexPath.row];
        
    }
    
    return cell;
}


#pragma mark- collection delegate

//item间距
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

//行距
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 20;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ChooseClassViewController *controller =[[ChooseClassViewController alloc]initWithGrade:_selectedGrade andSubject:[subjects[indexPath.row] substringWithRange:NSMakeRange(0, 2)]];
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
}


//选择年级信息 -- 回调
-(void)chooseGrade:(NSString *)grade{
    
    _selectedGrade = [NSString stringWithFormat:@"%@",grade];
    
    subjects = @[].mutableCopy;
    //课程表变化
    if ([grade isEqualToString:@"初三"]) {
        //        语、数、英、物、化、政、历
        subjects = @[@"全部",@"语文",@"数学",@"英语",@"物理",@"化学",@"政治",@"历史"].mutableCopy;
    }else if ([grade isEqualToString:@"初二"]){
        //        语、数、英、物、政、历、生、地
        subjects = @[@"全部",@"语文",@"数学",@"英语",@"物理",@"政治",@"历史",@"生物",@"地理"].mutableCopy;
    }else if ([grade isEqualToString:@"初一"]){
        subjects = @[@"全部",@"语文",@"数学",@"英语",@"政治",@"历史",@"地理"].mutableCopy;
    }else if ([grade isEqualToString:@"六年级"]||[grade isEqualToString:@"五年级"]||[grade isEqualToString:@"四年级"]||[grade isEqualToString:@"三年级"]){
        //        语、数、英、科学
        subjects = @[@"全部",@"语文",@"数学",@"英语",@"科学"].mutableCopy;
    }else if ([grade isEqualToString:@"一年级"]||[grade isEqualToString:@"二年级"]){
        subjects = @[@"全部",@"语文",@"数学",@"英语"].mutableCopy;
    }else {
        subjects = @[@"全部",@"语文",@"数学",@"英语",@"历史",@"物理",@"政治",@"地理",@"生物",@"化学"].mutableCopy;
    }
    
    [_chooseView.subjectCollection reloadSections:[NSIndexSet indexSetWithIndex:0]];
    
}

- (void)search{
    SearchTipsViewController *controller = [[SearchTipsViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
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
