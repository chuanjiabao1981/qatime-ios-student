//
//  ClassNoticeTimeSettingTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/30.
//  Copyright © 2016年 WWTD. All rights reserved.
//


#import "ClassNoticeTimeSettingTableViewCell.h"

@interface ClassNoticeTimeSettingTableViewCell (){
    
    UILabel *_before;
    UIImageView *_arrow;
    
    UIView *_line;
    
    
}

@end


@implementation ClassNoticeTimeSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        /* 选项名*/
        _name = [[UILabel alloc]init];
        _name.textColor = [UIColor blackColor];
        
        _before = ({
            UILabel *_ = [[UILabel alloc]init];
            _.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
            _.text = @"提前";
            _;
        });
        
        _timeButton = ({
            UILabel *_ = [[UILabel alloc]init];
            [_ setFont:[UIFont systemFontOfSize:15*ScrenScale]];
            _.textColor = BUTTONRED;
            _.text =@"00小时00分钟" ;
            _.userInteractionEnabled = YES;
            _;
        
        });
    
        _arrow = ({
            UIImageView *_ = [[UIImageView alloc]init];
            [_ setImage:[UIImage imageNamed:@"下"]];
            _;
        });

        _line = ({
            UIView *_ = [[UIView alloc]init];
            _.backgroundColor = SEPERATELINECOLOR_2;
            
            _;
        });
        
        
        /* 布局*/
        
        [self.contentView sd_addSubviews:@[_name,_before,_timeButton,_arrow,_line]];
        
        _name.sd_layout
        .topSpaceToView(self.contentView,15)
        .bottomSpaceToView(self.contentView,15)
        .leftSpaceToView(self.contentView,12);
        [_name setSingleLineAutoResizeWithMaxWidth:500];
        
        _arrow.sd_layout
        .rightSpaceToView(self.contentView,12)
        .topSpaceToView(self.contentView,15)
        .bottomSpaceToView(self.contentView,15)
        .widthEqualToHeight();

        _timeButton.sd_layout
        .topSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,10)
        .rightSpaceToView(_arrow,12);
        [_timeButton setSingleLineAutoResizeWithMaxWidth:200];
        
        _before.sd_layout
        .rightSpaceToView(_timeButton,12)
        .topEqualToView(_timeButton)
        .bottomEqualToView(_timeButton);
        [_before setSingleLineAutoResizeWithMaxWidth:100];
        _before.textAlignment = NSTextAlignmentRight;
        
        
        _line.sd_layout
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
