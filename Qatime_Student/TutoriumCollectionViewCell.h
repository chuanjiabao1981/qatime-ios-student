//
//  TutoriumCollectionViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/2.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutoriumCollectionViewCell : UICollectionViewCell

/* 课程的背景图*/
@property(nonatomic,strong) UIImageView *classImage ;

/* 距开课时间*/
@property(nonatomic,strong) UILabel *timeToStart ;

/* 教师姓名*/
@property(nonatomic,strong) UILabel *teacherName ;


/* 年级*/
@property(nonatomic,strong) UILabel *grade ;

/* 科目*/
@property(nonatomic,strong) UILabel *subjectName ;

/* 价格*/
@property(nonatomic,strong) UILabel *price ;

/* 已购买的用户*/

@property(nonatomic,strong) UILabel *saleNumber ;



@end
