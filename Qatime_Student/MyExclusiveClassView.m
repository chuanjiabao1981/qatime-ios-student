//
//  MyExclusiveClassView.m
//  Qatime_Student
//
//  Created by Shin on 2017/7/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "MyExclusiveClassView.h"

@implementation MyExclusiveClassView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _segmentControl = [HMSegmentedControl segmentControlWithTitles:@[@"待开课",@"已开课",@"已结束"]];
        [self addSubview:_segmentControl];
        _segmentControl.sd_layout
        .leftSpaceToView(self, 0)
        .topSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .heightIs(40);
        
        _scrollView = [[UIScrollView alloc]init];
        [self addSubview:_scrollView];
        _scrollView.sd_layout
        .leftEqualToView(_segmentControl)
        .rightEqualToView(_segmentControl)
        .topSpaceToView(_segmentControl, 0)
        .bottomSpaceToView(self, 0);
        _scrollView.contentSize = CGSizeMake(100, 100);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        
        //三个子视图
        _publishedView = [[UITableView alloc]init];
        [_scrollView addSubview:_publishedView];
        _publishedView.sd_layout
        .leftSpaceToView(_scrollView, 0)
        .topSpaceToView(_scrollView, 0)
        .bottomSpaceToView(_scrollView, 0)
        .widthRatioToView(_scrollView, 1.0);
        _publishedView.showsHorizontalScrollIndicator = NO;
        _publishedView.showsVerticalScrollIndicator = NO;
        _publishedView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _teachingView = [[UITableView alloc]init];
        [_scrollView addSubview:_teachingView];
        _teachingView.sd_layout
        .leftSpaceToView(_publishedView, 0)
        .topEqualToView(_publishedView)
        .bottomEqualToView(_publishedView)
        .widthRatioToView(_publishedView, 1.0);
        _teachingView.showsHorizontalScrollIndicator = NO;
        _teachingView.showsVerticalScrollIndicator = NO;
        _teachingView.separatorStyle = UITableViewCellSeparatorStyleNone;

        _completedView = [[UITableView alloc]init];
        [_scrollView addSubview:_completedView];
        _completedView.sd_layout
        .leftSpaceToView(_teachingView, 0)
        .topEqualToView(_teachingView)
        .bottomEqualToView(_teachingView)
        .widthRatioToView(_teachingView, 1.0);
        _completedView.showsHorizontalScrollIndicator = NO;
        _completedView.showsVerticalScrollIndicator = NO;
        _completedView.separatorStyle = UITableViewCellSeparatorStyleNone;

        [_scrollView setupAutoContentSizeWithBottomView:_publishedView bottomMargin:0];
        [_scrollView setupAutoContentSizeWithRightView:_completedView rightMargin:0];
        
        typeof(self) __weak weakSelf = self;
        _segmentControl.indexChangeBlock = ^(NSInteger index) {
            [weakSelf.scrollView scrollRectToVisible:CGRectMake(weakSelf.scrollView.width_sd*index, 0, weakSelf.scrollView.width_sd, weakSelf.scrollView.height_sd) animated:YES];
        };
        
    }
    return self;
}

@end
