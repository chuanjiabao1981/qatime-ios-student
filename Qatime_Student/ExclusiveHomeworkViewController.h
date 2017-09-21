//
//  ExclusiveHomeworkViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/8/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassHomeworkCell.h"
#import "ClassHomework.h"
#import "HomeworkManage.h"

@interface ExclusiveHomeworkViewController : UIViewController

@property (nonatomic, strong) UITableView *mainView ;

-(instancetype)initWithClassID:(NSString *)classID;

@end
