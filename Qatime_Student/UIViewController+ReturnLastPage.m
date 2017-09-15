//
//  UIViewController+ReturnLastPage.m
//  Qatime_Teacher
//
//  Created by Shin on 2017/5/26.
//  Copyright © 2017年 Shin. All rights reserved.
//

#import "UIViewController+ReturnLastPage.h"

@implementation UIViewController (ReturnLastPage)

- (void)returnLastPage{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
