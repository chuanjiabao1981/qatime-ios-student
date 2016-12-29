//
//  MyClassView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "MyClassView.h"

#define SCREENWIDTH self.frame.size.width
#define SCREENHEIGHT self.frame.size.height

@implementation MyClassView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        /* 滑动segemnt*/
        _segmentControl =({
            HMSegmentedControl *_ = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"待开课",@"已开课",@"已结束",@"我的试听"]];
            [self addSubview:_];
            _.frame = CGRectMake(0, 0, SCREENWIDTH, self.height_sd*0.07) ;
            _.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
            _.borderType = HMSegmentedControlBorderTypeBottom;
            _.borderColor = [UIColor lightGrayColor];
            _.borderWidth = 0.4;
            _.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
            _.selectionIndicatorColor = [UIColor blackColor];
            _.selectionIndicatorHeight = 2;
            _.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor lightGrayColor]};
            _.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
            _.selectedSegmentIndex = 0;
            _.verticalDividerEnabled = NO;
            _;
        });
        
        
        /* 大滑动视图*/
        
        _scrollView = ({
            
            UIScrollView *_=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, SCREENHEIGHT-40)];
            _.contentSize = CGSizeMake(SCREENWIDTH*4, SCREENHEIGHT-40);
            [self addSubview:_];
            _.pagingEnabled = YES;
            _.bounces = NO;
            _.alwaysBounceVertical = NO;
            _.alwaysBounceHorizontal = NO;
            _.showsVerticalScrollIndicator = NO;
            _.showsHorizontalScrollIndicator = NO;
//            _.backgroundColor = [UIColor redColor];
            _;
        });
        
        
                
        
    }
    return self;
}

@end
