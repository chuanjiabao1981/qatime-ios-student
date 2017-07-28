//
//  ExclusivePlayerInfoView.m
//  Qatime_Student
//
//  Created by Shin on 2017/7/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ExclusivePlayerInfoView.h"
#import "NSString+ChangeYearsToChinese.h"
#import "NSString+TimeStamp.h"

@implementation ExclusivePlayerInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /* 课程名*/
        _classNameLabel = [[UILabel alloc]init];
        _classNameLabel.font = TITLEFONTSIZE;
        [self addSubview: _classNameLabel];
        _classNameLabel.sd_layout
        .leftSpaceToView(self,10)
        .rightSpaceToView(self,20)
        .topSpaceToView(self,20)
        .autoHeightRatio(0);
        
        //基本属性
        UILabel *info = [[UILabel alloc]init];
        [self addSubview:info];
        info.font = TITLEFONTSIZE;
        info.text = @"基本属性";
        info.sd_layout
        .leftSpaceToView(self,10)
        .topSpaceToView(_classNameLabel,20)
        .autoHeightRatio(0);
        [info setSingleLineAutoResizeWithMaxWidth:100];
        
        /* 年级*/
        UIImageView *book1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self addSubview:book1];
        book1.sd_layout
        .leftEqualToView(info);
        
        _gradeLabel =[[UILabel alloc]init];
        _gradeLabel.font = TEXT_FONTSIZE;
        _gradeLabel.textColor = TITLECOLOR;
        [self addSubview:_gradeLabel];
        _gradeLabel.sd_layout
        .leftSpaceToView(book1,5)
        .topSpaceToView(info,10)
        .autoHeightRatio(0);
        [_gradeLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
        
        book1.sd_layout
        .heightRatioToView(_gradeLabel,0.6)
        .centerYEqualToView(_gradeLabel)
        .widthEqualToHeight();
        [book1 updateLayout];
        
        /**科目*/
        UIImageView *book2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self addSubview:book2];
        book2.sd_layout
        .centerXEqualToView(self)
        .topEqualToView(book1)
        .bottomEqualToView(book1)
        .widthEqualToHeight();
        
        _subjectLabel = [[UILabel alloc]init];
        _subjectLabel.font = TEXT_FONTSIZE;
        _subjectLabel.textColor = TITLECOLOR;
        [self addSubview:_subjectLabel];
        _subjectLabel.sd_layout
        .topEqualToView(_gradeLabel)
        .leftSpaceToView(book2,5)
        .autoHeightRatio(0);
        [_subjectLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
        
        /* 课时 进度*/
        _classCount=[[UILabel alloc]init];
        _classCount.font = TEXT_FONTSIZE;
        _classCount.textColor = TITLECOLOR;
        [self addSubview:_classCount];
        _classCount.sd_layout
        .leftEqualToView(_gradeLabel)
        .topSpaceToView(_gradeLabel,10)
        .autoHeightRatio(0);
        [_classCount setSingleLineAutoResizeWithMaxWidth:200];
        
        UIImageView *book3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self addSubview:book3];
        book3.sd_layout
        .leftEqualToView(book1)
        .rightEqualToView(book1)
        .widthRatioToView(book1,1.0)
        .centerYEqualToView(_classCount)
        .heightRatioToView(book1,1.0);
        
        /* 直播时间*/
        _liveTimeLabel = [[UILabel alloc]init];
        _liveTimeLabel.font = TEXT_FONTSIZE;
        _liveTimeLabel.textColor =TITLECOLOR;
        [self addSubview:_liveTimeLabel];
        _liveTimeLabel.sd_layout
        .leftEqualToView(_classCount)
        .topSpaceToView(_classCount,10)
        .autoHeightRatio(0);
        [_liveTimeLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        UIImageView *image4  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self addSubview:image4];
        image4.sd_layout
        .leftEqualToView(book3)
        .rightEqualToView(book3)
        .heightRatioToView(book3,1.0)
        .centerYEqualToView(_liveTimeLabel)
        .widthRatioToView(book3,1.0);
        
        //课程目标
        UILabel *taget = [[UILabel alloc]init];
        [self addSubview:taget];
        taget.textColor = [UIColor blackColor];
        taget.font = TITLEFONTSIZE;
        taget.text = @"课程目标";
        taget.sd_layout
        .leftEqualToView(info)
        .topSpaceToView(_liveTimeLabel,20)
        .autoHeightRatio(0);
        [taget setSingleLineAutoResizeWithMaxWidth:100];
        
        _classTarget = [[UILabel alloc]init];
        [self addSubview:_classTarget];
        _classTarget.font = TEXT_FONTSIZE;
        _classTarget.textColor = TITLECOLOR;
        
        _classTarget.sd_layout
        .topSpaceToView(taget,10)
        .leftEqualToView(taget)
        .rightSpaceToView(self,20)
        .autoHeightRatio(0);
        
        //适合人群
        UILabel *suit = [[UILabel alloc]init];
        [self addSubview:suit];
        suit.font = TITLEFONTSIZE;
        suit.textColor = [UIColor blackColor];
        suit.text = @"适合人群";
        suit.sd_layout
        .leftEqualToView(taget)
        .topSpaceToView(_classTarget,20)
        .autoHeightRatio(0);
        [suit setSingleLineAutoResizeWithMaxWidth:100];
        
        _suitable = [[UILabel alloc]init];
        _suitable.font = TEXT_FONTSIZE;
        _suitable.textColor = TITLECOLOR;
        _suitable.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_suitable];
        _suitable.sd_layout
        .leftEqualToView(suit)
        .topSpaceToView(suit,10)
        .autoHeightRatio(0)
        .rightSpaceToView(self,20);
        
        
        /* 辅导简介*/
        _descriptions=[[UILabel alloc]init];
        _descriptions.font = TITLEFONTSIZE;
        [_descriptions setText:@"辅导简介"];
        [self addSubview:_descriptions];
        _descriptions.sd_layout
        .leftEqualToView(info)
        .topSpaceToView(_suitable,20)
        .autoHeightRatio(0);
        [_descriptions setSingleLineAutoResizeWithMaxWidth:100];
        
        _classDescriptionLabel =[[UILabel alloc]init];
        _classDescriptionLabel.font = TITLEFONTSIZE;
        _classDescriptionLabel.isAttributedContent = YES;
        [self addSubview:_classDescriptionLabel];
        _classDescriptionLabel.sd_layout
        .leftEqualToView(_descriptions)
        .topSpaceToView(_descriptions,10)
        .autoHeightRatio(0)
        .rightSpaceToView(self,20);
        
        /* 分割线1*/
        UIView *line1 =[[UIView alloc]init];
        line1.backgroundColor = SEPERATELINECOLOR;
        [self addSubview:line1];
        
        line1.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(_classDescriptionLabel,20)
        .heightIs(10);
        
