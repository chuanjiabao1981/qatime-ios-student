//
//  VideoClass_Player_InfoView.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/13.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoClass_Player_InfoView : UIScrollView

/** 课程名*/
@property(nonatomic,strong) UILabel  *className ;

/** 科目*/
@property(nonatomic,strong) UILabel *subjectLabel ;

/** 年级*/
@property(nonatomic,strong) UILabel *gradeLabel ;

/** 课时*/
@property(nonatomic,strong) UILabel *classCount ;

/** 直播时间*/
@property(nonatomic,strong) UILabel *liveTimeLabel ;


/**课程目标*/
@property (nonatomic, strong) UILabel *classTarget ;

/** 适合人群*/
@property (nonatomic, strong) UILabel *suitable ;


/** 辅导简介*/
@property(nonatomic,strong) UILabel *descriptions  ;//"辅导简介"字样,自动布局使用
@property(nonatomic,strong) UILabel *classDescriptionLabel ;


/** 要传数据的所有的label 2 */

@property(nonatomic,strong) UIScrollView *view2 ;

/** 教师姓名*/
@property(nonatomic,strong) UILabel *teacherNameLabel ;

/** 指教年限*/
@property(nonatomic,strong) UILabel  *workYearsLabel ;

/** 所在学校*/
@property(nonatomic,strong) UILabel *workPlaceLabel ;

/** 教师简介*/

@property(nonatomic,strong) UILabel *descrip  ;//"教师简介"的label 布局用
@property(nonatomic,strong) UILabel *teacherInterviewLabel ;

/** 性别*/
@property(nonatomic,strong) UIImageView *genderImage ;

/** 老师照片*/
@property(nonatomic,strong) UIImageView *teacherHeadImage ;



@property(nonatomic,strong) UIView *view3 ;

/* 课程列表*/
@property(nonatomic,strong) UITableView *classesListTableView ;




@end
