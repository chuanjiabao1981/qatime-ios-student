//
//  RefundTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/1/17.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Refund.h"



@interface RefundTableViewCell : UITableViewCell
/* 编号*/
@property(nonatomic,strong) UILabel *number ;

/* 退款方式*/
@property(nonatomic,strong) UILabel *mode ;
/* 时间*/
@property(nonatomic,strong) UILabel *time ;
/* 金额*/
@property(nonatomic,strong) UILabel *money ;

/* 状态*/
@property(nonatomic,strong) UILabel *status ;

/* frame model*/
@property(nonatomic,strong) Refund *model ;

@end
