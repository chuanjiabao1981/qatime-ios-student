//
//  MyOrderViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"
#import "MyOrderView.h"

#import "UnpaidOrderView.h"
#import "PaidOrderView.h"
#import "CanceldOrderView.h"

@interface MyOrderViewController : UIViewController

@property(nonatomic,strong) MyOrderView *myOrderView ;

/* 未付款页*/
@property(nonatomic,strong) UnpaidOrderView *unpaidView ;

/* 已付款页*/

@property(nonatomic,strong) PaidOrderView *paidView ;
/* 取消列表页*/
@property(nonatomic,strong) CanceldOrderView *cancelView ;

@end
