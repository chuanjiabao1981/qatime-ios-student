//
//  ConfirmChargeViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfirmChargeView.h"

@interface ConfirmChargeViewController : UIViewController

@property(nonatomic,strong) ConfirmChargeView *confirmView ;

- (instancetype)initWithInfo:(__kindof NSDictionary *)info;

@end
