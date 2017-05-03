//
//  CashRecordView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "CashRecordView.h"

@implementation CashRecordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _segmentControl = ({
        
            HMSegmentedControl *_=[[HMSegmentedControl alloc]initWithFrame:CGRectMake(0, 0, self.width_sd, self.height_sd*0.1)];
        
            _ .sectionTitles = @[@"充值记录",/*@"提现记录",*/@"消费记录",@"退款记录"];
            _.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                      NSFontAttributeName:[UIFont systemFontOfSize:18*ScrenScale]};
            _.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],
                                              NSFontAttributeName:[UIFont systemFontOfSize:18*ScrenScale]};
            _.type = HMSegmentedControlTypeText;
            _.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
            _.selectionIndicatorColor = NAVIGATIONRED;
            _.selectionIndicatorHeight = 2;
            _.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
            _.borderType = HMSegmentedControlBorderTypeBottom;
            _.borderWidth = 0.6;
            _.borderColor = [UIColor lightGrayColor];
            _;
        });
        
        _scrollView =({
            UIScrollView *_=[[UIScrollView alloc]init];
            _.contentSize = CGSizeMake(self.width_sd*3, self.height_sd-_segmentControl.height_sd);
            _.pagingEnabled = YES;
            _.showsHorizontalScrollIndicator = NO;
            _;
        });
        
        _rechargeView=({
            RechargeView *_= [[RechargeView alloc]init];
            _.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            _.backgroundColor = [UIColor whiteColor];
            _.tableFooterView = [[UIView alloc]init];
            _;
        });
        
//        _withDrawView=({
//            WidthDrawView *_= [[WidthDrawView alloc]init];
//            _.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//            _.backgroundColor = [UIColor whiteColor];
//            _.tableFooterView = [[UIView alloc]init];
//            _;
//        });

        _paymentView=({
            PaymentView *_= [[PaymentView alloc]init];
            _.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            
            _.backgroundColor = [UIColor whiteColor];
            _.tableFooterView = [[UIView alloc]init];
            _;
        });
        _refundView=({
            RefundTableView *_= [[RefundTableView alloc]init];
            _.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            
            _.backgroundColor = [UIColor whiteColor];
            _.tableFooterView = [[UIView alloc]init];
            _;
        });
    
        [self sd_addSubviews:@[_segmentControl,_scrollView]];
        [_scrollView sd_addSubviews:@[_rechargeView,/*_withDrawView,*/_paymentView,_refundView]];
        
        
        /* 布局*/
        
        _segmentControl.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(self,0)
        .heightRatioToView(self,0.06);
        
        _scrollView.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(_segmentControl,0)
        .bottomEqualToView(self);
        
        _rechargeView.sd_layout
        .leftEqualToView(_scrollView)
        .topEqualToView(_scrollView)
        .bottomEqualToView(_scrollView)
        .widthRatioToView(self,1.0f);
        
        
//        _withDrawView.sd_layout
//        .leftSpaceToView(_rechargeView,0)
//        .topEqualToView(_scrollView)
//        .bottomEqualToView(_scrollView)
//        .widthRatioToView(self,1.0f);
        
        _paymentView.sd_layout
        .leftSpaceToView(_rechargeView,0)
        .topEqualToView(_scrollView)
        .bottomEqualToView(_scrollView)
        .widthRatioToView(self,1.0f);

        _refundView.sd_layout
        .leftSpaceToView(_paymentView,0)
        .topEqualToView(_scrollView)
        .bottomEqualToView(_scrollView)
        .widthRatioToView(self,1.0f);

    }
    return self;
}

@end
