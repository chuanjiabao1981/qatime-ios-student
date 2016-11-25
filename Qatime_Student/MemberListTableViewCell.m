//
//  MemberListTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/22.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "MemberListTableViewCell.h"

@implementation MemberListTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _memberICon = [[UIImageView alloc]init];
        [self.contentView addSubview:_memberICon];
        _memberICon.sd_layout
        .leftSpaceToView(self.contentView,10)
        .topSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,10)
        .widthEqualToHeight();
        
        
        _name = [[UILabel alloc]init];
        [self.contentView addSubview:_name];
        _name.sd_layout
        .leftSpaceToView(_memberICon,10)
        .topEqualToView(_memberICon)
        .bottomEqualToView(_memberICon);
        [_name setSingleLineAutoResizeWithMaxWidth:300];
        
        
        
    }
    
    return  self;
    
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
