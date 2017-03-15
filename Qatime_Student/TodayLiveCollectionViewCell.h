//
//  TodayLiveCollectionViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodayLive.h"

@interface TodayLiveCollectionViewCell : UICollectionViewCell

/**
 课程图
 */
@property (nonatomic, strong) UIImageView *classImageView ;

/**
 课程名
 */
@property (nonatomic, strong) UILabel *classNameLabel ;

/**
 直播时间和状态
 */
@property (nonatomic, strong) UILabel *stateLabel ;


/**
 model
 */
@property (nonatomic, strong) TodayLive *model ;

@end
