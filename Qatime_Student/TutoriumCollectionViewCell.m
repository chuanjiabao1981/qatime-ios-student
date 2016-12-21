//
//  TutoriumCollectionViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/2.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "TutoriumCollectionViewCell.h"

@interface TutoriumCollectionViewCell (){
    
    /* "老师"字样的label*/
//    UILabel *teacher;
    
    /* 学生人数图片*/
//    UIImageView *student;
    
    
}

@end

@implementation TutoriumCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /* 白色背景*/
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        /* 课程图布局*/
        
        _classImage = [[UIImageView alloc]init];
//        [_classImage setImage:[UIImage imageNamed:@"school"]];
        [self.contentView addSubview:_classImage];
        _classImage.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).heightRatioToView(self.contentView,0.7);
        
        /* 距开课时间label布局*/
//        _timeToStart = [[UILabel alloc]init];
//        [_classImage addSubview: _timeToStart];
//        _timeToStart.backgroundColor = [UIColor orangeColor];
//        _timeToStart.text = [NSString stringWithFormat:@"距开课**天"];
//        _timeToStart.textColor = [UIColor whiteColor];
//        _timeToStart.sd_layout.rightSpaceToView(_classImage,0).bottomSpaceToView(_classImage,0).autoHeightRatio(0);
//        [_timeToStart setSingleLineAutoResizeWithMaxWidth:160];
        
        
        /* 课程名*/
        _className = [[UILabel alloc]init];
        [self.contentView addSubview:_className];
        _className.sd_layout
        .leftEqualToView(_classImage)
        .rightEqualToView(_classImage)
        .topSpaceToView(_classImage,5)
        .heightIs(20);
        
        
        
        
        
        /* “老师”label*/
//        teacher = [[UILabel alloc]init];
//        [self.contentView addSubview:teacher];
//        [teacher setText:@"老师"];
//        teacher.textColor = [UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:1.0f];
//        teacher.textAlignment = NSTextAlignmentLeft;
//        teacher.sd_layout.topEqualToView(_teacherName).bottomEqualToView(_teacherName).leftSpaceToView(_teacherName,0);
//        [teacher setSingleLineAutoResizeWithMaxWidth:60];
        

        
        
        /* 科目 label*/
        /* 科目名称  预留名称的接口model*/
//        _subjectName = [[UILabel alloc]init];
//        [self.contentView addSubview:_subjectName];
//        [_subjectName setText:@"科目名称"];
//        _subjectName.textColor =[UIColor grayColor];
//        _subjectName.sd_layout.rightSpaceToView(self.contentView,0).topSpaceToView(_classImage,5).autoHeightRatio(0);
//        [_subjectName setSingleLineAutoResizeWithMaxWidth:80];
//        _subjectName.textAlignment = NSTextAlignmentRight;
        
        /* 年级 label*/
//        _grade = [[UILabel alloc]init];
//        [self.contentView addSubview:_grade];
//        [_grade setText:@"年级"];
//        _grade.textColor =[UIColor grayColor];
//        _grade.sd_layout.rightSpaceToView(_subjectName,0).topEqualToView(_subjectName).bottomEqualToView(_subjectName);
//        [_grade setSingleLineAutoResizeWithMaxWidth:80];
//        _grade.textAlignment = NSTextAlignmentRight;
        
        /* 教师姓名label*/
        /**** 预留label的宽度和教师姓名model源 ***/
        _teacherName = [[UILabel alloc]init];
        [self.contentView addSubview:_teacherName];
        _teacherName.textColor = [UIColor blackColor];
        _teacherName.sd_layout
        .rightSpaceToView(self.contentView,0)
        .topSpaceToView(_className,5)
        .autoHeightRatio(0);
        [_teacherName setSingleLineAutoResizeWithMaxWidth:200];
        
        [_teacherName setText:@"老师姓名"];
//        _teacherName.textAlignment = NSTextAlignmentLeft;
        
        /* 价格label */
        /* 价格信息  预留接口model*/
        _price = [[UILabel alloc]init];
        [self.contentView addSubview:_price];
        _price.textColor = [UIColor redColor];
        _price.text = [NSString stringWithFormat:@"¥0.00"];
        _price.sd_layout
        .leftSpaceToView(self.contentView,0)
        .topSpaceToView(_className,5)
        .rightSpaceToView(_teacherName,0)
        .autoHeightRatio(0);
        
        _price.textAlignment = NSTextAlignmentLeft;
        

        
        
        
        /* 已购买的用户数量*/
//        _saleNumber = [[UILabel alloc]init];
//        [self.contentView addSubview:_saleNumber];
//        _saleNumber.textColor = [UIColor lightGrayColor];
//        _saleNumber.text = @"10";
//        _saleNumber.sd_layout.rightSpaceToView(self.contentView,0).topSpaceToView(_subjectName,5).autoHeightRatio(0);
//        [_saleNumber setSingleLineAutoResizeWithMaxWidth:80];
//        _saleNumber.textAlignment = NSTextAlignmentRight;
        
        /* student的图片*/
//        student =[[UIImageView alloc]init];
//        [self.contentView addSubview:student];
//        [student setImage:[UIImage imageNamed:@"students"]];
//        
//        student.sd_layout.rightSpaceToView(_saleNumber,2).widthEqualToHeight().centerYEqualToView(_saleNumber).heightRatioToView(_saleNumber,0.8);
//        
        
        
        
        /* 测试代码*/
        
//        self.contentView.layer.borderColor =[UIColor blackColor].CGColor;
//        self.contentView.layer.borderWidth =0.6f;
        
        
        
        
        
        
        
        
        
    }
    return self;
}



@end
