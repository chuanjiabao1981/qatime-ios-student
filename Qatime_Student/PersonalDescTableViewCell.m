//
//  PersonalDescTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/6.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "PersonalDescTableViewCell.h"

@implementation PersonalDescTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _name = [[UILabel alloc]init];
        _name.font = TITLEFONTSIZE;
        _name.textColor = TITLECOLOR;
        
        
        _content = [[UILabel alloc]init];
        _content.font = TITLEFONTSIZE;
        _content.textColor = [UIColor lightGrayColor];
        
        
        [self.contentView sd_addSubviews:@[_name,_content]];
        
        _name.sd_layout
        .topSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,10)
        .leftSpaceToView(self.contentView,20);
        
        [_name setSingleLineAutoResizeWithMaxWidth:500];
        
        _content.sd_layout
        .rightSpaceToView(self.contentView,10)
        .topSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,10);
        
        [_content setSingleLineAutoResizeWithMaxWidth:self.width_sd-20-_name.width-10];

        
        
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
