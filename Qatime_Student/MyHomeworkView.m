//
//  MyHomeworkView.m
//  Qatime_Student
//
//  Created by Shin on 2017/9/8.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "MyHomeworkView.h"

@implementation MyHomeworkView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _segmentControl = [HMSegmentedControl segmentControlWithTitles:@[@"未交",@"已交",@"已批"]];
        [self addSubview:_segmentControl];
        _segmentControl.sd_layout
        .leftSpaceToView(self, 0)
        .topSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .heightIs(40);
        
        _scrollView = [[UIScrollView alloc]init];
        [self addSubview:_scrollView];
        _scrollView.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(_segmentControl, 0)
        .bottomSpaceToView(self, 0);
        _scrollView.contentSize = CGSizeMake(100, 100);
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        
        
        _unhandedList = [[UITableView alloc]init];
        _unhandedList.tableFooterView = [[UIView alloc]init];
        _unhandedList.backgroundColor = [UIColor whiteColor];
        _unhandedList.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_scrollView addSubview:_unhandedList];
        _unhandedList.sd_layout
        .leftSpaceToView(_scrollView, 0)
        .topSpaceToView(_scrollView, 0)
        .bottomSpaceToView(_scrollView, 0)
        .widthRatioToView(_scrollView, 1.0);
        
        _handedList = [[UITableView alloc]init];
        _handedList.tableFooterView = [[UIView alloc]init];
        _handedList.backgroundColor = [UIColor whiteColor];
        _handedList.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_scrollView addSubview:_handedList];
        _handedList.sd_layout
        .leftSpaceToView(_unhandedList, 0)
        .topEqualToView(_unhandedList)
        .bottomEqualToView(_unhandedList)
        .widthRatioToView(_unhandedList, 1.0);
        
        _checkedList = [[UITableView alloc]init];
        _checkedList.tableFooterView = [[UIView alloc]init];
        _checkedList.backgroundColor = [UIColor whiteColor];
        _checkedList.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_scrollView addSubview:_checkedList];
        _checkedList.sd_layout
        .leftSpaceToView(_handedList, 0)
        .topEqualToView(_handedList)
        .bottomEqualToView(_handedList)
        .widthRatioToView(_handedList, 1.0);
        
        [_scrollView setupAutoContentSizeWithRightView:_checkedList rightMargin:0];
        [_scrollView setupAutoContentSizeWithBottomView:_unhandedList bottomMargin:0];
        
        typeof(self) __weak weakSelf = self;
        _segmentControl.indexChangeBlock = ^(NSInteger index) {
            [weakSelf.scrollView scrollRectToVisible:CGRectMake(index *weakSelf.scrollView.width_sd, weakSelf.scrollView.origin_sd.y, weakSelf.scrollView.width_sd, weakSelf.scrollView.height_sd) animated:YES];
        };
    }
    return self;
}


@end
