//
//  InfoHeaderView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/15.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "InfoHeaderView.h"

@implementation InfoHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
#pragma mark- view3的辅导班的详情页面
        
        
        /* view3中的课程简介*/
        /* 辅导班概况 的所有label*/
        
        
        /* 课程名*/
        _classNameLabel = [[UILabel alloc]init];
        [self addSubview: _classNameLabel];
        _classNameLabel.sd_layout
        .leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .topSpaceToView(self,10)
        .heightIs(30);
        _classNameLabel.textColor = [UIColor blackColor];
        _classNameLabel.text = @"sdfasdfsdf";
        
        
        
        
        /* 年级*/
        
        _gradeLabel =[[UILabel alloc]init];
        [_gradeLabel setText:@"年级"];
        [self addSubview:_gradeLabel];
        _gradeLabel.sd_layout.leftEqualToView(_classNameLabel).topSpaceToView(_classNameLabel,20).autoHeightRatio(0);
        [_gradeLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
        
        
        
        /* 课时 进度*/
        UILabel *counted =[[UILabel alloc]init];
        [self addSubview:counted];
        counted.sd_layout.leftSpaceToView(self,[UIScreen mainScreen].bounds.size.width/2).topSpaceToView(_classNameLabel,20).autoHeightRatio(0);
        [counted setSingleLineAutoResizeWithMaxWidth:100.0f];
        [counted setText:@"进度"];
        
        _completed_conunt=[[UILabel alloc]init];
        [self addSubview:_completed_conunt];
        _completed_conunt.sd_layout.leftSpaceToView(counted,0).topEqualToView(counted).autoHeightRatio(0);
        [_completed_conunt setSingleLineAutoResizeWithMaxWidth:100.0f];
        [_completed_conunt setText:@"***"];
        
        UILabel *cut=[[UILabel alloc]init];
        [self addSubview:cut];
        cut.sd_layout.leftSpaceToView(_completed_conunt,0).topEqualToView(_completed_conunt).autoHeightRatio(0);
        [cut setSingleLineAutoResizeWithMaxWidth:100.0f];
        [cut setText:@"/"];
        
        
        _classCount=[[UILabel alloc]init];
        [self addSubview:_classCount];
        _classCount.sd_layout.leftSpaceToView(cut,0).topEqualToView(_completed_conunt).autoHeightRatio(0);
        [_classCount setSingleLineAutoResizeWithMaxWidth:100.0f];
        [_classCount setText:@"***"];
        
        
        
        /* 科目*/
        UILabel *subject =[[UILabel alloc]init];
        [self addSubview:subject];
        subject.sd_layout.topSpaceToView(_gradeLabel,20).leftEqualToView(_gradeLabel).autoHeightRatio(0);
        [subject setSingleLineAutoResizeWithMaxWidth:100.0f];
        [subject setText:@"科目"];
        
        _subjectLabel = [[UILabel alloc]init];
        [self addSubview:_subjectLabel];
        _subjectLabel.sd_layout.topEqualToView(subject).leftSpaceToView(subject,20).autoHeightRatio(0);
        [_subjectLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
        [_subjectLabel setText:@"科目"];
        
        
        /* 在线直播*/
        _onlineVideoLabel =[[UILabel alloc]init];
        [self addSubview:_onlineVideoLabel];
        _onlineVideoLabel.sd_layout.leftEqualToView(counted).topEqualToView(subject).autoHeightRatio(0);
        [_onlineVideoLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
        [_onlineVideoLabel setText:@"在线直播"];
        
        
        /* 直播时间*/
        
        _liveStartTimeLabel = [[UILabel alloc]init];
        [self addSubview:_liveStartTimeLabel];
        _liveStartTimeLabel.sd_layout.leftEqualToView(subject).topSpaceToView(subject,20).autoHeightRatio(0);
        [_liveStartTimeLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
        [_liveStartTimeLabel setText:@"2016-11-10"];
        
        UILabel *_to =[[UILabel alloc]init];
        [self addSubview:_to];
        _to.sd_layout.leftSpaceToView(_liveStartTimeLabel,2).topEqualToView(_liveStartTimeLabel).autoHeightRatio(0);
        [_to setSingleLineAutoResizeWithMaxWidth:100.0f];
        [_to setText:@"至"];
        
        _liveEndTimeLabel = [[UILabel alloc]init];
        [self addSubview:_liveEndTimeLabel];
        _liveEndTimeLabel.sd_layout.leftSpaceToView(_to,2).topEqualToView(_liveStartTimeLabel).autoHeightRatio(0);
        [_liveEndTimeLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
        [_liveEndTimeLabel setText:@"2016-11-10"];
        
        
        
        /* 辅导简介*/
        _descriptions=[[UILabel alloc]init];
        [self addSubview:_descriptions];
        _descriptions.sd_layout.leftEqualToView(subject).topSpaceToView(_to,20).autoHeightRatio(0);
        [_descriptions setSingleLineAutoResizeWithMaxWidth:100.0f];
        [_descriptions setText:@"辅导简介"];
        
        _classDescriptionLabel =[[UILabel alloc]init];
        [self addSubview:_classDescriptionLabel];
        _classDescriptionLabel.sd_layout
        .leftEqualToView(_descriptions)
        .topSpaceToView(_descriptions,20)
        .autoHeightRatio(0)
        .rightSpaceToView(self,20);
        _classDescriptionLabel.numberOfLines = 0;
        [_classDescriptionLabel setText:@""];
        
        
        /* 分割线1*/
        UIView *line1 =[[UIView alloc]init];
        line1.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
        [self addSubview:line1];
        
        line1.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(_classDescriptionLabel,10)
        .heightIs(10);
        
        
#pragma mark- view3的下拉view  教师详情页
        
        
        
        /* 教师姓名*/
        _teacherNameLabel =[[UILabel alloc]init];
        _teacherNameLabel.font = [UIFont systemFontOfSize:22*ScrenScale];
        [self addSubview:_teacherNameLabel];
        
        _teacherNameLabel.sd_layout
        .leftSpaceToView(self,20)
        .topSpaceToView(line1,20)
        .autoHeightRatio(0);
        [_teacherNameLabel setSingleLineAutoResizeWithMaxWidth:100];
        _teacherNameLabel.text = @"教师姓名";
        
        
        
        
        
        /* 性别*/
        _genderImage  = [[UIImageView alloc]init];
        [self addSubview:_genderImage];
        
        _genderImage.sd_layout
        .leftSpaceToView(_teacherNameLabel,5)
        .topEqualToView(_teacherNameLabel)
        .heightRatioToView(_teacherNameLabel,0.8f)
        .widthEqualToHeight();
        
        
        /* 教龄*/
        UILabel *teachYear = [[UILabel alloc]init];
        teachYear.textColor = [UIColor blackColor];
        teachYear.text = @"执教年数";
        //        teachYear.font = [UIFont systemFontOfSize:16*ScrenScale];
        [self addSubview:teachYear];
        
        
        teachYear.sd_layout
        .leftEqualToView(_teacherNameLabel)
        .topSpaceToView(_teacherNameLabel,20)
        .autoHeightRatio(0);
        [teachYear setSingleLineAutoResizeWithMaxWidth:100];
        teachYear.text = @"执教年限";
        
        
        _teaching_year= [[UILabel alloc]init];
        //        _teaching_year.font = [UIFont systemFontOfSize:16*ScrenScale];
        [self addSubview:_teaching_year];
        
        
        _teaching_year.sd_layout
        .leftSpaceToView(teachYear,20)
        .topEqualToView(teachYear)
        .autoHeightRatio(0);
        [_teaching_year setSingleLineAutoResizeWithMaxWidth:300];
        
        
        
        UILabel *schools=[[UILabel alloc]init];
        //        schools.font = [UIFont systemFontOfSize:14*ScrenScale];
        schools.textColor = [UIColor blackColor];
        
        
        
        [self addSubview:schools];
        
        
        schools.sd_layout
        .leftEqualToView(teachYear)
        .topSpaceToView(teachYear,20)
        .autoHeightRatio(0);
        [schools setSingleLineAutoResizeWithMaxWidth:300];
        schools.text = @"所在学校" ;
        
        
        /* 教师头像*/
        _teacherHeadImage = [[UIImageView alloc]init];
        [self addSubview:_teacherHeadImage];
        _teacherHeadImage.sd_layout
        .topEqualToView(_teacherNameLabel)
        .rightSpaceToView(self,15)
        .bottomSpaceToView(schools,0)
        .widthEqualToHeight();
        
        
        
        
        
        _workPlace= [[UILabel alloc]init];
        //        _workPlace.font = [UIFont systemFontOfSize:16];
        
        [self addSubview:_workPlace];
        
        _workPlace.sd_layout
        .leftSpaceToView(schools,10)
        .topEqualToView(schools)
        .autoHeightRatio(0);
        [_workPlace setSingleLineAutoResizeWithMaxWidth:300];
        
        
        
        
        /* 自我介绍标题*/
        _selfIntroLabel =[[UILabel alloc]init];
        _selfIntroLabel.text =@"教师简介";
        //        selfIntroLabel.font =[UIFont systemFontOfSize:20];
        
        [self addSubview:_selfIntroLabel];
        
        
        /* 自我介绍*/
        _selfInterview= [[UILabel alloc]init];
        
        [self addSubview:_selfInterview];
        /* 布局*/
        
        
        
        
        //        [_infoScrollView sd_addSubviews:@[_teacherHeadImage,_teacherNameLabel,_genderImage,teachYear,_teaching_year,schools,_workPlace,selfIntroLabel,_selfInterview]];
        //
        
        
        
        
        
        
        
        
        /* 自我介绍部分的布局*/
        
        
        _selfIntroLabel.sd_layout
        .leftEqualToView(schools)
        .topSpaceToView(schools,20)
        .autoHeightRatio(0);
        [_selfIntroLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        
        _selfInterview.sd_layout
        .leftEqualToView(_selfIntroLabel)
        .topSpaceToView(_selfIntroLabel,20)
        .rightSpaceToView(self,20)
        .autoHeightRatio(0);
        _selfInterview .text = @"" ;
        _selfInterview.numberOfLines =0;
        [_selfInterview sizeToFit];
        
        
        
        /* 自动布局参考线*/
        _layoutLine = [[UIView alloc]init];
        _layoutLine.backgroundColor =[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
        [self addSubview:_layoutLine];
        _layoutLine.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(_selfInterview,10)
        .heightIs(10);
        
        
        
        
        
        
        
    }
    return self;
}


@end
