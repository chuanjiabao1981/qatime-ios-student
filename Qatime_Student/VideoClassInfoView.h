//
//  VideoClassInfoView.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/11.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "VideoClassInfo.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "WorkFlowView.h"


@interface VideoClassInfoView : UIView

@property (nonatomic, strong) UIView *headView ;

/* 课程名*/
@property(nonatomic,strong) UILabel  *className ;

/**课程特色*/
@property (nonatomic, strong) UICollectionView *classFeature ;


/* 价格*/
@property(nonatomic,strong) UILabel *priceLabel ;

/* 报名人数*/
@property(nonatomic,strong) UILabel *saleNumber ;


/* 滑动视图*/
@property(nonatomic,strong) UIScrollView  *scrollView ;

/* 滑动控制器*/
@property(nonatomic,strong) HMSegmentedControl *segmentControl ;


/**model*/
@property (nonatomic, strong) VideoClassInfo *model ;

@end
