//
//  InteractionInfoView.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/28.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTGTextTagCollectionView.h"

#import "OneOnOneClass.h"
#import "Teacher.h"
@interface InteractionInfoView : UIView

/*课程名*/
@property(nonatomic,strong) UILabel *classNameLabel ;
/* 科目名*/
@property(nonatomic,strong) UILabel *subjectLabel ;
/* 年级名*/
@property(nonatomic,strong) UILabel *gradeLabel ;

/**总课时*/
@property(nonatomic,strong) UILabel *classDuring ;

@property (nonatomic, strong) UILabel *classPerDuring ;

/**课时数量*/
@property(nonatomic,strong) UILabel *classCountLabel;

/* 课程标签图*/
//@property (nonatomic, strong) TTGTextTagCollectionView *classTagsView ;

/* 课程目标*/
@property (nonatomic, strong) UILabel *classTarget ;

/* 适合人群*/
@property (nonatomic, strong) UILabel *suitable ;


/* 课程描述*/
@property(nonatomic,strong) UILabel *descriptions  ; //"辅导简介"字样,做自动布局
@property(nonatomic,strong) UILabel *classDescriptionLabel ;


/* 教师详情页的属性*/

/* 教师头像*/

//@property(nonatomic,strong) UIImageView *teacherHeadImage ;
//
///* 老师姓名*/
//@property(nonatomic,strong) UILabel *teacherNameLabel ;
//
///* 性别*/
//@property(nonatomic,strong) UIImageView *genderImage ;
//
//
///* 教龄*/
//@property(nonatomic,strong) UILabel *teaching_year ;
//
//
///* 学校*/
//@property(nonatomic,strong) UILabel *workPlace ;
//
//
///* 教师标签*/
//@property (nonatomic, strong) TTGTextTagCollectionView *teacherTagsView ;
//
//
///* 自我介绍*/
//
//@property(nonatomic,strong) UILabel *selfIntroLabel;    //"自我介绍"label 自适应高度布局使用
//@property(nonatomic,strong) UILabel *selfInterview ;

/* 自动布局参考线*/
@property(nonatomic,strong) UIView *layoutLine;

/**赋值用的model*/
//@property (nonatomic, strong) TutoriumListInfo *classModel ;
@property (nonatomic, strong) OneOnOneClass *classModel ;
@property (nonatomic, strong) Teacher *teacherModel ;

@end
