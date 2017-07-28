//
//  ExclusivePlayerInfoView.h
//  Qatime_Student
//
//  Created by Shin on 2017/7/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TutoriumList.h"
#import "ExclusiveInfo.h"

@interface ExclusivePlayerInfoView : UIView
/*课程名*/
@property(nonatomic,strong) UILabel *classNameLabel ;
/* 科目名*/
@property(nonatomic,strong) UILabel *subjectLabel ;
/* 年级名*/
@property(nonatomic,strong) UILabel *gradeLabel ;
/* 课程数量*/
@property(nonatomic,strong) UILabel *classCount ;

/* 直播时间*/
@property(nonatomic,strong) UILabel *liveTimeLabel;

/* 课程目标*/
@property (nonatomic, strong) UILabel *classTarget ;

/* 适合人群*/
@property (nonatomic, strong) UILabel *suitable ;


/* 课程描述*/
@property(nonatomic,strong) UILabel *descriptions  ; //"辅导简介"字样,做自动布局
@property(nonatomic,strong) UILabel *classDescriptionLabel ;

/* 教师头像*/
@property(nonatomic,strong) UIImageView *teacherHeadImage ;

/* 老师姓名*/
@property(nonatomic,strong) UILabel *teacherNameLabel ;

/* 性别*/
@property(nonatomic,strong) UIImageView *genderImage ;

/* 教龄*/
@property(nonatomic,strong) UILabel *teaching_year ;

/* 学校*/
@property(nonatomic,strong) UILabel *workPlace ;

/* 自我介绍*/

@property(nonatomic,strong) UILabel *selfIntroLabel;    //"自我介绍"label 自适应高度布局使用
@property(nonatomic,strong) UILabel *selfInterview ;

/* 自动布局参考线*/
@property(nonatomic,strong) UIView *layoutLine;

@property (nonatomic, strong) ExclusiveInfo *model ;

@end
