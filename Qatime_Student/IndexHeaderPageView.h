//
//  IndexHeaderPageView.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "YZSquareMenu.h"
#import "YZSquareMenuCell.h"
#import "IndexHeaderPageView.h"
#import "SquareView.h"

@interface IndexHeaderPageView : UICollectionReusableView



/* 轮播图*/
@property(nonatomic,strong) SDCycleScrollView *cycleScrollView ;

/* 整个的headerview*/
@property(nonatomic,strong) UIView *headerContentView ;

/* 科目 Menu的视图*/
@property(nonatomic,strong) UIView *squareMenu ;
@property(nonatomic,strong) NSMutableArray <UIView *> *squareMenuArr ;


/* 名师入驻 滚动视图*/
@property(nonatomic,strong) SquareView *teacherScrollView ;

/* 名师入驻的header*/
@property(nonatomic,strong) UIView *teacherScrollHeader ;


/* 名师入驻刷新按钮*/
@property(nonatomic,strong) UIButton  *refreshTeacherListButton ;


/* 全部辅导推荐按钮*/
@property(nonatomic,strong) UIButton *recommandAllButton ;

@property(nonatomic,strong) UIButton *allArrowButton ;



@end
