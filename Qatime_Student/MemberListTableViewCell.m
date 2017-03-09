//
//  MemberListTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/22.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "MemberListTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation MemberListTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _memberIcon = [[UIImageView alloc]init];
        [self.contentView addSubview:_memberIcon];
        _memberIcon.sd_layout
        .leftSpaceToView(self.contentView,10)
        .topSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,10)
        .widthEqualToHeight();
        _memberIcon.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
        
        _name = [[UILabel alloc]init];
        _name.font = [UIFont systemFontOfSize:16*ScrenScale];
        _name.textColor = TITLECOLOR;
        
        [self.contentView addSubview:_name];
        _name.sd_layout
        .leftSpaceToView(_memberIcon,10)
        .topEqualToView(_memberIcon)
        .bottomEqualToView(_memberIcon);
        [_name setSingleLineAutoResizeWithMaxWidth:300];
        
        _character = [[UILabel alloc]init];
        _character.font = [UIFont systemFontOfSize:15*ScrenScale];
        _character.textColor = TITLECOLOR;
        [self.contentView addSubview:_character];
        _character.sd_layout
        .topEqualToView(_name)
        .bottomEqualToView(_name)
        .rightSpaceToView(self.contentView,10);
        [_character setSingleLineAutoResizeWithMaxWidth:300];
        
        
        
        
        
    }
    
    return  self;
    
}

-(void)setModel:(Members *)model{
    
    _model = model;
    [_memberIcon sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    _name.text = model.name;
    
    
    
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
