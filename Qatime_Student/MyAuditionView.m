//
//  MyAuditionView.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "MyAuditionView.h"

@interface MyAuditionView (){
    
    
}

@end


@implementation MyAuditionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //滑动控制器
        _segmentControl =({
            HMSegmentedControl *_ = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"直播课",@"视频课"]];
            [self addSubview:_];
            _.frame = CGRectMake(0, 0, self.width_sd, 40*ScrenScale) ;
            _.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
            _.borderType = HMSegmentedControlBorderTypeBottom;
            _.borderColor = SEPERATELINECOLOR_2;
            _.borderWidth = 0.5;
            _.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
            _.selectionIndicatorColor = BUTTONRED;
            _.selectionIndicatorHeight = 2;
            _.titleTextAttributes = @{NSForegroundColorAttributeName:TITLECOLOR,
                                      NSFontAttributeName:[UIFont systemFontOfSize:14*ScrenScale]};
            _.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],
                                              NSFontAttributeName:[UIFont systemFontOfSize:14*ScrenScale]};
            _.selectedSegmentIndex = 0;
            _.verticalDividerEnabled = NO;
            _;
        });
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
