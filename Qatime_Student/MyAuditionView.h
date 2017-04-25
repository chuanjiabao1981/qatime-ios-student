//
//  MyAuditionView.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@interface MyAuditionView : UIView
/**滑动控制器*/
@property (nonatomic, strong) HMSegmentedControl *segmentControl;
/**滑动视图*/
@property (nonatomic, strong) UIScrollView *scrollView ;
/**直播课列表*/
@property (nonatomic, strong) UITableView *liveClassList ;
/**视频课列表*/
@property (nonatomic, strong) UITableView *videoClassList ;

@end
