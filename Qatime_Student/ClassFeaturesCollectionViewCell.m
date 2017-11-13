//
//  ClassFeaturesCollectionViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/11/10.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ClassFeaturesCollectionViewCell.h"
#import "UIColor+HcdCustom.h"

@implementation ClassFeaturesCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _circle = [[UIView alloc]init];
        [self.contentView addSubview:_circle];
        _circle.sd_layout
        .topSpaceToView(self.contentView, 10*ScrenScale)
        .centerXEqualToView(self.contentView)
        .widthRatioToView(self.contentView, 0.66f)
        .heightEqualToWidth();
        [_circle updateLayout];
        _circle.sd_cornerRadiusFromWidthRatio = @0.5;
        
        _title = [[UILabel alloc]init];
        [_circle addSubview:_title];
        _title.font = [UIFont systemFontOfSize:20*ScrenScale];
        _title.textColor = [UIColor whiteColor];
        _title.sd_layout
        .centerXEqualToView(_circle)
        .centerYEqualToView(_circle)
        .autoHeightRatio(0);
        [_title setSingleLineAutoResizeWithMaxWidth:2000];
        
        _subTitle = [[UILabel alloc]init];
        [self.contentView addSubview:_subTitle];
        _subTitle.font = [UIFont systemFontOfSize:14*ScrenScale];
        _subTitle.textColor = [UIColor colorWithHexString:@"666666" ];
        _subTitle.textAlignment = NSTextAlignmentCenter;
        _subTitle.sd_layout
        .topSpaceToView(_circle, 10*ScrenScale)
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .autoHeightRatio(0);
        
        
    }
    return self;
}

-(void)makeFeatures:(NSDictionary *)features{
    
    _circle.backgroundColor = [UIColor colorWithHexString:features[@"color"]];
    _title.text = features[@"title"];
    _subTitle.text = features[@"content"];
    
}


@end
