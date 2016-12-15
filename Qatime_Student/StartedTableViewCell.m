//
//  StartedTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "StartedTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation StartedTableViewCell

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
        
        
        /* 进度label*/
        UILabel *progress = [[UILabel alloc]init];
        progress.text = @"进度";
        progress.textColor = [UIColor blackColor];
        
        
        /* 已进行课时*/
        _presentCount = [[UILabel alloc]init];
        _presentCount.textColor = [UIColor blackColor];
        
        
        /* 斜杠*/
        UILabel *line2 = [[UILabel alloc]init];
        line2.text = @"/";
        line2.textColor = [UIColor blackColor];
        
        /* 总课时*/
        _totalCount = [[UILabel alloc]init];
        _totalCount.textColor = [UIColor blackColor];
        
        
        /* 进入按钮*/
        
        _enterButton  = [[UIButton alloc]init];
        [_enterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _enterButton.layer.borderColor = [UIColor blackColor].CGColor;
        _enterButton.layer.borderWidth = 0.8f;
        _enterButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_enterButton setTitle:@"进入" forState:UIControlStateNormal];
        
        
        
        
        /* 所有控件的布局*/
        [_content sd_addSubviews:@[_classImage,_status,_className,_grade,_subject,line,_teacherName,progress,_presentCount,line2,_totalCount,_enterButton]];
        
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
            
            [_enterButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _enterButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
            
        }
        
    }else{
        /* 无试听标示*/
        
        _status.hidden =YES;
        _className.sd_layout
        .leftSpaceToView(_classImage,10)
        .topSpaceToView(_content,10)
        .autoHeightRatio(0)
        .rightSpaceToView(_content,10);
        
        [_enterButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _enterButton.layer.borderColor = [UIColor lightGrayColor].CGColor;

        
    }
    
    
    _grade.text = model.grade;
    _subject.text = model.subject;
    _teacherName.text = model.teacher_name;
    _className.text = model.name;
    
    _presentCount.text = model.completed_lesson_count;
    _totalCount.text = model.preset_lesson_count;


    
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