//
//  TutoriumInfo_TeacherView.m
//  Qatime_Student
//
//  Created by Shin on 2017/11/10.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "TutoriumInfo_TeacherView.h"
#import "UIImageView+WebCache.h"
#import "NSString+ChangeYearsToChinese.h"
#import "NSString+HTML.h"
#import "NSAttributedString+YYText.h"

@interface TutoriumInfo_TeacherView(){
    
    UITapGestureRecognizer *tapTeacher;
    
}

@end

@implementation TutoriumInfo_TeacherView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor  =[UIColor whiteColor];
        self.contentSize = CGSizeMake(self.width_sd, 100);
        /* 教师头像*/
        _teacherHeadImage = [[UIImageView alloc]init];
        _teacherHeadImage.userInteractionEnabled = YES;
        [self addSubview:_teacherHeadImage];
        
        _teacherHeadImage.sd_layout
        .leftSpaceToView(self,10)
        .topSpaceToView(self,10)
        .widthIs(80)
        .heightEqualToWidth();
        _teacherHeadImage.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
        
        tapTeacher = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTeacher)];
        [_teacherHeadImage addGestureRecognizer:tapTeacher];
        
        //教师名
        _teacherNameLabel = [[UILabel alloc]init];
        _teacherNameLabel.font = TITLEFONTSIZE;
        [self addSubview:_teacherNameLabel];
        _teacherNameLabel.sd_layout
        .leftSpaceToView(_teacherHeadImage,10)
        .centerYEqualToView(_teacherHeadImage)
        .autoHeightRatio(0);
        [_teacherNameLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        /* 性别图标*/
        _genderImage  = [[UIImageView alloc]init];
        [self addSubview:_genderImage];
        _genderImage .sd_layout
        .leftSpaceToView(_teacherNameLabel,10)
        .centerYEqualToView(_teacherNameLabel)
        .heightRatioToView(_teacherNameLabel,0.6)
        .widthEqualToHeight();
        
        /* 所在学校*/
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
        
        /* 执教年数*/
        UILabel *workYears = [[UILabel alloc]init];
        workYears.font = TITLEFONTSIZE;
        [self addSubview:workYears];
        workYears.sd_layout
        .leftEqualToView(schools)
        .topSpaceToView(_workPlaceLabel,20)
        .autoHeightRatio(0);
        [workYears setSingleLineAutoResizeWithMaxWidth:200];
        [workYears setText:@"执教年限"];
        
        _workYearsLabel = [[UILabel alloc]init];
        _workYearsLabel.font = TEXT_FONTSIZE;
        _workYearsLabel.textColor = TITLECOLOR;
        [self addSubview:_workYearsLabel];
        _workYearsLabel.sd_layout
        .leftEqualToView(_workPlaceLabel)
        .topSpaceToView(workYears,10)
        .autoHeightRatio(0);
        [_workYearsLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        
        //目前不做的教师标签
        UILabel *teacherTag = [[UILabel alloc]init];
        teacherTag.font = TITLEFONTSIZE;
        teacherTag.text = @"教师标签";
        [self addSubview:teacherTag];
        teacherTag.sd_layout
        .leftEqualToView(workYears)
        .topSpaceToView(_workYearsLabel,20)
        .autoHeightRatio(0);
        [teacherTag setSingleLineAutoResizeWithMaxWidth:100];
        teacherTag.hidden = YES;
        
        /* 教师简介*/
        _descrip =[[UILabel alloc]init];
        _descrip.font = TITLEFONTSIZE;
        [self addSubview:_descrip];
        _descrip.sd_layout
        .leftEqualToView(workYears)
        .topSpaceToView(_workYearsLabel,20)
        .autoHeightRatio(0);
        [_descrip setSingleLineAutoResizeWithMaxWidth:200];
        _descrip.text = @"自我介绍";
        
        _teacherInterviewLabel =[UILabel new];
        _teacherInterviewLabel.font = TEXT_FONTSIZE;
        _teacherInterviewLabel.textColor = TITLECOLOR;
        _teacherInterviewLabel.isAttributedContent = YES;
        [self addSubview:_teacherInterviewLabel];
        _teacherInterviewLabel.sd_layout
        .leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .topSpaceToView(_descrip,20)
        .autoHeightRatio(0);
        
        [self setupAutoContentSizeWithBottomView:_teacherInterviewLabel bottomMargin:20];
        self.alwaysBounceVertical = YES;
    }
    return self;
}

-(void)setTeacher:(RecommandTeacher *)teacher{
    _teacher = teacher;
    [_teacherHeadImage sd_setImageWithURL:[NSURL URLWithString:teacher.avatar_url]];
    _teacherNameLabel.text = teacher.teacherName;
    if ([teacher.gender isEqualToString:@"male"]) {
        [_genderImage setImage:[UIImage imageNamed:@"男"]];
    }else if ([teacher.gender isEqualToString:@"female"]){
        [_genderImage setImage:[UIImage imageNamed:@"女"]];
    }else{
        [_genderImage setImage:nil];
    }
    _workPlaceLabel.text = teacher.school;
    _workYearsLabel.text = [teacher.teaching_years changeEnglishYearsToChinese];
    //教师简介
    NSMutableAttributedString *attDesc;
    if (teacher.describe) {
        if ([[NSString getPureStringwithHTMLString:teacher.describe]isEqualToString:teacher.describe]) {
            //不包html富文本
            _teacherInterviewLabel.text = teacher.describe;
        }else{
            attDesc = [[NSMutableAttributedString alloc]initWithData:[teacher.describe?[@"" stringByAppendingString:teacher.describe]:@" " dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            if ([attDesc.yy_font.familyName isEqualToString:@"Times New Roman"]&& attDesc.yy_font.pointSize == 12) {
                attDesc.yy_font = [UIFont fontWithName:@".SF UI Text" size:16*ScrenScale];
                attDesc.yy_color = TITLECOLOR;
            }else if ([attDesc.yy_font.familyName isEqualToString:@"Times New Roman"]&&attDesc.yy_font.pointSize != 12){
                attDesc.yy_font = [UIFont fontWithName:@".SF UI Text" size:attDesc.yy_font.pointSize];
                attDesc.yy_color = TITLECOLOR;
            }
            _teacherInterviewLabel.attributedText = attDesc;
        }
    }
    [_teacherInterviewLabel updateLayout];
    
}

- (void)tapTeacher{
    
    [_teacherdelegate tapTeachers];
     
}

@end
