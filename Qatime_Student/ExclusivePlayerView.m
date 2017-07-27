//
//  ExclusivePlayerView.m
//  Qatime_Student
//
//  Created by Shin on 2017/7/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ExclusivePlayerView.h"

@implementation ExclusivePlayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _segmentControl = [HMSegmentedControl segmentControlWithTitles:@[@"聊天",@"公告",@"详情",@"成员"]];
        [self addSubview: _segmentControl];
        _segmentControl.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(self, 0)
        .heightIs(40);
        
        _scrollView = [[UIScrollView alloc]init];
        [self addSubview: _scrollView ];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.sd_layout
        .leftEqualToView(_segmentControl)
        .rightEqualToView(_segmentControl)
        .topSpaceToView(_segmentControl,0)
        .bottomSpaceToView(self,0);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(100, 100);
        
        
    }
    return self;
}

@end
