//
//  MyOneOnOneView.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/31.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "MyOneOnOneView.h"
#import "HMSegmentedControl+Category.h"

@implementation MyOneOnOneView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _segmentControl = [HMSegmentedControl segmentControlWithTitles:@[@"学习中",@"已结束"]];
        [self addSubview:_segmentControl];
        _segmentControl.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(self, 0)
        .heightIs(40);

        //滚动视图
        _scrollView = ({
            UIScrollView *_ = [[UIScrollView alloc]init];
            [self addSubview:_];
            _.contentSize = CGSizeMake(self.width_sd*2, self.height_sd - _segmentControl.height_sd);
            _.pagingEnabled = YES;
            _.bounces = NO;
            _.showsHorizontalScrollIndicator = NO;
            _.sd_layout
            .leftSpaceToView(self, 0)
            .rightSpaceToView(self, 0)
            .topSpaceToView(_segmentControl, 0)
            .bottomSpaceToView(self, 0);
            
            _;
        });
        
        //学习中的tableview
        _onStudyTableView = ({
        
            UITableView *_ = [[UITableView alloc]init];
            _.separatorStyle = UITableViewCellSeparatorStyleNone;
            [_scrollView addSubview:_];
            _.sd_layout
            .leftSpaceToView(_scrollView, 0)
            .topSpaceToView(_scrollView, 0)
            .bottomSpaceToView(_scrollView, 0)
            .widthIs(self.width_sd);
            
            _;
            
        });
        
        //学习结束的tabelview
        _finishStudyTableView = ({
            UITableView *_ = [[UITableView alloc]init];
            _.separatorStyle = UITableViewCellSeparatorStyleNone;
            [_scrollView addSubview:_];
            _.sd_layout
            .leftSpaceToView(_onStudyTableView, 0)
            .topEqualToView(_onStudyTableView)
            .bottomEqualToView(_onStudyTableView)
            .widthIs(self.width_sd);
            _;
            
        });
        
    }
    return self;
}


@end
