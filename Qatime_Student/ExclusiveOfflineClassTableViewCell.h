//
//  ExclusiveOfflineClassTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/7/24.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExclusiveLessons.h"

@interface ExclusiveOfflineClassTableViewCell : UITableViewCell
/* 状态原点图*/
@property(nonatomic,strong) UIImageView *tips ;

/* 课程名称*/
@property(nonatomic,strong) UILabel *className ;

/** 上课地点 */
@property (nonatomic, strong) UILabel *address ;

/* 上课时间*/
@property(nonatomic,strong) UILabel *classDate;

@property(nonatomic,strong) UILabel *classTime ;

/* 课程状态*/
@property(nonatomic,strong) UILabel *status ;
@property(nonatomic,strong) NSString *class_status ;


/* 回放次数*/
@property(nonatomic,strong) UIButton *replay ;

/* 数据model */
@property (nonatomic, strong) ExclusiveLessons *model ;

@end
