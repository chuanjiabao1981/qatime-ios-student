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
#import "UIImage+Color.h"

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
        .leftSpaceToView(self,15*ScrenScale)
        .topSpaceToView(self,15*ScrenScale)
        .widthIs(80)
        .heightEqualToWidth();
        _teacherHeadImage.sd_cornerRadiusFromHeightRatio = @0.5;
        _teacherHeadImage.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        _teacherHeadImage.layer.borderWidth = 0.5;
        
//        tapTeacher = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTeacher)];
//        [_teacherHeadImage addGestureRecognizer:tapTeacher];
        
        //教师名
        _teacherNameLabel = [[UILabel alloc]init];
        _teacherNameLabel.font = TITLEFONTSIZE;
        [self addSubview:_teacherNameLabel];
        _teacherNameLabel.sd_layout
        .leftSpaceToView(_teacherHeadImage, 15*ScrenScale)
        .topEqualToView(_teacherHeadImage)
        .autoHeightRatio(0);
        [_teacherNameLabel setSingleLineAutoResizeWithMaxWidth:400];
        
        /* 性别图标*/
        _genderImage  = [[UIImageView alloc]init];
        [self addSubview:_genderImage];
        _genderImage.sd_layout
        .leftSpaceToView(_teacherNameLabel, 10*ScrenScale)
        .centerYEqualToView(_teacherNameLabel)
        .heightRatioToView(_teacherNameLabel, 0.5)
        .widthEqualToHeight();
        
        //教龄
        _workYearsLabel = [[UIButton alloc]init];
        _workYearsLabel .titleLabel.font = [UIFont systemFontOfSize:12*ScrenScale];
        [_workYearsLabel setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [self addSubview:_workYearsLabel];
        _workYearsLabel.sd_layout
        .leftEqualToView(_teacherNameLabel)
        .centerYEqualToView(_teacherHeadImage);
        [_workYearsLabel setupAutoSizeWithHorizontalPadding:5 buttonHeight:20*ScrenScale];
        _workYearsLabel.sd_cornerRadiusFromHeightRatio = @0.5;
        _workYearsLabel.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
        _workYearsLabel.layer.borderWidth = 0.6;
        _workYearsLabel.enabled = NO;
        
        //所在学校
        _workPlaceLabel =[[UILabel alloc]init];
        _workPlaceLabel.font = TEXT_FONTSIZE_MIN;
        _workPlaceLabel.textColor = [UIColor colorWithHexString:@"666666"];
        [self addSubview:_workPlaceLabel];
        _workPlaceLabel.sd_layout
        .leftEqualToView(_teacherNameLabel)
        .bottomEqualToView(_teacherHeadImage)
        .rightSpaceToView(self, 10)
        .heightIs(15*ScrenScale);
        
        [_workPlaceLabel setMaxNumberOfLinesToShow:1];
        [_workPlaceLabel updateLayout];
        _workPlaceLabel.textAlignment = NSTextAlignmentLeft;
        
//        /* 所在学校*/
//        UILabel *schools =[[UILabel alloc]init];
//        schools.font = TITLEFONTSIZE;
//        [self addSubview:schools];
//        schools.sd_layout
//        .leftEqualToView(_teacherHeadImage)
//        .topSpaceToView(_teacherHeadImage,20)
//        .autoHeightRatio(0);
//        [schools setSingleLineAutoResizeWithMaxWidth:200];
//        [schools setText:@"所在学校"];
        
//        /* 执教年数*/
//        UILabel *workYears = [[UILabel alloc]init];
//        workYears.font = TITLEFONTSIZE;
//        [self addSubview:workYears];
//        workYears.sd_layout
//        .leftEqualToView(schools)
//        .topSpaceToView(_workPlaceLabel,20)
//        .autoHeightRatio(0);
//        [workYears setSingleLineAutoResizeWithMaxWidth:200];
//        [workYears setText:@"执教年限"];
        
        //目前不做的教师标签
//        UILabel *teacherTag = [[UILabel alloc]init];
//        teacherTag.font = TITLEFONTSIZE;
//        teacherTag.text = @"教师标签";
//        [self addSubview:teacherTag];
//        teacherTag.sd_layout
//        .leftEqualToView(workYears)
//        .topSpaceToView(_workYearsLabel,20)
//        .autoHeightRatio(0);
//        [teacherTag setSingleLineAutoResizeWithMaxWidth:100];
//        teacherTag.hidden = YES;
//
//        /* 教师简介*/
//        _descrip =[[UILabel alloc]init];
//        _descrip.font = TITLEFONTSIZE;
//        [self addSubview:_descrip];
//        _descrip.sd_layout
//        .leftEqualToView(workYears)
//        .topSpaceToView(_workYearsLabel,20)
//        .autoHeightRatio(0);
//        [_descrip setSingleLineAutoResizeWithMaxWidth:200];
//        _descrip.text = @"自我介绍";
        
        //右箭头
        _arrowBtn = [[UIButton alloc]init];
        [self addSubview:_arrowBtn];
        _arrowBtn.sd_layout
        .centerYEqualToView(_teacherHeadImage)
        .rightSpaceToView(self, 15*ScrenScale)
        .heightIs(20)
        .widthEqualToHeight();
        [_arrowBtn setImage:[[UIImage imageNamed:@"leftArrow"]imageRedrawWithColor:TITLECOLOR] forState:UIControlStateNormal];
        _arrowBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        [_arrowBtn setEnlargeEdge:40];
        [_arrowBtn addTarget:self action:@selector(tapTeacher) forControlEvents:UIControlEventTouchUpInside];
        
        //教师简介
        _teacherInterviewLabel =[UILabel new];
        _teacherInterviewLabel.font = TEXT_FONTSIZE;
        _teacherInterviewLabel.textColor = TITLECOLOR;
        _teacherInterviewLabel.isAttributedContent = YES;
        [self addSubview:_teacherInterviewLabel];
        _teacherInterviewLabel.sd_layout
        .leftSpaceToView(self, 15*ScrenScale)
        .rightSpaceToView(self, 15*ScrenScale)
        .topSpaceToView(_teacherHeadImage, 20*ScrenScale)
        .autoHeightRatio(0);
        
        [_teacherInterviewLabel setMaxNumberOfLinesToShow:3];
        
        [self setupAutoContentSizeWithBottomView:_teacherInterviewLabel bottomMargin:20];
//        self.alwaysBounceVertical = YES;
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
    [_workYearsLabel setTitle:[teacher.teaching_years changeEnglishYearsToChinese] forState:UIControlStateNormal]; ;
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
