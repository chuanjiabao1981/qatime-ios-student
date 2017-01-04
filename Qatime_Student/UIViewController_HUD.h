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


/**
 加载HUD

 @param hudTitle 加载文字
 */
- (void) loadingHUDStartLoadingWithTitle:(NSString * _Nullable)hudTitle;



/**
 结束HUD

 @param hudTitle 结束文字
 */
- (void) loadingHUDStopLoadingWithTitle:(NSString *_Nullable)hudTitle;


/**
 停止
 */
- (void)stopHUD;

+ (instancetype)loadingHUD;

+ (instancetype)endHUD;


@end
