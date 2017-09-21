//
//  ClassHomeworkCell.h
//  Qatime_Teacher
//
//  Created by Shin on 2017/9/8.
//  Copyright © 2017年 Shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassHomework.h"
#import "HomeworkManage.h"
//#import "AssignedHomework.h"

@interface ClassHomeworkCell : UITableViewCell

@property (nonatomic, strong) UILabel *title ;

@property (nonatomic, strong) UILabel *name ;

@property (nonatomic, strong) UILabel *created_at ;

@property (nonatomic, strong) UILabel *status ;

@property (nonatomic, strong) ClassHomework *model ;

@property (nonatomic, strong) HomeworkManage *homeworkModel ;

//@property (nonatomic, strong) AssignedHomework *assignedModel ;

@end
