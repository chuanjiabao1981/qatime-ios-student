//
//  CashRecordView.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "RechargeTableView.h"
#import "WidthDrawTableView.h"
#import "PaymentTableView.h"
#import "RefundTableView.h"

@interface CashRecordView : UIView

/* 滑动控制器*/
@property(nonatomic,strong) HMSegmentedControl *segmentControl ;

/* 大滑动视图*/

@property(nonatomic,strong) UIScrollView *scrollView ;


/* 4张图*/
/* 充值记录*/
@property(nonatomic,strong) RechargeView *rechargeView ;

/* 提现记录*/
@property(nonatomic,strong) WidthDrawView *withDrawView ;

/* 消费记录*/
@property(nonatomic,strong) PaymentView *paymentView ;

/* 退款记录*/
@property(nonatomic,strong) RefundTableView *refundView ;
@end
