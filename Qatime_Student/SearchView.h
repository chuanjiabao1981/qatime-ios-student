//
//  SearchView.h
//  Qatime_Student
//
//  Created by Shin on 2017/6/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@interface SearchView : UIView

@property (nonatomic, strong) HMSegmentedControl *segmentControl ;

@property (nonatomic, strong) UIScrollView *scrollView ;

@property (nonatomic, strong) UITableView *classSearchResultView ;

@property (nonatomic, strong) UITableView *teacherSearchResultView ;

@end
