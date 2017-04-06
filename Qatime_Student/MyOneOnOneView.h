//
//  MyOneOnOneView.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/31.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@interface MyOneOnOneView : UIView

/**分段控制器*/
@property (nonatomic, strong) HMSegmentedControl *segmentControl ;
/**大滑动视图*/
@property (nonatomic, strong) UIScrollView *scrollView ;

/**学习中的视图*/
@property (nonatomic, strong) UITableView *onStudyTableView ;

/**已结束的视图*/
@property (nonatomic, strong) UITableView *finishStudyTableView ;

@end
