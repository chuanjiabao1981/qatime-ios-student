//
//  InteractionInfoView.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/28.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "InteractionInfoView.h"
#import "UIImageView+WebCache.h"
#import "NSString+ChangeYearsToChinese.h"

@interface InteractionInfoView (){
    
    TTGTextTagConfig *_config;
    
}

@end

@implementation InteractionInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
#pragma mark- 辅导班的详情页面
        
        
        /* 辅导班概况 的所有label*/
        
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
        
        /**总课时长*/
        _classDuring=[[UILabel alloc]init];
        _classDuring.font = TEXT_FONTSIZE;
        _classDuring.textColor = TITLECOLOR;
        [self addSubview:_classDuring];
        _classDuring.sd_layout
        .leftEqualToView(_gradeLabel)
        .topSpaceToView(_gradeLabel,10)
        .autoHeightRatio(0);
        [_classDuring setSingleLineAutoResizeWithMaxWidth:200];
        
        UIImageView *book3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self addSubview:book3];
        
        book3.sd_layout
        .centerXEqualToView(book1)
        .widthRatioToView(book2, 1.0f)
        .heightEqualToWidth()
        .centerYEqualToView(_classDuring);

        
        /**每节课时长*/
        _classPerDuring = [[UILabel alloc]init];
        _classPerDuring.font = TEXT_FONTSIZE;
        _classPerDuring.textColor = TITLECOLOR;
        [self addSubview:_classPerDuring];
        _classPerDuring.sd_layout
        .leftEqualToView(_subjectLabel)
        .topEqualToView(_classDuring)
        .autoHeightRatio(0);
        [_classPerDuring setSingleLineAutoResizeWithMaxWidth:200];
        
        UIImageView *book3_3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self addSubview:book3_3];
        book3_3.sd_layout
        .leftEqualToView(book2)
        .rightEqualToView(book2)
        .centerYEqualToView(_classPerDuring)
        .heightEqualToWidth();

        
        /**课时*/
        _classCountLabel = [[UILabel alloc]init];
        _classCountLabel.font = TEXT_FONTSIZE;
        _classCountLabel.textColor =TITLECOLOR;
        [self addSubview:_classCountLabel];
        _classCountLabel.sd_layout
        .leftEqualToView(_classDuring)
        .topSpaceToView(_classDuring,10)
        .autoHeightRatio(0);
        [_classCountLabel setSingleLineAutoResizeWithMaxWidth:500];
        
        UIImageView *image4  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self addSubview:image4];
        image4.sd_layout
        .leftEqualToView(book1)
        .rightEqualToView(book1)
        .heightRatioToView(book1,1.0)
        .centerYEqualToView(_classCountLabel)
        .widthRatioToView(book1,1.0);
        
        
//        //标签设置项
//        _config = [[TTGTextTagConfig alloc]init];
//        _config.tagTextColor = TITLECOLOR;
//        _config.tagBackgroundColor = [UIColor whiteColor];
//        _config.tagBorderColor = [UIColor colorWithRed:0.88 green:0.60 blue:0.60 alpha:1.00];
//        _config.tagShadowColor = [UIColor clearColor];
//        _config.tagCornerRadius = 0;
//        _config.tagExtraSpace = CGSizeMake(15, 5);
//        _config.tagTextFont = TEXT_FONTSIZE;

        
//        //课程标签
//        UILabel *tags = [[UILabel alloc]init];
//        [self addSubview:tags];
//        tags.text = @"课程标签";
//        tags.font = TITLEFONTSIZE;
//        tags.sd_layout
//        .topSpaceToView(_classCountLabel,20)
//        .leftEqualToView(info)
//        .autoHeightRatio(0);
//        [tags setSingleLineAutoResizeWithMaxWidth:100];
//        
//        //课程标签图
//        _classTagsView = [[TTGTextTagCollectionView alloc]init];
//        _classTagsView.alignment = TTGTagCollectionAlignmentLeft;
//        _classTagsView.enableTagSelection = NO;
//        [self addSubview:_classTagsView];
//        _classTagsView.sd_layout
//        .leftEqualToView(tags)
//        .rightSpaceToView(self,20)
//        .topSpaceToView(tags,10)
//        .heightIs(200);
        
        //课程目标
        UILabel *taget = [[UILabel alloc]init];
        [self addSubview:taget];
        taget.textColor = [UIColor blackColor];
        taget.font = TITLEFONTSIZE;
        taget.text = @"课程目标";
        taget.sd_layout
        .topSpaceToView(_classCountLabel,20)
        .leftEqualToView(info)
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
        .leftEqualToView(suit)
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
        
