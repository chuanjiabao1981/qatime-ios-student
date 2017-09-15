//
//  MyHomeworkView.h
//  Qatime_Student
//
//  Created by Shin on 2017/9/8.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HMSegmentedControl+Category.h"
@interface MyHomeworkView : UIView

@property (nonatomic, strong) HMSegmentedControl *segmentControl ;
@property (nonatomic, strong) UIScrollView *scrollView ;

@property (nonatomic, strong) UITableView *unhandedList ;

@property (nonatomic, strong) UITableView *handedList ;

@property (nonatomic, strong) UITableView *checkedList ;

@end
