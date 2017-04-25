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
            HMSegmentedControl *_ = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"待开课",@"已开课",@"已结束"]];
            [self addSubview:_];
            _.frame = CGRectMake(0, 0, SCREENWIDTH, self.height_sd*0.07*ScrenScale) ;
            _.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
            _.borderType = HMSegmentedControlBorderTypeBottom;
            _.borderColor = SEPERATELINECOLOR_2;
            _.borderWidth = 0.5;
            _.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
            _.selectionIndicatorColor = BUTTONRED;
            _.selectionIndicatorHeight = 2;
            _.titleTextAttributes = @{NSForegroundColorAttributeName:TITLECOLOR};
            _.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
            _.selectedSegmentIndex = 0;
            _.verticalDividerEnabled = NO;
            _;
        });
        
        
        /* 大滑动视图*/
        
        _scrollView = ({
            
            UIScrollView *_=[[UIScrollView alloc]initWithFrame:CGRectMake(0,_segmentControl.bottom_sd, SCREENWIDTH, SCREENHEIGHT-40)];
            _.contentSize = CGSizeMake(SCREENWIDTH*3, SCREENHEIGHT-40);
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
