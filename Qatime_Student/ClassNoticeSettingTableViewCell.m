//
//  ClassNoticeSettingTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/30.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ClassNoticeSettingTableViewCell.h"

@interface ClassNoticeSettingTableViewCell (){
    
    UIView *_line;
    
    
}

@end

@implementation ClassNoticeSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        /* 选项名*/
        _name = [[UILabel alloc]init];
        _name.textColor = [UIColor blackColor];
        
        
        /* 左侧的选项的按钮*/
        _leftButton = ({
        
            UIButton *_ = [[UIButton alloc]init];
            _.layer.masksToBounds = YES;
            //            _.layer.borderColor = [UIColor lightGrayColor].CGColor;
            //            _.layer.borderWidth =2;
            
            
            _.backgroundColor = [UIColor colorWithRed:0.84 green:0.33 blue:0.6 alpha:1.00];
            [_ setImage:[UIImage imageNamed:@"right_button"] forState:UIControlStateNormal];
            
            _.selected = YES;
            
            _;
            
        });
        
        
        _leftLabel = ({
            UILabel *_ = [[UILabel alloc]init];
            
            _.textColor = [UIColor blackColor];
            
            _;
        });
        
        
        
        
        
        
        /* 右侧的选项的按钮*/
        _rightButton = ({
            
            UIButton *_ = [[UIButton alloc]init];
            _.layer.masksToBounds = YES;
            //            _.layer.borderColor = [UIColor lightGrayColor].CGColor;
            //            _.layer.borderWidth =2;
            
            
            _.backgroundColor = [UIColor colorWithRed:0.84 green:0.33 blue:0.6 alpha:1.00];
            [_ setImage:[UIImage imageNamed:@"right_button"] forState:UIControlStateNormal];
            
            _.selected = YES;
            
            _;
            
        });

        _rightLabel = ({
            UILabel *_ = [[UILabel alloc]init];
            
            _.textColor = [UIColor blackColor];
            
            _;
        });
        
        _line = ({
            UIView *_ = [[UIView alloc]init];
            _.backgroundColor = [UIColor grayColor];
            
            _;
        });
        

        
        
        /* 布局 */
        [self.contentView sd_addSubviews:@[_name,_leftButton,_leftLabel,_rightButton,_rightLabel,_line]];
        
        _name.sd_layout
        .topSpaceToView(self.contentView,15)
        .bottomSpaceToView(self.contentView,15)
        .leftSpaceToView(self.contentView,20);
        [_name setSingleLineAutoResizeWithMaxWidth:500];
        
        
        _leftButton.sd_layout
        .leftSpaceToView(self.contentView,self.contentView.width_sd*0.4f)
        .centerYEqualToView(self.contentView)
        .heightIs(20)
        .widthEqualToHeight();
        _leftButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        
        _leftLabel.sd_layout
        .leftSpaceToView(_leftButton,5)
        .topSpaceToView(self.contentView,15)
        .bottomSpaceToView(self.contentView,15);
        [_leftLabel setSingleLineAutoResizeWithMaxWidth:500];
        
        
        
        _rightButton.sd_layout
        .leftSpaceToView(self.contentView,self.contentView.width_sd*0.8f)
        .centerYEqualToView(self.contentView)
        .heightIs(20)
        .widthEqualToHeight();
         _rightButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        
        _rightLabel.sd_layout
        .leftSpaceToView(_rightButton,5)
        .topSpaceToView(self.contentView,15)
        .bottomSpaceToView(self.contentView,15);
        [_leftLabel setSingleLineAutoResizeWithMaxWidth:500];
        

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
