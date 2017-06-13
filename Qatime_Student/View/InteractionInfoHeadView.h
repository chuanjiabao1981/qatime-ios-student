//
//  InteractionInfoHeadView.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/28.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTGTextTagCollectionView.h"

#import "OneOnOneClass.h"
#import "Teacher.h"
@interface InteractionInfoHeadView : UIView

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

/* 课程目标*/
@property (nonatomic, strong) UILabel *classTarget ;

/* 适合人群*/
@property (nonatomic, strong) UILabel *suitable ;


/* 课程描述*/
@property(nonatomic,strong) UILabel *descriptions  ; //"辅导简介"字样,做自动布局
@property(nonatomic,strong) UILabel *classDescriptionLabel ;

/**赋值用的model*/

@property (nonatomic, strong) OneOnOneClass *classModel ;


@end
