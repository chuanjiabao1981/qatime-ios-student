//
//  MyClassTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "MyTutoriumModel.h"

@interface UnStartClassTableViewCell :UITableViewCell


/**
 课程图片
 */
@property(nonatomic,strong) UIImageView *classImage ;


/**
 课程名称
 */

@property(nonatomic,strong) UILabel *className ;

/* 年级*/
@property(nonatomic,strong) UILabel *grade ;

/* 科目*/
@property(nonatomic,strong) UILabel *subject ;

/* 老师姓名*/
@property(nonatomic,strong) UILabel *teacherName ;


/* 状态*/

@property(nonatomic,strong) UILabel *status ;



/* 外框content*/
@property(nonatomic,strong) UIView *content;

/* 距离开课时间*/

@property(nonatomic,strong) UILabel *deadLineLabel ;


/* 数据model*/

@property(nonatomic,strong) MyTutoriumModel *model ;

@end