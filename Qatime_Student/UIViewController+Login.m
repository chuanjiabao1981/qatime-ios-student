//
//  UIViewController+Login.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/10.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "UIViewController+Login.h"


@implementation UIViewController (Login)

- (void)loginAgain{
    
    LoginAgainViewController *_ = [[LoginAgainViewController alloc]init];
    
    [self.navigationController pushViewController:_ animated:YES];
    
}

- (void)popToSecondPage{
    
    
}

- (BOOL)isLogin{
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"Login"]) {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"Login"]==YES) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}


@end
