//
//  OrderInfoViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/1/10.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfoView.h"
#import "Unpaid.h"
#import "Paid.h"
#import "Canceld.h"

@interface OrderInfoViewController : UIViewController


@property(nonatomic,strong) OrderInfoView *orderInfoView ;

///* 未付款订单详情页初始化*/
//-(instancetype)initWithUnpaid:(Unpaid *)unpaid;
//
///* 已付款订单详情页初始化*/
//-(instancetype)initWithPaid:(Paid *)paid;
//
///* 已取消订单详情页初始化*/
//-(instancetype)initWithCaid:(Canceld *)canceld;
//
///* 初始化方法*/
//-(instancetype)initWithInfo:(NSDictionary *)info;


/**初始化方法,直接传order类的对象进去(paid/unpaid/cancel)*/
-(instancetype)initWithOrderInfos:(id)orderInfo;


@end
