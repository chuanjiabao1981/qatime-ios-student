//
//  InfoHeaderView.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/15.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTGTextTagCollectionView.h"
#import "LiveClassInfo.h"
#import "Teacher.h"


@interface InfoHeaderView : UIView

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

/* 课程标签图*/
@property (nonatomic, strong) TTGTextTagCollectionView *classTagsView ;

/* 课程目标*/
@property (nonatomic, strong) UILabel *classTarget ;

/* 适合人群*/
@property (nonatomic, strong) UILabel *suitable ;


/* 课程描述*/
@property(nonatomic,strong) UILabel *descriptions  ; //"辅导简介"字样,做自动布局
@property(nonatomic,strong) UILabel *classDescriptionLabel ;


/* 教师详情页的属性*/

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


/* 教师标签*/
@property (nonatomic, strong) TTGTextTagCollectionView *teacherTagsView ;


/* 自我介绍*/

@property(nonatomic,strong) UILabel *selfIntroLabel;    //"自我介绍"label 自适应高度布局使用
@property(nonatomic,strong) UILabel *selfInterview ;

/* 自动布局参考线*/
@property(nonatomic,strong) UIView *layoutLine;

@property (nonatomic, strong) LiveClassInfo *model ;
@property (nonatomic, strong) Teacher *teacher ;


@end
