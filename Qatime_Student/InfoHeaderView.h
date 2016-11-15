//
//  InfoHeaderView.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/15.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoHeaderView : UIView


/*课程名*/
@property(nonatomic,strong) UILabel *classNameLabel ;
/* 科目名*/
@property(nonatomic,strong) UILabel *subjectLabel ;
/* 年级名*/
@property(nonatomic,strong) UILabel *gradeLabel ;
/* 课程数量*/
@property(nonatomic,strong) UILabel *classCount ;

/* 已完成课程*/
@property(nonatomic,strong) UILabel *completed_conunt ;



/* 在线直播*/
/* */
@property(nonatomic,strong) UILabel *onlineVideoLabel ;

/* 直播时间*/

@property(nonatomic,strong) UILabel *liveStartTimeLabel;
@property(nonatomic,strong) UILabel *liveEndTimeLabel;


/* 课程描述*/
@property(nonatomic,strong) UILabel *classDescriptionLabel ;




/* 教师详情页的属性*/

/* 教师头像*/

@property(nonatomic,strong) UIImageView *teacherHeadImage ;

/* 老师姓名*/
@property(nonatomic,strong) UILabel *teacherNameLabel ;

/* 性别*/
@property(nonatomic,strong) UIImageView *genderImage ;

/* 学龄阶段*/
//@property(nonatomic,strong) UILabel *category ;


/* 科目*/

//@property(nonatomic,strong) UILabel *subject ;

/* 教龄*/
@property(nonatomic,strong) UILabel *teaching_year ;

/* 地址*/
//@property(nonatomic,strong) UILabel *province ;
//
//@property(nonatomic,strong) UILabel *city ;

/* 学校*/
@property(nonatomic,strong) UILabel *workPlace ;

/* 自我介绍*/
@property(nonatomic,strong) UILabel *selfInterview ;


/* 自动布局参考线*/
@property(nonatomic,strong) UILabel *layoutLine;





@end
