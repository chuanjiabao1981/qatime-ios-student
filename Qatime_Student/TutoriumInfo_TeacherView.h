//
//  TutoriumInfo_TeacherView.h
//  Qatime_Student
//
//  Created by Shin on 2017/11/10.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommandTeacher.h"

@protocol TeacherTapProtocol <NSObject>

- (void)tapTeachers;
@end

@interface TutoriumInfo_TeacherView : UIScrollView
/* 教师姓名*/
@property(nonatomic,strong) UILabel *teacherNameLabel ;

/* 指教年限*/
@property(nonatomic,strong) UIButton  *workYearsLabel ;

/* 所在学校*/
@property(nonatomic,strong) UILabel *workPlaceLabel ;

/* 教师简介*/

@property(nonatomic,strong) UILabel *descrip  ;//"教师简介"的label 布局用
@property(nonatomic,strong) UILabel *teacherInterviewLabel ;

/* 性别*/
@property(nonatomic,strong) UIImageView *genderImage ;

/* 老师照片*/
@property(nonatomic,strong) UIImageView *teacherHeadImage ;

@property (nonatomic, strong) RecommandTeacher *teacher ;

/** 右箭头,跳到教师个人页 */
@property (nonatomic, strong) UIButton *arrowBtn ;

@property (nonatomic, weak) id<TeacherTapProtocol> teacherdelegate ;

@end
