//
//  MyClassView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "MyClassView.h"
#import "HMSegmentedControl+Category.h"

#define SCREENWIDTH self.frame.size.width
#define SCREENHEIGHT self.frame.size.height

@implementation MyClassView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _segmentControl = [HMSegmentedControl segmentControlWithTitles:@[@"待开课",@"已开课",@"已结束"]];
        [self addSubview:_segmentControl];
        _segmentControl.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(self, 0)
        .heightIs(40);
        
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
