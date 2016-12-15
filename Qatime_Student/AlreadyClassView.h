//
//  AlreadyClassView.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/28.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassTimeTableViewCell.h"
#import "HaveNoClassView.h"

@interface AlreadyClassView : UIView

@property(nonatomic,strong) UITableView *alreadyClassTableView ;

/* 当月无课程*/
@property(nonatomic,strong) HaveNoClassView *haveNoClassView ;

@end
