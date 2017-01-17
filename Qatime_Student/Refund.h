//
//  Refund.h
//  Qatime_Student
//
//  Created by Shin on 2017/1/17.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Refund : NSObject

@property(nonatomic,strong) NSString *status ;
@property(nonatomic,strong) NSString *amount ;
@property(nonatomic,strong) NSString *refund_amount ;
@property(nonatomic,strong) NSString *idNumber ;
@property(nonatomic,strong) NSString *created_at ;
@property(nonatomic,strong) NSString *pay_type ;
@property(nonatomic,strong) NSString *reason ;
@property(nonatomic,strong) NSString *transaction_no ;

@end
