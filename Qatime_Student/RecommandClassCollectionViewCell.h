//
//  RecommandClassCollectionViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

//#import "TutoriumCollectionViewCell.h"
#import "RecommandClasses.h"

@interface RecommandClassCollectionViewCell : UICollectionViewCell

/* 课程名称*/
@property(nonatomic,strong) UILabel *className ;
/* 课程的背景图*/
@property(nonatomic,strong) UIImageView *classImage ;
/* 教师姓名*/
@property(nonatomic,strong) UILabel *teacherName ;


/* 年级*/
@property(nonatomic,strong) UILabel *grade ;

/* 科目*/
@property(nonatomic,strong) UILabel *subjectName ;
/* 已购买的用户*/

@property(nonatomic,strong) UILabel *saleNumber ;

/* 推荐原因(最新/最热)*/
@property(nonatomic,strong) UILabel *reason ;
/* 复用的判断属性,是否最新或者最热*/
@property(nonatomic,assign) BOOL isNewest ;
@property(nonatomic,assign) BOOL isHottest ;
/* model*/
@property(nonatomic,strong) RecommandClasses *model ;

@property(nonatomic,strong) UILabel *saledLabel ;




@end
