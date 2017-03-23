//
//  ClassNotice.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/23.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ClassNotice.h"

@implementation ClassNotice

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _classNotice = [[UITableView alloc]init];
        [self addSubview:_classNotice];
        
        _classNotice.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topEqualToView(self)
        .bottomEqualToView(self);

        
    }
    return self;
}

@end
