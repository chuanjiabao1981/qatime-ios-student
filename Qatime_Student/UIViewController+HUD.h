//
//  UIViewController+HUD.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UIViewController+HUD.h"

@interface UIViewController (HUD)

//拓展hud属性
@property (nonatomic, strong) MBProgressHUD *hud ;

@property (nonatomic, strong) MBProgressHUD *loadingHUD ;

@property (nonatomic, strong) MBProgressHUD *endHUD ;

/**
 加载HUD
 
 @param hudTitle 加载文字
 */
- (void) HUDStartWithTitle:(NSString * _Nullable)hudTitle;



/**
 结束HUD
 
 @param hudTitle 结束文字
 */
- (void) HUDStopWithTitle:(NSString *_Nullable)hudTitle;


/**
 HUD停止
 */
- (void)stopHUD;

/**
 HUD开始
 */
- (void)startHUD;

@end
