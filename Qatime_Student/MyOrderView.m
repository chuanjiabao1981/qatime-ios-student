//
//  MyOrderView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/8.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "MyOrderView.h"

@implementation MyOrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /* 滑动选项卡*/
        _segmentControl = ({
            HMSegmentedControl *_ = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"待付款",@"已付款",@"已取消"]];
            _.frame = CGRectMake(0, 0, self.width_sd, self.height_sd*0.05);
            _.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
            _.borderType = HMSegmentedControlBorderTypeBottom;
            _.borderColor = [UIColor lightGrayColor];
            _.borderWidth = 0.4;
            _.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
            _.selectionIndicatorColor = [UIColor redColor];
            _.selectionIndicatorHeight = 2;
            _.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                      NSFontAttributeName:[UIFont systemFontOfSize:18*ScrenScale]};
            _.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],
                                              NSFontAttributeName:[UIFont systemFontOfSize:18*ScrenScale]};
            _.selectedSegmentIndex = 0;
            _.verticalDividerEnabled = NO;
            [self addSubview:_];
            _;
        
        });
        
        /* 大滚动视图*/
        _scrollView = ({
            UIScrollView *_=[[UIScrollView alloc]initWithFrame:CGRectMake(0, _segmentControl.height_sd, self.width_sd, self.height_sd-_segmentControl.height_sd)];
            _.contentSize = CGSizeMake(self.width_sd*4,self.height_sd-_segmentControl.height_sd);
            _.pagingEnabled = YES;
            _.bounces = NO;
            _.alwaysBounceVertical = NO;
            _.alwaysBounceHorizontal = NO;
            _.showsVerticalScrollIndicator = NO;
            _.showsHorizontalScrollIndicator = NO;
         
            
            [self addSubview:_];
            _;
        });
        
        
        
    }
    return self;
}

@end
