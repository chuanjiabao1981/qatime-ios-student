//
//  IndexHeaderPageView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "IndexHeaderPageView.h"
#import "YZSquareMenuCell.h"

@interface IndexHeaderPageView ()
/**<,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>*/

{
    UIView *_squareButton;
    NSArray *menuImages;
    NSArray *menuTitiels;
}


@end



@implementation IndexHeaderPageView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        menuImages = @[[UIImage imageNamed:@"语文"],[UIImage imageNamed:@"数学"],[UIImage imageNamed:@"英语"],[UIImage imageNamed:@"物理"],[UIImage imageNamed:@"化学"],[UIImage imageNamed:@"生物"],[UIImage imageNamed:@"历史"],[UIImage imageNamed:@"地理"],[UIImage imageNamed:@"政治"],[UIImage imageNamed:@"科学"]];
        menuTitiels = @[@"语文",@"数学",@"英语",@"物理",@"化学",@"生物",@"历史",@"地理",@"政治",@"科学"];
        
        
        /* 底层content视图 headerView视图初始化*/
        _headerContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        
        [self addSubview:_headerContentView];
        
        _squareMenuArr = @[].mutableCopy;
        
        /* banner页布局*/
        
        _cycleScrollView =[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(_headerContentView.frame), CGRectGetWidth(_headerContentView.frame)*316/1190) imageURLStringsGroup:@[[NSString stringWithFormat:@"%@/assets/banner-016c8e1cde7b776617bd6e93c128dd61.jpg",Request_Header],[NSString stringWithFormat:@"%@/assets/banner2-149105719fc13d02b78770a0e9e1fd05.jpg",Request_Header],[NSString stringWithFormat:@"%@/assets/banner3-873b7627ebd8fc13d9de61ff53c110b5.jpg",Request_Header]]];
        
//        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:<#(CGRect)#> delegate:<#(id<SDCycleScrollViewDelegate>)#> placeholderImage:<#(UIImage *)#>]
        
        
        
        [_headerContentView addSubview:_cycleScrollView];
        
       
        _squareMenu = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_cycleScrollView.frame),CGRectGetWidth(_headerContentView.bounds),CGRectGetWidth(_headerContentView.frame)/5*2)];
        
        [_headerContentView addSubview:_squareMenu];
        
        /* 遍历出第一行的5个图标*/
        for (int i =0 ; i<5; i++) {
            
            UIView *btn = [[UIView alloc]initWithFrame:CGRectMake(i*CGRectGetWidth(_squareMenu.bounds)/5, 0, CGRectGetWidth(_squareMenu.bounds)/5, CGRectGetWidth(_squareMenu.bounds)/5) ];
            UIImageView *iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(btn.frame.size.width/3/2+5, 10, btn.frame.size.width*2/3-10, btn.frame.size.width*2/3-10)];
            
            
            UILabel *iconLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, btn.frame.size.width*3/4+2, btn.frame.size.width, btn.frame.size.width/4-2)];
            iconLabel.textAlignment = NSTextAlignmentCenter;
            iconLabel.font = [UIFont systemFontOfSize:16*ScrenScale];
            [btn addSubview:iconImage];
            [btn addSubview:iconLabel];
            
            [iconImage setImage:menuImages[i]];
            [iconLabel setText:menuTitiels[i]];
            
            btn.tag =i+10;
            
            
            [_squareMenu addSubview:btn];
            [_squareMenuArr addObject:btn];
            
            
        }
        
        /* 遍历出第二行的5个图标*/
        for (int i =5 ; i<10; i++) {
            
            UIView *btn = [[UIView alloc]initWithFrame:CGRectMake((i-5)*CGRectGetWidth(_squareMenu.bounds)/5, CGRectGetWidth(_squareMenu.bounds)/5, CGRectGetWidth(_squareMenu.bounds)/5, CGRectGetWidth(_squareMenu.bounds)/5) ];
            UIImageView *iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(btn.frame.size.width/3/2+5, 10, btn.frame.size.width*2/3-10, btn.frame.size.width*2/3-10)];
            
            UILabel *iconLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, btn.frame.size.width*3/4+2, btn.frame.size.width, btn.frame.size.width/4-2)];
            iconLabel.textAlignment = NSTextAlignmentCenter;
            iconLabel.font = [UIFont systemFontOfSize:16*ScrenScale];
            [btn addSubview:iconImage];
            [btn addSubview:iconLabel];
            
            [iconImage setImage:menuImages[i]];
            [iconLabel setText:menuTitiels[i]];
            
            btn.tag =i+10;
            
            
            [_squareMenu addSubview:btn];
            [_squareMenuArr addObject:btn];
            
        }
        
        /* 分割线1*/
        UIView *line1 =[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_squareMenu.frame)+10, CGRectGetWidth(_headerContentView.bounds), 0.6f)];
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
        
