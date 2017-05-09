
//
//  UITabBarController+Rotation.m
//  Qatime_Student
//
//  Created by Shin on 2017/5/9.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "UITabBarController+Rotation.h"

@implementation UITabBarController (Rotation)
// 是否支持自动转屏
- (BOOL)shouldAutorotate{
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"SupportedLandscape"]) {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"SupportedLandscape"]==YES) {
            return YES;
        }else{
            
            if ([UIDevice currentDevice].orientation!=UIDeviceOrientationPortrait) {
                return YES;
            }
        }
    }else{
        return NO;
    }
    
    return NO;
}

// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"SupportedLandscape"]) {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"SupportedLandscape"]==YES) {
            return UIInterfaceOrientationMaskAllButUpsideDown;
        }else{
            
            if ([UIDevice currentDevice].orientation!=UIDeviceOrientationPortrait) {
                return UIInterfaceOrientationMaskPortrait;
            }
        }
    }else{
        
    }
    
    
    return UIInterfaceOrientationMaskPortrait;
}
@end
