//
//  DoHomeworkViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/9/13.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoHomeworkView.h"
#import "HomeworkInfo.h"
//做作业传值

typedef void(^DoHomework)(NSString *answer);

@interface DoHomeworkViewController : UIViewController
@property (nonatomic, strong) DoHomeworkView *mainView ;
@property (nonatomic, copy) DoHomework doHomework ;

-(instancetype)initWithHomework:(HomeworkInfo *)homework;



@end
