//
//  TutoriumCollectionViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/2.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "TutoriumCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface TutoriumCollectionViewCell (){
  
    
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
        [self.contentView addSubview:_classImage];
        _classImage.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).heightRatioToView(self.contentView,0.7);
        
        
        /* 课程名*/
        _className = [[UILabel alloc]init];
        [self.contentView addSubview:_className];
        _className.sd_layout
        .leftEqualToView(_classImage)
        .rightEqualToView(_classImage)
        .topSpaceToView(_classImage,5)
        .heightIs(20);
        

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
        
        [_teacherName setText:NSLocalizedString(@"老师姓名", nil)];
        _teacherName.font = [UIFont systemFontOfSize:14*ScrenScale];

        
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
        _price.font = [UIFont systemFontOfSize:14*ScrenScale];
        _price.textAlignment = NSTextAlignmentLeft;
        
        
    }
    return self;
}


-(void)setModel:(TutoriumListInfo *)model{
    
    _model = model;
    
    [_classImage sd_setImageWithURL:[NSURL URLWithString:model.publicize] placeholderImage:[UIImage imageNamed:@"school"]];
    
    /* cell 教师姓名 赋值*/
    [_teacherName setText:model.teacher_name];
    
    /* cell 科目赋值*/
    
    [_subjectName setText:NSLocalizedString(model.subject, nil)];
    
    /* cell 年级赋值*/
    [_grade setText:NSLocalizedString(model.grade, nil)];
    
    /* cell 价格赋值*/
    [_price setText:[NSString stringWithFormat:@"¥%@.00",model.price]];
    
    /* cell 已购买的用户 赋值*/
    [_saleNumber setText:model.buy_tickets_count];
    
    /* cell 的课程id属性*/
    _classID = model.classID ;
    
    [_className setText: model.name];

    
}


@end
