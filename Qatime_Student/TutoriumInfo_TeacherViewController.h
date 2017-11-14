//
//  TutoriumInfo_TeacherViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/11/10.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommandTeacher.h"
#import "TutoriumInfo_TeacherView.h"

@interface TutoriumInfo_TeacherViewController : UIViewController

@property (nonatomic, strong) TutoriumInfo_TeacherView *mainView ;

-(instancetype)initWithTeacher:(RecommandTeacher *)teacher;

@end
