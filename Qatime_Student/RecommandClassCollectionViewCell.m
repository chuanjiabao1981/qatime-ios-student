//
//  RecommandClassCollectionViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "RecommandClassCollectionViewCell.h"

@implementation RecommandClassCollectionViewCell

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
       
        
        
        
        
        /* 教师姓名label*/
        /**** 预留label的宽度和教师姓名model源 ***/
        _className = [[UILabel alloc]init];
        [self.contentView addSubview:_className];
        _className.textColor = [UIColor blackColor];
        _className.sd_layout.leftSpaceToView(self.contentView,0).topSpaceToView(_classImage,5).autoHeightRatio(0);
        [_className setSingleLineAutoResizeWithMaxWidth:300];
        
        [_className setText:@"课程名称"];
        _className.textAlignment = NSTextAlignmentLeft;
        
        /* 年级 label*/
        _grade = [[UILabel alloc]init];
        [self.contentView addSubview:_grade];
        [_grade setText:@"年级"];
        _grade.textColor =[UIColor grayColor];
        _grade.sd_layout.leftEqualToView(_className).topSpaceToView(_className,0).autoHeightRatio(0);
        [_grade setSingleLineAutoResizeWithMaxWidth:80];
        _grade.textAlignment = NSTextAlignmentRight;
        [_grade setFont:[UIFont systemFontOfSize:12]];
        
        /* 科目 label*/
        /* 科目名称  预留名称的接口model*/
        _subjectName = [[UILabel alloc]init];
        [self.contentView addSubview:_subjectName];
        [_subjectName setText:@"科目名称"];
        _subjectName.textColor =[UIColor grayColor];
        _subjectName.sd_layout.leftSpaceToView(_grade,0).topSpaceToView(_className,0).autoHeightRatio(0);
        [_subjectName setSingleLineAutoResizeWithMaxWidth:80];
        _subjectName.textAlignment = NSTextAlignmentRight;
        [_subjectName setFont:[UIFont systemFontOfSize:12]];
        
        /* **人已购的label*/
        UILabel *saledLabel =[[UILabel alloc]init];
        [self.contentView addSubview:saledLabel];
        [saledLabel setText:@"人已购"];
        saledLabel.sd_layout.rightEqualToView(self.contentView).topSpaceToView(_className,0).autoHeightRatio(0);
        [saledLabel setSingleLineAutoResizeWithMaxWidth:100];
        [saledLabel setFont:[UIFont systemFontOfSize:12]];
        
        
        
        
        /* 已购买的用户数量*/
        _saleNumber = [[UILabel alloc]init];
        [self.contentView addSubview:_saleNumber];
        _saleNumber.textColor = [UIColor lightGrayColor];
        _saleNumber.text = @"10";
        _saleNumber.sd_layout.rightSpaceToView(saledLabel,0).topEqualToView(saledLabel).autoHeightRatio(0);
        [_saleNumber setSingleLineAutoResizeWithMaxWidth:80];
        _saleNumber.textAlignment = NSTextAlignmentRight;
        [_saleNumber setFont:[UIFont systemFontOfSize:12]];
        
        
        
        
        
        
        
    }
    return self;
}



///* 距开课时间*/
//@property(nonatomic,strong) UILabel *timeToStart ;
///* 价格*/
//@property(nonatomic,strong) UILabel *price ;
//
///* 已购买的用户*/
//
//@property(nonatomic,strong) UILabel *saleNumber ;

@end