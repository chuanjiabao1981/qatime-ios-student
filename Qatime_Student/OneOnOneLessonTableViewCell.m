//
//  OneOnOneLessonTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/1.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "OneOnOneLessonTableViewCell.h"
#import "NSString+StatusSwitch.h"

@interface OneOnOneLessonTableViewCell  (){
    
    UIImageView *_image;
    
}

@end

@implementation OneOnOneLessonTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //日期
        [self.contentView addSubview:self.date];
        self.date.sd_layout
        .topSpaceToView(self.contentView, 20)
        .leftSpaceToView(self.contentView, 30)
        .autoHeightRatio(0);
        [self.date setSingleLineAutoResizeWithMaxWidth:200];
        //时间
        [self.contentView addSubview:self.time];
        self.time.sd_layout
        .leftSpaceToView(self.date, 10)
        .topEqualToView(self.date)
        .bottomEqualToView(self.date);
        [self.time setSingleLineAutoResizeWithMaxWidth:400];
        
        //状态
        [self.contentView addSubview:self.status];
        self.status.sd_layout
        .rightSpaceToView(self.contentView, 20)
        .centerYEqualToView(self.contentView)
        .autoHeightRatio(0);
        [self.status setSingleLineAutoResizeWithMaxWidth:100];
        
        //课程名
        [self.contentView addSubview:self.lessonName];
        self.lessonName.sd_layout
        .leftEqualToView(self.date)
        .topSpaceToView(self.date, 10)
        .rightSpaceToView(self.status, 10)
        .autoHeightRatio(0);
        
        //菱形图
        _image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self.contentView addSubview:_image];
        _image.sd_layout
        .widthIs(10)
        .heightIs(10)
        .centerYEqualToView(self.lessonName)
        .leftSpaceToView(self.contentView,10);
        
        //教师名
        [self.contentView addSubview:self.teacherName];
        self.teacherName.sd_layout
        .leftEqualToView(self.lessonName)
        .topSpaceToView(self.lessonName, 10)
        .autoHeightRatio(0);
        [self.teacherName setSingleLineAutoResizeWithMaxWidth:300];
    
        
        [self setupAutoHeightWithBottomView:self.teacherName bottomMargin:20];
        
    }
    return self;
}

#pragma mark- SetModel

-(void)setModel:(InteractionLesson *)model{
    
    _model = model;
    
    self.date.text = model.class_date;
    self.time.text = [NSString stringWithFormat:@"%@ - %@",model.start_time,model.end_time];
    self.status.text = [NSString statusSwitchWithStatus:model.status];
    if ([[NSString statusSwitchWithStatus:model.status] isEqualToString:@"已结束"]) {
        self.status.textColor = TITLECOLOR;
    }else{
        self.status.textColor = [UIColor blackColor];
    }
    self.lessonName.text = model.name;
    self.teacherName.text = [NSString stringWithFormat:@"老师：%@",model.teacher.name];
    
}



#pragma mark- GET Method

-(UILabel *)date{
    
    if (!_date) {
        _date = [[UILabel alloc]init];
        _date.font = [UIFont systemFontOfSize:14*ScrenScale];
        _date.textColor = TITLECOLOR;
    }
    return _date;
}

-(UILabel *)time{
    if (!_time) {
        _time = [[UILabel alloc]init];
        _time.font = [UIFont systemFontOfSize:14*ScrenScale];
        _time.textColor = TITLECOLOR;
    }
    return _time;
}
-(UILabel *)lessonName{
    if (!_lessonName) {
        _lessonName = [[UILabel alloc]init];
        _lessonName.font = TEXT_FONTSIZE;
        _lessonName.textColor = [UIColor blackColor];
    }
    return _lessonName;
    
}

-(UILabel *)teacherName{
    if (!_teacherName) {
        _teacherName = [[UILabel alloc]init];
        _teacherName.font = [UIFont systemFontOfSize:14*ScrenScale];
        _teacherName.textColor = TITLECOLOR;
    }
    return _teacherName;
    
}

-(UILabel *)status{
    if (!_status) {
        _status = [[UILabel alloc]init];
        _status.textColor = [UIColor lightGrayColor];
        _status.font = TEXT_FONTSIZE;
    }
    return _status;
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
