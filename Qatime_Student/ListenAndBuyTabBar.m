//
//  ListenAndBuyTabBar.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/10.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ListenAndBuyTabBar.h"

@implementation ListenAndBuyTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /* 一条线*/
        UIView *line =[[UIView alloc]init];
        line.backgroundColor = [UIColor grayColor];
        
        
        /* <# State #>*/
        
                
        
        line.sd_layout
        .topEqualToView(self)
        .rightEqualToView(self)
        .leftEqualToView(self)
        .heightIs(0.8);
        
        
        
        
        
    }
    return self;
}

@end
