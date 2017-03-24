//
//  ClassTimeView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/28.
//  Copyright © 2016年 WWTD. All rights reserved.
//



#import "ClassTimeView.h"

#define SCREENWIDTH self.frame.size.width
#define SELFHEIGHT self.frame.size.height

@implementation ClassTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
#pragma mark- 滑动导航栏
        
        _segmentControl = [[HMSegmentedControl alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.height_sd*0.055)];
        [self addSubview:_segmentControl];
        _segmentControl .sectionTitles = @[@"未上课",@"已上课"];
        _segmentControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:16*ScrenScale]};
        _segmentControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:16*ScrenScale]};
        _segmentControl.type = HMSegmentedControlTypeText;
        _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _segmentControl.selectionIndicatorColor = NAVIGATIONRED;
        _segmentControl.selectionIndicatorHeight = 2;
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.borderType = HMSegmentedControlBorderTypeBottom;
        _segmentControl.borderWidth = 0.6;
        _segmentControl.borderColor = SEPERATELINECOLOR_2;
        
        #pragma mark- 大滚动视图
        _scrollView = [[UIScrollView alloc]init];
        [self addSubview:_scrollView];
        _scrollView.sd_layout
        .topSpaceToView(_segmentControl,0)
        .bottomEqualToView(self)
        .leftEqualToView(self)
        .rightEqualToView(self);
        _scrollView.contentSize = CGSizeMake(SCREENWIDTH*2, SELFHEIGHT-40);
        
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        
        /* 未上课页面*/
        _notClassView = [[NotClassView alloc]init];
        [_scrollView addSubview:_notClassView];
        _notClassView.backgroundColor = [UIColor whiteColor];
        _notClassView.sd_layout
        .topEqualToView(_scrollView)
        .leftEqualToView(_scrollView)
        .bottomEqualToView(_scrollView)
        .widthIs(SCREENWIDTH);
        
        
        /* 已上课页面*/
        _alreadyClassView = [[AlreadyClassView alloc]init];
        [_scrollView addSubview:_alreadyClassView];
        _alreadyClassView.backgroundColor = [UIColor whiteColor];
        _alreadyClassView.sd_layout
        .topEqualToView(_notClassView)
        .bottomEqualToView(_notClassView)
        .leftSpaceToView(_notClassView,0)
        .widthIs(SCREENWIDTH);
        
                
        
        
        
        
    }
    return self;
}

@end
