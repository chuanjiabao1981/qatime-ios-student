//
//  TutoriumInfoView.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/8.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

#import "TTGTextTagCollectionView.h"
#import "OneOnOneWorkFlowView.h"
#import "WorkFlowView.h"
#import "ExclusiveInfo.h"


@interface TutoriumInfoView : UIView

/* 课程名*/
@property(nonatomic,strong) UILabel  *className ;

/**课程状态*/
@property(nonatomic,strong) UILabel *status ;

/** 课程特色*/
@property (nonatomic, strong) UICollectionView *classFeature ;

/* 价格*/
@property(nonatomic,strong) UILabel *priceLabel ;

/* 报名人数*/
@property(nonatomic,strong) UILabel *saleNumber ;

/* 滑动视图*/
@property(nonatomic,strong) UIScrollView  *scrollView ;

/* 滑动控制器*/
@property(nonatomic,strong) HMSegmentedControl *segmentControl ;



@end
