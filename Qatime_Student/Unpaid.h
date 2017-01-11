//
//  Unpaid.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/9.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Unpaid : NSObject

//"id": "201611110928180185",
//"amount": "0.0",
//"pay_type": "weixin",
//"status": "unpaid",
//"source": "app",
//"created_at": "2016-11-11T09:28:18.088+08:00",
//"updated_at": "2016-11-11T09:28:18.088+08:00",
//"pay_at": null,
//"prepay_id": "wx20161111092818cca03172780469801747",
//"nonce_str": "McHGp2QFUNtKB4BI",
//"app_pay_params": {
//    "appid": "wxf2dfbeb5f641ce40",
//    "partnerid": "1379576802",
//    "package": "Sign=WXPay",
//    "timestamp": "1481251614",
//    "prepayid": "wx20161111092818cca03172780469801747",
//    "noncestr": "McHGp2QFUNtKB4BI",
//    "sign": "9C2B0A68145DFFCE336EFA2C6BA7A27F"
//},
//"app_pay_str": null,
//"product": {
//    "id": 25,
//    "name": "初中数学",
//    "subject": "数学",
//    "grade": "初一",
//    "teacher_name": "马燕兆",
//    "price": 50,
//    "current_price": 50,
//    "chat_team_id": "7962752",
//    "chat_team_owner": "8b8dac47fc743ebc7d163bd360caaafb",
//    "buy_tickets_count": 0,
//    "status": "teaching",
//    "preset_lesson_count": 2,
//    "completed_lesson_count": 0,
//    "completed_lessons_count": 0,
//    "live_start_time": "2016-09-25 10:00",
//    "live_end_time": "2016-09-25 22:00",
//    "publicize": "http://qatime-testing.oss-cn-beijing.aliyuncs.com/courses/publicize/list_2d71a0cb8c07f529009ce51bb8cd3dbf.jpg"
//}
//},


@property(nonatomic,strong) NSString *status ;
@property(nonatomic,strong) NSString *name ;
@property(nonatomic,strong) NSString *subject ;
@property(nonatomic,strong) NSString *grade ;
@property(nonatomic,strong) NSString *preset_lesson_count ;
@property(nonatomic,strong) NSString *teacher_name ;
@property(nonatomic,strong) NSString *price ;
/* 支付*/
@property(nonatomic,strong) NSString *appid ;
@property(nonatomic,strong) NSString *pay_type;
@property(nonatomic,strong) NSString *timestamp ;
@property(nonatomic,strong) NSString *orderID ;
@property(nonatomic,strong) NSString *created_at ;
@property(nonatomic,strong) NSString *pay_at ;


@end
