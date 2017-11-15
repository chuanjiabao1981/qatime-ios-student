//
//  ExclusiveInfoViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/7/24.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TutoriumInfoViewController.h"
#import "ExclusiveInfo_InfoViewController.h"
#import "ExclusiveInfo_TeacherViewController.h"
#import "ExclusiveInfo_ClassListViewController.h"

@interface ExclusiveInfoViewController : TutoriumInfoViewController

@property (nonatomic, strong) ExclusiveInfo_InfoViewController *info_VC ;
@property (nonatomic, strong) ExclusiveInfo_TeacherViewController *teacher_VC ;
@property (nonatomic, strong) ExclusiveInfo_ClassListViewController *class_VC ;


@end
