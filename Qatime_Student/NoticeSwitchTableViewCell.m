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

        UILabel *name = [[UILabel alloc]init];
        name.text =  @"辅导班消息通知";
        name.textColor = [UIColor blackColor];
        
        _noticeSwitch = [[UISwitch alloc]init];
        
        [self.contentView sd_addSubviews:@[name,_noticeSwitch]];
        
        name.sd_layout
        .leftSpaceToView(self.contentView,20)
        .centerYEqualToView(self.contentView)
        .autoHeightRatio(0);
        [name setSingleLineAutoResizeWithMaxWidth:300];
        
        _noticeSwitch.sd_layout
        .rightSpaceToView(self.contentView,20)
        .topSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,10)
        .autoHeightRatio(0.45);
        
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
