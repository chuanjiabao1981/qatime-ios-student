//
//  TutoriumViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "TutoriumViewController.h"
#import "TutoriumCollectionViewCell.h"

@interface TutoriumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation TutoriumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
//    self.view.backgroundColor = [UIColor whiteColor];
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64)];
    [self.view addSubview:_navigationBar];
    [_navigationBar.titleLabel setText:@"辅导班"];
    _navigationBar.backgroundColor = [UIColor colorWithRed:190/255.0f green:11/255.0f blue:11/255.0f alpha:1.0f];
    
    _tutoriumView = [[TutoriumView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64-49)];
    [self .view addSubview:_tutoriumView];
    
    /* 瀑布流视图的代理*/
    _tutoriumView.classesCollectionView.delegate = self;
    _tutoriumView.classesCollectionView.dataSource = self;
    
    
    /* 瀑布流展示注册*/
    /* collectionView 注册cell、headerID、footerId*/
    [_tutoriumView.classesCollectionView registerClass:[TutoriumCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
  
    
    
}
#pragma mark- collection的代理方法
/* item数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 6;
    
}
/* item重用队列*/
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"CollectionCell";
    TutoriumCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    /* cell的数据源赋值*/
    [cell.classImage setImage:[UIImage imageNamed:@"school"]];
        

    return cell;

  
}
/* section数量*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((CGRectGetWidth(self.view.bounds)-40)/2, (CGRectGetWidth(self.view.bounds)-40)/2*1.1);
}

/* 最小行间距*/
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
    
}
/* 最小列间距*/
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
    
}
/* 上下左右的间距*/
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}




#pragma mark- item被选中的回调方法
/* item被选中的回调方法*/
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
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
