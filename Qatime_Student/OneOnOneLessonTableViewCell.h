//
//  OneOnOneLessonTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/1.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InteractionLesson.h"

@interface OneOnOneLessonTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *date ;

@property (nonatomic, strong) UILabel *time ;

@property (nonatomic, strong) UILabel *lessonName ;

@property (nonatomic, strong) UILabel *teacherName ;

@property (nonatomic, strong) UILabel *status ;

/**model*/
@property (nonatomic, strong) InteractionLesson *model ;

@end
