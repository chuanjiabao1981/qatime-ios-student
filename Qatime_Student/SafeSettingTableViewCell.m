//
//  SafeSettingTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/1.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "SafeSettingTableViewCell.h"

@interface SafeSettingTableViewCell (){
    
    UIView *_line;
    
    
}

@end

@implementation SafeSettingTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    
        _name = [[UILabel alloc]init];
        _name.textColor = [UIColor blackColor];
        
        _content = [[UILabel alloc]init];
        _content.textColor = [UIColor grayColor];
        
        _arrow = [[UIImageView alloc]init];
        [_arrow setImage:[UIImage imageNamed:@"rightArrow"]];
        
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor grayColor];
        
        
        
        [self.contentView sd_addSubviews:@[_name,_arrow,_content,_line]];
        
        
        _name.sd_layout
        .topSpaceToView(self.contentView,15)
        .bottomSpaceToView(self.contentView,15)
        .leftSpaceToView(self.contentView,20);
        [_name setSingleLineAutoResizeWithMaxWidth:500];
        
        
        _arrow.sd_layout
        .topSpaceToView(self.contentView,20)
        .bottomSpaceToView(self.contentView,20)
        .leftSpaceToView(self.contentView,20)
        .widthEqualToHeight();
        

        
        _content.sd_layout
        . topSpaceToView(self.contentView,15)
        .bottomSpaceToView(self.contentView,15)
        .leftSpaceToView(_arrow,15);
        [_content setSingleLineAutoResizeWithMaxWidth:500];


        _line.sd_layout
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .bottomEqualToView(self.contentView)
        .heightIs(0.4);
        
        
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
