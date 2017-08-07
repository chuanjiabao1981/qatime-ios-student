//
//  ExclusiveOfflineClassTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/7/24.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ExclusiveOfflineClassTableViewCell.h"

@implementation ExclusiveOfflineClassTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupViews];
        
    }
    
    return self;
}



- (void)setupViews{
    
    /* 原点布局*/
    _tips = [[UIImageView alloc]init];
    [_tips setImage:[UIImage imageNamed:@"菱形"]];
    
    /* 课程名称label 布局*/
    _className = [[UILabel alloc]init];
    _className.font = TEXT_FONTSIZE;
    
    _address = [[UILabel alloc]init];
    [_address setFont:[UIFont systemFontOfSize:14*ScrenScale]];
    _address.textColor = [UIColor lightGrayColor];
    
    /* 课程时间*/
    _classDate = [[UILabel alloc]init];
    [_classDate setFont:[UIFont systemFontOfSize:14*ScrenScale]];
    _classDate.textColor = [UIColor lightGrayColor];
    
    _classTime = [[UILabel alloc]init];
    [_classTime setFont:[UIFont systemFontOfSize:14*ScrenScale]];
    _classTime.textColor = [UIColor lightGrayColor];
    
    /* 课程状态*/
    _status = [[UILabel alloc]init];
    _status.textColor = TITLECOLOR;
    _status.font = [UIFont systemFontOfSize:15*ScrenScale];
    
    _class_status = @"".mutableCopy;
    
    /* 回放次数*/
    _replay = [[UIButton alloc]init];
    [_replay setTitleColor:BUTTONRED forState:UIControlStateNormal];
    [_replay.titleLabel setFont:[UIFont systemFontOfSize:14*ScrenScale]];
    
    
    /* 全部进行布局*/
    [self.contentView sd_addSubviews:@[_className,_tips,_address,_classDate,_classTime,_status,_replay]];
    
    _className.sd_layout
    .leftSpaceToView(self.contentView,30)
    .topSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
    .autoHeightRatio(0);
    _className.numberOfLines = 0;
    
    _tips.sd_layout
    .widthIs(15)
    .heightIs(15)
    .centerYEqualToView(_className)
    .leftSpaceToView(self.contentView,10);
    
    _address.sd_layout
    .leftEqualToView(_className)
    .topSpaceToView(_className, 10)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);
    
    _classDate.sd_layout
    .leftEqualToView(_className)
    .topSpaceToView(_address,10)
    .autoHeightRatio(0);
    [_classDate setSingleLineAutoResizeWithMaxWidth:200];
    
    _classTime.sd_layout
    .leftSpaceToView(_classDate,10)
    .topEqualToView(_classDate)
    .autoHeightRatio(0);
    [_classTime setSingleLineAutoResizeWithMaxWidth:300];
    
    _status.sd_layout
    .leftEqualToView(_className)
    .topSpaceToView(_classDate,5)
    .autoHeightRatio(0);
    [_status setSingleLineAutoResizeWithMaxWidth:100];
    
    _replay.sd_layout
    .centerYEqualToView(_status)
    .rightEqualToView(_className)
    .leftSpaceToView(_status,0)
    .autoHeightRatio(0);
    _replay.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    
    [self setupAutoHeightWithBottomView:_status bottomMargin:10];
    
    
}

-(void)setModel:(ExclusiveLesson *)model{
    
    _model = model;

    _className.text = model.name;
    _classDate .text = model.class_date;
    _address.text = model.class_address;
    _classTime .text = [NSString stringWithFormat:@"%@",model.start_time];
    
    /* 已开课的状态*/
    if ([model.status isEqualToString:@"init"]) {
        _status.text =@"未开始";
        _class_status = [NSString stringWithFormat:@"未开始"];
    }else if([model.status isEqualToString:@"ready"]){
        _status.text =@"待上课";
        _class_status = [NSString stringWithFormat:@"待上课"];
    }else if([model.status isEqualToString:@"teaching"]){
        _status.text =@"直播中";
        _class_status = [NSString stringWithFormat:@"直播中"];
    }else if([model.status isEqualToString:@"closed"]){
        _status.text =@"已直播";
        _class_status = [NSString stringWithFormat:@"已直播"];
    }else if([model.status isEqualToString:@"finished"]){
        _status.text =@"已结束";
        _class_status = [NSString stringWithFormat:@"已结束"];
    }else if([model.status isEqualToString:@"pause"]){
        _status.text =@"暂停中";
        _class_status = [NSString stringWithFormat:@"暂停中"];
    }else if([model.status isEqualToString:@"missed"]){
        _status.text =@"待补课";
        _class_status = [NSString stringWithFormat:@"待补课"];
    }else if([model.status isEqualToString:@"billing"]){
        _status.text =@"已结束";
        _class_status = [NSString stringWithFormat:@"已结束"];
    }else if([model.status isEqualToString:@"completed"]){
        _status.text =@"已结束";
        _class_status = [NSString stringWithFormat:@"已结束"];
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
