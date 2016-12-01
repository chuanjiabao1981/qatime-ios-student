//
//  MyClassTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "UnStartClassTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation UnStartClassTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  
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
        _content.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _content.layer.borderWidth = 0.8f;
        
        
        /* 课程图片*/
        _classImage = [[UIImageView alloc]init];
        
        /* 课程名称*/
        
//        _name = [[UILabel alloc]init];
        _className = [[UILabel alloc]init];
        
        /* 年级*/
        _grade = [[UILabel alloc]init];
        _grade.textColor = [UIColor grayColor];
        _grade.font = [UIFont systemFontOfSize:14];
        
        
        /* 科目*/
        _subject = [[UILabel alloc]init];
        _subject.textColor = [UIColor grayColor];
        _subject.font = [UIFont systemFontOfSize:14];
        
        /* 斜杠*/
        UILabel *line = [[UILabel alloc]init];
        line.textColor = [UIColor grayColor];
        line.font = [UIFont systemFontOfSize:14];
        line.text = @"/";
        
        /* 教师姓名*/
        _teacherName = [[UILabel alloc]init];
        _teacherName.textColor = [UIColor grayColor];
        _teacherName.font = [UIFont systemFontOfSize:14];
        
        
       
        
        /* 状态*/
        _status = [[UILabel alloc]init];
        _status.textColor = [UIColor whiteColor];
        _status.font = [UIFont systemFontOfSize:14];
        
        
        
        
        
        
        /* 所有控件的布局*/
        [_content sd_addSubviews:@[_classImage,_status,_className,_grade,_subject,line,_teacherName]];
        
        /* 课程图片布局*/
        _classImage.sd_layout
        .topEqualToView(_content)
        .bottomEqualToView(_content)
        .leftEqualToView(_content)
        .widthEqualToHeight();
        
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
        
        
        
        
        /* 距离开课时间*/
        UILabel *dist = [[UILabel alloc]init];
        [_content addSubview:dist];
        dist.textColor = [UIColor blackColor];
        dist.text = @"距开课";
        
        dist.sd_layout
        .leftSpaceToView(_classImage,10)
        .bottomSpaceToView(_content,5)
        .autoHeightRatio(0);
        [dist setSingleLineAutoResizeWithMaxWidth:200];
        
        
        _deadLineLabel = [[UILabel alloc]init];
        _deadLineLabel.textColor = [UIColor grayColor];
        _deadLineLabel.font = [UIFont systemFontOfSize:16];
        [_content addSubview: _deadLineLabel];
        _deadLineLabel.sd_layout
        .leftSpaceToView(dist,0)
        .topEqualToView(dist)
        .bottomEqualToView(dist);
        [_deadLineLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        /* 天label*/
        UILabel *days = [[UILabel alloc]init];
        [_content addSubview:days];
        days.text = @"天";
        days.textColor = [UIColor blackColor];
        days.sd_layout
        .leftSpaceToView(_deadLineLabel,0)
        .topEqualToView(_deadLineLabel)
        .bottomEqualToView(_deadLineLabel);
        [days setSingleLineAutoResizeWithMaxWidth:200];
        
        
    
        
        
    }
    
    return self;
    
}


- (void)setModel:(MyTutoriumModel *)model{
    
    
    _model = model;
    
    /* model数据对应的空间赋值*/
    [_classImage sd_setImageWithURL:[NSURL URLWithString:model.publicize]];
    
    if (model.is_tasting ==YES) {
        /* 有试听标示*/
        
        NSLog(@"%@",model.camera_pull_stream);
        
        if (model.camera_pull_stream != nil) {
            
            _status.text = @" 试听中 ";
            _status.backgroundColor = [UIColor orangeColor];
            
            
        }else{
            
            _status.text = @" 已试听 ";
            _status.backgroundColor = [UIColor grayColor];
            
        }
        
    }else{
        /* 无试听标示*/
        
        _status.hidden =YES;
        _className.sd_layout
        .leftSpaceToView(_classImage,10)
        .topSpaceToView(_content,10)
        .autoHeightRatio(0)
        .rightSpaceToView(_content,10);
        
    }
    
    
    _grade.text = model.grade;
    _subject.text = model.subject;
    _teacherName.text = model.teacher_name;
    _className.text = model.name;
    
        
    
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
    
    NSTimeInterval time=[nowDate timeIntervalSinceDate:startDate];
    
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
