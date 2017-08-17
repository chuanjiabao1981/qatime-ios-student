//
//  YZSlider.m
//  Qatime_Student
//
//  Created by Shin on 2017/8/16.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "YZSlider.h"

@implementation YZSlider

-(CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value{
    
    rect.origin.x=rect.origin.x-10;
    rect.size.width=rect.size.width+20;
    return CGRectInset([super thumbRectForBounds:bounds trackRect:rect value:value],10,10);
}

@end
