//
//  TutoriumView.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/2.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutoriumView : UIView
/* 筛选条件按钮*/

/* 按时间*/
@property(nonatomic,strong) UIButton *timeButton ;
/* 科目*/
@property(nonatomic,strong) UIButton *subjectButton ;
/* 全部*/
@property(nonatomic,strong) UIButton *gradeButton ;

/* 条件筛选按钮*/
@property(nonatomic,strong) UIButton *filtersButton ;

/* 课程瀑布流视图*/

@property(nonatomic,strong) UICollectionView *classesCollectionView;


@end
