//
//  InteractiveInfo_ClassListViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/11/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneOnOneLessonTableViewCell.h"


@interface InteractiveInfo_ClassListViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray <InteractionLesson *>*lesonsArray ;

-(instancetype)initWithLessons:(__kindof NSArray *)lessons bought:(BOOL)bought;
@end
