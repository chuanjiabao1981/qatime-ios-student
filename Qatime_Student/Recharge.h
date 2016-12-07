//
//  Recharge.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recharge : NSObject



@property(nonatomic,strong) NSString *idNumber ;
@property(nonatomic,strong) NSString *amount ;
@property(nonatomic,strong) NSString *pay_type ;
@property(nonatomic,strong) NSString *status ;
@property(nonatomic,strong) NSString *source ;
@property(nonatomic,strong) NSString *created_at ;
@property(nonatomic,strong) NSString *updated_at ;
@property(nonatomic,strong) NSString *pay_at ;
@property(nonatomic,strong) NSString *prepay_id ;
@property(nonatomic,strong) NSString *nonce_str ;

@property(nonatomic,strong) NSString *timeStamp ;



@end
