//
//  MyOrderView.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/8.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HMSegmentedControl.h"


@interface MyOrderView : UIView


/* 滑动控制器*/
@property(nonatomic,strong) HMSegmentedControl *segmentControl ;

/* 大滑动视图*/
@property(nonatomic,strong) UIScrollView *scrollView ;


@end
