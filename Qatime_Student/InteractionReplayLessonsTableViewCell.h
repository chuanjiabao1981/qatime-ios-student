//
//  InteractionReplayLessonsTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/8/23.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InteractionReplayLesson.h"

@interface InteractionReplayLessonsTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *name;

@property (nonatomic, strong) InteractionReplayLesson *model ;

@end
