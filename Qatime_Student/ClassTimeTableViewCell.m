//
//  ClassTimeTableView_m
//  Qatime_Student
//
//  Created by Shin on 2016/11/28.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ClassTimeTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+StatusSwitch.h"

@interface ClassTimeTableViewCell ()
    



@end

@implementation ClassTimeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        /* contentview的裁边*/
        _content = [[UIView alloc]init];
        [self.contentView addSubview:_content];
        _content .sd_layout
        .leftSpaceToView(self.contentView,10)
        .rightSpaceToView(self.contentView,10)
        .topSpaceToView(self.contentView,5)
        .bottomSpaceToView(self.contentView,5);
        _content.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        _content.layer.borderWidth = 0.8f;
        
      /* 课程图片*/
        _classImage = [[UIImageView alloc]init];
        
        /**课程类型*/
        _type =[[UILabel alloc]init];
        _type.font = [UIFont systemFontOfSize:14*ScrenScale];
        _type.textColor = [UIColor whiteColor];
        _type.textAlignment = NSTextAlignmentCenter;
        [_classImage addSubview:_type];
        _type.sd_layout
        .leftSpaceToView(_classImage,0)
        .rightSpaceToView(_classImage, 0)
        .bottomSpaceToView(_classImage, 0)
        .autoHeightRatio(0);
        
        /* 课程名称*/
        _name = [[UILabel alloc]init];
        _name.font = TEXT_FONTSIZE;
        _className = [[UILabel alloc]init];
        _className.font = TEXT_FONTSIZE;
        
        /* 年级*/
        _grade = [[UILabel alloc]init];
        _grade.textColor = [UIColor grayColor];
        _grade.font = [UIFont systemFontOfSize:14*ScrenScale];
        
        /* 科目*/
        _subject = [[UILabel alloc]init];
        _subject.textColor = [UIColor grayColor];
        _subject.font = [UIFont systemFontOfSize:14*ScrenScale];
        
        /* 斜杠*/
        UILabel *line = [[UILabel alloc]init];
        line.textColor = [UIColor grayColor];
        line.font = [UIFont systemFontOfSize:14*ScrenScale];
        line.text = @"/";
        
        /* 教师姓名*/
        _teacherName = [[UILabel alloc]init];
        _teacherName.textColor = [UIColor grayColor];
        _teacherName.font = [UIFont systemFontOfSize:14*ScrenScale];
        
        /* 日期*/
        _date = [[UILabel alloc]init];
        _date.textColor = [UIColor grayColor];
        _date.font = [UIFont systemFontOfSize:14*ScrenScale];

        /* 状态*/
        _status = [[UILabel alloc]init];
        _status.textColor = [UIColor lightGrayColor];
        _status.font = [UIFont systemFontOfSize:14*ScrenScale];

        /* 进入按钮*/
        _enterButton = [[UIButton alloc]init];
        _enterButton.layer.borderColor = [UIColor orangeColor].CGColor;
        _enterButton.layer.borderWidth = 0.8;
        [_enterButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_enterButton.titleLabel setFont:[UIFont systemFontOfSize:14*ScrenScale]];
         [_enterButton setTitle:@"进入" forState:UIControlStateNormal];
        
        /* 所有控件的布局*/
        [_content sd_addSubviews:@[_classImage,_name,_className,_grade,_subject,line,_teacherName,_status,_date,_enterButton]];
        
        /* 课程图片布局*/
        _classImage.sd_layout
        .topSpaceToView(_content,0)
        .bottomSpaceToView(_content,0)
        .leftSpaceToView(_content,0)
        .autoWidthRatio(1.0);
        
        /* 课程名称布局*/
        
        _name.sd_layout
        .leftSpaceToView(_classImage,10*ScrenScale)
        .topSpaceToView(_content,5*ScrenScale);
