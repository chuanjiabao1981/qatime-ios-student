//
//  ConfirmChargeView.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmChargeView : UIView

/* 交易编号*/
@property(nonatomic,strong) UILabel *number ;

/* 时间*/
@property(nonatomic,strong) UILabel *time ;

/* 交易类型*/
@property(nonatomic,strong) UILabel *charge_type ;

/* 交易方式*/
@property(nonatomic,strong) UILabel *pay_type ;

/* 交易金额*/
@property(nonatomic,strong) UILabel *money ;


/* 支付按钮*/


@property(nonatomic,strong) UIButton *payButton ;


@end
