//
//  UnStartClassView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "UnStartClassView.h"

#define SCREENWIDTH self.frame.size.width
#define SCREENHEIGHT self.frame.size.height

@implementation UnStartClassView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _classTableView = ({
        
            UITableView *_ = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,SCREENWIDTH , SCREENHEIGHT)];
            _.backgroundColor  = [UIColor whiteColor];
            [self addSubview:_];
            _.separatorStyle = UITableViewCellSeparatorStyleNone;
            _;
        });
        
        
    }
    return self;
}

@end
