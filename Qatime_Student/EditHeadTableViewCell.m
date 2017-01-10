//
//  EditHeadTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/1/10.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "EditHeadTableViewCell.h"

@interface EditHeadTableViewCell (){
    
    UIImageView *_arrow;
}

@end

@implementation EditHeadTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        /* 设置项*/
        _name = [[UILabel alloc]init];
        _name.font = TITLEFONTSIZE;
        _name.textColor = TITLECOLOR;
        _name.text = @"头像";
        
        /* 头像框*/
        _headImage = [[UIImageView alloc]init];
        
        /* 箭头*/
        _arrow = [[UIImageView alloc]init];
        [_arrow setImage:[UIImage imageNamed:@"rightArrow"]];
        
        
        
        [self.contentView sd_addSubviews:@[_name,_headImage,_arrow]];
        
        /* 布局*/
        _name.sd_layout
        .leftSpaceToView(self.contentView,20)
        .centerYEqualToView(self.contentView)
        .autoHeightRatio(0);
        [_name setSingleLineAutoResizeWithMaxWidth:200];
        
        _headImage.sd_layout
        .topSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,10)
        .leftSpaceToView(_name,20)
        .widthEqualToHeight();
        
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
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
