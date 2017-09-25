//
//  ClassHomeworkCell.m
//  Qatime_Teacher
//
//  Created by Shin on 2017/9/8.
//  Copyright © 2017年 Shin. All rights reserved.
//

#import "ClassHomeworkCell.h"
#import "NSString+TimeStamp.h"

@implementation ClassHomeworkCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        UIView *content = [[UIView alloc]init];
        [self.contentView addSubview:content];
        content.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        content.layer.borderWidth = 0.5;
        content.sd_layout
        .leftSpaceToView(self.contentView, 10*ScrenScale)
        .topSpaceToView(self.contentView, 10*ScrenScale)
        .bottomSpaceToView(self.contentView, 10*ScrenScale)
        .rightSpaceToView(self.contentView, 10*ScrenScale);
        
        _title = [[UILabel alloc]init];
        [content addSubview:_title];
        _title.font = TEXT_FONTSIZE;
        _title.textColor = [UIColor blackColor];
        _title.sd_layout
        .leftSpaceToView(content, 10*ScrenScale)
        .topSpaceToView(content, 10*ScrenScale)
        .rightSpaceToView(content, 10*ScrenScale)
        .autoHeightRatio(0);
        [_title setMaxNumberOfLinesToShow:2];
        
        _name = [[UILabel alloc]init];
        [content addSubview:_name];
        _name.font = TEXT_FONTSIZE;
        _name.textColor = TITLECOLOR;
        _name.sd_layout
        .leftEqualToView(_title)
        .centerYEqualToView(content)
        .autoHeightRatio(0);
        [_name setSingleLineAutoResizeWithMaxWidth:500];
        
        _created_at = [[UILabel alloc]init];
        [content addSubview:_created_at];
        _created_at.font = TEXT_FONTSIZE_MIN;
        _created_at.textColor = TITLECOLOR;
        _created_at.sd_layout
        .leftEqualToView(_title)
        .bottomSpaceToView(content, 10*ScrenScale)
        .autoHeightRatio(0);
        [_created_at setSingleLineAutoResizeWithMaxWidth:2000];
        
        _status = [[UILabel alloc]init];
        [content addSubview:_status];
        _status.font = TEXT_FONTSIZE;
        _status.textColor = TITLECOLOR;
        _status.sd_layout
        .rightSpaceToView(content, 10*ScrenScale)
        .bottomSpaceToView(content, 10*ScrenScale)
        .autoHeightRatio(0);
        [_status setSingleLineAutoResizeWithMaxWidth:500];

        
    }
    
    return self;
}

-(void)setModel:(ClassHomework *)model{
    
    _model = model;
    _title.text = model.title;
//    _name.text = model.user_name;
    if ([model.status isEqualToString:@"submitted"]) {
        //没批改
        _status.textColor = [UIColor redColor];
        _status.text = @"待批改";
    }else if ([model.status isEqualToString:@"resolved"]){
        //批改完成
        _status.textColor = [UIColor greenColor];
        _status.text = @"已批改";
    }else if ([model.status isEqualToString:@"pending"]){
        _status.textColor = TITLECOLOR;
        _status.text = @"未交";
    }
    
    _created_at.text = [@"发布时间:" stringByAppendingString:[model.created_at changeTimeStampToDateString]];
    
}

-(void)setHomeworkModel:(HomeworkManage *)homeworkModel{
    
    _homeworkModel = homeworkModel;
    _title.text = homeworkModel.title;
    //    _name.text = model.user_name;
    if ([homeworkModel.status isEqualToString:@"submitted"]) {
        //没批改
        _status.textColor = [UIColor redColor];
        _status.text = @"待批改";
    }else if ([homeworkModel.status isEqualToString:@"resolved"]){
        //批改完成
        _status.textColor = [UIColor greenColor];
        _status.text = @"已批改";
    }else if ([homeworkModel.status isEqualToString:@"pending"]){
        _status.textColor = TITLECOLOR;
        _status.text = @"未交";
    }
    _created_at.text = [@"发布时间:" stringByAppendingString:[homeworkModel.created_at changeTimeStampToDateString]];
    
    
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
