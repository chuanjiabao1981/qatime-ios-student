//
//  PayConfirmViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/13.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"
#import "PayConfirmView.h"

@interface PayConfirmViewController : UIViewController

@property(nonatomic,strong) PayConfirmView *payConfirmView ;

-(instancetype)initWithData:(NSDictionary *)dataDic ;

@end
