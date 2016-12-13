//
//  WithdrawConfirmViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/12.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WithdrawConfirmView.h"

@interface WithdrawConfirmViewController : UIViewController

@property(nonatomic,strong) WithdrawConfirmView *withdrawConfirmView ;

- (instancetype)initWithData:(NSDictionary *)datadic;

@end
