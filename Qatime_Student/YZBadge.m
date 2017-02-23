//
//  YZBadge.m
//  Qatime_Student
//
//  Created by Shin on 2017/2/22.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "YZBadge.h"

@implementation YZBadge


+ (instancetype)showBadgeWithNumber:(NSInteger)number{
    
    YZBadge *_ = [[YZBadge alloc]init];
    _.textColor = [UIColor whiteColor];
    _.backgroundColor = [UIColor redColor];
    _.text = [NSString stringWithFormat:@"%ld",number];
    
    return _;
}

-(void)setBadgeNumber:(NSInteger)badgeNumber{
    
    _badgeNumber = badgeNumber;
    
    
}





@end
