//
//  TutoriumInfoViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/8.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TutoriumInfoView.h"


@interface TutoriumInfoViewController : UIViewController

/* 课程id 用来传参数*/
@property(nonatomic,strong) NSString *classID ;





@property(nonatomic,strong) TutoriumInfoView  *tutoriumInfoView ;




@end
