//
//  VideoInfoView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/11.
//  Copyright © 2016年 WWTD. All rights reserved.
//


#import "VideoInfoView.h"

#define SCREENWIDTH self.frame.size.width
#define VIEWHEIGHT  self.frame.size.height

@interface VideoInfoView (){
    
    
}

@end


@implementation VideoInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /* 滑动控制器*/
        _segmentControl = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"公告",@"聊天",@"详情",@"成员"]];
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
        
        
        /* 大滑动页面*/
        _scrollView = [[UIScrollView alloc]init];
        [self addSubview: _scrollView ];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(_segmentControl,0.5)
        .bottomSpaceToView(self,0);
        
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        _view1= [[UIView alloc]init];
        _view1.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:_view1];
        
        _view1.sd_layout
        .topEqualToView(_scrollView)
        .bottomEqualToView(_scrollView)
        .leftEqualToView(_scrollView)
        .widthRatioToView(self,1.0f);
        
        _view2= [[UIView alloc]init];
        _view2.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:_view2];
        
        _view2.sd_layout
        .topEqualToView(_scrollView)
        .bottomEqualToView(_scrollView)
        .leftSpaceToView(_view1,0)
        .widthRatioToView(self,1.0f);
        
        _view3= [[UIView alloc]init];
        _view3.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:_view3];
        
        _view3.sd_layout
        .topEqualToView(_scrollView)
        .bottomEqualToView(_scrollView)
        .leftSpaceToView(_view2,0)
        .widthRatioToView(self,1.0f);
        
        _view4= [[UIView alloc]init];
        _view4.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:_view4];
        
        _view4.sd_layout
        .topEqualToView(_scrollView)
        .bottomEqualToView(_scrollView)
        .leftSpaceToView(_view3,0)
        .widthRatioToView(self,1.0f);
        
               
    }
    return self;
}



@end
