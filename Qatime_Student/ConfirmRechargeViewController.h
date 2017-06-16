//
//  ConfirmRechargeViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/26.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recharge.h"
#import <StoreKit/StoreKit.h>
#import "ItunesProduct.h"


@interface ConfirmRechargeViewController : UIViewController <SKPaymentTransactionObserver,SKProductsRequestDelegate>{
    
    /**购买类型*/
    int buyType;
}


- (void)requestProUpgradeProductData;

-(void)RequestProductData;

-(void)buy:(int)type;

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;

-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction;

- (void) completeTransaction: (SKPaymentTransaction *)transaction;

- (void) failedTransaction: (SKPaymentTransaction *)transaction;

-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction;

-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error;

- (void) restoreTransaction: (SKPaymentTransaction *)transaction;

-(void)provideContent:(NSString *)product;

-(void)recordTransaction:(NSString *)product;



/**
 初始化方法

 @param recharge 从服务器拿到的服务端订单信息
 @return 实例
 */
-(instancetype)initWithRechage:(Recharge *)recharge andProduct:(ItunesProduct *)product;

@end