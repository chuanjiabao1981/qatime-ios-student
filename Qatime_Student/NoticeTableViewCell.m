//
//  NoticeTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/11.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "NoticeTableViewCell.h"

@implementation NoticeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        
        
        [self.contentView  sizeToFit];
        self.contentView .autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        /* 喇叭*/
        _noticeImage = [[UIImageView alloc]init];
        [_noticeImage setImage:[UIImage imageNamed:@"喇叭"]];
        
        
        /* 日期*/
        _edit_at = [[UILabel alloc]init];
        _edit_at.font = [UIFont systemFontOfSize:15*ScrenScale];
        _edit_at.textColor = [UIColor grayColor];
        
        /* 时间*/
        _time = [[UILabel alloc]init];
        _time.font = [UIFont systemFontOfSize:15*ScrenScale];
        _time.textColor = [UIColor grayColor];
        
        
        /* 公告内容*/
        _announcement = [[UILabel alloc]init];
        _announcement.font = [UIFont systemFontOfSize:16*ScrenScale];
        _announcement.textColor = [UIColor grayColor];
        _announcement.numberOfLines =0;
        
        //////////////预留公告状态接口//////////////
        /* 公告状态*/
        _status = [[UILabel alloc]init];
        _status.textColor = [UIColor redColor];
        _status.font = [UIFont systemFontOfSize:15*ScrenScale];
        
        
        
        [self.contentView sd_addSubviews:@[_noticeImage,_edit_at,_time,_announcement,_status]];
        
        
//        cell上的布局
        
        _noticeImage.sd_layout
        .topSpaceToView(self.contentView,10)
        .leftSpaceToView(self.contentView,10)
        .widthIs(20)
        .heightEqualToWidth();
        
        _edit_at.sd_layout
        .leftSpaceToView(_noticeImage,5)
        .topEqualToView(_noticeImage)
        .heightIs(20);
        [_edit_at setSingleLineAutoResizeWithMaxWidth:200];
        
        _time.sd_layout
        . leftSpaceToView(_edit_at,5)
        .topEqualToView(_edit_at)
        .heightIs(20);
        [_time setSingleLineAutoResizeWithMaxWidth:200];

        _status .sd_layout
        . leftSpaceToView(_time,5)
        .topEqualToView(_time)
        .heightIs(20);
        [_status setSingleLineAutoResizeWithMaxWidth:200];
        
        
        _announcement.sd_layout
        .leftSpaceToView(_noticeImage,10)
        .topSpaceToView(_edit_at,5)
        .rightSpaceToView(self.contentView,30)
        .autoHeightRatio(0);
        _announcement.numberOfLines = 0;

        [self setupAutoHeightWithBottomView:_announcement bottomMargin:10];
        
        
    }
    
    return self;
    
}


- (void)setModel:(Notice *)model{
    
    _model = model;
    
    _edit_at.text = model.edit_at;
    
    _announcement.text = model.announcement;
    
}


-(void)setInteractionNoticeModel:(InteractionNotice *)interactionNoticeModel{
    
    
    _interactionNoticeModel = interactionNoticeModel;
    
    _edit_at.text = interactionNoticeModel.edit_at;
    
    _announcement.text = interactionNoticeModel.announcement;
    
}






- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
