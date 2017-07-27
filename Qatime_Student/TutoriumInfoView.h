//
//  TutoriumInfoView.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/8.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

#import "TTGTextTagCollectionView.h"
#import "OneOnOneWorkFlowView.h"
#import "WorkFlowView.h"
#import "ExclusiveInfo.h"


@interface TutoriumInfoView : UIView

/* 课程名*/
@property(nonatomic,strong) UILabel  *className ;

/* 课程图*/
//@property(nonatomic,strong) UIImageView * classImage ;

/**课程状态*/
@property(nonatomic,strong) UILabel *status ;

/** 课程特色*/
@property (nonatomic, strong) UICollectionView *classFeature ;


/* 价格*/
@property(nonatomic,strong) UILabel *priceLabel ;

/* 报名人数*/
@property(nonatomic,strong) UILabel *saleNumber ;


/* 滑动视图*/
@property(nonatomic,strong) UIScrollView  *scrollView ;

/* 滑动控制器*/

@property(nonatomic,strong) HMSegmentedControl *segmentControl ;


/* 要传数据的所有的label 1 */

@property(nonatomic,strong) UIScrollView *view1 ;

/* 科目*/
@property(nonatomic,strong) UILabel *subjectLabel ;

/* 年级*/
@property(nonatomic,strong) UILabel *gradeLabel ;

/* 课时*/
@property(nonatomic,strong) UILabel *classCount ;


/* 直播时间*/
@property(nonatomic,strong) UILabel *liveTimeLabel ;


/* 课程标签图*/
@property (nonatomic, strong) TTGTextTagCollectionView *classTagsView ;

/* 课程目标*/
@property (nonatomic, strong) UILabel *classTarget ;

/* 适合人群*/
@property (nonatomic, strong) UILabel *suitable ;


/* 辅导简介*/
@property(nonatomic,strong) UILabel *descriptions  ;//"辅导简介"字样,自动布局使用
@property(nonatomic,strong) UILabel *classDescriptionLabel ;

/**学习流程*/
@property (nonatomic, strong) WorkFlowView *workFlowView ;


/* 要传数据的所有的label 2 */

@property(nonatomic,strong) UIScrollView *view2 ;

/* 教师姓名*/
@property(nonatomic,strong) UILabel *teacherNameLabel ;

/* 指教年限*/
@property(nonatomic,strong) UILabel  *workYearsLabel ;

/* 所在学校*/
@property(nonatomic,strong) UILabel *workPlaceLabel ;

/* 教师简介*/

@property(nonatomic,strong) UILabel *descrip  ;//"教师简介"的label 布局用
@property(nonatomic,strong) UILabel *teacherInterviewLabel ;

/* 性别*/
@property(nonatomic,strong) UIImageView *genderImage ;

/* 老师照片*/
@property(nonatomic,strong) UIImageView *teacherHeadImage ;


/* 教师标签*/
@property (nonatomic, strong) TTGTextTagCollectionView *teacherTagsView ;



@property(nonatomic,strong) UIView *view3 ;

/* 课程列表*/
@property(nonatomic,strong) UITableView *classesListTableView ;

@property (nonatomic, strong) ExclusiveInfo *exclusiveModel ;



@end
