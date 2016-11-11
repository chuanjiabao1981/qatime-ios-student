//
//  VideoInfoView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/11.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "VideoInfoView.h"

@interface VideoInfoView (){
    
    
}

@end


@implementation VideoInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        /* 滑动控制器*/
        _segmentControl = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"公告",@"聊天",@"直播详情",@"成员列表"]];
        [self addSubview:_segmentControl];
        _segmentControl.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(self,5).heightIs(30);
        
        
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.borderType = HMSegmentedControlTypeText;
        _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;

        /* 大滑动页面*/
        _scrollView = [[UIScrollView alloc]init];

        [self addSubview: _scrollView ];
        
        _scrollView.sd_layout.
        leftEqualToView(self).
        rightEqualToView(self).
        topSpaceToView(_segmentControl,0).
        bottomSpaceToView(self,0);

        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [_scrollView scrollRectToVisible:CGRectMake(0, 0, CGRectGetWidth(self.frame), _scrollView.size.height) animated:NO];

        
        
        UIView *view1= [[UIView alloc]init];
        [_scrollView addSubview:view1];
        view1.backgroundColor = [UIColor redColor];
        view1.sd_layout
        .topEqualToView(_scrollView)
        .bottomEqualToView(_scrollView)
        .leftEqualToView(_scrollView)
        .widthRatioToView(self,1.0f);
        
        UIView *view2= [[UIView alloc]init];
        [_scrollView addSubview:view2];
        view2.backgroundColor = [UIColor orangeColor];

        view2.sd_layout
        .topEqualToView(_scrollView)
        .bottomEqualToView(_scrollView)
        .leftSpaceToView(view1,0)
        .widthRatioToView(self,1.0f);
        
        UIView *view3= [[UIView alloc]init];
        [_scrollView addSubview:view3];
        view3.backgroundColor = [UIColor yellowColor];

        view3.sd_layout
        .topEqualToView(_scrollView)
        .bottomEqualToView(_scrollView)
         .leftSpaceToView(view2,0)
        .widthRatioToView(self,1.0f);
        
        UIView *view4= [[UIView alloc]init];
        [_scrollView addSubview:view4];
        view4.backgroundColor = [UIColor greenColor];

        view4.sd_layout
        .topEqualToView(_scrollView)
        .bottomEqualToView(_scrollView)
         .leftSpaceToView(view3,0)
        .widthRatioToView(self,1.0f);
        
        
        /* 公告栏*/
        _noticeTabelView = [[UITableView alloc]init];
        [view1 addSubview:_noticeTabelView];
        
        _noticeTabelView.sd_layout
        .topEqualToView(view1)
        .bottomEqualToView(view1)
        .leftEqualToView(view1)
        .rightEqualToView(view1);
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    return self;
}



@end
