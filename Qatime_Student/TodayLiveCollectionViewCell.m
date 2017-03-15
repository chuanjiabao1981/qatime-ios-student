//
//  TodayLiveCollectionViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

//  今日直播cell

#import "TodayLiveCollectionViewCell.h"

@implementation TodayLiveCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        //课程图
        _classImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_classImageView];
        _classImageView.sd_layout
        .topSpaceToView(self.contentView,0)
        .leftSpaceToView(self.contentView,0)
        .rightSpaceToView(self.contentView,0)
        .heightIs(self.contentView.width_sd*10/16.0);
        
        //课程名
        _classNameLabel = [[UILabel alloc]init];
        _classNameLabel.textColor = [UIColor whiteColor];
        _classNameLabel.textAlignment = NSTextAlignmentLeft;
        _classNameLabel.font = [UIFont systemFontOfSize:13*ScrenScale];
        _classNameLabel.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        [_classImageView addSubview:_classNameLabel];
        _classNameLabel.sd_layout
        .bottomEqualToView(_classImageView)
        .leftEqualToView(_classImageView)
        .rightEqualToView(_classImageView)
        .autoHeightRatio(0);
        
        //状态label
        _stateLabel = [[UILabel alloc]init];
        _stateLabel.font = [UIFont systemFontOfSize:13*ScrenScale];
        _stateLabel.textColor = TITLECOLOR;
        [self.contentView addSubview:_stateLabel];
        _stateLabel.sd_layout
        .topSpaceToView(_classImageView,2)
        .centerXEqualToView(_classImageView)
        .autoHeightRatio(0);
        [_stateLabel setSingleLineAutoResizeWithMaxWidth:300];
        [_stateLabel updateLayout];
        [self setupAutoHeightWithBottomView:_stateLabel bottomMargin:0];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"TodayHeight" object:self];
        
    }
    return self;

}

-(void)setModel:(TodayLive *)model{
    
    _model = model;
    
    [_classImageView setImage:[UIImage imageNamed:@"school"]];
    _classNameLabel.text = @"今日直播课程内容";
    
    _stateLabel.text = @"12:00-13:00 直播结束";
    
    
    
}

@end
