//
//  CanceldOrderView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/8.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "CanceldOrderView.h"

@implementation CanceldOrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width_sd, self.height_sd) style:UITableViewStylePlain];
        [self addSubview:_tableView];
        _tableView.backgroundColor = [UIColor whiteColor];
                
    }
    return self;
}


@end