//        .autoHeightRatio(0);
        [_name setSingleLineAutoResizeWithMaxWidth:100];
        
        _className.sd_layout
        .leftSpaceToView(_name,5*ScrenScale)
        .topEqualToView(_name)
        .rightSpaceToView(_content,10*ScrenScale)
        .bottomEqualToView(_name);
//        [_className setSingleLineAutoResizeWithMaxWidth:200];
    
        
        /* 年级布局*/
        _grade .sd_layout
        .leftEqualToView(_name)
        .centerYEqualToView(_classImage)
        .autoHeightRatio(0);
        [_grade setSingleLineAutoResizeWithMaxWidth:100];
        
        /* 科目布局*/
        
        _subject .sd_layout
        .leftSpaceToView(_grade,0)
        .topEqualToView(_grade)
        .heightRatioToView(_grade,1.0f);
        
        [_subject setSingleLineAutoResizeWithMaxWidth:100];
        
        /* 斜杠布局*/
        
        line.sd_layout
        .leftSpaceToView(_subject,0)
        .heightRatioToView(_subject,1.0f)
        .topEqualToView(_subject);
        [line setSingleLineAutoResizeWithMaxWidth:100];
        
        
        /* 教师姓名布局*/
        
        _teacherName.sd_layout
        .leftSpaceToView(line,0)
        .topEqualToView(line)
        .heightRatioToView(line,1.0);
        
        [_teacherName setSingleLineAutoResizeWithMaxWidth:100];
        
        /* 状态label布局*/
        
        _status.sd_layout
        .rightSpaceToView(_content,20*ScrenScale)
        .topEqualToView(_teacherName)
        .autoHeightRatio(0);
        
        [_status setSingleLineAutoResizeWithMaxWidth:200];
        
        /* 进入按钮*/
        _enterButton .sd_layout
        .rightSpaceToView(_content,10*ScrenScale)
        .bottomSpaceToView(_content,5*ScrenScale)
        .heightIs(20)
        .widthIs(50);
        
        /* 日期*/
        _date.sd_layout
        .leftEqualToView(_grade)
        .rightSpaceToView(_content,10*ScrenScale)
        .bottomSpaceToView(_content,5*ScrenScale)
        .autoHeightRatio(0);
        
        
  
        
        
//        [self setupAutoHeightWithBottomView:_content bottomMargin:5];
    }
    
    
    return self;
}



-(void)setModel:(ClassTimeModel *)model{
    _model = model;
    [_classImage sd_setImageWithURL:[NSURL URLWithString:_model.course_publicize]];
    _name .text = model.name;
    _className.text = model.course_name;
    _date.text = [NSString stringWithFormat:@"%@ %@",model.class_date,model.live_time];
    _teacherName.text = model.teacher_name;
    NSLog(@"%@",model.status);
    NSLog(@"%@",[NSString statusSwitchWithStatus:model.status]);
    _status.text = [NSString statusSwitchWithStatus:model.status];
    _grade.text = model.grade;
    _subject.text = model.subject;

    /* 不能进入观看*/
    if ([model.status isEqualToString:@"init"]||[model.status isEqualToString:@"finished"]||[model.status isEqualToString:@"missed"]) {
        
        _canUse = NO;
    }else{
        _canUse = YES;
    }
    
    //课程类型
    if ([model.modal_type isEqualToString:@"LiveStudio::Lesson"]) {
        _type.text = @"直播课";
        _type.backgroundColor = NAVIGATIONRED;
    }else if ([model.modal_type isEqualToString:@"LiveStudio::InteractiveLesson"]){
        
        _type.text = @"一对一";
        _type.backgroundColor = [UIColor colorWithRed:1.0 green:0.8 blue:1.0 alpha:1.0];
    }else{
        _type.text = @"视频课";
    }


}

//-(void)setEnterButtonHidden:(BOOL)enterButtonHidden{
//    
//    _enterButtonHidden = enterButtonHidden;
//
//    if (_enterButtonHidden ==YES) {
//        
//        [self.enterButton setHidden:YES];
//    }else{
//        [self.enterButton setHidden:NO];
//    }
//    
//}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
