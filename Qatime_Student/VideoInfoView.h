//
//  VideoInfoView.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/11.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "InfoHeaderView.h"


@interface VideoInfoView : UIView

/* 滑动选择器*/
@property(nonatomic,strong) HMSegmentedControl *segmentControl;

/* 大滑动视图*/
@property(nonatomic,strong) UIScrollView *scrollView;


/* 单独提出view3*/
@property(nonatomic,strong) UIView *view3 ;


/* 公告*/
@property(nonatomic,strong) UITableView  *noticeTabelView ;
//
//
///* 课程和教师简介中的scrollview*/
//@property(nonatomic,strong) UIScrollView *infoScrollView ;
//
///* scrollView下面分三个视图*/
////@property(nonatomic,strong) UIView *classInfoView ;
////@property(nonatomic,strong) UIView *teacherInfoView ;
//
//@property(nonatomic,strong) UITableView *classListTableView ;
//@property(nonatomic,strong) InfoHeaderView *infoHeaderView ;

//
//
///*课程名*/
//@property(nonatomic,strong) UILabel *classNameLabel ;
///* 科目名*/
//@property(nonatomic,strong) UILabel *subjectLabel ;
///* 年级名*/
//@property(nonatomic,strong) UILabel *gradeLabel ;
///* 课程数量*/
//@property(nonatomic,strong) UILabel *classCount ;
//
///* 已完成课程*/
//@property(nonatomic,strong) UILabel *completed_conunt ;
//
///* 正在进行的课程*/
////@property(nonatomic,strong) <#NSClass*#>  ;
//
///* 在线直播*/
///* */
//@property(nonatomic,strong) UILabel *onlineVideoLabel ;
//
///* 直播时间*/
//
//@property(nonatomic,strong) UILabel *liveStartTimeLabel;
//@property(nonatomic,strong) UILabel *liveEndTimeLabel;
//
//
///* 课程描述*/
//@property(nonatomic,strong) UILabel *classDescriptionLabel ;
//
//
//
//
///* 教师详情页的属性*/
//
///* 教师头像*/
//
//@property(nonatomic,strong) UIImageView *teacherHeadImage ;
//
///* 老师姓名*/
//@property(nonatomic,strong) UILabel *teacherNameLabel ;
//
///* 性别*/
//@property(nonatomic,strong) UIImageView *genderImage ;
//
///* 学龄阶段*/
////@property(nonatomic,strong) UILabel *category ;
//
//
///* 科目*/
//
////@property(nonatomic,strong) UILabel *subject ;
//
///* 教龄*/
//@property(nonatomic,strong) UILabel *teaching_year ;
//
///* 地址*/
////@property(nonatomic,strong) UILabel *province ;
////
////@property(nonatomic,strong) UILabel *city ;
//
///* 学校*/
//@property(nonatomic,strong) UILabel *workPlace ;
//
///* 自我介绍*/
//@property(nonatomic,strong) UILabel *selfInterview ;
//
//





@end