#pragma mark- 教师组
        
//        /* 教师头像*/
//        _teacherHeadImage = [[UIImageView alloc]init];
//        [self addSubview:_teacherHeadImage];
//        _teacherHeadImage.sd_layout
//        .topSpaceToView(line1,10)
//        .leftSpaceToView(self,10)
//        .heightIs(60)
//        .widthEqualToHeight();
//        _teacherHeadImage.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
//        
//        /* 教师姓名*/
//        _teacherNameLabel =[[UILabel alloc]init];
//        _teacherNameLabel.font = TITLEFONTSIZE;
//        _teacherNameLabel.textColor = TITLECOLOR;
//        [self addSubview:_teacherNameLabel];
//        
//        _teacherNameLabel.sd_layout
//        .leftSpaceToView(_teacherHeadImage,10)
//        .centerYEqualToView(_teacherHeadImage)
//        .autoHeightRatio(0);
//        [_teacherNameLabel setSingleLineAutoResizeWithMaxWidth:100];
//        
//        /* 性别*/
//        _genderImage  = [[UIImageView alloc]init];
//        [self addSubview:_genderImage];
//        
//        _genderImage.sd_layout
//        .leftSpaceToView(_teacherNameLabel,5)
//        .centerYEqualToView(_teacherNameLabel)
//        .heightRatioToView(_teacherNameLabel,0.6f)
//        .widthEqualToHeight();
//        
//        //所在学校
//        UILabel *school = [[UILabel alloc]init];
//        [self addSubview:school];
//        school.font = TITLEFONTSIZE;
//        school.text = @"所在学校";
//        school.sd_layout
//        .topSpaceToView(_teacherHeadImage,20)
//        .leftEqualToView(_descriptions)
//        .autoHeightRatio(0);
//        [school setSingleLineAutoResizeWithMaxWidth:100];
//        
//        _workPlace= [[UILabel alloc]init];
//        _workPlace.font = TEXT_FONTSIZE;
//        _workPlace.textColor = TITLECOLOR;
//        [self addSubview:_workPlace];
//        _workPlace.sd_layout
//        .leftEqualToView(school)
//        .topSpaceToView(school,10)
//        .autoHeightRatio(0);
//        [_workPlace setSingleLineAutoResizeWithMaxWidth:300];
//        
//        /* 教龄*/
//        UILabel *teachYear = [[UILabel alloc]init];
//        teachYear.font = TITLEFONTSIZE;
//        teachYear.text = @"执教年数";
//        [self addSubview:teachYear];
//        
//        teachYear.sd_layout
//        .leftEqualToView(school)
//        .topSpaceToView(_workPlace,20)
//        .autoHeightRatio(0);
//        [teachYear setSingleLineAutoResizeWithMaxWidth:100];
//        
//        _teaching_year= [[UILabel alloc]init];
//        _teaching_year.font = TEXT_FONTSIZE;
//        _teaching_year.textColor = TITLECOLOR;
//        [self addSubview:_teaching_year];
//        
//        _teaching_year.sd_layout
//        .leftEqualToView(teachYear)
//        .topSpaceToView(teachYear,10)
//        .autoHeightRatio(0);
//        [_teaching_year setSingleLineAutoResizeWithMaxWidth:300];
//        
//        //目前不做的教师标签
//        UILabel *teacherTag = [[UILabel alloc]init];
//        teacherTag.font = TITLEFONTSIZE;
//        teacherTag.text = @"教师标签";
//        [self addSubview:teacherTag];
//        teacherTag.sd_layout
//        .leftEqualToView(teachYear)
//        .topSpaceToView(_teaching_year,20)
//        .autoHeightRatio(0);
//        [teacherTag setSingleLineAutoResizeWithMaxWidth:100];
//        teacherTag.hidden = YES;
//        
//        //教师标签
//        _teacherTagsView = [[TTGTextTagCollectionView alloc]init];
//        _teacherTagsView.alignment = TTGTagCollectionAlignmentLeft;
//        _teacherTagsView.enableTagSelection = NO;
//        [self addSubview:_teacherTagsView];
//        _teacherTagsView.sd_layout
//        .leftEqualToView(teacherTag)
//        .rightSpaceToView(self,20)
//        .topSpaceToView(teacherTag,10)
//        .heightIs(200);
//        _teacherTagsView.hidden = YES;
//        
//        /* 自我介绍标题*/
//        _selfIntroLabel =[[UILabel alloc]init];
//        _selfIntroLabel.font = TITLEFONTSIZE;
//        _selfIntroLabel.text =@"自我介绍";
//        [self addSubview:_selfIntroLabel];
//        
//        _selfIntroLabel.sd_layout
//        .leftEqualToView(teachYear)
//        .topSpaceToView(_teaching_year,20)
//        .autoHeightRatio(0);
//        [_selfIntroLabel setSingleLineAutoResizeWithMaxWidth:100];
//        
//        /* 自我介绍*/
//        _selfInterview= [[UILabel alloc]init];
//        _selfInterview.font = TEXT_FONTSIZE;
//        _selfInterview.textColor = TITLECOLOR;
//        _selfInterview.isAttributedContent = YES;
//        [self addSubview:_selfInterview];
//        
//        _selfInterview.sd_layout
//        .leftEqualToView(_selfIntroLabel)
//        .rightSpaceToView(self,20)
//        .topSpaceToView(_selfIntroLabel,10)
//        .autoHeightRatio(0);
        
        /* 自动布局参考线*/
        _layoutLine = [[UIView alloc]init];
        _layoutLine.backgroundColor =[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
        [self addSubview:_layoutLine];
        _layoutLine.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(_classDescriptionLabel,20)
        .heightIs(10);
        
        //自动刷新自身的高度
        [self setupAutoHeightWithBottomView:_layoutLine bottomMargin:10];
        
        
    }
    return self;
}


