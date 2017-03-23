//
//  MembersListView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/22.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "MembersListView.h"

@implementation MembersListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _memberListTableView = [[UITableView alloc]init];
        _memberListTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        [self addSubview: _memberListTableView];
        _memberListTableView.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topEqualToView(self)
        .bottomEqualToView(self);
        
        
    }
    return self;
}

@end
