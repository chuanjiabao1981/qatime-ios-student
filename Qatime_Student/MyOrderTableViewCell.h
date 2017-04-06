//
//  MyOrderTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/8.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Unpaid.h"

@interface MyOrderTableViewCell : UITableViewCell
/* 课程名*/
@property(nonatomic,strong) UILabel  *name ;
/**订单课程信息*/
@property (nonatomic, strong) UILabel *orderInfos ;

/* 价格*/
@property(nonatomic,strong) UILabel *price ;
/* 交易状态*/
@property(nonatomic,strong) UILabel *status ;
/* 左侧按钮*/
@property(nonatomic,strong) UIButton *leftButton;

/* 右侧按钮*/
@property(nonatomic,strong) UIButton *rightButton ;

/* frame model*/
@property(nonatomic,strong) Unpaid *unpaidModel ;

@property (nonatomic, strong) UIView *content ;


@end
