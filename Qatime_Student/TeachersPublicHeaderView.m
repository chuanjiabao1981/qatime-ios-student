//
//  TeachersPublicHeaderView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/9.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "TeachersPublicHeaderView.h"

@implementation TeachersPublicHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupViews];
        
    }
    return self;
}

- (void)setupViews{

    /* 背景图*/
    _bakcgroudImage = [[UIImageView alloc]init];
    [_bakcgroudImage setImage:[UIImage imageNamed:@"back"]];
    [self addSubview:_bakcgroudImage];
    _bakcgroudImage.sd_layout
    .leftEqualToView(self)
    .topEqualToView(self)
    .rightEqualToView(self)
    .autoHeightRatio(0.4);
    
    /* 教师头像*/
    _teacherHeadImage = [[UIImageView alloc]init];
    [_bakcgroudImage addSubview:_teacherHeadImage];
    _teacherHeadImage.sd_layout
    .centerYEqualToView(_bakcgroudImage)
    .centerXEqualToView(_bakcgroudImage)
    .widthIs(60)
    .heightEqualToWidth();
    _teacherHeadImage.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
    
    /* 教师姓名*/
    _teacherNameLabel =[[UILabel alloc]init];
    _teacherNameLabel.font = TEXT_FONTSIZE;
    [_bakcgroudImage addSubview:_teacherNameLabel];
    _teacherNameLabel.sd_layout
    .centerXEqualToView(_teacherHeadImage)
    .topSpaceToView(_teacherHeadImage,5)
    .autoHeightRatio(0);
    [_teacherNameLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    /* 性别*/
    _genderImage  = [[UIImageView alloc]init];
    [_bakcgroudImage addSubview:_genderImage];
    _genderImage.sd_layout
    .leftSpaceToView(_teacherNameLabel,5)
    .centerYEqualToView(_teacherNameLabel)
    .heightRatioToView(_teacherNameLabel,0.6)
    .widthEqualToHeight();
    
    //基本资料
    UILabel *info = [[UILabel alloc]init];
    [self addSubview:info];
    info.text = @"基本资料";
    info.font = TITLEFONTSIZE;
    info.sd_layout
    .topSpaceToView(_bakcgroudImage,20)
    .leftSpaceToView(self,15)
    .autoHeightRatio(0);
    [info setSingleLineAutoResizeWithMaxWidth:100];
    
    //教龄
    _teaching_year= [[UILabel alloc]init];
    _teaching_year.font = TEXT_FONTSIZE;
    _teaching_year.textColor = TITLECOLOR;
    [self addSubview:_teaching_year];
    _teaching_year.sd_layout
    .leftEqualToView(info)
    .topSpaceToView(info,10)
    .autoHeightRatio(0);
    [_teaching_year setSingleLineAutoResizeWithMaxWidth:200];
    

   //学龄阶段和科目
    _categoryAndSubject = [[UILabel alloc]init];
    [self addSubview:_categoryAndSubject];
    _categoryAndSubject.textColor = TITLECOLOR;
    _categoryAndSubject.font = TEXT_FONTSIZE;
    _categoryAndSubject.sd_layout
    .topSpaceToView(_teaching_year,10)
    .leftEqualToView(_teaching_year)
    .autoHeightRatio(0);
    [_categoryAndSubject setSingleLineAutoResizeWithMaxWidth:200];
    
    //地址
    _location = [[UILabel alloc]init];
    [self addSubview:_location];
    _location.textColor = TITLECOLOR;
    _location.font = TEXT_FONTSIZE;
    _location.sd_layout
    .topSpaceToView(_categoryAndSubject,10)
    .leftEqualToView(_categoryAndSubject)
    .autoHeightRatio(0);
    [_location setSingleLineAutoResizeWithMaxWidth:200];
    
    
    /* 学校*/
    _workPlace= [[UILabel alloc]init];
    _workPlace.textColor = TITLECOLOR;
    _workPlace.font = TEXT_FONTSIZE;
    [self addSubview:_workPlace];
    _workPlace.sd_layout
    .leftEqualToView(_location)
    .topSpaceToView(_location,10)
    .autoHeightRatio(0);
    [_workPlace setSingleLineAutoResizeWithMaxWidth:200];
    
    //分割线1
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = SEPERATELINECOLOR;
    [self addSubview:line1];
    line1.sd_layout
    .leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .topSpaceToView(_workPlace,20)
    .heightIs(10);
    
    /* 自我介绍*/
    UILabel *selfIntroLabel =[[UILabel alloc]init];
    selfIntroLabel.text =@"自我介绍";
    selfIntroLabel.font = TITLEFONTSIZE;
    [self addSubview:selfIntroLabel];
    selfIntroLabel.sd_layout
    .leftEqualToView(info)
    .topSpaceToView(line1,20)
    .autoHeightRatio(0);
    [selfIntroLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    /* 自我介绍*/
    _selfInterview= [[UILabel alloc]init];
    _selfInterview.font = TEXT_FONTSIZE;
    _selfInterview.textColor = TITLECOLOR;
    _selfInterview.isAttributedContent = YES;
    [self addSubview:_selfInterview];
    _selfInterview.sd_layout
    .leftEqualToView(selfIntroLabel)
    .topSpaceToView(selfIntroLabel,10)
    .rightSpaceToView(self,20)
    .autoHeightRatio(0);
    
    //分割线2
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = SEPERATELINECOLOR;
    [self addSubview: line2];
    line2.sd_layout
    .leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .topSpaceToView(_selfInterview,20)
    .heightIs(10);
    
    //课程
    _classList = [[UILabel alloc]init];
    _classList.text = @"一对一";
    _classList.font = TITLEFONTSIZE;
    [self addSubview:_classList];
    _classList.sd_layout
    .leftEqualToView(info)
    .topSpaceToView(line2,20)
    .autoHeightRatio(0);
    [_classList setSingleLineAutoResizeWithMaxWidth:100];
    
    [self setupAutoHeightWithBottomView:_classList bottomMargin:0];
    
}





@end
