//
//  WithDrawViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/11.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WithDrawView.h"

@interface WithDrawViewController : UIViewController

@property(nonatomic,strong) WithDrawView *withDrawView ;

-(instancetype)initWithEnableAmount:(NSString *)amount;

@end
