//
//  ExclusiveInfo_InfoHeadView.h
//  Qatime_Student
//
//  Created by Shin on 2017/11/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExclusiveInfo.h"

@interface ExclusiveInfo_InfoHeadView : UICollectionReusableView
/* 科目*/
@property(nonatomic,strong) UILabel *subjectLabel ;

/* 年级*/
@property(nonatomic,strong) UILabel *gradeLabel ;

/* 课时*/
@property(nonatomic,strong) UILabel *classCount ;

/* 直播时间*/
@property(nonatomic,strong) UILabel *liveTimeLabel ;

/** 目标 */
@property (nonatomic, strong) UILabel *taget ;
/* 课程目标*/
@property (nonatomic, strong) UILabel *classTarget ;
/* 适合人群*/
@property (nonatomic, strong) UILabel *suitable ;
/* 辅导简介*/
@property(nonatomic,strong) UILabel *descriptions  ;//"辅导简介"字样,自动布局使用
/** 辅导简介的label */
@property(nonatomic,strong) UILabel *classDescriptionLabel ;

//课程特色大标题
@property (nonatomic, strong) UILabel *features ;

@property (nonatomic, strong) ExclusiveInfo *model ;

@end
