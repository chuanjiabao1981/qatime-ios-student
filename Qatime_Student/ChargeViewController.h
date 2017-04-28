//
//  ChargeViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChargeView.h"
#import <StoreKit/StoreKit.h>

//typedef enum : NSUInteger {
//    Charge_50 = 50,
//    Charge_108,
//    Charge_158,
//    Charge_208,
//    Charge_258,
//    Charge_308
//} ChargeTag;

@interface ChargeViewController : UIViewController<SKPaymentTransactionObserver,SKProductsRequestDelegate>

@property(nonatomic,strong) ChargeView *chargeView ;

- (void)requestProUpgradeProductData;

-(void)RequestProductData;

-(void)buy;

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;

-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction;

- (void) completeTransaction: (SKPaymentTransaction *)transaction;

- (void) failedTransaction: (SKPaymentTransaction *)transaction;

-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction;

-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error;

- (void) restoreTransaction: (SKPaymentTransaction *)transaction;

-(void)provideContent:(NSString *)product;

-(void)recordTransaction:(NSString *)product;

@end
