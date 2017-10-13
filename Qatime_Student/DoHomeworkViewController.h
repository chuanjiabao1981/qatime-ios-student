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
#import "NewQuestionViewController.h"

//写作类型
typedef NS_ENUM(NSUInteger, WriteType) {
    Write,
    Rewrite,
};

//做作业传值
typedef void(^DoHomework)(NSDictionary *answer);

@interface DoHomeworkViewController : UIViewController
@property (nonatomic, strong) DoHomeworkView *mainView ;
@property (nonatomic, copy) DoHomework doHomework ;

-(instancetype)initWithHomework:(HomeworkInfo *)homework andWriteType:(WriteType)writeType;



@end
