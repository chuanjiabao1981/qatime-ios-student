//
//  WorkFlowTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/5/8.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "WorkFlowTableViewCell.h"

@implementation WorkFlowTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
        
        [_subTitle updateLayout];
        
        _title.sd_resetLayout
        .centerXEqualToView(self.contentView)
        .autoHeightRatio(0)
        .topSpaceToView(self.contentView, (self.height_sd - (_title.height_sd+_subTitle.height_sd+8*ScrenScale))/2.0) ;
        
        [_title updateLayout];
        [_subTitle updateLayout];
        
        
    }
    return self;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
