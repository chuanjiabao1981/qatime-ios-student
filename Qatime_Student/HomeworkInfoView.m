//
//  HomeworkInfoView.m
//  Qatime_Student
//
//  Created by Shin on 2017/9/12.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "HomeworkInfoView.h"

@implementation HomeworkInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        _subtitle = [[QuestionSubTitle alloc]init];
        [self addSubview:_subtitle];
        _subtitle.sd_layout
        .leftSpaceToView(self, 0)
        .topSpaceToView(self, 0)
        .rightSpaceToView(self, 0);
        
        _homeworkList = [[UITableView alloc]init];
        _homeworkList.tableFooterView = [UIView new];
        [self addSubview:_homeworkList];
        _homeworkList.sd_layout
        .topSpaceToView(_subtitle, 0)
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .bottomSpaceToView(self, 0);
        
    }
    return self;
}

@end
