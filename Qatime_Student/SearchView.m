//
//  SearchView.m
//  Qatime_Student
//
//  Created by Shin on 2017/6/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "SearchView.h"

@implementation SearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //segment
        _segmentControl  = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"课程",@"教师"]];
        [self addSubview:_segmentControl];
        _segmentControl.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(self, 0)
        .heightIs(40*ScrenScale);
        _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _segmentControl.selectionIndicatorColor = BUTTONRED;
        _segmentControl.selectionIndicatorHeight = 1;
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.backgroundColor = SEPERATELINECOLOR;
        _segmentControl.titleTextAttributes = @{NSFontAttributeName:TEXT_FONTSIZE};
        
        //scrollview
        _scrollView = [[UIScrollView alloc]init];
        [self addSubview:_scrollView ];
        _scrollView.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(_segmentControl, 0)
        .bottomSpaceToView(self, 0);
        _scrollView.contentSize = CGSizeMake(self.width_sd*2, self.height_sd-_segmentControl.height_sd);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        //课程页面
        _classSearchResultView = [[UITableView alloc]init];
        [_scrollView addSubview:_classSearchResultView];
        _classSearchResultView.sd_layout
        .leftSpaceToView(_scrollView, 0)
        .topSpaceToView(_scrollView, 0)
        .bottomSpaceToView(_scrollView, 0)
        .widthRatioToView(self, 1.0);
        _classSearchResultView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _classSearchResultView.backgroundColor = [UIColor redColor];
        
        //教师页面
        _teacherSearchResultView = [[UITableView alloc]init];
        [_scrollView addSubview:_teacherSearchResultView];
        _teacherSearchResultView.sd_layout
        .leftSpaceToView(_classSearchResultView, 0)
        .topEqualToView(_classSearchResultView)
        .bottomEqualToView(_classSearchResultView)
        .widthRatioToView(_classSearchResultView, 1.0);
        _teacherSearchResultView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_scrollView setupAutoContentSizeWithRightView:_teacherSearchResultView rightMargin:0];
        
    }
    return self;
}



@end
