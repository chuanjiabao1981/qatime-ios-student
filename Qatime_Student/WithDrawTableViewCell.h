//
//  WithDrawTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WithDraw.h"


@interface WithDrawTableViewCell : UITableViewCell
/* 编号*/
@property(nonatomic,strong) UILabel *number ;

/* 支付方式*/
@property(nonatomic,strong) UILabel *mode ;
/* 时间*/

@property(nonatomic,strong) UILabel *time ;
/* 金额*/
@property(nonatomic,strong) UILabel *money ;
/* 状态*/
@property(nonatomic,strong) UILabel *status ;


/* frame model*/
@property(nonatomic,strong) WithDraw *model ;

@end
