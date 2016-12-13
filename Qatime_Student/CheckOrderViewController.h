//
//  CheckOrderViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/13.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckOrderView.h"

typedef NS_ENUM(NSUInteger, PayStatus) {
    recieved = 0,
    unpaid = 1,
    other = 2,
    
};

@interface CheckOrderViewController : UIViewController

@property(nonatomic,strong) CheckOrderView *checkOrderView ;

- (instancetype)initWithIDNumber:(NSString *)number andAmount:(NSString *)amount ;

@end