#pragma mark- view3的下拉view  教师详情页
        
        /* 教师头像*/
        _teacherHeadImage = [[UIImageView alloc]init];
        [self addSubview:_teacherHeadImage];
        _teacherHeadImage.sd_layout
        .topSpaceToView(line1,10)
        .leftSpaceToView(self,10)
        .heightIs(60)
        .widthEqualToHeight();
        _teacherHeadImage.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
        
        /* 教师姓名*/
        _teacherNameLabel =[[UILabel alloc]init];
        _teacherNameLabel.font = TITLEFONTSIZE;
        _teacherNameLabel.textColor = TITLECOLOR;
        [self addSubview:_teacherNameLabel];
        
        _teacherNameLabel.sd_layout
        .leftSpaceToView(_teacherHeadImage,10)
        .centerYEqualToView(_teacherHeadImage)
        .autoHeightRatio(0);
        [_teacherNameLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        /* 性别*/
        _genderImage  = [[UIImageView alloc]init];
        [self addSubview:_genderImage];
        
        _genderImage.sd_layout
        .leftSpaceToView(_teacherNameLabel,5)
        .centerYEqualToView(_teacherNameLabel)
        .heightRatioToView(_teacherNameLabel,0.6f)
        .widthEqualToHeight();
        
        //所在学校
        UILabel *school = [[UILabel alloc]init];
        [self addSubview:school];
        school.font = TITLEFONTSIZE;
        school.text = @"所在学校";
        school.sd_layout
        .topSpaceToView(_teacherHeadImage,20)
        .leftEqualToView(_descriptions)
        .autoHeightRatio(0);
        [school setSingleLineAutoResizeWithMaxWidth:100];
        
        _workPlace= [[UILabel alloc]init];
        _workPlace.font = TEXT_FONTSIZE;
        _workPlace.textColor = TITLECOLOR;
        [self addSubview:_workPlace];
        _workPlace.sd_layout
        .leftEqualToView(school)
        .topSpaceToView(school,10)
        .autoHeightRatio(0);
        [_workPlace setSingleLineAutoResizeWithMaxWidth:300];
        
        /* 教龄*/
        UILabel *teachYear = [[UILabel alloc]init];
        teachYear.font = TITLEFONTSIZE;
        teachYear.text = @"执教年数";
        [self addSubview:teachYear];
        
        teachYear.sd_layout
        .leftEqualToView(school)
        .topSpaceToView(_workPlace,20)
        .autoHeightRatio(0);
        [teachYear setSingleLineAutoResizeWithMaxWidth:100];
        
        _teaching_year= [[UILabel alloc]init];
        _teaching_year.font = TEXT_FONTSIZE;
        _teaching_year.textColor = TITLECOLOR;
        [self addSubview:_teaching_year];
        
        _teaching_year.sd_layout
        .leftEqualToView(teachYear)
        .topSpaceToView(teachYear,10)
        .autoHeightRatio(0);
        [_teaching_year setSingleLineAutoResizeWithMaxWidth:300];
        
        
        /* 自我介绍标题*/
        _selfIntroLabel =[[UILabel alloc]init];
        _selfIntroLabel.font = TITLEFONTSIZE;
        _selfIntroLabel.text =@"自我介绍";
        [self addSubview:_selfIntroLabel];
        
        _selfIntroLabel.sd_layout
        .leftEqualToView(teachYear)
        .topSpaceToView(_teaching_year,20)
        .autoHeightRatio(0);
        [_selfIntroLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        /* 自我介绍*/
        _selfInterview= [[UILabel alloc]init];
        _selfInterview.font = TEXT_FONTSIZE;
        _selfInterview.textColor = TITLECOLOR;
        _selfInterview.isAttributedContent = YES;
        [self addSubview:_selfInterview];
        
        _selfInterview.sd_layout
        .leftEqualToView(_selfIntroLabel)
        .rightSpaceToView(self,20)
        .topSpaceToView(_selfIntroLabel,10)
        .autoHeightRatio(0);
        
        /* 自动布局参考线*/
        _layoutLine = [[UIView alloc]init];
        _layoutLine.backgroundColor =[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
        [self addSubview:_layoutLine];
        _layoutLine.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(_selfInterview,20)
        .heightIs(10);
        
        [self setupAutoHeightWithBottomView:_layoutLine bottomMargin:0];
        
    }
    return self;
}

-(void)setModel:(ExclusiveInfo *)model{
    
    _model = model;
    
    _classNameLabel.text = model.name;
    _gradeLabel.text = model.grade;
    _subjectLabel.text = model.subject;
    _classCount.text = [NSString stringWithFormat:@"共%@课",model.events_count];
    
    _liveTimeLabel.text = [NSString stringWithFormat:@"%@ 至 %@",[[model.start_at changeTimeStampToDateString] substringToIndex:10],[[model.end_at changeTimeStampToDateString] substringToIndex:10]];
    _classTarget.text = model.objective;
    _suitable.text = model.suit_crowd;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithData:[model.descriptions dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    _classDescriptionLabel.attributedText = str;
    
    [_teacherHeadImage sd_setImageWithURL:[NSURL URLWithString:model.teacher.avatar_url] placeholderImage:[UIImage imageNamed:@"人"]];
    _teacherNameLabel.text = model.teacher_name;
    
    if ([model.teacher.gender isEqualToString:@"male"]) {
        [_genderImage setImage:[UIImage imageNamed:@"男"]];
    }else if ([model.teacher.gender isEqualToString:@"female"]){
        [_genderImage setImage:[UIImage imageNamed:@"女"]];
    }
    _workPlace.text =model.teacher.school_name;
    _teaching_year.text = [model.teacher.teaching_years changeEnglishYearsToChinese];
    
    NSMutableAttributedString *strs = [[NSMutableAttributedString alloc]initWithData:[model.teacher.desc dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    _descriptions.attributedText = strs;
    
}


@end
