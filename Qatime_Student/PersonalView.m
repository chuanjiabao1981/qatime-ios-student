//
//  PersonalView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/3.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "PersonalView.h"

#define SCREENWIDTH self.frame.size.width
#define SCREENHEIGHT self.frame.size.height

@interface PersonalView (){
    
}

@end

@implementation PersonalView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        _settingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStyleGrouped];
        _settingTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self addSubview:_settingTableView];
        _settingTableView.backgroundColor = [UIColor clearColor];
        _settingTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0,CGFLOAT_MIN )];
        _settingTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 10)];
        _settingTableView.sectionFooterHeight = 5;
        _settingTableView.sectionHeaderHeight = 5;
        
    }
    return self;
}

@end
