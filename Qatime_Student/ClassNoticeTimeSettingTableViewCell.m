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
    UILabel *_noticeMe;
    
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
            _.textColor = [UIColor blackColor];
            _.text = @"提前";
            _;
        });
        
        _timeButton = ({
        
            UIButton *_ = [[UIButton alloc]init];
            
            [_ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_ setTitle:@"00小时00分钟" forState:UIControlStateNormal];
            _;
        
        });
    
        _arrow = ({
            UIImageView *_ = [[UIImageView alloc]init];
            [_ setImage:[UIImage imageNamed:@"下"]];
            _;
        });
        _noticeMe = ({
            UILabel *_ = [[UILabel alloc]init];
            _.textColor = [UIColor blackColor];
            _.text = @"提醒我";
            _;
        });
        
        _line = ({
            UIView *_ = [[UIView alloc]init];
            _.backgroundColor = [UIColor grayColor];
            
            _;
        });
        
        
        /* 布局*/
        
        [self.contentView sd_addSubviews:@[_name,_before,_timeButton,_arrow,_noticeMe,_line]];
        
        _name.sd_layout
        .topSpaceToView(self.contentView,15)
        .bottomSpaceToView(self.contentView,15)
        .leftSpaceToView(self.contentView,20);
        [_name setSingleLineAutoResizeWithMaxWidth:500];
        
        _before.sd_layout
        .leftSpaceToView(self.contentView,self.contentView.width_sd/3.0f)
        .centerYEqualToView(self.contentView)
        .heightIs(20);
        [_before setSingleLineAutoResizeWithMaxWidth:500];
        
        _timeButton.sd_layout
        .leftSpaceToView(_before,5)
        .topEqualToView(_before)
        .bottomEqualToView(_before)
        .widthRatioToView(self,1/3.0f);
        
        _arrow.sd_layout
        .leftSpaceToView(_timeButton,0)
        .topSpaceToView(self.contentView,15)
        .bottomSpaceToView(self.contentView,15)
        .widthIs(10);
        
        _noticeMe.sd_layout
        .leftSpaceToView(_arrow,10)
        .topSpaceToView(self.contentView,15)
        .bottomSpaceToView(self.contentView,15);
        [_noticeMe setSingleLineAutoResizeWithMaxWidth:500];
        
        
        
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
