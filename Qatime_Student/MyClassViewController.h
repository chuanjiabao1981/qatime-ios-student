//
//  MyClassViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyClassView.h"

#import "UnStartClassView.h"
#import "StartedClassView.h"
#import "EndedClassView.h"
#import "MJRefresh.h"
//#import "ListenClassView.h"

@interface MyClassViewController : UIViewController

/* 我的辅导主视图页*/
@property(nonatomic,strong) MyClassView *myClassView ;

/* 未开始课程*/
@property(nonatomic,strong) UnStartClassView *unStartClassView ;

/* 已开始课程*/
@property(nonatomic,strong) StartedClassView *startedClassView ;

/* 已结束课程*/
@property(nonatomic,strong) EndedClassView *endedClassView ;

/* 试听课程*/
//@property(nonatomic,strong) ListenClassView *listenClassView ;


@end
