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
        
        //教师头像
        _teacherHeaderImage = [[UIImageView alloc]init];
        [self addSubview:_teacherHeaderImage];
        _teacherHeaderImage.sd_layout
        .leftEqualToView(_gradeAndSubject)
        .topSpaceToView(line, 10*ScrenScale)
        .leftEqualToView(line)
        .heightIs(60*ScrenScale)
        .widthEqualToHeight();
        _teacherHeaderImage.sd_cornerRadiusFromHeightRatio = @0.5;
        
        //教师名
        _teacherName = [[UILabel alloc]init];
        [self addSubview:_teacherName];
        _teacherName.font = TEXT_FONTSIZE;
        _teacherName.textColor = TITLECOLOR;
        _teacherName.sd_layout
        .centerYEqualToView(_teacherHeaderImage)
        .leftSpaceToView(_teacherHeaderImage, 10)
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
        
        //箭头子
        UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightArrow"]];
        [self addSubview:arrow];
        arrow.sd_layout
        .rightSpaceToView(self, 10)
        .centerYEqualToView(_teacherGenderImage)
        .heightRatioToView(_teacherGenderImage, 0.8)
        .widthEqualToHeight();
        
        //分割线
        UIView *line2 = [[UIView alloc]init];
        [self addSubview:line2];
        line2.backgroundColor = SEPERATELINECOLOR_2;
        line2.sd_layout
        .leftSpaceToView(self, 10*ScrenScale)
        .topSpaceToView(_teacherHeaderImage, 10*ScrenScale)
        .rightSpaceToView(self, 10*ScrenScale)
        .heightIs(0.5);
        
        
        //俩分割线中间贴个图,加个手势
        _teachersInfo = [[UIView alloc]init];
        [self addSubview:_teachersInfo];
        _teachersInfo.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topEqualToView(line)
        .bottomEqualToView(line2);
        _teachersInfo.userInteractionEnabled = YES ;
        
        //年级科目
        UILabel *gradeAndSubject = [[UILabel alloc]init];
        [self addSubview:gradeAndSubject];
        gradeAndSubject.text = @"年级科目:";
        gradeAndSubject.font = TEXT_FONTSIZE;
        gradeAndSubject.textColor = TITLECOLOR;
        gradeAndSubject.sd_layout
        .leftEqualToView(_name)
        .topSpaceToView(line2, 10*ScrenScale)
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

        //视频时长
        UILabel *duaring = [[UILabel alloc]init];
        [self addSubview:duaring];
        duaring.text = @"视频时长:";
        duaring.font = TEXT_FONTSIZE;
        duaring.textColor = TITLECOLOR;
        duaring.sd_layout
        .leftEqualToView(_name)
        .topSpaceToView(gradeAndSubject, 10*ScrenScale)
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
