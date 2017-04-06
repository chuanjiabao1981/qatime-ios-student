//
//  Paid.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/9.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "app_pay_params.h"

@interface Paid : NSObject

//
//{
//    "id": "201610111014520082",
//    "amount": "3000.0",
//    "pay_type": "weixin",
//    "status": "shipped",
//    "source": "web",
//    "created_at": "2016-10-11T10:14:52.275+08:00",
//    "updated_at": "2016-10-11T10:15:36.610+08:00",
//    "pay_at": "2016-10-11T10:15:36.593+08:00",
//    "prepay_id": "wx20161011101453b3b2af05600765742763",
//    "nonce_str": "KWmX7Pjem9zySlOa",
//    "app_pay_params": {
//        "appid": "wxf2dfbeb5f641ce40",
//        "partnerid": "1379576802",
//        "package": "Sign=WXPay",
//        "timestamp": "1481252943",
//        "prepayid": "wx20161011101453b3b2af05600765742763",
//        "noncestr": "KWmX7Pjem9zySlOa",
//        "sign": "F4BD14923A892C9492EECBC76BCE5EAD"
//    },
//    "app_pay_str": null,
//    "product": {
//        "id": 27,
//        "name": "钢琴辅导班",
//        "subject": "数学",
//        "grade": "初二",
//        "teacher_name": "王志成",
//        "price": 3000,
//        "current_price": 0,
//        "chat_team_id": "7964474",
//        "chat_team_owner": "07b7c43a854ed44d36c2941f1fc5ad00",
//        "buy_tickets_count": 1,
//        "status": "completed",
//        "preset_lesson_count": 10,
//        "completed_lesson_count": 10,
//        "completed_lessons_count": 10,
//        "live_start_time": "2016-09-12 11:33",
//        "live_end_time": "2016-10-11 17:24",
//        "publicize": "%@/imgs/no_img.png"
//    }
//},

@property(nonatomic,strong) NSString *amount ;
@property(nonatomic,strong) NSString *status ;
@property(nonatomic,strong) NSString *name ;
@property(nonatomic,strong) NSString *subject ;
@property(nonatomic,strong) NSString *grade ;
@property(nonatomic,strong) NSString *preset_lesson_count ;
@property(nonatomic,strong) NSString *completed_lessons_count ;
@property(nonatomic,strong) NSString *teacher_name ;
@property(nonatomic,strong) NSString *price ;
/* 支付*/
@property(nonatomic,strong) NSString *appid ;
@property(nonatomic,strong) NSString *pay_type;
@property(nonatomic,strong) NSString *timestamp ;
@property(nonatomic,strong) NSString *orderID ;
@property(nonatomic,strong) NSString *created_at ;
@property(nonatomic,strong) NSString *pay_at ;
@property(nonatomic,strong) NSString *updated_at ;

@property(nonatomic,strong) NSDictionary *app_pay_params ;

//课程类型
@property (nonatomic, strong) NSString *type ;

@end
