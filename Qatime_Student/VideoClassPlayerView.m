//
//  VideoClassPlayerView.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/12.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "VideoClassPlayerView.h"

@interface VideoClassPlayerView (){
    
    
    
}

@end

@implementation VideoClassPlayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //滑动控制器
        _segmentControl = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"进度",@"详情"]];
        _segmentControl.borderType = HMSegmentedControlBorderTypeBottom;
        _segmentControl.borderWidth = 0.5;
        _segmentControl.borderColor = SEPERATELINECOLOR;
        _segmentControl.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15*ScrenScale]};
        _segmentControl.selectionIndicatorColor = NAVIGATIONRED;
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.borderType = HMSegmentedControlTypeText;
        _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        [self addSubview:_segmentControl];
        _segmentControl.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topEqualToView(self)
        .heightIs(30);
        
        //滑动视图
        _scrollView = [[UIScrollView alloc]init];
        [self addSubview:_scrollView];
        _scrollView.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(_segmentControl, 0)
        .bottomSpaceToView(self, 0);
        _scrollView.contentSize = CGSizeMake(self.width_sd*2, self.height_sd - _segmentControl.height_sd);
        
        
        //视频列表
        _classVideoListTableView = [[UITableView alloc]init];
        [_scrollView addSubview:_classVideoListTableView];
        _classVideoListTableView.sd_layout
        .leftSpaceToView(_scrollView, 0)
        .topSpaceToView(_scrollView, 0)
        .bottomSpaceToView(_scrollView, 0)
        .widthIs(self.width_sd);
        
        //课程信息详情
        
        
        

        
        
        
    }
    return self;
}


@end
