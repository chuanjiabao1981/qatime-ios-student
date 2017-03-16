//
//  QualityTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

//  新首页 用的cell

#import <UIKit/UIKit.h>
#import "QualityClass.h"
#import "TutoriumList.h"


@interface QualityTableViewCell : UITableViewCell

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
@property (nonatomic, strong) UILabel *gradeAndSubject ;

/**
 教师名
 */
@property (nonatomic, strong) UILabel *teacherName ;

/**
 两个状态标签
 */
@property (nonatomic, strong) UILabel *left_StateLabel ;
@property (nonatomic, strong) UILabel *right_StateLabel ;


/**
 model
 */
@property (nonatomic, strong) QualityClass *model ;


/**
 classModel
 */
@property (nonatomic, strong) TutoriumListInfo *classModel ;

@end
