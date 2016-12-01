//
//  NoticeSettingTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/30.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "NoticeSettingTableViewCell.h"

@interface NoticeSettingTableViewCell ()

{
    
    UIView *_line;
    
}

@end

@implementation NoticeSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _name = [[UILabel alloc]init];
        _name.textColor = [UIColor blackColor];
        
        _button = ({
            
            UIButton *_ =[[UIButton alloc]init];
            
            _.layer.masksToBounds = YES;
//            _.layer.borderColor = [UIColor lightGrayColor].CGColor;
//            _.layer.borderWidth =2;
            
            
            _.backgroundColor = [UIColor colorWithRed:0.84 green:0.33 blue:0.6 alpha:1.00];
            [_ setImage:[UIImage imageNamed:@"right_button"] forState:UIControlStateNormal];
            
            _.selected = YES;
            
            _;
            
        
        });
        
        _line = ({
            UIView *_ = [[UIView alloc]init];
            _.backgroundColor = [UIColor grayColor];
            
            _;
        });
        
        
        [self.contentView sd_addSubviews:@[_name,_button,_line]];
        
        _name.sd_layout
        .leftSpaceToView(self.contentView,20)
        .topSpaceToView(self.contentView,15)
        .bottomSpaceToView(self.contentView,15);
        [_name setSingleLineAutoResizeWithMaxWidth:500];
        
        _button.sd_layout
        .rightSpaceToView(self.contentView,20)
        .centerYEqualToView(self.contentView)
        .heightIs(20)
        .widthEqualToHeight();
        _button.sd_cornerRadius = [NSNumber numberWithFloat:M_PI ];
        
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
