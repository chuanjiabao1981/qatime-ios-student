//
//  TeacherPublicClassCollectionViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/9.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TutoriumList.h"
#import "UIImageView+WebCache.h"
#import "OneOnOneClass.h"

@interface TeacherPublicClassCollectionViewCell : UICollectionViewCell

/* 课程名称*/
@property(nonatomic,strong) UILabel *className ;
/* 课程的背景图*/
@property(nonatomic,strong) UIImageView *classImage ;
/* 年级*/
@property(nonatomic,strong) UILabel *grade ;

/* 科目*/
@property(nonatomic,strong) UILabel *subjectName ;


/* 价格*/
@property(nonatomic,strong) UILabel *priceLabel ;

/* model*/
@property(nonatomic,strong) TutoriumListInfo *model ;
/**一对一model*/
@property (nonatomic, strong) OneOnOneClass *oneOnOneModel ;

@end
