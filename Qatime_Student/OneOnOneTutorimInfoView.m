//
//  OneOnOneTutorimInfoView.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/31.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "OneOnOneTutorimInfoView.h"
#import "UIImageView+WebCache.h"

@interface OneOnOneTutorimInfoView ()

@end

@implementation OneOnOneTutorimInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        _headView = [[UIView alloc]init];
        [self addSubview:_headView];
        _headView.backgroundColor = [UIColor whiteColor];
        _headView.sd_layout
        .leftSpaceToView(self, 0)
        .topSpaceToView(self, 0)
        .rightSpaceToView(self, 0);
        /* 课程名称*/
        _className = [[UILabel alloc]init];
        [_headView addSubview:_className];
        _className.sd_layout
        .leftSpaceToView(_headView,10)
        .rightSpaceToView(_headView, 10)
        .topSpaceToView(_headView,20)
        .autoHeightRatio(0);
        [_className setTextColor:[UIColor blackColor]];
        [_className setFont:TITLEFONTSIZE];
        
        //课程特色
        UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc]init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 0;
        _classFeature = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _classFeature.backgroundColor = [UIColor whiteColor];
        [_headView addSubview:_classFeature];
        _classFeature.sd_layout
        .leftSpaceToView(_headView, 0)
        .rightSpaceToView(_headView, 0)
        .topSpaceToView(_className, 10)
        .heightIs(20);

        
        /* 价格*/
        _priceLabel=[[UILabel alloc]init];
        [_headView addSubview:_priceLabel];
        _priceLabel.sd_layout
        .topSpaceToView(_classFeature,10)
        .leftEqualToView(_className)
        .autoHeightRatio(0);
        [_priceLabel setSingleLineAutoResizeWithMaxWidth:500];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        [_priceLabel setTextColor:NAVIGATIONRED];
        [_priceLabel setFont:[UIFont systemFontOfSize:16*ScrenScale]];
        [_headView setupAutoHeightWithBottomView:_priceLabel bottomMargin:10];
        [_headView updateLayout];
        /* 分割线1*/
        UIView *line1 = [[UIView alloc]init];
        [self addSubview:line1];
        line1.sd_layout
        .leftSpaceToView(self,0)
        .rightSpaceToView(self,0)
        .topSpaceToView(_headView,0)
        .heightIs(1.0f);
        [line1 updateLayout];
        /* 滑动控制器*/
        _segmentControl = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"课程介绍",@"教师组",@"上课安排"]];
        [self addSubview:_segmentControl];
        _segmentControl.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(line1,0)
        .heightIs(30);
        [_segmentControl updateLayout];
        
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.borderType = HMSegmentedControlTypeText;
        _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _segmentControl.selectionIndicatorColor = NAVIGATIONRED ;
        _segmentControl.borderType = HMSegmentedControlBorderTypeTop | HMSegmentedControlBorderTypeBottom;
        _segmentControl.borderWidth = 0.5;
        _segmentControl.borderColor = SEPERATELINECOLOR_2;
        _segmentControl.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15*ScrenScale]};
        _segmentControl.selectionIndicatorHeight = 2;
        [_segmentControl updateLayout];
        
        /* 大滑动页面*/
        _scrollView = [[UIScrollView alloc]init];
        [self addSubview: _scrollView ];
        _scrollView.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(_segmentControl,0)
        .bottomSpaceToView(self, 0);
        
        [_scrollView updateLayout];
        _scrollView.contentSize = CGSizeMake(self.width_sd*3,_scrollView.height_sd );
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        
        /* 分割线2*/
        UIView *line2 =[[UIView alloc]init];
        [self addSubview:line2];
        line2.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(_segmentControl,0)
        .heightIs(0.8f);
        
    }

    return self;
}

//model 直接赋值方法
- (void)setModel:(OneOnOneClass *)model{
    
    _model = model;
    _className.text = model.name;
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    
}




@end
