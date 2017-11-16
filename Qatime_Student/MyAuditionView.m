//
//  MyAuditionView.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "MyAuditionView.h"
#import "HMSegmentedControl+Category.h"

@interface MyAuditionView (){
    
    
}

@end


@implementation MyAuditionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _segmentControl = [HMSegmentedControl segmentControlWithTitles:@[@"直播课",@"视频课"]];
        [self addSubview:_segmentControl];
        _segmentControl.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(self, 0)
        .heightIs(40);
        //滚动视图
        _scrollView = ({
            UIScrollView *_ = [[UIScrollView alloc]init];
            [self addSubview:_];
            _.contentSize = CGSizeMake(self.width_sd*2, self.height_sd - _segmentControl.height_sd);
            _.pagingEnabled = YES;
            _.bounces = NO;
            _.showsHorizontalScrollIndicator = NO;
            _.sd_layout
            .leftSpaceToView(self, 0)
            .rightSpaceToView(self, 0)
            .topSpaceToView(_segmentControl, 0)
            .bottomSpaceToView(self, 0);
            _;
        });
        
        //两个tableview
        _liveClassList = ({
            UITableView *_ = [[UITableView alloc]init];
            _.backgroundColor = BACKGROUNDGRAY;
            _.separatorStyle = UITableViewCellSeparatorStyleNone;
            [_scrollView addSubview:_];
            _.sd_layout
            .leftSpaceToView(_scrollView, 0)
            .topSpaceToView(_scrollView, 0)
            .bottomSpaceToView(_scrollView, 0)
            .widthIs(self.width_sd);
            
            _;
            
        });
        
        _videoClassList= ({
            UITableView *_ = [[UITableView alloc]init];
            _.backgroundColor = BACKGROUNDGRAY;
            _.separatorStyle = UITableViewCellSeparatorStyleNone;
            [_scrollView addSubview:_];
            _.sd_layout
            .leftSpaceToView(_liveClassList, 0)
            .topEqualToView(_liveClassList)
            .bottomEqualToView(_liveClassList)
            .widthIs(self.width_sd);
            _;
            
        });

        [_scrollView setupAutoContentSizeWithRightView:_videoClassList rightMargin:0];
        [_scrollView setupAutoContentSizeWithBottomView:_videoClassList bottomMargin:0];
        

    }
    return self;
}

@end
