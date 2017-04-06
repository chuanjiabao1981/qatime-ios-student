//
//  AllClassViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/28.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllClassView.h"
#import "FSCalendar.h"

#import "HaveNoClassView.h"
@interface AllClassViewController : UIViewController
/**日历*/
//@property(nonatomic,strong) AllClassView *allClassView ;
/**日历*/
@property (nonatomic, strong) FSCalendar *calendar ;
/**课程列表*/
@property(nonatomic,strong) UITableView *classTableView ;
/**没有课程的占位图*/
//@property(nonatomic,strong) HaveNoClassView *haveNoClassView ;

@end
