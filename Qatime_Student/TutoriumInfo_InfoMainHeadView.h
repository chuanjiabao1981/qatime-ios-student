//
//  TutoriumInfo_InfoMainHeadView.h
//  Qatime_Student
//
//  Created by Shin on 2017/11/10.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTGTextTagCollectionView.h"
#import "TutoriumList.h"
#import "NSAttributedString+YYText.h"

typedef void(^EndfreshTTGTextTag)(CGFloat height);

@interface TutoriumInfo_InfoMainHeadView : UICollectionReusableView <TTGTextTagCollectionViewDelegate>
/* 科目*/
@property(nonatomic,strong) UILabel *subjectLabel ;

/* 年级*/
@property(nonatomic,strong) UILabel *gradeLabel ;

/* 课时*/
@property(nonatomic,strong) UILabel *classCount ;

/* 直播时间*/
@property(nonatomic,strong) UILabel *liveTimeLabel ;

/** 标签 */
@property (nonatomic, strong) UILabel *tags ;

/* 课程标签图*/
@property (nonatomic, strong) TTGTextTagCollectionView *classTagsView ;
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

//高度变化的block
@property (nonatomic, copy) EndfreshTTGTextTag tagEndrefresh ;


@property (nonatomic, strong) TutoriumListInfo *tutorium ;
@end
