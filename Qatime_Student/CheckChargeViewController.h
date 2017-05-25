//
//  CheckChargeViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/8.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckChargeView.h"
#import "ItunesProduct.h"
#import <StoreKit/StoreKit.h>


typedef NS_ENUM(NSUInteger, PayStatus) {
    recieved = 0,
    unpaid = 1,
    other = 2,
    
};

@interface CheckChargeViewController : UIViewController

@property(nonatomic,strong) CheckChargeView *checkChargeView ;

/**废弃方法*/
- (instancetype)initWithIDNumber:(NSString *)number andAmount:(NSString *)amount ;


/**
 校验后台是否充值成功

 @param transaction 支付回调transaction
 @param product 产品
 @return 实例
 */
-(instancetype)initWithTransaction:(SKPaymentTransaction *)transaction andProduct:(ItunesProduct *)product;

@end
