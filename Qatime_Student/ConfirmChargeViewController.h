//
//  ConfirmChargeViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfirmChargeView.h"
#import "Recharge.h"
#import "Unpaid.h"
@interface ConfirmChargeViewController : UIViewController

@property(nonatomic,strong) ConfirmChargeView *confirmView ;

/* 传字典初始化方法*/
- (instancetype)initWithInfo:(__kindof NSDictionary *)info;
/* 传model初始化方法*/
-(instancetype)initWithModel:(Recharge *)model;

-(instancetype)initWithPayModel:(Unpaid *)model;


@end
