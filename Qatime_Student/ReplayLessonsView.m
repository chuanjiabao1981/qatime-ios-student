//
//  ReplayLessonsView.m
//  Qatime_Student
//
//  Created by Shin on 2017/6/22.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ReplayLessonsView.h"
#import "UIImageView+WebCache.h"

@implementation ReplayLessonsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        //课程名
        _name = [[UILabel alloc]init];
        [self addSubview:_name];
        _name.font = TITLEFONTSIZE;
        _name.textColor = [UIColor blackColor];
        _name.sd_layout
        .leftSpaceToView(self,10*ScrenScale)
        .topSpaceToView(self, 10*ScrenScale)
        .autoHeightRatio(0)
        .rightSpaceToView(self, 10*ScrenScale);
        
        //分割线
        UIView *line = [[UIView alloc]init];
        [self addSubview: line];
        line.backgroundColor = SEPERATELINECOLOR_2;
        line.sd_layout
        .leftSpaceToView(self, 10*ScrenScale)
        .topSpaceToView(_name, 10*ScrenScale)
        .rightSpaceToView(self, 10*ScrenScale)
        .heightIs(0.5);
        
        //年级科目
        UILabel *gradeAndSubject = [[UILabel alloc]init];
        [self addSubview:gradeAndSubject];
        gradeAndSubject.text = @"年级科目:";
        gradeAndSubject.font = TEXT_FONTSIZE;
        gradeAndSubject.textColor = TITLECOLOR;
        gradeAndSubject.sd_layout
        .leftEqualToView(_name)
        .topSpaceToView(line, 10*ScrenScale)
        .autoHeightRatio(0);
        [gradeAndSubject setSingleLineAutoResizeWithMaxWidth:200];
        
        _gradeAndSubject = [[UILabel alloc]init];
        [self addSubview:_gradeAndSubject];
        _gradeAndSubject.font = TEXT_FONTSIZE;
        _gradeAndSubject.textColor = TITLECOLOR;
        _gradeAndSubject.sd_layout
        .leftSpaceToView(gradeAndSubject, 15*ScrenScale)
        .topEqualToView(gradeAndSubject)
        .autoHeightRatio(0);
        [_gradeAndSubject setSingleLineAutoResizeWithMaxWidth:200];
        
        
        //授课老师
        UILabel *teacher = [[UILabel alloc]init];
        [self addSubview:teacher];
        teacher.text = @"授课教师:";
        teacher.font = TEXT_FONTSIZE;
        teacher.textColor = TITLECOLOR;
        teacher.sd_layout
        .leftEqualToView(_name)
        .topSpaceToView(gradeAndSubject, 10*ScrenScale)
        .autoHeightRatio(0);
        [teacher setSingleLineAutoResizeWithMaxWidth:200];
        
        //教师头像
        _teacherHeaderImage = [[UIImageView alloc]init];
        [self addSubview:_teacherHeaderImage];
        _teacherHeaderImage.sd_layout
        .leftEqualToView(_gradeAndSubject)
        .topEqualToView(teacher)
        .heightRatioToView(teacher, 1.0)
        .widthEqualToHeight();
        _teacherHeaderImage.sd_cornerRadiusFromHeightRatio = @0.5;
        
        //教师名
        _teacherName = [[UILabel alloc]init];
        [self addSubview:_teacherName];
        _teacherName.font = TEXT_FONTSIZE;
        _teacherName.textColor = TITLECOLOR;
        _teacherName.sd_layout
        .leftSpaceToView(_teacherHeaderImage, 5*ScrenScale)
        .topEqualToView(teacher)
        .autoHeightRatio(0);
        [_teacherName setSingleLineAutoResizeWithMaxWidth:200];
        
        //性别
        _teacherGenderImage = [[UIImageView alloc]init];
        [self addSubview:_teacherGenderImage];
        _teacherGenderImage.sd_layout
        .centerYEqualToView(_teacherName)
        .leftSpaceToView(_teacherName, 5*ScrenScale)
        .heightRatioToView(_teacherName, 0.6)
        .widthEqualToHeight();
    
        
        //视频时长
        UILabel *duaring = [[UILabel alloc]init];
        [self addSubview:duaring];
        duaring.text = @"视频时长:";
        duaring.font = TEXT_FONTSIZE;
        duaring.textColor = TITLECOLOR;
        duaring.sd_layout
        .leftEqualToView(_name)
        .topSpaceToView(teacher, 10*ScrenScale)
        .autoHeightRatio(0);
        [duaring setSingleLineAutoResizeWithMaxWidth:200];
        
        _duration = [[UILabel alloc]init];
        [self addSubview:_duration];
        _duration.font = TEXT_FONTSIZE;
        _duration.textColor = TITLECOLOR;
        _duration.sd_layout
        .leftSpaceToView(duaring, 15*ScrenScale)
        .topEqualToView(duaring)
        .autoHeightRatio(0);
        [_duration setSingleLineAutoResizeWithMaxWidth:200];
        
        
        //回访次数
        UILabel *times = [[UILabel alloc]init];
        [self addSubview:times];
        times.text = @"回访次数:";
        times.font = TEXT_FONTSIZE;
        times.textColor = TITLECOLOR;
        times.sd_layout
        .leftEqualToView(_name)
        .topSpaceToView(duaring, 10*ScrenScale)
        .autoHeightRatio(0);
        [times setSingleLineAutoResizeWithMaxWidth:200];
        
        _replayTimes = [[UILabel alloc]init];
        [self addSubview:_replayTimes];
        _replayTimes.font = TEXT_FONTSIZE;
        _replayTimes.textColor = TITLECOLOR;
        _replayTimes.sd_layout
        .leftSpaceToView(times, 15*ScrenScale)
        .topEqualToView(times)
        .autoHeightRatio(0);
        [_replayTimes setSingleLineAutoResizeWithMaxWidth:200];
        
    }
    return self;
}

- (void)setModel:(ReplayLessonInfo *)model{
    
    _model = model;
    
    _name.text = model.live_studio_lesson.name;
    _gradeAndSubject.text = [model.grade stringByAppendingString:model.subject];
    [_teacherHeaderImage sd_setImageWithURL:[NSURL URLWithString:model.teacher.avatar_url]];
    _teacherName.text = model.teacher.name;
    
    if ([model.teacher.gender isEqualToString:@"male"]) {
        [_teacherGenderImage setImage:[UIImage imageNamed:@"男"]];
    }else if ([model.teacher.gender isEqualToString:@"female"]){
        [_teacherGenderImage setImage:[UIImage imageNamed:@"女"]];
    }
    
    _duration.text = [self timeFormatted:model.video_duration.intValue];
    _replayTimes.text = model.replay_times;
    
}


//转换成时分秒

- (NSString *)timeFormatted:(int)totalSeconds{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    if (hours > 0) {
        
        return [NSString stringWithFormat:@"%02d小时%02d分%02d秒",hours, minutes, seconds];
    }else{
        return [NSString stringWithFormat:@"%02d分%02d秒", minutes, seconds];
    }
}



@end
