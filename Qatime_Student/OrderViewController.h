//
//  OrderViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/12.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderView.h"

@interface OrderViewController : UIViewController


@property(nonatomic,strong) NSString *classID ;

@property(nonatomic,strong) OrderView *orderView ;


-(instancetype)initWithClassID:(NSString *)classID;

@end
