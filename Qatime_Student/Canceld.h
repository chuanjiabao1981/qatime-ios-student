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


@property (nonatomic, strong) NSString *orderID ;
@property (nonatomic, strong) NSString *amount ;
@property (nonatomic, strong) NSString *pay_type ;
@property (nonatomic, strong) NSString *status ;
@property (nonatomic, strong) NSString *source ;
@property (nonatomic, strong) NSString *created_at ;
@property (nonatomic, strong) NSString *updated_at ;
@property (nonatomic, strong) NSString *pay_at ;
@property (nonatomic, strong) NSString *prepay_id ;
@property (nonatomic, strong) NSString *nonce_str ;
@property (nonatomic, strong) NSString *app_pay_params ;
@property (nonatomic, strong) NSString *app_pay_str ;
@property (nonatomic, strong) NSString *product_type ;
@property (nonatomic, strong) NSDictionary *product ;
@property (nonatomic, strong) NSDictionary *product_interactive_course ;
@property (nonatomic, strong) NSDictionary *product_video_course;
@property (nonatomic, strong) NSString *coupon_code ;


@property(nonatomic,strong) NSString *name ;
@property(nonatomic,strong) NSString *subject ;
@property(nonatomic,strong) NSString *grade ;
@property(nonatomic,strong) NSString *preset_lesson_count ;
@property(nonatomic,strong) NSString *teacher_name ;
@property(nonatomic,strong) NSString *price ;

///* 支付*/
@property(nonatomic,strong) NSString *appid ;

@property(nonatomic,strong) NSString *timestamp ;


@end
