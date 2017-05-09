//
//  VideoClassInfoView.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/11.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "VideoClassInfo.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "WorkFlowView.h"


@interface VideoClassInfoView : UIScrollView
/* 课程名*/
@property(nonatomic,strong) UILabel  *className ;

/**课程特色*/
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


/* 视频时长*/
@property(nonatomic,strong) UILabel *liveTimeLabel ;

/* 课程目标*/
@property (nonatomic, strong) UILabel *classTarget ;

/* 适合人群*/
@property (nonatomic, strong) UILabel *suitable ;


/* 辅导简介*/
@property(nonatomic,strong) UILabel *descriptions  ;//"辅导简介"字样,自动布局使用
@property(nonatomic,strong) UILabel *classDescriptionLabel ;

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

@property(nonatomic,strong) UIView *view3 ;

/* 课程列表*/
@property(nonatomic,strong) UITableView *classesListTableView ;


/**model*/
@property (nonatomic, strong) VideoClassInfo *model ;

@end
