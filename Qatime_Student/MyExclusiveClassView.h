//
//  MyExclusiveClassView.h
//  Qatime_Student
//
//  Created by Shin on 2017/7/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl+Category.h"

@interface MyExclusiveClassView : UIView

@property (nonatomic, strong) HMSegmentedControl *segmentControl ;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UITableView *publishedView ;

@property (nonatomic, strong) UITableView *teachingView ;

@property (nonatomic, strong) UITableView *completedView ;


@end
