//
//  MyOrderTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/8.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderTableViewCell : UITableViewCell
/* 课程名*/
@property(nonatomic,strong) UILabel  *name ;
/* 科目*/
@property(nonatomic,strong) UILabel *subject ;
/* 年级*/
@property(nonatomic,strong) UILabel *grade ;
/* 课时*/
@property(nonatomic,strong) UILabel *classTime ;
/* 教师姓名*/
@property(nonatomic,strong) UILabel *teacherName ;
/* 价格*/
@property(nonatomic,strong) UILabel *price ;
/* 交易状态*/
@property(nonatomic,strong) UILabel *status ;
/* 左侧按钮*/
@property(nonatomic,strong) UIButton *leftButton;

/* 右侧按钮*/
@property(nonatomic,strong) UIButton *rightButton ;


@end
