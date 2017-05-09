//
//  VideoClass_Player_InfoView.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/13.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "VideoClass_Player_InfoView.h"
#import "NSString+ChangeYearsToChinese.h"
#import "UIImageView+WebCache.h"


@implementation VideoClass_Player_InfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentSize = CGSizeMake(self.width_sd, self.height_sd);
        self.showsHorizontalScrollIndicator = NO;
        //课程名
        _className = [[UILabel alloc]init];
        _className.textColor = [UIColor blackColor];
        _className.font = TITLEFONTSIZE;
        _className.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_className];
        _className.sd_layout
        .leftSpaceToView(self, 10)
        .topSpaceToView(self, 20)
        .rightSpaceToView(self, 10)
        .autoHeightRatio(0);
        
        //基本属性
        UILabel *desLabel = [[UILabel alloc]init];
        [self addSubview:desLabel];
        desLabel.textColor = [UIColor blackColor];
        desLabel.text = @"基本属性";
        desLabel.sd_layout
        .leftEqualToView(_className)
        .topSpaceToView(_className,20)
        .autoHeightRatio(0);
        [desLabel setSingleLineAutoResizeWithMaxWidth:100];

        /* 年级*/
        UIImageView *book1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self addSubview:book1];
        
        book1.sd_layout
        .leftEqualToView(desLabel);
        
        _gradeLabel =[[UILabel alloc]init];
        _gradeLabel.font = TEXT_FONTSIZE;
        _gradeLabel.textColor = TITLECOLOR;
        [self addSubview:_gradeLabel];
        _gradeLabel.sd_layout
        .leftSpaceToView(book1,5)
        .topSpaceToView(desLabel,10)
        .autoHeightRatio(0);
        [_gradeLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
        [_gradeLabel updateLayout];
        
        book1.sd_layout
        .heightRatioToView(_gradeLabel,0.6)
        .centerYEqualToView(_gradeLabel)
        .widthEqualToHeight();
        [book1 updateLayout];
        
        /* 科目*/
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
        .bottomEqualToView(_gradeLabel)
        .leftSpaceToView(book2,5);
        [_subjectLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
        
        /* 课时*/
        UIImageView *book3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self addSubview:book3];
        book3.sd_layout
        .leftEqualToView(book1);
        
        _classCount=[[UILabel alloc]init];
        _classCount.font = TEXT_FONTSIZE;
        _classCount.textColor = TITLECOLOR;
        [self addSubview:_classCount];
        _classCount.sd_layout
        .leftEqualToView(_gradeLabel)
        .topSpaceToView(_gradeLabel,10)
        .autoHeightRatio(0);
        [_classCount setSingleLineAutoResizeWithMaxWidth:150];
        
        book3.sd_layout
        .centerYEqualToView(_classCount)
        .heightRatioToView(_classCount,0.6)
        .widthEqualToHeight();
        [book3 updateLayout];
        
        /* 视频时长*/
        UIImageView *clock  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self addSubview:clock];
        clock.sd_layout
        .leftEqualToView(book3);
        
        _liveTimeLabel = [[UILabel alloc]init];
        [self addSubview:_liveTimeLabel];
        _liveTimeLabel.font = TEXT_FONTSIZE;
        _liveTimeLabel.textColor = TITLECOLOR;
        _liveTimeLabel.sd_layout
        .leftEqualToView(_classCount)
        .topSpaceToView(_classCount,10)
        .autoHeightRatio(0);
        [_liveTimeLabel setSingleLineAutoResizeWithMaxWidth:300];
        
        clock.sd_layout
        .centerYEqualToView(_liveTimeLabel)
        .heightRatioToView(_liveTimeLabel,0.6)
        .widthEqualToHeight();
        [clock updateLayout];
        
        //课程目标
        UILabel *taget = [[UILabel alloc]init];
        [self addSubview:taget];
        taget.textColor = [UIColor blackColor];
        taget.font = TITLEFONTSIZE;
        taget.text = @"课程目标";
        taget.sd_layout
        .leftEqualToView(desLabel)
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

        //分割线
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = SEPERATELINECOLOR;
        [self addSubview:line];
        line.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(_suitable, 20)
        .heightIs(10);
        
        //教师信息
        // 教师头像
        _teacherHeadImage = [[UIImageView alloc]init];
        _teacherHeadImage.userInteractionEnabled = YES;
        [self addSubview:_teacherHeadImage];
        
        _teacherHeadImage.sd_layout
        .leftSpaceToView(self,10)
        .topSpaceToView(line,20)
        .widthIs(80)
        .heightEqualToWidth();
        _teacherHeadImage.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
        
        //教师名
        _teacherNameLabel = [[UILabel alloc]init];
        _teacherNameLabel.font = TITLEFONTSIZE;
        [self addSubview:_teacherNameLabel];
        _teacherNameLabel.sd_layout
        .leftSpaceToView(_teacherHeadImage,10)
        .centerYEqualToView(_teacherHeadImage)
        .autoHeightRatio(0);
        [_teacherNameLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        // 性别图标
        _genderImage  = [[UIImageView alloc]init];
        [self addSubview:_genderImage];
        _genderImage .sd_layout
        .leftSpaceToView(_teacherNameLabel,10)
        .centerYEqualToView(_teacherNameLabel)
        .heightRatioToView(_teacherNameLabel,0.6)
        .widthEqualToHeight();
        
        // 所在学校
        UILabel *schools =[[UILabel alloc]init];
        schools.font = TITLEFONTSIZE;
        [self addSubview:schools];
        schools.sd_layout
        .leftEqualToView(_teacherHeadImage)
        .topSpaceToView(_teacherHeadImage,20)
        .autoHeightRatio(0);
        [schools setSingleLineAutoResizeWithMaxWidth:200];
        [schools setText:@"所在学校"];
        
        _workPlaceLabel =[[UILabel alloc]init];
        _workPlaceLabel.font = TEXT_FONTSIZE;
        _workPlaceLabel.textColor = TITLECOLOR;
        
        [self addSubview:_workPlaceLabel];
        _workPlaceLabel.sd_layout
        .leftSpaceToView(self,20)
        .topSpaceToView(schools,10)
        .autoHeightRatio(0);
        [_workPlaceLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        // 执教年数
        UILabel *workYears = [[UILabel alloc]init];
        workYears.font = TITLEFONTSIZE;
        [self addSubview:workYears];
        workYears.sd_layout
        .leftEqualToView(schools)
        .topSpaceToView(_workPlaceLabel,20)
        .autoHeightRatio(0);
        [workYears setSingleLineAutoResizeWithMaxWidth:200];
        [workYears setText:@"执教年龄"];
        
        _workYearsLabel = [[UILabel alloc]init];
        _workYearsLabel.font = TEXT_FONTSIZE;
        _workYearsLabel.textColor = TITLECOLOR;
        [self addSubview:_workYearsLabel];
        _workYearsLabel.sd_layout
        .leftEqualToView(_workPlaceLabel)
        .topSpaceToView(workYears,10)
        .autoHeightRatio(0);
        [_workYearsLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        
        // 教师简介
        UILabel *descrip =[[UILabel alloc]init];
        descrip.font = TITLEFONTSIZE;
        [self addSubview:descrip];
        descrip.sd_layout
        .leftEqualToView(workYears)
        .topSpaceToView(_workYearsLabel,20)
        .autoHeightRatio(0);
        [descrip setSingleLineAutoResizeWithMaxWidth:200];
        descrip.text = @"自我介绍";
        
        _teacherInterviewLabel =[UILabel new];
        _teacherInterviewLabel.font = TEXT_FONTSIZE;
        _teacherInterviewLabel.textColor = TITLECOLOR;
        _teacherInterviewLabel.isAttributedContent = YES;
        [self addSubview:_teacherInterviewLabel];
        _teacherInterviewLabel.sd_layout
        .leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .topSpaceToView(descrip,20)
        .autoHeightRatio(0);
        
        [self setupAutoHeightWithBottomView:_teacherInterviewLabel bottomMargin:20];
        
    }
    return self;
}

-(void)setModel:(VideoClassInfo *)model{
    
    _model = model;
    
    _className.text = model.name;
    _gradeLabel.text = model.grade;
    _subjectLabel.text = model.subject;
    _classCount.text = model.video_lessons_count;
    _liveTimeLabel.text = [NSString stringWithFormat:@"视频总长:%@",model.total_duration];
    _classTarget.text = model.objective;
    _suitable.text = model.suit_crowd;
    
    [_teacherHeadImage sd_setImageWithURL:[NSURL URLWithString:model.teacher[@"avatar_url"]]];
    _teacherNameLabel.text = model.teacher[@"name"];
    
    if ([model.teacher[@"gender"]isEqualToString:@"male"]) {
        [_genderImage setImage:[UIImage imageNamed:@"男"]];
        
    }else if ([model.teacher[@"gender"]isEqualToString:@"female"]){
        
        [_genderImage setImage:[UIImage imageNamed:@"女"]];
    }
    _workPlaceLabel.text = model.teacher[@"school"];
    _workYearsLabel.text = [model.teacher[@"teaching_years"] changeEnglishYearsToChinese];
    _teacherInterviewLabel.attributedText = [[NSMutableAttributedString alloc]initWithData:[model.teacher[@"desc"] dataUsingEncoding:NSUnicodeStringEncoding ] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    [_teacherHeadImage sd_setImageWithURL:[NSURL URLWithString:model.teacher[@""]]];
    
}


@end
