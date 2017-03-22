//
//  NoticeSwitchTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "NoticeSwitchTableViewCell.h"

@implementation NoticeSwitchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _name = [[UILabel alloc]init];
//        _name.text =  @"辅导班消息通知";
        _name.textColor = [UIColor blackColor];
        _name.font = [UIFont systemFontOfSize:17*ScrenScale];
        _noticeSwitch = [[UISwitch alloc]init];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor  = SEPERATELINECOLOR_2;
        
        
        
        
        [self.contentView sd_addSubviews:@[_name,_noticeSwitch,line]];
        
        _name.sd_layout
        .leftSpaceToView(self.contentView,12)
        .centerYEqualToView(self.contentView)
        .autoHeightRatio(0);
        [_name setSingleLineAutoResizeWithMaxWidth:300];
        
        _noticeSwitch.sd_layout
        .rightSpaceToView(self.contentView,20)
        .topSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,10)
        .centerYEqualToView(_name)
        .autoHeightRatio(0.5);
        
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
