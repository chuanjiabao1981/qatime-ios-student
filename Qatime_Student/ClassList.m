//
//  ClassList.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/15.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ClassList.h"

@implementation ClassList

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _classListTableView = [[UITableView alloc]init];
        
        [self addSubview:_classListTableView];
        _classListTableView.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topEqualToView(self)
        .bottomEqualToView(self);
        
        
        
    }
    return self;
}

@end
