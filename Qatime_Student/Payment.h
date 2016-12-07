//
//  Payment.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Payment : NSObject

//"id": 13074,
//"amount": "-3000.0",
//"change_type": "weixin",
//"created_at": "10月11日 10:15",
//"target_type": "订单"

@property(nonatomic,strong) NSString *idNumber ;
@property(nonatomic,strong) NSString *amount ;
@property(nonatomic,strong) NSString *change_type ;
@property(nonatomic,strong) NSString *created_at ;
@property(nonatomic,strong) NSString *target_type ;

@end
