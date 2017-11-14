//
//  InteractiveInfo_InfoHeadView.h
//  Qatime_Student
//
//  Created by Shin on 2017/11/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneOnOneClass.h"
#import "NSAttributedString+YYText.h"


@interface InteractiveInfo_InfoHeadView : UICollectionReusableView
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

//课程特色大标题
@property (nonatomic, strong) UILabel *features ;

@property (nonatomic, strong) OneOnOneClass *model ;

@end
