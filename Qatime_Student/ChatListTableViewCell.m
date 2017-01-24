//
//  ChatListTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/17.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ChatListTableViewCell.h"

@implementation ChatListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _badge = ({
            M13BadgeView *_=[[M13BadgeView alloc]init];
            _.hidden = YES;
            [self.contentView addSubview:_];
            _badge.hidesWhenZero = YES;
            
            _badge.frame = CGRectMake(self.contentView.width_sd, 10, self.contentView.height_sd-20, self.contentView.height_sd-20);
            _.verticalAlignment = M13BadgeViewVerticalAlignmentMiddle;
            _.horizontalAlignment = M13BadgeViewHorizontalAlignmentNone;
            _.pixelPerfectText = YES;
            _.alignmentShift = CGSizeMake(60, 0);
            _.maximumWidth = 40;
            _;
        
        });
        
        _className = ({
            
            UILabel *_= [[UILabel alloc]init];
            _.textColor = TITLECOLOR;
            _.font = [UIFont systemFontOfSize:15*ScrenScale];
            
            [self.contentView addSubview:_];
            
            _.sd_layout
            .leftSpaceToView(self.contentView,20)
            .topSpaceToView(self.contentView,10)
            .bottomSpaceToView(self.contentView,10);
            [_ setSingleLineAutoResizeWithMaxWidth:300];
            _;
        });
        
        /* 取消提醒*/
        _closeNotice = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"取消提醒"]];
        [self.contentView addSubview:_closeNotice];
        _closeNotice.hidden = NO;
        _closeNotice.sd_layout
        .leftSpaceToView(_className,20)
        .centerYEqualToView(_className)
        .heightRatioToView(_className,0.5)
        .widthEqualToHeight();
        
        
        /* 默认接受推送*/
        _noticeOn = YES;
        
        [self setupAutoHeightWithBottomView:_className bottomMargin:10];
        
        
    }
    return self;
    
}

-(void)setModel:(ChatList *)model{
    
    _model = model;
    _className.text = model.name;
    
    self.badge.text = [NSString stringWithFormat:@"%ld",self.model.badge];
    if (self.model.badge>999) {
        self.badge.text = @"999+";
    }

    if (model.tutorium.notify==YES) {
        _noticeOn = YES;
    }else if (model.tutorium.notify==NO){
        _noticeOn = NO;
    }
    
    
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
