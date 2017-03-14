//
//  QualityTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "QualityTableViewCell.h"

@interface QualityTableViewCell (){
    
    UIView *_content;  //背景框
    
    UIImageView *_subjectImage;
    
    UIImageView *_teacherImage;
    
    
}

@end

@implementation QualityTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //背景图
        _content = [[UIView alloc]init];
        [self.contentView addSubview:_content];
        _content.sd_layout
        .leftSpaceToView(self.contentView,10)
        .topSpaceToView(self.contentView,10)
        .rightSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,10);
        _content.layer.borderColor = SEPERATELINECOLOR.CGColor;
        _content.layer.borderWidth = 0.8;
        
        //课程图
        _classImage = [[UIImageView alloc]init];
        [_content addSubview:_classImage];
        _classImage.sd_layout
        .leftSpaceToView(_content,0)
        .topSpaceToView(_content,0)
        .bottomSpaceToView(_content,0)
        .autoHeightRatio(10/16.0);
        
        //课程名
        _className = [[UILabel alloc]init];
        _className.font = [UIFont systemFontOfSize:15*ScrenScale];
        [_content addSubview:_className];
        _className.sd_layout
        .topSpaceToView(_content,10)
        .leftSpaceToView(_classImage,10)
        .rightSpaceToView(_content,10)
        .maxHeightIs(_classImage.height_sd/2.0)
        .autoHeightRatio(0);
        
        //教师图片
        _teacherImage = [[UIImageView alloc]init];
        [_teacherImage setImage:[UIImage imageNamed:@"老师"]];
        [_content addSubview:_teacherImage];
        _teacherImage.sd_layout
        .leftEqualToView(_className)
        .bottomSpaceToView(_content,10)
        .heightIs(12)
        .widthEqualToHeight();
        
        //教师姓名
        _teacherName = [[UILabel alloc]init];
        _teacherName.textColor = TITLECOLOR;
        _teacherName.font = [UIFont systemFontOfSize:12*ScrenScale];
        [_content addSubview:_teacherName];
        _teacherName.sd_layout
        .leftSpaceToView(_teacherImage,5)
        .topEqualToView(_teacherImage)
        .bottomEqualToView(_teacherImage);
        [_teacherName setSingleLineAutoResizeWithMaxWidth:100];
        
        //年级科目图片
        _subjectImage = [[UIImageView alloc]init];
        [_subjectImage setImage:[UIImage imageNamed:@"book"]];
        [_content addSubview:_subjectImage];
        _subjectImage.sd_layout
        .leftEqualToView(_className)
        .bottomSpaceToView(_teacherImage,10)
        .heightIs(12)
        .widthEqualToHeight();
        
        //年级科目label
        _gradeAndSubject = [[UILabel alloc]init];
        _gradeAndSubject.font = [UIFont systemFontOfSize:12*ScrenScale];
        _gradeAndSubject.textColor = TITLECOLOR;
        [_content addSubview:_gradeAndSubject];
        _gradeAndSubject.sd_layout
        .leftEqualToView(_teacherName)
        .topEqualToView(_subjectImage)
        .bottomEqualToView(_subjectImage);
        [_gradeAndSubject setSingleLineAutoResizeWithMaxWidth:200];
        
        
        
    }
    return self;
}



-(void)setModel:(QualityClass *)model{
    
    
    
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
