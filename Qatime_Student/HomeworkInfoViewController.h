//
//  HomeworkInfoViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/9/12.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkInfoView.h"
#import "HomeworkInfoTableViewCell.h"
#import "HomeworkInfo.h"

@class HomeworkManage;


@interface HomeworkInfoViewController : UIViewController

@property (nonatomic, strong) HomeworkInfoView *mainView ;


-(instancetype)initWithHomework:(HomeworkManage *)homework;

@end
