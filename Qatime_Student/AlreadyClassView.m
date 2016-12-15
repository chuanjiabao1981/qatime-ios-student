//
//  AlreadyClassView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/28.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "AlreadyClassView.h"

@implementation AlreadyClassView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _alreadyClassTableView = [[UITableView alloc]init];
        [self addSubview: _alreadyClassTableView];
        _alreadyClassTableView.sd_layout
        .topEqualToView(self)
        .bottomEqualToView(self)
        .leftEqualToView(self)
        .rightEqualToView(self);
        
        
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
