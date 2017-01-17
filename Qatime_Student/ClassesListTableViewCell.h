//
//  ClassesListTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/9.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassesInfo_Time.h"
#import "Classes.h"



@interface ClassesListTableViewCell : UITableViewCell

/* 状态原点图*/
@property(nonatomic,strong) UIImageView *circle ;

/* 课程名称*/
@property(nonatomic,strong) UILabel *className ;


/* 上课时间*/
@property(nonatomic,strong) UILabel *classDate;

@property(nonatomic,strong) UILabel *classTime ;

/* 课程状态*/
@property(nonatomic,strong) UILabel *status ;
@property(nonatomic,strong) NSString *class_status ;


/* 回放次数*/
@property(nonatomic,strong) UIButton *replay ;

/* 数据model 用来计算高度*/
@property(nonatomic,strong) ClassesInfo_Time *model ;

/* 视频直播页的课程model*/
@property(nonatomic,strong) Classes *classModel ;





@end
