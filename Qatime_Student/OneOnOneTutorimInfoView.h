
//
//  OneOnOneTutorimInfoView.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/31.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

#import "OneOnOneClass.h"
#import "UICollectionViewLeftAlignedLayout.h"

@interface OneOnOneTutorimInfoView : UIView

@property (nonatomic, strong) UIView *headView ;

/** 课程名*/
@property(nonatomic,strong) UILabel  *className ;

/**课程特色*/
@property (nonatomic, strong) UICollectionView *classFeature ;
/** 价格*/
@property(nonatomic,strong) UILabel *priceLabel ;

/**滑动控制栏*/
@property (nonatomic, strong) HMSegmentedControl *segmentControl ;
/**大滑动视图*/
@property (nonatomic, strong) UIScrollView *scrollView ;

/**model*/
@property (nonatomic, strong) OneOnOneClass *model ;


@end
