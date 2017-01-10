//
//  OrderInfoView.h
//  Qatime_Student
//
//  Created by Shin on 2017/1/10.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderInfoView : UIView

/* 状态图*/
@property(nonatomic,strong) UIImageView *statusImage ;

/* 课程名*/
@property(nonatomic,strong) UILabel  *name ;

/* 次级课程名*/
@property(nonatomic,strong) UILabel *subName ;

/* 订单号*/
@property(nonatomic,strong) UILabel *orderNumber ;

/* 创建时间*/
@property(nonatomic,strong) UILabel *creatTime ;

/* 支付时间*/
@property(nonatomic,strong) UILabel *payTime ;

/* 支付方式*/
@property(nonatomic,strong) UILabel *payType ;

/* 支付金额*/
@property(nonatomic,strong) UILabel *amount ;

/* 取消订单按钮*/
@property(nonatomic,strong) UIButton *cancelButton ;

/* 付款按钮*/
@property(nonatomic,strong) UIButton *payButton;

@end
