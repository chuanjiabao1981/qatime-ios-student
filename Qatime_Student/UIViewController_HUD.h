//
//  UIViewController_HUD.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//


/* 封装MBProgress   */

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIViewController ()

@property(nonatomic,strong) MBProgressHUD  *loadingHUD ;
@property(nonatomic,strong) MBProgressHUD *endHUD ;


- (void) loadingHUDStartLoadingWithTitle:(NSString *)hudTitle;

- (void) loadingHUDStopLoadingWithTitle:(NSString *)hudTitle;



@end
