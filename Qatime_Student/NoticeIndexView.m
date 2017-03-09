//
//  NoticeIndexView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/16.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "NoticeIndexView.h"


@interface NoticeIndexView (){
    
    
    
}

@end

@implementation NoticeIndexView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _segmentControl = ({
//            HMSegmentedControl *_=[[HMSegmentedControl alloc]initWithSectionTitles:@[@"辅导班消息",@"系统消息"]];
////            _.type = HMSegmentedControlTypeTextImages;
//            _.frame = CGRectMake(0, 0, self.width_sd, self.height_sd*0.05);
//            _.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
//            _.borderType = HMSegmentedControlBorderTypeBottom;
//            _.borderColor = [UIColor lightGrayColor];
//            _.borderWidth = 0.4;
//            _.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
//            _.selectionIndicatorColor = [UIColor redColor];
//            _.selectionIndicatorHeight = 2;
//            _.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor lightGrayColor],
//                                      NSFontAttributeName:[UIFont systemFontOfSize:15*ScrenScale]};
//            _.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],
//                                              NSFontAttributeName:[UIFont systemFontOfSize:15*ScrenScale]};
//            _.selectedSegmentIndex = 0;
//            _.verticalDividerEnabled = NO;
            
            JTSegmentControl *_=[[JTSegmentControl alloc]initWithFrame:CGRectMake(0, 0, self.width_sd, self.height_sd*0.065)];
//            _.delegate = self;
            _.items = @[@"辅导班消息",@"系统消息"];
            _.autoScrollWhenIndexChange = NO;
            _.itemSelectedTextColor = [UIColor blackColor];
            _.itemTextColor = [UIColor blackColor];
            _.font = [UIFont systemFontOfSize:15*ScrenScale];
            _.selectedFont = [UIFont systemFontOfSize:15*ScrenScale];
            _.sliderViewColor = BUTTONRED;
            [_ setSliderViewHeight:0.5];
            [self addSubview:_];
            _;
        });
        
        /* 大滚动视图*/
        _scrollView = ({
            UIScrollView *_=[[UIScrollView alloc]initWithFrame:CGRectMake(0, _segmentControl.height_sd, self.width_sd, self.height_sd-_segmentControl.height_sd)];
            _.backgroundColor = [UIColor whiteColor];
            _.contentSize = CGSizeMake(self.width_sd*2,self.height_sd-_segmentControl.height_sd);
            _.pagingEnabled = YES;
            _.bounces = NO;
            _.alwaysBounceVertical = NO;
            _.alwaysBounceHorizontal = NO;
            _.showsVerticalScrollIndicator = NO;
            _.showsHorizontalScrollIndicator = NO;
            
            [self addSubview:_];
            _;
        });
        
        _chatListTableView = ({
        
            UITableView *_=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width_sd, _scrollView.height_sd) style:UITableViewStylePlain];
            _.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            _.tableFooterView = [[UIView alloc]init];
            [_scrollView addSubview:_];
            _;
        
        });
        
        _noticeTableView= ({
            
            UITableView *_=[[UITableView alloc]initWithFrame:CGRectMake(self.width_sd, 0, self.width_sd, _scrollView.height_sd) style:UITableViewStylePlain];
            _.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            _.tableFooterView = [[UIView alloc]init];
            
            [_scrollView addSubview:_];
            _;
            
        });


        
        
        
        
    }
    return self;
}

@end
