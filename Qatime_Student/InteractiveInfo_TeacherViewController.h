//
//  InteractiveInfo_TeacherViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/11/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneOnOneTeacherTableViewCell.h"

@interface InteractiveInfo_TeacherViewController :UITableViewController

@property (nonatomic, strong) NSMutableArray <Teacher *>*teachersArray ;


-(instancetype)initWithTeachers:(__kindof NSArray *)teachers;

@end
