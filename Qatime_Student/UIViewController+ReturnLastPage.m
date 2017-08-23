//
//  UIViewController+ReturnLastPage.m
//  Qatime_Student
//
//  Created by Shin on 2017/8/21.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "UIViewController+ReturnLastPage.h"

@implementation UIViewController (ReturnLastPage)

-(void)returnLastPage{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
