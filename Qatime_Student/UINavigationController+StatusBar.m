//
//  UINavigationController+StatusBar.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/2.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "UINavigationController+StatusBar.h"

@implementation UINavigationController (StatusBar)

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[self topViewController] preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden{
    
    return [[self topViewController] prefersStatusBarHidden];
}

@end
