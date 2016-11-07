//
//  IndexPageViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "IndexPageViewController.h"
#import "RecommandClassCollectionViewCell.h"
#import "IndexHeaderPageView.h"


@interface IndexPageViewController ()<UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation IndexPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    /* 导航栏加载*/
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64)];
    [self .view addSubview:_navigationBar];
    _navigationBar.backgroundColor = [UIColor redColor];
    
    
    
    /* 页面初始化布局*/
    
    _indexPageView = [[IndexPageView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64-63) ];
    
   [ self .view addSubview:_indexPageView];
    
    _headerView = [[IndexHeaderPageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    
//                   [self.view addSubview:_headerView];
    
    
    
    
    /* 指定代理*/
       
    _indexPageView.recommandClassCollectionView.delegate = self;
    _indexPageView.recommandClassCollectionView.dataSource = self;
    
//    _headerView.teacherScrollView.delegate = self;
//    _headerView.teacherScrollView.dataSource = self;
    
    
    /* collectionView 注册cell、headerID、footerId*/
    
    
      
    [  _indexPageView.recommandClassCollectionView registerClass:[RecommandClassCollectionViewCell class] forCellWithReuseIdentifier:@"RecommandCell"];
  

    [_indexPageView.recommandClassCollectionView registerClass:[IndexHeaderPageView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RecommandHeader"];
   
    
    
   
    
    
    
    
}
    
    
    
#pragma mark- collectionview的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger items=0;
    
       if (collectionView == _indexPageView.recommandClassCollectionView){
        
        items = 6;
    }
    
    
    return items;
    
}
    
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CGSize layoutSize = CGSizeZero ;
    
        if (collectionView == _indexPageView.recommandClassCollectionView){
        
        layoutSize = CGSizeMake((CGRectGetWidth(self.view.bounds)-40)/2, (CGRectGetWidth(self.view.bounds)-40)/2);
        
    }
    
    
    return layoutSize;
    }
    
  
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
   __kindof UICollectionViewCell *cell=[[UICollectionViewCell alloc]init];
    
    
//    static NSString * CellIdentifier = @"CollectionCell";
    static NSString * recommandIdentifier = @"RecommandCell";
    
    /* 教师推荐的横滑视图*/
    
    
    /* 辅导推荐*/
    
    if (collectionView == _indexPageView.recommandClassCollectionView) {
        
        RecommandClassCollectionViewCell *reccell=[collectionView dequeueReusableCellWithReuseIdentifier:recommandIdentifier forIndexPath:indexPath];
        
        
        [reccell.classImage setImage:[UIImage imageNamed:@"school"]];
        
        
        cell=reccell ;
        
    }
    
    
    return cell;
    
}
    
    /* 回调 返回header*/
    
    //返回 Header的大小 size
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    
    CGSize headSize=CGSizeZero;
    
    if (collectionView == _indexPageView.recommandClassCollectionView){
        
        headSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.frame)/5*3.4);
        
    }
    
//    if (collectionView == _headerView.teacherScrollView) {
//        headSize = CGSizeZero;
//    }
    
    return headSize;
    
}
    
    #pragma mark- 获取collection header的方法
    //重要的方法 获取Header的 方法。
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
     NSString *CellIdentifier = @"RecommandHeader";

    if (collectionView == _indexPageView.recommandClassCollectionView) {
        
        //从缓存中获取 Headercell
        _headerView = (IndexHeaderPageView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
    }
    
    
    return _headerView;
}
    
    
    
    
    
    /* section数量*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
   
    return 1;
    
}
    
    /* cell的四边间距*/
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if (collectionView == _indexPageView.recommandClassCollectionView) {
        insets =UIEdgeInsetsMake(10, 15, 10, 10);
    }
    
    
    
        return insets;//分别为上、左、下、右
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