//        _refreshTeacherListButton = [[UIButton alloc]init];
//        [_teacherScrollHeader addSubview:_refreshTeacherListButton];
//        [_refreshTeacherListButton setImage:[UIImage imageNamed:@"刷新"] forState:UIControlStateNormal];
//        _refreshTeacherListButton.sd_layout.rightSpaceToView(_teacherScrollHeader,20).topSpaceToView(_teacherScrollHeader,10).bottomSpaceToView(_teacherScrollHeader,10).widthEqualToHeight();
        
        
        
        /* 名师入驻 滚动视图*/
        UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        
        _teacherScrollView = [[TeacherView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_teacherScrollHeader.frame), CGRectGetWidth(_headerContentView.frame), CGRectGetHeight(_squareMenu.frame)/2) collectionViewLayout:layout];
        [_headerContentView addSubview:_teacherScrollView];
        _teacherScrollView.backgroundColor = [UIColor whiteColor];
        _teacherScrollView.showsVerticalScrollIndicator = NO;
        _teacherScrollView.showsHorizontalScrollIndicator = NO;
        
        
        [_headerContentView addSubview:_teacherScrollView];
        
        /* 分割线2*/
        UIView *line2 =[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_teacherScrollView.frame)+5, CGRectGetWidth(_headerContentView.frame), 0.6f)];
        line2.backgroundColor =[UIColor lightGrayColor];
        [_headerContentView addSubview:line2];
        
        
        /* 推荐header 2*/
        
        /* 暂时写死2*/
        _conmmandView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line2.frame), CGRectGetWidth(_headerContentView.frame), 40)];
        [_headerContentView addSubview:_conmmandView];
        
        
        /* 辅导推荐图标*/
        UIImageView *commandImage=[[UIImageView alloc]init];
        [commandImage setImage:[UIImage imageNamed:@"老师"]];
        [_conmmandView addSubview:commandImage];
        commandImage.sd_layout.leftSpaceToView(_conmmandView,20).topSpaceToView(_conmmandView,10).bottomSpaceToView(_conmmandView,10).widthEqualToHeight();
        
        /* 辅导推荐label*/
        UILabel *commandLabel=[[UILabel alloc]init];
        commandLabel .text =@"辅导推荐" ;
        [_conmmandView addSubview:commandLabel];
        commandLabel.sd_layout.leftSpaceToView(commandImage,5).topEqualToView(commandImage).bottomSpaceToView(_conmmandView,10);
        
        [commandLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        
        /* 全部辅导课程推荐按钮和箭头按钮*/
        _recommandAllButton = [[UIButton alloc]init];
        [_conmmandView addSubview:_recommandAllButton];
        [_recommandAllButton setTitle:@"全部" forState:UIControlStateNormal];
        [_recommandAllButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        
        _allArrowButton = [[UIButton alloc]init];
        [_conmmandView addSubview:_allArrowButton];
        [_allArrowButton setImage:[UIImage imageNamed:@"rightArrow"] forState:UIControlStateNormal];
        
        _allArrowButton.sd_layout.rightSpaceToView(_conmmandView,20).topSpaceToView(_conmmandView,10).bottomSpaceToView(_conmmandView,10).widthEqualToHeight();
        
        _recommandAllButton .sd_layout.rightSpaceToView(_allArrowButton,0).topEqualToView(_allArrowButton).bottomEqualToView(_allArrowButton).widthIs(50);
        
        
        
        [_teacherScrollView registerClass:[YZSquareMenuCell class] forCellWithReuseIdentifier:@"CollectionCell"];
        
        
        
        CGFloat maxy = CGRectGetMaxY(_conmmandView.frame);
        
                
        
    }
    return self;
}




//    /* section数量*/
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//
//    return 1;
//
//}
//
//
//
//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//
//    return 10;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//
//
//    CGSize layoutSize = CGSizeZero ;
//
//
//        layoutSize =CGSizeMake(CGRectGetWidth(self.frame)/5-10, CGRectGetWidth(self.frame)/5-10);
//
//
//    return layoutSize;
//}
//
//
//- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//
//
//
//    static NSString * CellIdentifier = @"CollectionCell";
////    static NSString * recommandIdentifier = @"RecommandCell";
//
//    /* 教师推荐的横滑视图*/
//
//        YZSquareMenuCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
//
//        [cell.iconTitle setText:@"名师推荐"];
//
//        [cell.iconImage setImage: [UIImage imageNamed:@"老师"]];
//        cell.iconImage.layer.masksToBounds = YES;
//        cell.iconImage.layer.cornerRadius = cell.iconImage.frame.size.height/2.0f;
//
//
//
//    return cell;
//
//}






@end
