//
//  VideoClassInfo_TeacherViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/11/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoClassInfo_TeacherView.h"


@interface VideoClassInfo_TeacherViewController : UIViewController

@property (nonatomic, strong) VideoClassInfo_TeacherView *mainView ;

-(instancetype)initWithTeacher:(Teacher *)teacher;

@end
