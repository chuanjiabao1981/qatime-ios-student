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
    
    UILabel *line;
    UILabel *line2;
    UILabel *days;
    UILabel *progress;
    UILabel *dist;
    
}

@end

@implementation ListenTableViewCell

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
        line = [[UILabel alloc]init];
        line.tintColor = [UIColor grayColor];
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
        
        
        
        
        /* 距离开课时间*/
        dist = [[UILabel alloc]init];
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
        days = [[UILabel alloc]init];
        [_content addSubview:days];
        days.text = @"天";
        days.textColor = [UIColor blackColor];
        days.sd_layout
        .leftSpaceToView(_deadLineLabel,0)
        .topEqualToView(_deadLineLabel)
        .bottomEqualToView(_deadLineLabel);
        [days setSingleLineAutoResizeWithMaxWidth:200];
        
        
        /* 进度label*/
        progress = [[UILabel alloc]init];
        progress.text = @"进度";
        progress.textColor = [UIColor blackColor];
        
        
        /* 已进行课时*/
        _presentCount = [[UILabel alloc]init];
        _presentCount.textColor = [UIColor blackColor];
        
        
        /* 斜杠*/
        line2 = [[UILabel alloc]init];
        line2.text = @"/";
        line2.textColor = [UIColor blackColor];
        
        /* 总课时*/
        _totalCount = [[UILabel alloc]init];
        _totalCount.textColor = [UIColor blackColor];
        
        
        /* 结课*/
        _finish = [[UILabel alloc]init];
        _finish.textColor = [UIColor blackColor];
        _finish .text = @"全部课程已完成";
        
        
        
        /* 进入按钮*/
        
        _enterButton  = [[UIButton alloc]init];
        [_enterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _enterButton.layer.borderColor = [UIColor blackColor].CGColor;
        _enterButton.layer.borderWidth = 0.8f;
        _enterButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_enterButton setTitle:@"进入" forState:UIControlStateNormal];

        
        
        
        
        /* 所有控件的布局*/
        [_content sd_addSubviews:@[_classImage,_status,_className,_grade,_subject,line,_teacherName,progress,_presentCount,line2,_totalCount,_enterButton,_finish]];
        
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
        
        
        
       

        
        
        /* 课程进度布局*/
        progress.sd_layout
        .leftSpaceToView(_classImage,10)
        .bottomSpaceToView(_content,5)
        .autoHeightRatio(0);
        [progress setSingleLineAutoResizeWithMaxWidth:100];
        
        _presentCount.sd_layout
        .leftSpaceToView(progress,0)
        .topEqualToView(progress)
        .bottomEqualToView(progress);
        [_presentCount setSingleLineAutoResizeWithMaxWidth:100];
        
        line2.sd_layout
        .leftSpaceToView(_presentCount,0)
        .topEqualToView(_presentCount)
        .bottomEqualToView(_presentCount);
        [line2 setSingleLineAutoResizeWithMaxWidth:100];
        
        _totalCount.sd_layout
        .leftSpaceToView(line2,0)
        .topEqualToView(line2)
        .bottomEqualToView(line2);
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
    
    
    
    if ([model.status isEqualToString:@"published"]) {
        
        dist.hidden = NO;
        _deadLineLabel.hidden =NO;
        days.hidden =NO;
        
        progress.hidden =YES;
        line2.hidden = YES;
        _presentCount.hidden =YES;
        _totalCount.hidden =YES;
        
        _finish.hidden =YES;
        
        
    }
   else if ([model.status isEqualToString:@"teaching"]) {
        
        dist.hidden = YES;
        _deadLineLabel.hidden =YES;
        days.hidden = YES;
        
        progress.hidden =NO;
        line2.hidden = NO;
        _presentCount.hidden = NO;
        _totalCount.hidden = NO;
        
        _finish.hidden =YES;
        
        
    }
    else if ([model.status isEqualToString:@"completed"]) {
        
        
        dist.hidden = YES;
        _deadLineLabel.hidden = YES;
        days.hidden = YES;
        
        progress.hidden = YES;
        line2.hidden = YES;
        _presentCount.hidden = YES;
        _totalCount.hidden = YES;
        
        _finish.hidden = NO;
        
        _enterButton.hidden = YES;
        
    }
    
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
