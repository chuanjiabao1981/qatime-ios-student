//
//  ClassTimeTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/28.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassTimeModel.h"

@interface ClassTimeTableViewCell : UITableViewCell

/**
 课程图片
 */
@property(nonatomic,strong) UIImageView *classImage ;

/**课程类型*/
@property (nonatomic, strong) UILabel *type ;

/**是否试听课*/
@property (nonatomic, strong) UILabel *isTaste ;

/**课程名称*/
@property(nonatomic,strong) UILabel *name ;

@property(nonatomic,strong) UILabel *className ;

/* 年级*/
@property(nonatomic,strong) UILabel *grade ;

/* 科目*/
@property(nonatomic,strong) UILabel *subject ;

/* 老师姓名*/
@property(nonatomic,strong) UILabel *teacherName ;

/* 日期和时间*/
@property(nonatomic,strong) UILabel *date ;



/* 状态*/

@property(nonatomic,strong) UILabel *status ;


/* 进入按钮*/

@property(nonatomic,strong) UIButton *enterButton ;


/* 自动高度的model*/
@property(nonatomic,strong) ClassTimeModel  *model ;

/* 进入按钮是否能点击*/
@property(nonatomic,assign) BOOL canUse ;

/* 外框content*/
@property(nonatomic,strong) UIView *content;

- (void)showTasteState:(BOOL)show;

@end
