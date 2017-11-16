//
//  MyOrderView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/8.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "MyOrderView.h"
#import "HMSegmentedControl+Category.h"

@implementation MyOrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _segmentControl = [HMSegmentedControl segmentControlWithTitles:@[@"待付款",@"已付款",@"已取消"]];
        [self addSubview:_segmentControl];
        _segmentControl.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(self, 0)
        .heightIs(40);
        
        /* 大滚动视图*/
        _scrollView = ({
            UIScrollView *_=[[UIScrollView alloc]initWithFrame:CGRectMake(0, _segmentControl.height_sd, self.width_sd, self.height_sd-_segmentControl.height_sd)];
            _.backgroundColor = BACKGROUNDGRAY;
            _.contentSize = CGSizeMake(self.width_sd*3,self.height_sd-_segmentControl.height_sd);
            _.pagingEnabled = YES;
            _.bounces = NO;
            _.alwaysBounceVertical = NO;
            _.alwaysBounceHorizontal = NO;
            _.showsVerticalScrollIndicator = NO;
            _.showsHorizontalScrollIndicator = NO;
         
            
            [self addSubview:_];
            _;
        });
        
        
        /**未支付页面*/
        _unpaidView = ({
            UITableView *_ =[[UITableView alloc]init];
            [_scrollView addSubview:_];
            _.separatorStyle = UITableViewCellSeparatorStyleNone;
            _.sd_layout
            .topSpaceToView(_scrollView, 0)
            .bottomSpaceToView(_scrollView, 0)
            .leftSpaceToView(_scrollView, 0)
            .widthIs(self.width_sd);
            _;
        });
        
        /**已支付页面*/
        _paidView = ({
            UITableView *_ =[[UITableView alloc]init];
            [_scrollView addSubview:_];
            _.separatorStyle = UITableViewCellSeparatorStyleNone;
            _.sd_layout
            .topSpaceToView(_scrollView, 0)
            .bottomSpaceToView(_scrollView, 0)
            .leftSpaceToView(_unpaidView, 0)
            .widthIs(self.width_sd);
            _;
        });
        
        /**未支付页面*/
        _cancelView = ({
            UITableView *_ =[[UITableView alloc]init];
            [_scrollView addSubview:_];
            _.separatorStyle = UITableViewCellSeparatorStyleNone;
            _.sd_layout
            .topSpaceToView(_scrollView, 0)
            .bottomSpaceToView(_scrollView, 0)
            .leftSpaceToView(_paidView, 0)
            .widthIs(self.width_sd);
            _;
        });
        
        [_scrollView setupAutoContentSizeWithRightView:_cancelView rightMargin:0];
        
    }
    return self;
}

@end
