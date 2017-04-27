//
//  ItunesProduct.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/27.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItunesProduct : NSObject
//"id": 1,
//"product_id": "Charge_50",
//"name": "50元充值卡",
//"price": "50.0",
//"amount": "34.3",
//"online": true

@property (nonatomic, strong) NSString *product_id ;
@property (nonatomic, strong) NSString *name ;
@property (nonatomic, strong) NSString *price ;
@property (nonatomic, strong) NSString *amount ;
@property (nonatomic, assign) BOOL online ;
@end
