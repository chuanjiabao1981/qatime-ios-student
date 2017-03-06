//
//  EditLocationTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/6.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "EditLocationTableViewCell.h"

@implementation EditLocationTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        /* 设置项*/
        _name = [[UILabel alloc]init];
        _name.font = TITLEFONTSIZE;
        _name.textColor = TITLECOLOR;
        _name.text = @"地区";
        
        /* 内容*/
        _content = [[UILabel alloc]init];
        _content.font = TITLEFONTSIZE;
        _content.textColor = TITLECOLOR;
        
        /* 副内容*/
        _subContent = [[UILabel alloc]init];
        _subContent.font = TITLEFONTSIZE;
        _subContent.textColor = TITLECOLOR;
        
        
        [self.contentView sd_addSubviews:@[_name,_subContent,_content]];
        
        /* 布局*/
        _name.sd_layout
        .leftSpaceToView(self.contentView,20)
        .centerYEqualToView(self.contentView)
        .autoHeightRatio(0);
        [_name setSingleLineAutoResizeWithMaxWidth:200];
        
        _subContent.sd_layout
        .topEqualToView(_name)
        .bottomEqualToView(_name)
        .rightSpaceToView(self.contentView,20);
        [_subContent setSingleLineAutoResizeWithMaxWidth:100];
        
        
        _content.sd_layout
        .rightSpaceToView(_subContent,20)
        .topEqualToView(_subContent)
        .bottomEqualToView(_subContent);
        [_content setSingleLineAutoResizeWithMaxWidth:100];
        
        
        
        
        
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
