//
//  IndexHeaderPageView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "IndexHeaderPageView.h"

@interface IndexHeaderPageView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end


@implementation IndexHeaderPageView
    
- (instancetype)initWithFrame:(CGRect)frame
    {
        self = [super initWithFrame:frame];
        if (self) {
            /* 底层content视图 headerView视图初始化*/
            _headerContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
            
            [self addSubview:_headerContentView];
            
            
            
            //        /* banner的content*/
            //
            //        UIView *bannerContent=[[UIView alloc]init];
            //        [_headerContentView addSubview:bannerContent];
            //
            //        bannerContent.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(_headerContentView,0).heightIs(CGRectGetWidth(self.frame)*316.0f/1190.f);
            
            
            
            /* banner页布局*/
            
            _cycleScrollView =[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(_headerContentView.frame), CGRectGetWidth(_headerContentView.frame)*316/1190) imageURLStringsGroup:@[@"http://testing.qatime.cn/assets/banner-016c8e1cde7b776617bd6e93c128dd61.jpg",@"http://testing.qatime.cn/assets/banner2-149105719fc13d02b78770a0e9e1fd05.jpg",@"http://testing.qatime.cn/assets/banner3-873b7627ebd8fc13d9de61ff53c110b5.jpg"]];
            
            
            [_headerContentView addSubview:_cycleScrollView];
            
            //        /* squarecontentview布局*/
            //        UIView *squareContent=[[UIView alloc]init];
            //        [_headerContentView addSubview:squareContent];
            //        squareContent.sd_layout.topSpaceToView(_cycleScrollView,0).leftEqualToView(_cycleScrollView).rightEqualToView(_cycleScrollView).heightRatioToView(_cycleScrollView,1.55f);
            
            /* squareMenu 科目 布局 */
            _squareMenu = [[YZSquareMenu alloc]initWithFrame:CGRectMake(0,CGRectGetHeight(_cycleScrollView.bounds),CGRectGetWidth(_headerContentView.bounds),CGRectGetHeight(_cycleScrollView.bounds)*1.55f) iconNumbers:10 menuIconName:@[@"语文",@"数学",@"英语",@"物理",@"化学",@"生物",@"历史",@"地理",@"政治",@"科学"] menuIconTitle:@[@"语文",@"数学",@"英语",@"物理",@"化学",@"生物",@"历史",@"地理",@"政治",@"科学"] iconType:YZMenuIconTypeNone];
            [_headerContentView addSubview:_squareMenu];
            
            
            /* 分割线1*/
            UIView *line1 =[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_squareMenu.frame), CGRectGetWidth(_headerContentView.bounds), 0.8f)];
            line1.backgroundColor =[UIColor lightGrayColor];
            [_headerContentView addSubview:line1];
            
            /* 暂时写死*/
            _teacherScrollHeader = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line1.frame), CGRectGetWidth(_headerContentView.frame), 40)];
            [_headerContentView addSubview:_teacherScrollHeader];
            
            /* 入驻名师图标*/
            UIImageView *teacherHead=[[UIImageView alloc]init];
            [teacherHead setImage:[UIImage imageNamed:@"老师"]];
            [_teacherScrollHeader addSubview:teacherHead];
            teacherHead.sd_layout.leftSpaceToView(_teacherScrollHeader,20).topSpaceToView(_teacherScrollHeader,10).bottomSpaceToView(_teacherScrollHeader,10).widthEqualToHeight();
            
            /* 入住名师label*/
            UILabel *teacherLabel=[[UILabel alloc]init];
            teacherLabel .text =@"名师入驻" ;
            [_teacherScrollHeader addSubview:teacherLabel];
            teacherLabel.sd_layout.leftSpaceToView(teacherHead,5).topEqualToView(teacherHead).bottomEqualToView(teacherHead);
            [teacherLabel setSingleLineAutoResizeWithMaxWidth:100];
            
            /* 名师刷新按钮*/
            
            _refreshTeacherListButton = [[UIButton alloc]init];
            [_teacherScrollHeader addSubview:_refreshTeacherListButton];
            [_refreshTeacherListButton setImage:[UIImage imageNamed:@"刷新"] forState:UIControlStateNormal];
            _refreshTeacherListButton.sd_layout.rightSpaceToView(_teacherScrollHeader,20).topSpaceToView(_teacherScrollHeader,10).bottomSpaceToView(_teacherScrollHeader,10).widthEqualToHeight();
            
            
            //        /* 滚动视图的底视图 content*/
            //        UIView *scrollContent = [[UIView alloc]init];
            //        [_headerContentView addSubview:scrollContent];
            //        scrollContent.sd_layout.leftSpaceToView(_headerContentView,0).rightSpaceToView(_headerContentView,0).topSpaceToView(teacherHead,10).heightRatioToView(_squareMenu,0.5f);
            
            
            
            /* 名师入驻 滚动视图*/
            UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            //        layout.itemSize = CGSizeMake(CGRectGetWidth(_headerContentView.frame)/5-10, CGRectGetWidth(_headerContentView.frame)/5-10);
            
            _teacherScrollView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_teacherScrollHeader.frame), CGRectGetWidth(_headerContentView.frame), CGRectGetHeight(_squareMenu.frame)/2) collectionViewLayout:layout];
            [_headerContentView addSubview:_teacherScrollView];
            _teacherScrollView.backgroundColor = [UIColor whiteColor];
            _teacherScrollView.showsVerticalScrollIndicator = NO;
            _teacherScrollView.showsHorizontalScrollIndicator = NO;
            
            
            
            
            //        _teacherScrollView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(teacherLabel.bounds), CGRectGetWidth(_headerContentView.frame), CGRectGetHeight(_squareMenu.bounds)/2) collectionViewLayout:layout];
            [_headerContentView addSubview:_teacherScrollView];
            
            /* 分割线2*/
            UIView *line2 =[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_teacherScrollView.frame)+5, CGRectGetWidth(_headerContentView.frame), 0.6f)];
            line2.backgroundColor =[UIColor lightGrayColor];
            [_headerContentView addSubview:line2];
            
            
            /* 推荐header 2*/
            
            /* 暂时写死2*/
            UIView *conmmandView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line2.frame), CGRectGetWidth(_headerContentView.frame), 40)];
            [_headerContentView addSubview:conmmandView];
            
            
            /* 辅导推荐图标*/
            UIImageView *commandImage=[[UIImageView alloc]init];
            [commandImage setImage:[UIImage imageNamed:@"老师"]];
            [conmmandView addSubview:commandImage];
            commandImage.sd_layout.leftSpaceToView(conmmandView,20).topSpaceToView(conmmandView,10).bottomSpaceToView(conmmandView,10).widthEqualToHeight();
            
            /* 辅导推荐label*/
            UILabel *commandLabel=[[UILabel alloc]init];
            commandLabel .text =@"辅导推荐" ;
            [conmmandView addSubview:commandLabel];
            commandLabel.sd_layout.leftSpaceToView(commandImage,5).topEqualToView(commandImage).bottomSpaceToView(conmmandView,10);
            
            [commandLabel setSingleLineAutoResizeWithMaxWidth:100];
            
            
            /* 全部辅导课程推荐按钮和箭头按钮*/
            _recommandAllButton = [[UIButton alloc]init];
            [conmmandView addSubview:_recommandAllButton];
            [_recommandAllButton setTitle:@"全部" forState:UIControlStateNormal];
            [_recommandAllButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            
            _allArrowButton = [[UIButton alloc]init];
            [conmmandView addSubview:_allArrowButton];
            [_allArrowButton setImage:[UIImage imageNamed:@"rightArrow"] forState:UIControlStateNormal];
            
            _allArrowButton.sd_layout.rightSpaceToView(conmmandView,20).topSpaceToView(conmmandView,10).bottomSpaceToView(conmmandView,10).widthEqualToHeight();
            
            _recommandAllButton .sd_layout.rightSpaceToView(_allArrowButton,0).topEqualToView(_allArrowButton).bottomEqualToView(_allArrowButton).widthIs(50);
            
            
            
            [_teacherScrollView registerClass:[YZSquareMenuCell class] forCellWithReuseIdentifier:@"CollectionCell"];
            
            _teacherScrollView.delegate = self;
            _teacherScrollView.dataSource = self;

            
            
        }
        return self;
    }
    
    
    
    
    /* section数量*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

    
    
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CGSize layoutSize = CGSizeZero ;
    
    
        layoutSize =CGSizeMake(CGRectGetWidth(self.frame)/5-10, CGRectGetWidth(self.frame)/5-10);
    
    
    return layoutSize;
}
    
    
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    static NSString * CellIdentifier = @"CollectionCell";
//    static NSString * recommandIdentifier = @"RecommandCell";
    
    /* 教师推荐的横滑视图*/
    
        YZSquareMenuCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        [cell.iconTitle setText:@"名师推荐"];
        
        [cell.iconImage setImage: [UIImage imageNamed:@"老师"]];
        cell.iconImage.layer.masksToBounds = YES;
        cell.iconImage.layer.cornerRadius = cell.iconImage.frame.size.height/2.0f;
        
    
    
    return cell;
    
}
    
    @end
