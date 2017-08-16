//
//  ExclusiveAskViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/8/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ExclusiveAskView.h"
#import "Qatime_Student-Swift.h"

@interface ExclusiveAskViewController : UIViewController

@property (nonatomic, strong) ExclusiveAskView *mainView ;

-(instancetype)initWithClassID:(NSString *)classID;

@end
