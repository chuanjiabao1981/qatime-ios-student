//
//  ChatListTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/17.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ChatListTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ChatListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _image = ({
        
            UIImageView *_ = [[UIImageView alloc]init];
            [self.contentView addSubview:_];
            _.sd_layout
            .leftSpaceToView(self.contentView, 15)
            .topSpaceToView(self.contentView, 10)
            .bottomSpaceToView(self.contentView, 10)
            .widthEqualToHeight();
            _.sd_cornerRadius = @(M_PI);
            _;
        });
        
        
        _className = ({
            
            UILabel *_= [[UILabel alloc]init];
            _.textColor = [UIColor blackColor];
            _.font = [UIFont systemFontOfSize:15*ScrenScale];
            _.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:_];
            
            _.sd_layout
            .leftSpaceToView(_image,10)
            .topEqualToView(_image)
            .autoHeightRatio(0)
            .rightSpaceToView(self.contentView, 40);
            
            _;
        });
        
        _lastTime = ({
            UILabel *_ = [[UILabel alloc]init];
            [self.contentView addSubview:_];
            _.textColor = TITLECOLOR;
            _.font = TEXT_FONTSIZE;
            _.sd_layout
            .leftEqualToView(_className)
            .bottomEqualToView(_image)
            .autoHeightRatio(0);
            [_ setSingleLineAutoResizeWithMaxWidth:200];
            _;
        });
        
        /* 取消提醒*/
        _closeNotice = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"取消提醒"]];
        [self.contentView addSubview:_closeNotice];
        _closeNotice.hidden = NO;
        _closeNotice.sd_layout
        .topEqualToView(_image)
        .rightSpaceToView(self.contentView, 15)
        .heightRatioToView(_className, 1.0)
        .widthEqualToHeight();
        
        _badge = ({
            UILabel *_ = [[UILabel alloc]init];
            [self.contentView addSubview:_];
            _.backgroundColor = [UIColor redColor];
            _.textColor = [UIColor whiteColor];
            _.textAlignment = NSTextAlignmentCenter;
            
            _;
            
        });
        
        /* 默认接受推送*/
        _noticeOn = YES;
        
        [self setupAutoHeightWithBottomView:_className bottomMargin:10];
        
        
    }
    return self;
    
}

-(void)setModel:(ChatList *)model{
    
    _model = model;
    
    __block NSURL *imageURL;
    if (model.classType == LiveCourseType) {
        imageURL = [NSURL URLWithString:model.tutorium.publicize];
    }else if (model.classType == InteractionCourseType){
        imageURL = [NSURL URLWithString:model.interaction.publicize[@"list"]];
    }else if (model.classType == ExclusiveCourseType){
        imageURL = [NSURL URLWithString:model.exclusive.publicizes_url[@"list"]];
    }
    
    [_image sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"school"]];
    _className.text = model.name;
    _lastTime.text = [self timeStampSwitcher:model.lastTime];
    self.badgeNumber = model.badge;
    if (self.model.badge>999) {
        self.badge.text = @"999+";
    }else{
        
        self.badge.text = [NSString stringWithFormat:@"%ld",self.model.badge];
    }
    
    if(self.model.badge>0&&self.model.badge<10){
        
        [_badge sd_clearAutoLayoutSettings];
        
        _badge.sd_layout
        .rightEqualToView(_closeNotice)
        .bottomEqualToView(_image)
        .autoHeightRatio(0)
        .widthEqualToHeight();
        
        _badge.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
        [_badge updateLayout];
        
    }else if(self.model.badge>=10&&self.model.badge<100){
        
        [_badge sd_clearAutoLayoutSettings];
        
        _badge.sd_layout
        .rightEqualToView(_closeNotice)
        .bottomEqualToView(_image)
        .autoHeightRatio(0)
        .autoWidthRatio(1.2);
        
        _badge.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
        [_badge updateLayout];
    }else if(self.model.badge>=100&&self.model.badge<1000){
        
        [_badge sd_clearAutoLayoutSettings];
        
        _badge.sd_layout
        .rightEqualToView(_closeNotice)
        .bottomEqualToView(_image)
        .autoHeightRatio(0)
        .autoWidthRatio(1.5);
        _badge.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
        [_badge updateLayout];
        
    }else if(self.model.badge>999){
        
        [_badge sd_clearAutoLayoutSettings];
        
        _badge.sd_layout
        .rightEqualToView(_closeNotice)
        .bottomEqualToView(_image)
        .autoHeightRatio(0)
        .autoWidthRatio(1.7);
        _badge.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
        [_badge updateLayout];
        
    }

    if (model.tutorium.name!=nil) {
        if (model.tutorium.notifyState == NIMTeamNotifyStateAll) {
            _noticeOn = YES;
        }else if (model.tutorium.notifyState == NIMTeamNotifyStateNone){
            _noticeOn = NO;
        }
    }else{
        
        if (model.interaction.notifyState == NIMTeamNotifyStateAll) {
            _noticeOn = YES;
        }else if (model.interaction.notifyState == NIMTeamNotifyStateNone){
            _noticeOn = NO;
        }
    }
 
}



- (NSString *)timeStampSwitcher:(NSTimeInterval)timeStamps{
    
    NSString *switchString;
    
    if (timeStamps !=0) {
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamps];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM-dd HH:mm:ss"];
        switchString = [formatter stringFromDate:date];
    }else{
        switchString = @"";
    }

    return switchString;
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
