//
//  AboutUsView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/30.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "AboutUsView.h"

@implementation AboutUsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _menuTableView = [[UITableView alloc]init];
        [self addSubview:_menuTableView];
        
        _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _menuTableView.sd_layout
        .topSpaceToView(self,0)
        .leftSpaceToView(self,0)
        .rightSpaceToView(self,0)
        .bottomSpaceToView(self, 0);
        
    }
    return self;
}


@end
