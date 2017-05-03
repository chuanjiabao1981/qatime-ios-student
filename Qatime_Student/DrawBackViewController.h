//
//  DrawBackViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/1/9.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawBackView.h"
#import "Paid.h"
#import "Refund.h"

@interface DrawBackViewController : UIViewController

@property(nonatomic,strong) DrawBackView *drawBackView ;

@property(nonatomic,strong) UIButton *finishButton ;

-(instancetype)initWithOrderNumber:(NSString *)orderNumber;

-(instancetype)initWithPaidOrder:(Paid *)paidOrder;

-(instancetype)initWithRefundOrder:(Refund *)refundOrder;


@end
