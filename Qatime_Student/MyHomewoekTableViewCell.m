//
//  MyHomewoekTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/9/11.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "MyHomewoekTableViewCell.h"
#import "NSString+TimeStamp.h"

@implementation MyHomewoekTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *content = [[UIView alloc]init];
        [self.contentView addSubview:content];
        content.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        content.layer.borderWidth = 0.5;
        content.sd_layout
        .leftSpaceToView(self.contentView, 10*ScrenScale)
        .topSpaceToView(self.contentView, 10*ScrenScale)
        .rightSpaceToView(self.contentView, 10*ScrenScale)
        .bottomSpaceToView(self.contentView, 10*ScrenScale);
        
        _title = [[UILabel alloc]init];
        [content addSubview:_title];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.font = TITLEFONTSIZE;
        _title.textColor = [UIColor blackColor];
        _title.sd_layout
        .leftSpaceToView(content, 10*ScrenScale)
        .topSpaceToView(content, 10*ScrenScale)
        .rightSpaceToView(content, 10*ScrenScale)
        .autoHeightRatio(0);
        [_title setMaxNumberOfLinesToShow:2];
        
        _created_at =[[UILabel alloc]init];
        [content addSubview:_created_at];
        _created_at.font = TEXT_FONTSIZE;
        _created_at.textAlignment = NSTextAlignmentLeft;
        _created_at.textColor = TITLECOLOR;
        _created_at.sd_layout
        .leftSpaceToView(content, 10*ScrenScale)
        .centerYEqualToView(content)
        .rightSpaceToView(content, 10*ScrenScale)
        .autoHeightRatio(0);
        [_created_at setMaxNumberOfLinesToShow:1];
        
        _aboutClass=[[UILabel alloc]init];
        [content addSubview:_aboutClass];
        _aboutClass.font = TEXT_FONTSIZE;
        _aboutClass.textAlignment = NSTextAlignmentLeft;
        _aboutClass.textColor = TITLECOLOR;
        _aboutClass.sd_layout
        .leftEqualToView(_created_at)
        .rightSpaceToView(content, 10*ScrenScale)
        .bottomSpaceToView(content, 10*ScrenScale)
        .autoHeightRatio(0);
        

        
        
    }
    return self;
}


-(void)setModel:(HomeworkManage *)model{
    
    _model = model;
    _title.text = model.title;
    _created_at.text = [@"创建时间: " stringByAppendingString:[model.created_at changeTimeStampToDateString]];
    
    _aboutClass.text = @"相关课程 :xxxxxxxx";
//    if ([model.status isEqualToString:@"submitted"]) {
//        _status.text = @"待批";
//        _status.textColor = [UIColor greenColor];
//    }else if ([model.status isEqualToString:@"pending"]){
//        _status.text = @"未交";
//        _status.textColor = [UIColor redColor];
//    }else if ([model.status isEqualToString:@"resolved"]){
//        _status.text = @"已批";
//        _status.textColor = TITLECOLOR;
//    }
    
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
