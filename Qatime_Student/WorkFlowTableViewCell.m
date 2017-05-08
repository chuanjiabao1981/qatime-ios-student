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
        
        _image = [[UIImageView alloc]init];
        [self.contentView addSubview:_image];
        _image.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .topSpaceToView(self.contentView, 0)
        .bottomSpaceToView(self.contentView, 0);
        
        _title = [[UILabel alloc]init];
        [self.contentView addSubview:_title];
        _title.sd_layout
        .centerXEqualToView(self.contentView)
        .autoHeightRatio(0);
        [_title setSingleLineAutoResizeWithMaxWidth:300];
        
        [_title updateLayout];
        
        _subTitle = [[UILabel alloc]init];
        [self.contentView addSubview:_subTitle];
        _subTitle.sd_layout
        .centerXEqualToView(self.contentView)
        .topSpaceToView(_title, 10*ScrenScale)
        .autoHeightRatio(0);
        [_subTitle setSingleLineAutoResizeWithMaxWidth:300];
        
        [_subTitle updateLayout];
        
        _title.sd_layout
        .topSpaceToView(self.contentView, self.height_sd - (_title.height_sd+_subTitle.height_sd+10*ScrenScale)) ;
        
        [_title updateLayout];
        
        
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
