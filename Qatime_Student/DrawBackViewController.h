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

@interface DrawBackViewController : UIViewController

@property(nonatomic,strong) DrawBackView *drawBackView ;



-(instancetype)initWithPaidOrder:(Paid *)paidOrder;

@end
