//
//  AllClassView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/28.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "AllClassView.h"

@implementation AllClassView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _calendarView = [[CalendarView alloc]init];
        [self addSubview:_calendarView];
        _calendarView.sd_layout
        .topEqualToView(self)
        .leftEqualToView(self)
        .rightEqualToView(self)
        .bottomEqualToView(self);
                
    }
    return self;
}

@end
