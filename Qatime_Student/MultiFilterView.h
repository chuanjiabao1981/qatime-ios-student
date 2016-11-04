//
//  MultiFilterView.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/4.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiFilterView : UIView

/* 价格范围*/

/* 最低价*/
@property(nonatomic,strong) UITextField *lowPrice ;
/* 最高价*/
@property(nonatomic,strong) UITextField *highPrice ;

/* 课时范围*/
/* */
@property(nonatomic,strong) UITextField *class_Low;
@property(nonatomic,strong) UITextField *class_High ;

/* 开课时间范围*/
/* 起始时间范围*/
@property(nonatomic,strong) UIButton *startTime ;
/* 截止时间范围*/
@property(nonatomic,strong) UIButton *endTime ;


/* 开课状态*/
@property(nonatomic,strong) UIButton *class_Begin ;
/* 招生状态*/
@property(nonatomic,strong) UIButton *recuit ;

/* 重置按钮*/
@property(nonatomic,strong) UIButton *resetButton ;

/* 确定按钮*/
@property(nonatomic,strong) UIButton *finishButton ;


@end
