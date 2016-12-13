//
//  PayConfirmView.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/13.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayConfirmView : UIView

/* 订单号*/
@property(nonatomic,strong) UILabel *number ;

/* 创建时间*/
@property(nonatomic,strong) UILabel *time ;

/* 支付方式*/
@property(nonatomic,strong) UILabel *type ;

/* 支付金额*/
@property(nonatomic,strong) UILabel *money ;

/* 确认支付按钮*/

@property(nonatomic,strong) UIButton *finishButton ;

@end
