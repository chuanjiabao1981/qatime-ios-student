//
//  VideoClassInfo_InfoView.h
//  Qatime_Student
//
//  Created by Shin on 2017/11/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoClassInfo.h"

@interface VideoClassInfo_InfoView : UIScrollView
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


/**model*/
@property (nonatomic, strong) VideoClassInfo *model ;

@end
