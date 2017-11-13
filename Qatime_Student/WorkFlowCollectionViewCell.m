//
//  WorkFlowCollectionViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/11/10.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "WorkFlowCollectionViewCell.h"

@implementation WorkFlowCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _image = [[UIImageView alloc]init];
        [self.contentView addSubview:_image];
        _image.sd_layout
        .leftSpaceToView(self.contentView, 5)
        .rightSpaceToView(self.contentView, 5)
        .topSpaceToView(self.contentView, 5)
        .bottomSpaceToView(self.contentView, 5);
        
        _title = [[UILabel alloc]init];
        _title.font = TEXT_FONTSIZE;
        _title.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_title];
        _title.sd_layout
        .centerXEqualToView(self.contentView)
        .autoHeightRatio(0);
        [_title setSingleLineAutoResizeWithMaxWidth:300];
        
        [_title updateLayout];
        
        _subTitle = [[UILabel alloc]init];
        _subTitle.font = TEXT_FONTSIZE_MIN;
        _subTitle.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_subTitle];
        _subTitle.sd_layout
        .centerXEqualToView(self.contentView)
        .topSpaceToView(_title, 10*ScrenScale)
        .autoHeightRatio(0);
        [_subTitle setSingleLineAutoResizeWithMaxWidth:300];
        
        
        
    }
    return self;
}

-(void)makeWorkFlow:(NSDictionary *)workFlow{
    
    _image.image = [UIImage imageNamed:workFlow[@"image"]];
    _title.text = workFlow[@"title"];
    _subTitle.text = workFlow[@"subTitle"];
    
    [_subTitle updateLayout];
    [_title updateLayout];
    CGFloat titleHeight = _title.height_sd;
    
    _title.sd_resetLayout
    .centerXEqualToView(self.contentView)
    .topSpaceToView(self.contentView, (self.height_sd - (titleHeight+_subTitle.height_sd+8*ScrenScale))/2.0)
    .autoHeightRatio(0);
    [_title updateLayout];
    [_subTitle updateLayout];
}

@end
