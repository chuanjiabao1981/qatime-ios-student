//
//  SettingTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "SettingTableViewCell.h"

@interface SettingTableViewCell (){
    
    UIView *_separateLine;
    
    
}

@end

@implementation SettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        /* 菜单名*/
        _settingName = [[UILabel alloc]init];
        _settingName.textColor = [UIColor blackColor];
        
        
        /* 箭头*/
        
        _arrow = [[UIImageView alloc]init];
        [_arrow setImage:[UIImage imageNamed:@"rightArrow"]];
        
        
       
        /* 余额*/
        
        _balance = [[UILabel alloc]init];
        _balance.textColor = [UIColor blackColor];
        _balance.hidden = YES;
        
        /* 分割线*/
        _separateLine = [[UIView alloc]init];
        _separateLine.backgroundColor= [UIColor lightGrayColor];
        
        
        [self.contentView sd_addSubviews:@[_settingName,_arrow,_balance,_separateLine]];
        
        
        /* 布局*/
        _settingName.sd_layout
        .topSpaceToView(self.contentView,15)
        .bottomSpaceToView(self.contentView,15)
        .leftSpaceToView(self.contentView,20);
        [_settingName setSingleLineAutoResizeWithMaxWidth:200];
        
        _arrow.sd_layout
        .topSpaceToView(self.contentView,20)
        .bottomSpaceToView(self.contentView,20)
        .rightSpaceToView(self.contentView,10)
        .widthEqualToHeight();
        
        _balance.sd_layout
        .rightSpaceToView(_arrow,15)
        .topSpaceToView(self.contentView,15)
        .bottomSpaceToView(self.contentView,15);
        [_balance setSingleLineAutoResizeWithMaxWidth:200];
        
        _separateLine.sd_layout
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .bottomEqualToView(self.contentView)
        .heightIs(0.4);
        
        
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





