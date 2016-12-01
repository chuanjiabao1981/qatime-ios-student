//
//  ClassTimeView.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/28.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "NotClassView.h"
#import "AlreadyClassView.h"

@interface ClassTimeView : UIView


/**
 大滚动视图
 */
@property(nonatomic,strong) UIScrollView *scrollView ;



/**
 滑动控制器
 */
@property(nonatomic,strong) HMSegmentedControl *segmentControl;


@property(nonatomic,strong) NotClassView *notClassView;
@property(nonatomic,strong) AlreadyClassView *alreadyClassView ;

@end
