//
//  ExclusivePlayerView.h
//  Qatime_Student
//
//  Created by Shin on 2017/7/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl+Category.h"

@interface ExclusivePlayerView : UIView
/* 滑动选择器*/
@property(nonatomic,strong) HMSegmentedControl *segmentControl;

/* 大滑动视图*/
@property(nonatomic,strong) UIScrollView *scrollView;

@end
