//
//  Canceld.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/9.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "app_pay_params.h"

@interface Canceld : NSObject


@property(nonatomic,strong) NSString *status ;
@property(nonatomic,strong) NSString *name ;
@property(nonatomic,strong) NSString *subject ;
@property(nonatomic,strong) NSString *grade ;
@property(nonatomic,strong) NSString *preset_lesson_count ;
@property(nonatomic,strong) NSString *teacher_name ;
@property(nonatomic,strong) NSString *price ;
@property(nonatomic,strong) NSString *productID ;
/* 支付*/
@property(nonatomic,strong) NSString *appid ;
@property(nonatomic,strong) NSString *pay_type;
@property(nonatomic,strong) NSString *timestamp ;
@property(nonatomic,strong) NSString *orderID ;
@property(nonatomic,strong) NSString *created_at ;
@property(nonatomic,strong) NSString *pay_at ;

@property(nonatomic,strong) NSDictionary *app_pay_params ;


@end
