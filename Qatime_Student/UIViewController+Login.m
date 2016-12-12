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
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popToSecondPage) name:@"WechatLoginSucess" object:nil];
    
}

- (void)popToSecondPage{
    
    
}


@end
