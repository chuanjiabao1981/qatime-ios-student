//
//  StartedTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTutoriumModel.h"
#import "Interactive.h"


@interface StartedTableViewCell : UITableViewCell

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
//@property(nonatomic,strong) UILabel *status ;

/* 状态属性*/
@property(nonatomic,strong) NSString  *state ;


/* 外框content*/
@property(nonatomic,strong) UIView *content;


/* 进入按钮*/

@property(nonatomic,strong) UIButton *enterButton ;

/* 是否可以进入试听*/
@property(nonatomic,assign) BOOL canTaste ;

/* 已进行课时*/
@property(nonatomic,strong) UILabel *presentCount ;

/* 总课时*/
@property(nonatomic,strong) UILabel *totalCount ;



/* 数据model*/

@property(nonatomic,strong) MyTutoriumModel *model ;

 ;

@property (nonatomic, strong) Interactive *interactiveModel ;


@end
