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
        _segmentControl.titleTextAttributes = @{NSFontAttributeName:TEXT_FONTSIZE};
        _segmentControl.borderType = HMSegmentedControlBorderTypeBottom;
        _segmentControl.borderColor = SEPERATELINECOLOR_2;
        
        //scrollview
        _scrollView = [[UIScrollView alloc]init];
        [self addSubview:_scrollView ];
        _scrollView.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(_segmentControl, 0)
        .bottomSpaceToView(self, 0);
        _scrollView.contentSize = CGSizeMake(100, 100);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        
        typeof(self) __weak weakSelf = self;
        [weakSelf.segmentControl setIndexChangeBlock:^(NSInteger index) {
            
            [weakSelf.scrollView scrollRectToVisible:CGRectMake(weakSelf.width_sd * index, 0, weakSelf.width_sd, weakSelf.height_sd) animated:YES];
            
        }];

        
        //课程页面
        _classSearchResultView = [[UITableView alloc]init];
        [_scrollView addSubview:_classSearchResultView];
        _classSearchResultView.sd_layout
        .leftSpaceToView(_scrollView, 0)
        .topSpaceToView(_scrollView, 0)
        .bottomSpaceToView(_scrollView, 0)
        .widthRatioToView(self, 1.0);
        _classSearchResultView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
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
