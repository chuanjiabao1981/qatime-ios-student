//
//  CourseFileInfoViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/9/5.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseFileInfoView.h"

@interface CourseFileInfoViewController : UIViewController

@property (nonatomic, strong) CourseFileInfoView *mainView ;

-(instancetype)initWithFile:(CourseFile *)file;

@end
