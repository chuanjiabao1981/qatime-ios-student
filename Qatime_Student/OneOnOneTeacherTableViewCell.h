//
//  OneOnOneTeacherTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/1.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Teacher.h"

@protocol OneOnOneTeacherTableViewCellDelegate <NSObject>

- (void)selectedTeacher:(NSString *)teacherID;

@end

@interface OneOnOneTeacherTableViewCell : UITableViewCell

/* 性别*/
@property(nonatomic,strong) UIImageView *genderImage ;

/* 老师照片*/
@property(nonatomic,strong) UIImageView *teacherHeadImage ;

/* 教师姓名*/
@property(nonatomic,strong) UILabel *teacherNameLabel ;

/* 指教年限*/
@property(nonatomic,strong) UILabel  *workYearsLabel ;

/* 所在学校*/
@property(nonatomic,strong) UILabel *workPlaceLabel ;

/* 教师简介*/
@property(nonatomic,strong) UILabel *descrip  ;//"教师简介"的label 布局用
@property(nonatomic,strong) UILabel *teacherInterviewLabel ;

/**教师头像点击事件*/
@property (nonatomic, strong) UITapGestureRecognizer *tap ;

/**代理*/
@property (nonatomic, weak) id <OneOnOneTeacherTableViewCellDelegate> delegate ;

/**model*/
@property (nonatomic, strong) Teacher *model ;

@end
