//
//  CheckChargeViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/8.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckChargeView.h"

typedef NS_ENUM(NSUInteger, PayStatus) {
    recieved = 0,
    unpaid = 1,
    other = 2,
    
};


@interface CheckChargeViewController : UIViewController

@property(nonatomic,strong) CheckChargeView *checkChargeView ;

- (instancetype)initWithIDNumber:(NSString *)number andAmount:(NSString *)amount ;

@end
