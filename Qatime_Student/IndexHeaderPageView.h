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


@interface IndexHeaderPageView : UIView

/**z
 轮播图
 */
@property(nonatomic,strong) SDCycleScrollView *cycleScrollView ;

/**
 年级菜单
 */
@property (nonatomic, strong) UIScrollView *gradeMenu ;



/**
 查看全部老师和直播回放
 */
@property (nonatomic, strong) UIView *checkAndReview;
@property (nonatomic, strong) UIControl *allTeachersBtn ;
@property (nonatomic, strong) UIControl *reviewBtn ;


/**
 今日直播 滚动视图
 */
@property (nonatomic, strong) UICollectionView *todayLiveScrollView ;

/**推荐教师*/
@property (nonatomic, strong) UICollectionView *recommandTeachersView ;

/**
 精选内容 栏
 */
@property (nonatomic, strong) UIView *fancyView;

/**
 更多精选 按钮
 */
@property (nonatomic, strong) UIControl *moreFancyButton ;


/**所有年级按钮*/

@property (nonatomic, strong) NSMutableArray  *buttons ;


@end
