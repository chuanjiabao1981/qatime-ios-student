//
//  ConfirmRechargeView.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/26.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recharge.h"

@interface ConfirmRechargeView : UIView

/* 交易编号*/
@property(nonatomic,strong) UILabel *number ;

/* 时间*/
@property(nonatomic,strong) UILabel *time ;

/* 交易类型*/
@property(nonatomic,strong) UILabel *charge_type ;

/* 交易金额*/
@property(nonatomic,strong) UILabel *money ;

/* 支付按钮*/
@property(nonatomic,strong) UIButton *payButton ;
/**model*/
@property (nonatomic, strong) Recharge *model;

@end
