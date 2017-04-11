//
//  MyVideoClassView.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/11.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@interface MyVideoClassView : UIView
/**滑动segment*/
@property (nonatomic, strong) HMSegmentedControl *segmentControl ;
/**大滑动视图*/
@property (nonatomic, strong) UIScrollView *scrollView ;
/**已购课程*/
@property (nonatomic, strong) UITableView *boughtClassTableView ;
/**免费课程*/
@property (nonatomic, strong) UITableView *freeClasstableView ;

@end
