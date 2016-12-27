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
    
    /* 教师头像*/
    _teacherHeadImage = [[UIImageView alloc]init];
    
    /* 教师姓名*/
    _teacherNameLabel =[[UILabel alloc]init];
    _teacherNameLabel.font = [UIFont systemFontOfSize:22];
    /* 性别*/
    _genderImage  = [[UIImageView alloc]init];
    
    /* 学龄阶段*/
    _category = [[UILabel alloc]init];
    [_category setTextColor:[UIColor whiteColor]];
    _category.backgroundColor = [UIColor orangeColor];
    _category.font = [UIFont systemFontOfSize:16];
    
    
    /* 科目*/
    _subject = [[UILabel alloc]init];
    [_subject setTextColor:[UIColor whiteColor]];
    _subject.backgroundColor = [UIColor orangeColor];
    _subject.font = [UIFont systemFontOfSize:16];
    

    
    /* 教龄*/
    _teaching_year= [[UILabel alloc]init];
    _teaching_year.font = [UIFont systemFontOfSize:16];
     _teaching_year.textColor = [UIColor lightGrayColor];
    /* 省*/
    _province= [[UILabel alloc]init];
    _province.font = [UIFont systemFontOfSize:16];
     _province.textColor = [UIColor lightGrayColor];
    /* 市*/
    _city= [[UILabel alloc]init];
    _city.font = [UIFont systemFontOfSize:16];
     _city.textColor = [UIColor lightGrayColor];
    /* 学校*/
    _workPlace= [[UILabel alloc]init];
     _workPlace.font = [UIFont systemFontOfSize:16];
     _workPlace.textColor = [UIColor lightGrayColor];
    
    /* 自我介绍部分*/
    UIImageView *selfIntro =[[UIImageView alloc]init];
    [selfIntro setImage:[UIImage imageNamed:@"老师"]];
    
    /* 自我介绍标题*/
    UILabel *selfIntroLabel =[[UILabel alloc]init];
    selfIntroLabel.text =@"自我介绍";
    selfIntroLabel.font =[UIFont systemFontOfSize:20];
    
    
    
    /* 自我介绍*/
    _selfInterview= [[UILabel alloc]init];
    
        
    
    [self sd_addSubviews:@[_bakcgroudImage,selfIntro,selfIntroLabel,_selfInterview]];
    
    
    
//    _bakcgroudImage.sd_layout
//    .leftSpaceToView(self,0)
//    .rightSpaceToView(self,0)
//    .topSpaceToView(self,0)
//    .heightIs([UIScreen mainScreen].bounds.size.width/2.0f);
//    
    [_bakcgroudImage sd_addSubviews:@[_teacherHeadImage,_teacherNameLabel,_genderImage,_category,_subject,_teaching_year,_province,_city,_workPlace,_selfInterview]];
    
    
    [_bakcgroudImage setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame),CGRectGetWidth(self.frame)/2.0f)];
    
    _teacherHeadImage.sd_layout
    .leftSpaceToView(_bakcgroudImage,10)
    .bottomSpaceToView(_bakcgroudImage,10)
    .heightIs(80)
    .widthEqualToHeight();
    
    
    _teacherNameLabel.sd_layout
    .leftSpaceToView(_teacherHeadImage,10)
    .topEqualToView(_teacherHeadImage)
    .autoHeightRatio(0);
    [_teacherNameLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    _genderImage.sd_layout
    .leftSpaceToView(_teacherNameLabel,5)
    .topEqualToView(_teacherNameLabel)
    .heightRatioToView(_teacherNameLabel,1.0f)
    .widthEqualToHeight();

    
    _category.sd_layout
    .leftEqualToView(_teacherNameLabel)
    .bottomEqualToView(_teacherHeadImage)
    .autoHeightRatio(0);
    [_category setSingleLineAutoResizeWithMaxWidth:100];
    
    _subject.sd_layout
    .leftSpaceToView(_category,0)
    .topEqualToView(_category)
    .bottomEqualToView(_category)
    .autoHeightRatio(0);
    [_subject setSingleLineAutoResizeWithMaxWidth:100];
    
    
    
    _teaching_year.sd_layout
    .rightSpaceToView(_bakcgroudImage,10)
    .topEqualToView(_teacherHeadImage)
    .autoHeightRatio(0);
    [_teaching_year setSingleLineAutoResizeWithMaxWidth:300];
    
    
    _city.sd_layout
    .centerYEqualToView(_teacherHeadImage)
    .rightEqualToView(_teaching_year)
    .autoHeightRatio(0);
    [_city setSingleLineAutoResizeWithMaxWidth:100];
    
    
    _province.sd_layout
    .rightSpaceToView(_city,5)
    .centerYEqualToView(_teacherHeadImage)
    .autoHeightRatio(0);
    [_province setSingleLineAutoResizeWithMaxWidth:100];
    
    
    
    _workPlace.sd_layout
    .bottomEqualToView(_teacherHeadImage)
    .rightEqualToView(_city)
    .autoHeightRatio(0);
    [_workPlace setSingleLineAutoResizeWithMaxWidth:300];
    
    
    /* 自我介绍部分的布局*/
    
    [selfIntro setFrame:CGRectMake(10, CGRectGetMaxY(_bakcgroudImage.frame)+10, 20, 20)];
    
    selfIntroLabel.sd_layout
    .leftSpaceToView(selfIntro,3)
    .centerYEqualToView(selfIntro)
    .autoHeightRatio(0);
    [selfIntroLabel setSingleLineAutoResizeWithMaxWidth:100];
    

    
    [_selfInterview setFrame:CGRectMake(10, CGRectGetMaxY(selfIntro.frame)+10, CGRectGetWidth(self.frame)-20, 60)];
    _selfInterview .text = @"" ;
    _selfInterview.numberOfLines =0;
    [_selfInterview sizeToFit];
    
    
    
    
    
}





@end
