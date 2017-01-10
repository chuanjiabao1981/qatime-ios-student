//
//  EditBirthdayTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/1/10.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "EditBirthdayTableViewCell.h"

@interface EditBirthdayTableViewCell (){
    
    UIImageView *_arrow;
}

@end

@implementation EditBirthdayTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        /* 设置项*/
        _name = [[UILabel alloc]init];
        _name.font = TITLEFONTSIZE;
        _name.textColor = TITLECOLOR;
        
        /* 内容*/
        _content = [[UILabel alloc]init];
        _content.font = TITLEFONTSIZE;
        _content.textColor = TITLECOLOR;
        
        
        /* 箭头*/
        _arrow = [[UIImageView alloc]init];
        [_arrow setImage:[UIImage imageNamed:@"下"]];
        
        
        [self.contentView sd_addSubviews:@[_name,_content,_arrow]];
        
        /* 布局*/
        _name.sd_layout
        .leftSpaceToView(self.contentView,20)
        .centerYEqualToView(self.contentView)
        .autoHeightRatio(0);
        [_name setSingleLineAutoResizeWithMaxWidth:200];
        
        _content.sd_layout
        .leftSpaceToView(_name,20)
        .topEqualToView(_name)
        .bottomEqualToView(_name)
        .widthRatioToView(self.contentView,0.5);
        
        _arrow.sd_layout
        .rightSpaceToView(self.contentView,20)
        .centerYEqualToView(_name)
        .heightRatioToView(_name,0.5)
        .widthEqualToHeight();
        
        
    
        
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
