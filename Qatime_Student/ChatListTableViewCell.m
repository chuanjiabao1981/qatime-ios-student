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
//            M13BadgeView *_=[[M13BadgeView alloc]init];
//            _.hidden = YES;
//            _.hidesWhenZero = YES;
//            
//            _.frame = CGRectMake(self.contentView.width_sd-30, 10, self.contentView.height_sd-20, self.contentView.height_sd-20);
//            [self.contentView addSubview:_];
//            
//            _.verticalAlignment = M13BadgeViewVerticalAlignmentMiddle;
//            _.horizontalAlignment = M13BadgeViewHorizontalAlignmentRight;
//            _.pixelPerfectText = YES;
//            _.alignmentShift = CGSizeMake(60, 0);
//            _.maximumWidth = 40;
//            _;
            
            
            
            UILabel *_ = [[UILabel alloc]init];
            [self.contentView addSubview:_];
            _.backgroundColor = [UIColor redColor];
            _.textColor = [UIColor whiteColor];
            _.textAlignment = NSTextAlignmentCenter;
          
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
        
//        self.contentView.badge.badgeMaximumBadgeNumber = 999;
//        self.contentView.badge.badgeCenterOffset = CGPointMake(self.contentView.width_sd-20, self.contentView.centerY_sd);
        
        [self setupAutoHeightWithBottomView:_className bottomMargin:10];
        
        
    }
    return self;
    
}

-(void)setModel:(ChatList *)model{
    
    _model = model;
    _className.text = model.name;
    
    self.badgeNumber = model.badge;
    
    
    if (self.model.badge>999) {
        self.badge.text = @"999+";
    }else{
        
        self.badge.text = [NSString stringWithFormat:@"%ld",self.model.badge];
    }
    
    if(self.model.badge>0&&self.model.badge<10){
        
        [_badge sd_clearAutoLayoutSettings];
        
        _badge.sd_layout
        .rightSpaceToView(self.contentView,20)
        .topSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,10)
        .widthEqualToHeight();
        _badge.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
        [_badge updateLayout];
        
    }else if(self.model.badge>=10&&self.model.badge<100){
        
        [_badge sd_clearAutoLayoutSettings];
        
        _badge.sd_layout
        .rightSpaceToView(self.contentView,20)
        .topSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,10)
        .widthIs((self.contentView.height_sd-20)*1.2);
        _badge.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
        [_badge updateLayout];
    }else if(self.model.badge>=100&&self.model.badge<1000){
        
        [_badge sd_clearAutoLayoutSettings];
        
        _badge.sd_layout
        .rightSpaceToView(self.contentView,20)
        .topSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,10)
        .widthIs((self.contentView.height_sd-20)*1.5);
        _badge.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
        [_badge updateLayout];
        
    }else if(self.model.badge>999){
        
        [_badge sd_clearAutoLayoutSettings];
        
        _badge.sd_layout
        .rightSpaceToView(self.contentView,20)
        .topSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,10)
        .heightIs((self.contentView.height_sd-20)*1.5);
        _badge.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
        [_badge updateLayout];
        
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
