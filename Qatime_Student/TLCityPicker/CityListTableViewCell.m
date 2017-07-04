//
//  CityListTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/9.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "CityListTableViewCell.h"

@implementation CityListTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self.contentView addSubview:self.cityName];
        self.cityName.sd_layout
        .leftSpaceToView(self.contentView,20)
        .topSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,10)
        .rightSpaceToView(self.contentView,20);
        
        
    }
    return self;
}
//懒加载出label
-(UILabel *)cityName{
    
    if (!_cityName) {
        _cityName = [[UILabel alloc]init];
        _cityName.font = [UIFont systemFontOfSize:16*ScrenScale];
        
    }
    return _cityName;
}

-(void)setModel:(TLCity *)model{
    
    _model = model;
    
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
