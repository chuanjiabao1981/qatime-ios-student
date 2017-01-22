//
//  ListenTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTutoriumModel.h"

@interface ListenTableViewCell : UITableViewCell


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


/* 已进行课时*/
@property(nonatomic,strong) UILabel *presentCount ;

/* 总课时*/
@property(nonatomic,strong) UILabel *totalCount ;

/* 进入按钮*/

@property(nonatomic,strong) UIButton *enterButton ;


/* 结课label*/
@property(nonatomic,strong) UILabel *finish ;


/* 数据model*/

@property(nonatomic,strong) MyTutoriumModel *model ;




@property(nonatomic,strong)UILabel *line;
@property(nonatomic,strong)UILabel *line2;

/*天 label*/
@property(nonatomic,strong)UILabel *days;
/* 当前进度*/
@property(nonatomic,strong)UILabel *progress;

/* 距离开课时间*/
@property(nonatomic,strong)UILabel *dist;


@end
