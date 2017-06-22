//
//  ReplayViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/6/21.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReplayFilterView.h"

@interface ReplayViewController : UIViewController

@property (nonatomic, strong) ReplayFilterView *filterView ;

@property (nonatomic, strong) UITableView *mainView ;

@end
