//
//  ListenTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ListenTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface ListenTableViewCell (){
    
  
    
}

@end

@implementation ListenTableViewCell

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
        _content.layer.shadowOffset = CGSizeMake(3, 2);
        _content.layer.shadowRadius = 3;
        _content.layer.shadowOpacity = 0.3;
        
        
        /* 课程图片*/
        _classImage = [[UIImageView alloc]init];
        
        /* 课程名称*/
        
        //        _name = [[UILabel alloc]init];
        _className = [[UILabel alloc]init];
        _className.font = TITLEFONTSIZE;
        
        /* 年级*/
        _grade = [[UILabel alloc]init];
        _grade.textColor = [UIColor grayColor];
        _grade.font = [UIFont systemFontOfSize:14*ScrenScale];
        
        
        /* 科目*/
        _subject = [[UILabel alloc]init];
        _subject.textColor = [UIColor grayColor];
        _subject.font = [UIFont systemFontOfSize:14*ScrenScale];
        
        /* 斜杠*/
        _line = [[UILabel alloc]init];
        _line.tintColor = [UIColor grayColor];
        _line.font = [UIFont systemFontOfSize:14*ScrenScale];
        _line.text = @"/";
        
        /* 教师姓名*/
        _teacherName = [[UILabel alloc]init];
        _teacherName.textColor = [UIColor grayColor];
        _teacherName.font = [UIFont systemFontOfSize:14*ScrenScale];
    
        
        /* 状态*/
        _status = [[UILabel alloc]init];
        _status.textColor = [UIColor whiteColor];
        _status.font = [UIFont systemFontOfSize:14*ScrenScale];
        _status.backgroundColor = [UIColor orangeColor];
        
        
        /* 距离开课时间*/
        _dist = [[UILabel alloc]init];
        [_content addSubview:_dist];
        _dist.textColor = [UIColor blackColor];
        _dist.text = @"距开课";
        _dist.font = TEXT_FONTSIZE;
        
        _dist.sd_layout
        .leftSpaceToView(_classImage,10)
        .bottomSpaceToView(_content,5)
        .autoHeightRatio(0);
        [_dist setSingleLineAutoResizeWithMaxWidth:200];
        
        
        _deadLineLabel = [[UILabel alloc]init];
        _deadLineLabel.textColor = [UIColor grayColor];
        _deadLineLabel.font = [UIFont systemFontOfSize:16*ScrenScale];
        [_content addSubview: _deadLineLabel];
        _deadLineLabel.sd_layout
        .leftSpaceToView(_dist,0)
        .topEqualToView(_dist)
        .bottomEqualToView(_dist);
        [_deadLineLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        /* 天label*/
        _days = [[UILabel alloc]init];
        [_content addSubview:_days];
        _days.text = @"天";
        _days.textColor = [UIColor blackColor];
        _days.font = TEXT_FONTSIZE;
        _days.sd_layout
        .leftSpaceToView(_deadLineLabel,0)
        .topEqualToView(_deadLineLabel)
        .bottomEqualToView(_deadLineLabel);
        [_days setSingleLineAutoResizeWithMaxWidth:200];
        
        
        /* 进度label*/
        _progress = [[UILabel alloc]init];
        _progress.text = @"进度";
        _progress.textColor = [UIColor blackColor];
        _progress.font = TEXT_FONTSIZE;
        
        
        /* 已进行课时*/
        _presentCount = [[UILabel alloc]init];
        _presentCount.textColor = [UIColor blackColor];
        _presentCount.font = TEXT_FONTSIZE;
        
        
        /* 斜杠*/
        _line2 = [[UILabel alloc]init];
        _line2.text = @"/";
        _line2.textColor = [UIColor blackColor];
        _line2.font = TEXT_FONTSIZE;
        
        /* 总课时*/
        _totalCount = [[UILabel alloc]init];
        _totalCount.textColor = [UIColor blackColor];
        _totalCount.font = TEXT_FONTSIZE;
        
        
        /* 结课*/
        _finish = [[UILabel alloc]init];
        _finish.textColor = [UIColor blackColor];
        _finish .text = @"全部课程已完成";
        _finish.font = TEXT_FONTSIZE;
        
        
        
        /* 进入按钮*/
        
        _enterButton  = [[UIButton alloc]init];
        [_enterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _enterButton.layer.borderColor = [UIColor blackColor].CGColor;
        _enterButton.layer.borderWidth = 0.8f;
        _enterButton.titleLabel.font = [UIFont systemFontOfSize:16*ScrenScale];
        [_enterButton setTitle:@"进入" forState:UIControlStateNormal];

        
        /* 所有控件的布局*/
        [_content sd_addSubviews:@[_classImage,_status,_className,_grade,_subject,_line,_teacherName,_progress,_presentCount,_line2,_totalCount,_enterButton,_finish]];
        
        /* 课程图片布局*/
        _classImage.sd_layout
        .topEqualToView(_content)
        .bottomEqualToView(_content)
        .leftEqualToView(_content)
        .autoWidthRatio(16/10.0);
        
        /* 状态label布局*/
        
        _status.sd_layout
        .leftSpaceToView(_classImage,10)
        .topSpaceToView(_content,5)
        .autoHeightRatio(0);
        
        [_status setSingleLineAutoResizeWithMaxWidth:200];
        
        
        
        /* 课程名称布局*/
        
        _className.sd_layout
        .leftSpaceToView(_status,2)
        .topEqualToView(_status)
        .rightSpaceToView(_content,10)
        .bottomEqualToView(_status);
        [_className setMaxNumberOfLinesToShow:1];
        
        
        
        /* 年级布局*/
        _grade .sd_layout
        .leftSpaceToView(_classImage,10)
        .centerYEqualToView(_content)
        .autoHeightRatio(0);
        [_grade setSingleLineAutoResizeWithMaxWidth:100];
        
        /* 科目布局*/
        
        _subject .sd_layout
        .leftSpaceToView(_grade,0)
        .topEqualToView(_grade)
        .heightRatioToView(_grade,1.0f);
        
        [_subject setSingleLineAutoResizeWithMaxWidth:100];
        
        /* 斜杠布局*/
        
        _line.sd_layout
        .leftSpaceToView(_subject,0)
        .heightRatioToView(_subject,1.0f)
        .topEqualToView(_subject);
        [_line setSingleLineAutoResizeWithMaxWidth:100];
        
        
        /* 教师姓名布局*/
        
        _teacherName.sd_layout
        .leftSpaceToView(_line,0)
        .topEqualToView(_line)
        .heightRatioToView(_line,1.0);
        
        [_teacherName setSingleLineAutoResizeWithMaxWidth:100];
        
        
        /* 课程进度布局*/
        _progress.sd_layout
        .leftSpaceToView(_classImage,10)
        .bottomSpaceToView(_content,5)
        .autoHeightRatio(0);
        [_progress setSingleLineAutoResizeWithMaxWidth:100];
        
        _presentCount.sd_layout
        .leftSpaceToView(_progress,0)
        .topEqualToView(_progress)
        .bottomEqualToView(_progress);
        [_presentCount setSingleLineAutoResizeWithMaxWidth:100];
        
        _line2.sd_layout
        .leftSpaceToView(_presentCount,0)
        .topEqualToView(_presentCount)
        .bottomEqualToView(_presentCount);
        [_line2 setSingleLineAutoResizeWithMaxWidth:100];
        
        _totalCount.sd_layout
        .leftSpaceToView(_line2,0)
        .topEqualToView(_line2)
        .bottomEqualToView(_line2);
        [_totalCount setSingleLineAutoResizeWithMaxWidth:100];
        

        
        
        _finish.sd_layout
        .leftSpaceToView(_classImage,10)
        .bottomSpaceToView(_content,5)
        .autoHeightRatio(0);
        [_finish setSingleLineAutoResizeWithMaxWidth:500];

        
        
        /* 进入按钮*/
        _enterButton.sd_layout
        .rightSpaceToView(_content,10)
        .bottomSpaceToView(_content,10)
        .heightIs(20)
        .widthIs(60);
        
        
        
    }
    
    return self;
    
}


- (void)setModel:(MyTutoriumModel *)model{
    
    
    _model = model;
    
    /* model数据对应的空间赋值*/
    [_classImage sd_setImageWithURL:[NSURL URLWithString:model.publicize]];
    
    
    _grade.text = model.grade;
    _subject.text = model.subject;
    _teacherName.text = model.teacher_name;
    _className.text = model.name;
    
    _presentCount.text = model.completed_lesson_count;
    _totalCount.text = model.preset_lesson_count;

    
    /* 计算距开课时间*/
    //创建日期格式化对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    
    //创建了两个日期对象
    /* 视频开始时间*/
    NSDate *startDate=[dateFormatter dateFromString:model.live_start_time];
    
    /* 当前时间*/
    NSDate *nowDate=[NSDate date];
    //取两个日期对象的时间间隔：
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
    
//    NSTimeInterval time=[nowDate timeIntervalSinceDate:startDate];
    NSTimeInterval time = [startDate timeIntervalSinceDate:nowDate];
    
    int days=((int)time)/(3600*24);
    //    int hours=((int)time)%(3600*24)/3600;
    NSString *dateContent=[[NSString alloc] initWithFormat:@"%d",days];
    
    _deadLineLabel.text = dateContent;
    
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
