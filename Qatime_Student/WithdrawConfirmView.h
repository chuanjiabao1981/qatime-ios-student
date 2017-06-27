//
//  WithdrawConfirmView.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/12.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawConfirmView : UIView

/* 订单号*/
@property(nonatomic,strong) UILabel *orderNumber ;

/* 时间*/

@property(nonatomic,strong) UILabel *time ;
/* 交易类型*/
@property(nonatomic,strong) UILabel *type ;
/* 提现方式*/
@property(nonatomic,strong) UILabel *method ;
/* 提现金额*/
@property(nonatomic,strong) UILabel *money ;

/* 手续费*/
//@property(nonatomic,strong) UILabel *fee ;


/* 确定按钮*/
@property(nonatomic,strong) UIButton *finishButton ;


@end
