//
//  EditNameTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/1/10.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "EditNameTableViewCell.h"

@interface EditNameTableViewCell (){
    
    UIImageView *_arrow;

}

@end

@implementation EditNameTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        /* 设置项*/
        _name = [[UILabel alloc]init];
        _name.font = TITLEFONTSIZE;
        _name.textColor = TITLECOLOR;
        _name.text = @"姓名";
        
        /* 姓名输入框*/
        _nameText = [[UITextField alloc]init];
        _nameText.font = TITLEFONTSIZE;
        _nameText.textColor = TITLECOLOR;
        
        /* 箭头*/
        _arrow = [[UIImageView alloc]init];
        [_arrow setImage:[UIImage imageNamed:@"rightArrow"]];
        
        
        [self.contentView sd_addSubviews:@[_name,_nameText,_arrow]];
        
        /* 布局*/
        _name.sd_layout
        .leftSpaceToView(self.contentView,20)
        .centerYEqualToView(self.contentView)
        .autoHeightRatio(0);
        [_name setSingleLineAutoResizeWithMaxWidth:200];
        
        _nameText.sd_layout
        .leftSpaceToView(_name,20)
        .topSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,10)
        .rightSpaceToView(self.contentView,20);
        
        
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
