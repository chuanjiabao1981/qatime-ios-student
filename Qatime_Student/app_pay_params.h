//
//  app_pay_params.h
//  Qatime_Student
//
//  Created by Shin on 2017/1/20.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface app_pay_params : NSObject
//    "appid": "wxf2dfbeb5f641ce40",
//    "partnerid": "1379576802",
//    "package": "Sign=WXPay",
//    "timestamp": "1481251614",
//    "prepayid": "wx20161111092818cca03172780469801747",
//    "noncestr": "McHGp2QFUNtKB4BI",
//    "sign": "9C2B0A68145DFFCE336EFA2C6BA7A27F"

@property(nonatomic,strong) NSString *appid;
@property(nonatomic,strong) NSString *partnerid ;
@property(nonatomic,strong) NSString *package;
@property(nonatomic,strong) NSString *timestamp;
@property(nonatomic,strong) NSString *prepayid;
@property(nonatomic,strong) NSString *noncestr;
@property(nonatomic,strong) NSString *sign;
@end
