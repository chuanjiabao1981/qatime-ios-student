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
#import "IndexHeaderPageView.h"


@interface IndexHeaderPageView : UICollectionReusableView

/**
 轮播图
 */
@property(nonatomic,strong) SDCycleScrollView *cycleScrollView ;

/**
 整个视图的headerview
 */
@property(nonatomic,strong) UIView *headerContentView ;

/**
 科目菜单
 */
@property(nonatomic,strong) UIView *squareMenu ;
@property(nonatomic,strong) NSMutableArray <UIView *> *squareMenuArr ;

/**
 名师入驻 滚动图
 */
@property(nonatomic,strong) UICollectionView *teacherScrollView ;


/**
 名师入驻的header
 */
@property(nonatomic,strong) UIView *teacherScrollHeader ;


/**
 全部辅导按钮
 */
@property(nonatomic,strong) UIView *conmmandView ;
@property(nonatomic,strong) UIButton *recommandAllButton ;

@property(nonatomic,strong) UIButton *allArrowButton ;



@end