//赋值
- (void)setClassModel:(OneOnOneClass *)classModel{
    
    _classModel = classModel;
    _classNameLabel.text = classModel.name;
    _gradeLabel.text = classModel.grade;
    [_gradeLabel updateLayout];
    _subjectLabel.text = classModel.subject;
    [_subjectLabel updateLayout];
    
    _classPerDuring.text = @"45分钟/课";
    _classCountLabel.text = [NSString stringWithFormat:@"共%@课",classModel.lessons_count];
    _classDuring.text = @"共450分钟";
    
    
//    [_classTagsView addTags:classModel.tag_list withConfig:_config];
    
    _classTarget.text = classModel.objective;
    _suitable.text = classModel.suit_crowd;
    
    //课程简介富文本
    NSMutableAttributedString *attDesc = [[NSMutableAttributedString alloc]initWithData:[classModel.descriptions dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }  documentAttributes:nil error:nil];
    _classDescriptionLabel.attributedText = attDesc;
    

}

//- (void)setTeacherModel:(Teacher *)teacherModel{
//    
//    _teacherModel = teacherModel;
//    [_teacherHeadImage sd_setImageWithURL:[NSURL URLWithString:teacherModel.avatar_url] placeholderImage:[UIImage imageNamed:@"人"]];
//    
//    _teacherNameLabel.text = teacherModel.name;
//    
//    if ([teacherModel.gender isEqualToString:@"male"]) {
//        
//        [_genderImage setImage:[UIImage imageNamed:@"male"]];
//    }else if([teacherModel.gender isEqualToString:@"female"]){
//        [_genderImage setImage:[UIImage imageNamed:@"female"]];
//    }else{
//        [_genderImage setImage:nil];
//    }
//    
//    _teaching_year.text = [teacherModel.teaching_years changeEnglishYearsToChinese];
//    _workPlace.text = teacherModel.school;
//    
//    NSMutableAttributedString *attDesc = [[NSMutableAttributedString alloc]initWithData:[teacherModel.desc dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//    _selfInterview.attributedText = attDesc;
//        
//}



@end
