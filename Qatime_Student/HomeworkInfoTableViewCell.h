//
//  HomeworkInfoTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/9/12.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomeworkInfo.h"

@interface HomeworkInfoTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *index ;

@property (nonatomic, strong) UILabel *title ;

@property (nonatomic, strong) UILabel *status ;

//我的答案
@property (nonatomic, strong) UILabel *answerTitle ;

//老师批改
@property (nonatomic, strong) UILabel *teacherCheckTitle ;

@property (nonatomic, strong) HomeworkInfo *model ;


@end
