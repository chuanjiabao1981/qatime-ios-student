//
//  NotClassView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/28.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "NotClassView.h"

@implementation NotClassView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _notClassTableView = [[UITableView alloc]init];
        [self addSubview: _notClassTableView];
        
        _notClassTableView.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topEqualToView(self)
        .bottomEqualToView(self);
        
        
        _haveNoClassView = [[HaveNoClassView alloc]init];
        _haveNoClassView.titleLabel.text = @"本月暂时没有课程";
        [self addSubview:_haveNoClassView];
        _haveNoClassView.sd_layout
        .leftEqualToView(self)
        .topEqualToView(self)
        .rightEqualToView(self)
        .bottomEqualToView(self);
        
        _haveNoClassView.hidden = YES;
        
        
        
    
        
    }
    return self;
}

@end
