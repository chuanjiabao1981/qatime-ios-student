//
//  MyVideoClassTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/21.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "MyVideoClassTableViewCell.h"


@interface MyVideoClassTableViewCell ()

@end

@implementation MyVideoClassTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        /* contentview的裁边*/
        _content = [[UIView alloc]init];
        _content.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_content];
        _content .sd_layout
        .leftSpaceToView(self.contentView,10)
        .rightSpaceToView(self.contentView,10)
        .topSpaceToView(self.contentView,5)
        .bottomSpaceToView(self.contentView,5);
        _content.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _content.layer.borderWidth = 0.8f;
        
        _content.layer.shadowColor =  TITLECOLOR.CGColor;
        _content.layer.shadowOffset = CGSizeMake(1, 1);
        _content.layer.shadowRadius = 1;
        _content.layer.shadowOpacity = 0.1;
        
        
        /* 课程图片*/
        _classImage = [[UIImageView alloc]init];
        [_content addSubview:_classImage];
        _classImage.sd_layout
        .leftSpaceToView(_content, 0)
        .topSpaceToView(_content, 0)
        .bottomSpaceToView(_content, 0)
        .autoWidthRatio(1.0);
        
        /* 课程名称*/
        _className = [[UILabel alloc]init];
        _className.font = TEXT_FONTSIZE;
        _className.textColor = [UIColor blackColor];
        [_content addSubview:_className];
        _className.sd_layout
        .leftSpaceToView(_classImage, 5*ScrenScale)
        .topSpaceToView(_content, 5*ScrenScale)
        .autoHeightRatio(0)
        .rightSpaceToView(_content, 5*ScrenScale);
        
        /* 基本信息*/
        _infos = [[UILabel alloc]init];
        _infos.textColor = TITLECOLOR;
        _infos.font = [UIFont systemFontOfSize:14*ScrenScale];
        [_content addSubview:_infos];
        _infos.sd_layout
        .leftEqualToView(_className)
        .centerYEqualToView(_classImage)
        .autoHeightRatio(0);
        [_infos setSingleLineAutoResizeWithMaxWidth:200];
        
        
        /* 状态*/
        _status = [[UILabel alloc]init];
        _status.textColor = TITLECOLOR;
        _status.font = [UIFont systemFontOfSize:14*ScrenScale];
        [_content addSubview:_status];
        _status.sd_layout
        .leftEqualToView(_className)
        .bottomSpaceToView(_content, 5*ScrenScale)
        .autoHeightRatio(0);
        [_status setSingleLineAutoResizeWithMaxWidth:200];
        
        /* 进入按钮*/
        _enterButton  = [[UIButton alloc]init];
        [_enterButton setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
        _enterButton.layer.borderColor = NAVIGATIONRED.CGColor;
        _enterButton.layer.borderWidth = 0.8f;
        _enterButton.titleLabel.font = [UIFont systemFontOfSize:14*ScrenScale];
        [_enterButton setTitle:@"观看" forState:UIControlStateNormal];
        [_content addSubview:_enterButton];
        _enterButton.sd_layout
        .bottomSpaceToView(_content, 15*ScrenScale)
        .rightSpaceToView(_content, 15*ScrenScale)
        .heightRatioToView(_className, 1.2)
        .widthIs(60*ScrenScale);
//        [_enterButton setupAutoSizeWithHorizontalPadding:15 buttonHeight:_className.height_sd];
        [_enterButton updateLayout];
        
    }
    return self;
}

-(void)setModel:(VideoClassInfo *)model{
    
    _model = model;
    
    [_classImage sd_setImageWithURL:[NSURL URLWithString:model.publicize]];
    
    _className.text = model.name;
    _infos.text = [NSString stringWithFormat:@"%@%@/%@",model.grade,model.subject,model.teacher_name];
    
    if (model.video_lessons_count.integerValue != model.completed_lessons_count.integerValue) {
        
        _status.text = [NSString stringWithFormat:@"进度%@/%@",model.completed_lessons_count,model.video_lessons_count];
    }else{
        _status.text = @"全部课程已观看";
        
    }
    
}


-(void)setMyVideoClassListModel:(MyVideoClassList *)myVideoClassListModel{
    
    _myVideoClassListModel = myVideoClassListModel;
    
    [_classImage sd_setImageWithURL:[NSURL URLWithString:myVideoClassListModel.video_course.publicize]];//接口里暂时还没有这个字段
    _className.text = myVideoClassListModel.video_course.name;
    _infos.text = [NSString stringWithFormat:@"%@%@/%@",myVideoClassListModel.video_course.grade,myVideoClassListModel.video_course.subject,myVideoClassListModel.video_course.teacher_name
                   ];
    if (myVideoClassListModel.buy_count!=myVideoClassListModel.used_count) {
        _status.text = [NSString stringWithFormat:@"进度%ld/%ld",(long)myVideoClassListModel.used_count,(long)myVideoClassListModel.buy_count];
    }else{
         _status.text = @"全部课程已观看";
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
