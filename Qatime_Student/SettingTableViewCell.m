//
//  SettingTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "SettingTableViewCell.h"
#import "UIView+FontSize.h"


@interface SettingTableViewCell (){
    
    
    
    
}

@end

@implementation SettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        /* logoImage*/
        _logoImage = [[UIImageView alloc]init];
        
        /* 菜单名*/
        _settingName = [[UILabel alloc]init];
        _settingName.textColor = TITLECOLOR;
        _settingName.font = TITLEFONTSIZE  ;
        
        
        /* 箭头*/
        _arrow = [[UIImageView alloc]init];
        [_arrow setImage:[UIImage imageNamed:@"rightArrow"]];
        
       
        /* 余额*/
        
        _balance = [[UILabel alloc]init];
        _balance.textColor = TITLECOLOR;
        _balance.hidden = YES;
        _balance.font = [UIFont systemFontOfSize:16*ScrenScale];
        
        /* 分割线*/
        _separateLine = [[UIView alloc]init];
        _separateLine.backgroundColor= SEPERATELINECOLOR;
        
        [self.contentView sd_addSubviews:@[_logoImage,_settingName,_balance,_separateLine,_arrow]];
        
        /* 布局*/
        
        _logoImage.sd_layout
        .leftSpaceToView(self.contentView,10)
        .centerYEqualToView(self.contentView)
        .heightRatioToView(self.contentView,0.5)
        .widthEqualToHeight();
        
        _settingName.sd_layout
        .centerYEqualToView(self.contentView)
        .heightRatioToView(self.contentView,0.5)
        .leftSpaceToView(_logoImage,20);
        [_settingName setSingleLineAutoResizeWithMaxWidth:200];
        
        _arrow.sd_layout
        .topSpaceToView(self.contentView,15)
        .bottomSpaceToView(self.contentView,15)
        .rightSpaceToView(self.contentView,20)
        .widthEqualToHeight();
        
        _balance.sd_layout
        .rightSpaceToView(self.contentView,15)
        .topSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,10);
        [_balance setSingleLineAutoResizeWithMaxWidth:200];
        
        _separateLine.sd_layout
        .leftSpaceToView(self.contentView,0)
        .rightEqualToView(self.contentView)
        .bottomEqualToView(self.contentView)
        .heightIs(0.5);
        
        
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





