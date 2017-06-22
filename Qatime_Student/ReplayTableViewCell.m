//
//  ReplayTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/6/21.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ReplayTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ReplayTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        //content
        UIView *content = [[UIView alloc]init];
        content.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:content];
        content.sd_layout
        .leftSpaceToView(self.contentView, 10*ScrenScale)
        .topSpaceToView(self.contentView, 10*ScrenScale)
        .rightSpaceToView(self.contentView, 10*ScrenScale)
        .bottomSpaceToView(self.contentView, 10*ScrenScale);
        content.layer.borderWidth = 0.5;
        content.layer.borderColor = SEPERATELINECOLOR.CGColor;
        
        //课程图
        _classImage = [[UIImageView alloc]init];
        [content addSubview:_classImage];
        _classImage.sd_layout
        .leftSpaceToView(content, 0)
        .topSpaceToView(content, 0)
        .bottomSpaceToView(content, 0)
        .widthEqualToHeight();
        
        //课程名
        _className = [[UILabel alloc]init];
        [content addSubview:_className];
        _className.font = TEXT_FONTSIZE;
        _className.textColor = [UIColor blackColor];
        _className.sd_layout
        .leftSpaceToView(_classImage, 10*ScrenScale)
        .topSpaceToView(content, 10*ScrenScale)
        .rightSpaceToView(content, 10*ScrenScale)
        .autoHeightRatio(0);
        [_className setMaxNumberOfLinesToShow:2];
        
        //课程基本详情
        _classInfo = [[UILabel alloc]init];
        [content addSubview:_classInfo];
        _classInfo.font = TEXT_FONTSIZE_MIN;
        _classInfo.textColor = TITLECOLOR;
        _classInfo.sd_layout
        .leftEqualToView(_className)
        .bottomSpaceToView(content, 10*ScrenScale)
        .autoHeightRatio(0);
        [_classInfo setSingleLineAutoResizeWithMaxWidth:500];
        
        //试听数
        _counts = [[UILabel alloc]init];
        [content addSubview:_counts];
        _counts.font = TEXT_FONTSIZE_MIN;
        _counts.textColor = TITLECOLOR;
        _counts.sd_layout
        .bottomEqualToView(_classInfo)
        .rightSpaceToView(content, 10*ScrenScale)
        .autoHeightRatio(0);
        [_counts setSingleLineAutoResizeWithMaxWidth:200];
        
        //试听图
        _sights = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sight"]];
        [content addSubview:_sights];
        _sights.sd_layout
        .rightSpaceToView(_counts, 5*ScrenScale)
        .centerYEqualToView(_counts)
        .heightRatioToView(_counts, 0.6)
        .autoWidthRatio(40/28.f);
        
        
    }
    
    return self;
}

-(void)setModel:(ReplayLesson *)model{
    
    _model = model;
    [_classImage sd_setImageWithURL:model.logo_url];
    _className.text = model.live_studio_lesson.name;
    _classInfo.text = [[[model.grade stringByAppendingString:model.subject]stringByAppendingString:@" | "]stringByAppendingString:model.teacher_name];
    _counts.text = model.replay_times;
    
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
