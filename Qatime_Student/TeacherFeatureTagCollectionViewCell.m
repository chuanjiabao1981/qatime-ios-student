
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

-(void)setModel:(Features *)model{
    
    _model = model;
    _features.text = [self featuresSwitch:model.content] ;
    if (model.include == YES) {
        [_featureImage setImage:[UIImage imageNamed:@"对勾_绿"]];
        _features.textColor = [UIColor colorWithHexString:@"1fac64"];
    }else{
        [_featureImage setImage:[UIImage imageNamed:@"对勾_灰"]];
        _features.textColor = [UIColor colorWithHexString:@"cccccc"];
    }
}

- (NSString *)featuresSwitch:(NSString *)string{
    
    NSString *str = @"".mutableCopy;
    if ([string isEqualToString:@"refund_any_time"]) {
        str = @"随时可退";
    }else if ([string isEqualToString:@"coupon_free"]) {
        str = @"报名立减";
    }else if ([string isEqualToString:@"cheap_moment"]) {
        str = @"限时打折";
    }else if ([string isEqualToString:@"join_cheap"]) {
        str = @"插班优惠";
    }else if ([string isEqualToString:@"free_taste"]) {
        str = @"免费试听";
    }
    return str;
}


- (void)updateLayoutSubviews{
    
//    [self.contentView layoutSubviews];
//    [self.contentView layoutIfNeeded];
    _featureImage.sd_resetLayout
    .leftSpaceToView(self.contentView,(self.width_sd-self.height_sd-_features.width_sd-5)*0.5)
    .topSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView, 0)
    .widthEqualToHeight();
    [_featureImage updateLayout];

}


@end
