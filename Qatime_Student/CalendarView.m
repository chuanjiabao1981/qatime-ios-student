//
//  CalendarView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/28.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "CalendarView.h"

@implementation CalendarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /* 日历 */
        _calendarView = [[FSCalendar alloc]init];
        
        [self addSubview: _calendarView];
        
        _calendarView.sd_layout
        .topEqualToView(self)
        .leftEqualToView(self)
        .rightEqualToView(self)
        .bottomEqualToView(self);
        
        
        
        
        
        
        
        
        
        
    }
    return self;
}

@end
