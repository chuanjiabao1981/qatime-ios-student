//
//  TeacherPublicClassCollectionViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/9.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "TeacherPublicClassCollectionViewCell.h"

@implementation TeacherPublicClassCollectionViewCell

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
        
       
        
        /* 价格label*/
        _priceLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_priceLabel];
        [_priceLabel setText:@"¥0.00"];
        _priceLabel.textColor =[UIColor redColor];
        _priceLabel.sd_layout.rightSpaceToView(self.contentView,0).topEqualToView(_grade).autoHeightRatio(0);
        [_priceLabel setSingleLineAutoResizeWithMaxWidth:80];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        [_priceLabel setFont:[UIFont systemFontOfSize:12]];

        
        
    }
    return self;
}

-(void)setModel:(TutoriumListInfo *)model{
    
    _model = model;
    _className.text = model.name;
    [_classImage sd_setImageWithURL:[NSURL URLWithString:model.publicize] placeholderImage:[UIImage imageNamed:@"school"]];
    _grade.text = model.grade;
    _subjectName.text = model.subject;
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    
    
}


@end
