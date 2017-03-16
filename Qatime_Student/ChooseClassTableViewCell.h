//
//  ChooseClassTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/16.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TutoriumList.h"

@interface ChooseClassTableViewCell : UITableViewCell

/**
 课程图片
 */
@property (nonatomic, strong) UIImageView *classImage ;

/**
 课程名
 */
@property (nonatomic, strong) UILabel *className ;

/**
 年级和科目
 */
@property (nonatomic, strong) UILabel *price ;

/**
 教师名
 */
@property (nonatomic, strong) UILabel *teacherName ;

/**
 classModel
 */
@property (nonatomic, strong) TutoriumListInfo *model ;

@end
