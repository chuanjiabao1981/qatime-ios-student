//
//  NoticeWaysTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/1/22.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "NoticeWaysTableViewCell.h"

@implementation NoticeWaysTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _name = [[UILabel alloc]init];
        [self.contentView addSubview:_name];
        _name.font = [UIFont systemFontOfSize:17*ScrenScale];
        _name.textColor = [UIColor blackColor];
        
        
        
        _content = [[UILabel alloc]init];
        [self.contentView addSubview:_content];
        _content.font = [UIFont systemFontOfSize:15*ScrenScale];
        _content.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
        
        UIView *line = [[UIView alloc]init];
        [self.contentView addSubview:line];
        line.backgroundColor = SEPERATELINECOLOR;
        
        [self.contentView sd_addSubviews:@[_name,_content,line]];
        
        _name.sd_layout
        .leftSpaceToView(self.contentView,12)
        .topSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,10);
        [_name setSingleLineAutoResizeWithMaxWidth:200];
        
        _content.sd_layout
        .rightSpaceToView(self.contentView,12)
        .topSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,10);
        [_content setSingleLineAutoResizeWithMaxWidth:200];
        
        line.sd_layout
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .bottomEqualToView(self.contentView)
        .heightIs(0.5);
        
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
