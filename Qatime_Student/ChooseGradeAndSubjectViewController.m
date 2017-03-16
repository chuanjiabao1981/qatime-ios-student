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

@interface ChooseGradeAndSubjectViewController ()<ChooseGradeAndSubjectDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    
    NavigationBar *_navigationBar;
    
    
    NSArray *subjects;
    
    
    NSString *_selectedGrade;
}


@end

@implementation ChooseGradeAndSubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    //基本信息
    subjects = @[@"全部",@"语文",@"数学",@"英语",@"历史",@"物理",@"政治",@"地理",@"生物",@"化学"];
    
    //加载视图
    [self setupViews];
    
    
    
    
    
    
}

- (void)setupViews{
    
    
    _navigationBar = ({
        NavigationBar *_=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
        _.titleLabel.text = @"选课";
        
        [self.view addSubview:_];
        _;
    
    });
    
    _chooseView = ({
        ChooseGradeAndSubjectView *_ = [[ChooseGradeAndSubjectView alloc]initWithFrame:CGRectMake(0, Navigation_Height, self.view.width_sd, self.view.height_sd-Navigation_Height-TabBar_Height)];
        
        _.delegate = self;
        _.subjectCollection.dataSource = self;
        _.subjectCollection.delegate = self;
        
        //注册类
        [_.subjectCollection registerClass:[ClassSubjectCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
        
        [self.view addSubview:_];
        
        _;
    
    });
    
}


#pragma mark- collection datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return subjects.count ;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"cellID";
    ClassSubjectCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.subject.text = subjects[indexPath.row];
    
    
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
   
    ChooseClassViewController *controller = [[ChooseClassViewController alloc]initWithGrade:_selectedGrade andSubject:subjects[indexPath.row]];
    
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
}



//回调年级信息
-(void)chooseGrade:(NSString *)grade{
    
    _selectedGrade = grade;
    
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
