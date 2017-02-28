//
//  ViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDVTabBarController.h"

#import "IndexPageViewController.h"
#import "TutoriumViewController.h"
#import "ClassTimeViewController.h"
#import "PersonalViewController.h"
#import "NoticeIndexViewController.h"
#import "RDVTabBarItem.h"

@interface ViewController : RDVTabBarController
/* 五个选项卡的ViewController*/
@property(nonatomic,strong) IndexPageViewController *indexPageViewController ;
@property(nonatomic,strong) TutoriumViewController *tutoriumViewController ;
@property(nonatomic,strong) ClassTimeViewController *classTimeViewController ;
@property(nonatomic,strong) PersonalViewController *personalViewController ;
@property(nonatomic,strong) NoticeIndexViewController *noticeIndexViewController ;



@end

