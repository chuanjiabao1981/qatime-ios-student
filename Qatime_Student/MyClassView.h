//
//  MyClassView.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@interface MyClassView : UIView

/* 滑动segment*/
@property(nonatomic,strong) HMSegmentedControl *segmentControl ;


/* 大滑动视图*/

@property(nonatomic,strong) UIScrollView *scrollView ;

@end
