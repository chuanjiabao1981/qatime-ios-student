//
//  WithDraw.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WithDraw : NSObject
//"transaction_no": "201612071604530036",
//"amount": "0.1",
//"pay_type": "alipay",
//"status": "init",
//"created_at": "2016-12-07T16:04:53.292+08:00",
//"account": "18733112312",
//"name": "信雅壮"

@property(nonatomic,strong) NSString *transaction_no ;
@property(nonatomic,strong) NSString *amount ;
@property(nonatomic,strong) NSString *pay_type ;
@property(nonatomic,strong) NSString *status ;
@property(nonatomic,strong) NSString *created_at ;
@property(nonatomic,strong) NSString *account ;
@property(nonatomic,strong) NSString *name ;


@end
