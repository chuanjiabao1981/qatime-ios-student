//
//  TutoriumView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/2.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "TutoriumView.h"

@interface TutoriumView (){
    
    UIView *_buttonContentView;
    
    
}

@end

@implementation TutoriumView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
       
        /* 4个button的contentview  白底*/
        _buttonContentView = [[UIView alloc]init];
        _buttonContentView.backgroundColor = [UIColor whiteColor];
        
        /* 分割线*/
        UIView *line1=[[UIView alloc]init];
        [_buttonContentView addSubview:line1];
        line1.backgroundColor = [UIColor lightGrayColor];
        line1.sd_layout.leftSpaceToView(_buttonContentView,0).rightSpaceToView(_buttonContentView,0).bottomSpaceToView(_buttonContentView,0).heightIs(0.6f);
        
        /* 按时间筛选按钮*/
        _timeButton = [[UIButton alloc]init];
        [_buttonContentView addSubview: _timeButton];
        [_timeButton setTitle:@"按时间∨" forState:UIControlStateNormal];
        [_timeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _timeButton.sd_layout.leftSpaceToView(_buttonContentView,10).topSpaceToView(_buttonContentView,0).bottomSpaceToView(_buttonContentView,0).widthRatioToView(_buttonContentView,0.2f);
        [_timeButton.titleLabel setFont:[UIFont systemFontOfSize:16*ScrenScale]];
        [_timeButton setEnlargeEdge:10];
        
        /* 按照科目筛选按钮*/
        
        _subjectButton = [[UIButton alloc]init];
        [_buttonContentView addSubview:_subjectButton];
        [_subjectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_subjectButton setTitle:@"按科目∨" forState:UIControlStateNormal];
        _subjectButton.sd_layout.leftSpaceToView(_timeButton,CGRectGetWidth(self.bounds)/10.0f).topSpaceToView(_buttonContentView,0).bottomSpaceToView(_buttonContentView,0).widthRatioToView(_buttonContentView,0.2f);
        [_subjectButton.titleLabel setFont:[UIFont systemFontOfSize:16*ScrenScale]];
        [_subjectButton setEnlargeEdge:10];
        
        /* 按年级筛选按钮*/
        _gradeButton = [[UIButton alloc]init];
        [_buttonContentView addSubview:_gradeButton];
        [_gradeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_gradeButton setTitle:@"按年级∨" forState:UIControlStateNormal];
        _gradeButton.sd_layout.leftSpaceToView(_subjectButton,CGRectGetWidth(self.bounds)/10.0f).topSpaceToView(_buttonContentView,0).bottomSpaceToView(_buttonContentView,0).widthRatioToView(_buttonContentView,0.2f);
         [_gradeButton.titleLabel setFont:[UIFont systemFontOfSize:16*ScrenScale]];
        [_gradeButton setEnlargeEdge:10];
        
        
        /* 其他条件筛选按钮*/
        _filtersButton= [[UIButton alloc]init];
        [_buttonContentView addSubview:_filtersButton];
        [_filtersButton setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
        _filtersButton.sd_layout.rightSpaceToView(_buttonContentView,10).topSpaceToView(_buttonContentView,0).bottomSpaceToView(_buttonContentView,0).widthRatioToView(_buttonContentView,0.06f);
        [_filtersButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [_filtersButton setEnlargeEdge:10];
        
        
#pragma mark- 瀑布流视图
        /* 瀑布流视图*/
        
        /* 视图布局*/
        
        UICollectionViewFlowLayout * layOut=[[UICollectionViewFlowLayout alloc]init];
        
        
        _classesCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) collectionViewLayout:layOut];
       
        
        _classesCollectionView.backgroundColor = [UIColor whiteColor];

      
                
        /* contentview添加在collection的上层*/
        [self addSubview:_buttonContentView];
        _buttonContentView.sd_layout.leftSpaceToView(self,0).rightSpaceToView(self,0).topSpaceToView(self,0).heightRatioToView(self,0.055f);
        
        /* collectionView的布局*/
        [self addSubview:_classesCollectionView];
        _classesCollectionView.sd_layout.leftSpaceToView(self,0).rightSpaceToView(self,0).topSpaceToView(_buttonContentView,0).bottomSpaceToView(self,0);

        
        _classesCollectionView.showsVerticalScrollIndicator = NO;
        
        
    }
    return self;
}

@end
