
//
//  OneOnOneTutorimInfoView.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/31.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "OneOnOneWorkFlowView.h"

#import "OneOnOneClass.h"
#import "TeachersGroupTableView.h"
#import "ClassListTableView.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "WorkFlowView.h"
@interface OneOnOneTutorimInfoView : UIView

/** 课程名*/
@property(nonatomic,strong) UILabel  *className ;

/**课程特色*/
@property (nonatomic, strong) UICollectionView *classFeature ;
/** 价格*/
@property(nonatomic,strong) UILabel *priceLabel ;

/**滑动控制栏*/
@property (nonatomic, strong) HMSegmentedControl *segmentControl ;
/**大滑动视图*/
@property (nonatomic, strong) UIScrollView *scrollView ;


/** 要传数据的所有的 tag 1 */
@property(nonatomic,strong) UIScrollView *view1 ;

/** 科目*/
@property(nonatomic,strong) UILabel *subjectLabel ;

/** 年级*/
@property(nonatomic,strong) UILabel *gradeLabel ;

/**总分钟*/
@property (nonatomic, strong) UILabel *totalMinutesLabel ;

/**每节课多长时间*/
@property (nonatomic, strong) UILabel *minutesLabel ;

/** 课时*/
@property(nonatomic,strong) UILabel *classCount ;


/** 课程目标*/
@property (nonatomic, strong) UILabel *classTarget ;

/** 适合人群*/
@property (nonatomic, strong) UILabel *suitable ;


/** 辅导简介*/
@property(nonatomic,strong) UILabel *descriptions  ;//"辅导简介"字样,自动布局使用
/**辅导简介的label*/
@property(nonatomic,strong) UILabel *classDescriptionLabel ;

/**上课流程*/
@property (nonatomic, strong) WorkFlowView *workFlowView ;

/**学习须知*/


/**tag2 教师列表*/

@property (nonatomic, strong) UITableView *teachersGroupTableView ;

/**tag3 课程列表*/
@property (nonatomic, strong) UITableView *classListTableView ;


/**model*/
@property (nonatomic, strong) OneOnOneClass *model ;



@end
