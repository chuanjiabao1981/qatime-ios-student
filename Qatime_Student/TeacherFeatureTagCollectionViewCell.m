
//
//  TeacherFeatureTagCollectionViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/19.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "TeacherFeatureTagCollectionViewCell.h"
#import "UIColor+HcdCustom.h"

@implementation TeacherFeatureTagCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _featureImage = [[UIImageView alloc]init];
        [self.contentView addSubview:_featureImage];
       
        _features = [[UILabel alloc]init];
        [self.contentView addSubview:_features];
        _features.textColor = [UIColor colorWithHexString:@"1fac64"];

        _featureImage.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .topSpaceToView(self.contentView, 0)
        .bottomSpaceToView(self.contentView, 0)
        .widthEqualToHeight();
        
        _features.sd_layout
        .leftSpaceToView(_featureImage, 5)
        .topSpaceToView(self.contentView, 0)
        .bottomSpaceToView(self.contentView, 0);
        [_features setSingleLineAutoResizeWithMaxWidth:200];
        
        
    }
    return self;
}

- (void)updateLayoutSubviews{
    
    [self.contentView layoutSubviews];
    [self.contentView layoutIfNeeded];
    _featureImage.sd_resetLayout
    .leftSpaceToView(self.contentView,(self.width_sd-self.height_sd-_features.width_sd-5)*0.5)
    .topSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView, 0)
    .widthEqualToHeight();
    [_featureImage updateLayout];

}


@end
