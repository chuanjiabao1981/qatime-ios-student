//
//  ProinceTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/6.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ProinceTableViewCell.h"

@implementation ProinceTableViewCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _title = [[UILabel alloc]init];
        _title.textColor = TITLECOLOR;
        [self.contentView addSubview:_title];
        _title.sd_layout
        .leftSpaceToView(self.contentView,20)
        .centerYEqualToView(self.contentView)
        .autoHeightRatio(0);
        [_title setSingleLineAutoResizeWithMaxWidth:200];
        
        
        
    }
    return self;
    
}


-(void)setModel:(Province *)model{
    
    _model = model;
    
    _title.text = model.name;
    
    
}

- (void)setCityModel:(City *)cityModel{
    
    _cityModel = cityModel;
    _title.text = cityModel.name;
    
    
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
