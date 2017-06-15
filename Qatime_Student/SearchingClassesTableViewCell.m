//
//  SearchingClassesTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/6/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "SearchingClassesTableViewCell.h"
#import "UIColor+HcdCustom.h"
#import "UIImageView+WebCache.h"

@implementation SearchingClassesTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //课程图
        _classImage = [[UIImageView alloc]init];
        [self.contentView addSubview:_classImage];
        _classImage.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .topSpaceToView(self.contentView, 8*ScrenScale)
        .bottomSpaceToView(self.contentView, 0)
        .autoWidthRatio(16/9.f);
        
        //课程名
        _className = [[UILabel alloc]init];
        _className.font = TEXT_FONTSIZE;
        _className.textColor = [UIColor blackColor];
        [self.contentView addSubview:_className];
        _className.sd_layout
        .leftSpaceToView(_classImage, 10*ScrenScale)
        .topEqualToView(_classImage)
        .rightSpaceToView(self.contentView, 10*ScrenScale)
        .autoHeightRatio(0);
        [_className setMaxNumberOfLinesToShow:2];
        
        //教师名
        _teacherName = [[UILabel alloc]init];
        _teacherName.font = TEXT_FONTSIZE_MIN;
        _teacherName.textColor = [UIColor colorWithHexString:@"666666"];
        [self.contentView addSubview:_teacherName];
        _teacherName.sd_layout
        .leftEqualToView(_className)
        .bottomSpaceToView(self.contentView, 8*ScrenScale)
        .autoHeightRatio(0);
        [_teacherName setSingleLineAutoResizeWithMaxWidth:200];
        
        //课程信息
        _classInfo = [[UILabel alloc]init];
        _classInfo.font = TEXT_FONTSIZE_MIN;
        _classInfo.textColor = [UIColor colorWithHexString:@"999999"];
        [self.contentView addSubview:_classInfo];
        _classInfo.sd_layout
        .leftEqualToView(_className)
        .bottomSpaceToView(_teacherName, 10*ScrenScale)
        .autoHeightRatio(0);
        [_classInfo setSingleLineAutoResizeWithMaxWidth:200];
        
        
        
        //万能分割线
        UIView *line = [[UIView alloc]init];
        [self.contentView addSubview:line];
        line.backgroundColor = SEPERATELINECOLOR_2;
        line.sd_layout
        .leftSpaceToView(_classImage, 0)
        .rightSpaceToView(self.contentView, 0)
        .bottomSpaceToView(self.contentView, 0)
        .heightIs(0.5);

        
    }
    return self;
}

-(void)setModel:(ClassSearch *)model{
    
    _model = model;
    
    [_classImage sd_setImageWithURL:[NSURL URLWithString:model.publicize]];
    _className.text = model.name;
    _teacherName.text = model.teacher_name;
    _classInfo.text = [model.grade stringByAppendingString:model.subject];
    
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
