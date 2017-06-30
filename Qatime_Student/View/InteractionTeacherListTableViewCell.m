//
//  InteractionTeacherListTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/6.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "InteractionTeacherListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+ChangeYearsToChinese.h"

@implementation InteractionTeacherListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView  sizeToFit];
        self.contentView .autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        //头像
        _headImage = [[UIImageView alloc]init];
        [self.contentView addSubview:_headImage];
        _headImage.sd_layout
        .topSpaceToView(self.contentView, 10)
        .leftSpaceToView(self.contentView, 20)
        .widthIs(60)
        .heightEqualToWidth();
        
        //姓名
        _teacherName = [[UILabel alloc]init];
        [self.contentView addSubview:_teacherName];
        _teacherName.font = TITLEFONTSIZE;
        _teacherName.textColor = [UIColor blackColor];
        _teacherName.sd_layout
        .leftSpaceToView(_headImage, 20)
        .topEqualToView(_headImage)
        .autoHeightRatio(0);
        [_teacherName setSingleLineAutoResizeWithMaxWidth:200];
        
        //性别
        _genderImage = [[UIImageView alloc]init];
        [self.contentView addSubview:_genderImage];
        _genderImage.sd_layout
        .leftSpaceToView(_teacherName, 5)
        .centerYEqualToView(_teacherName)
        .heightRatioToView(_teacherName, 0.6)
        .widthEqualToHeight();
        
        //学校
        _school = [[UILabel alloc]init];
        [self.contentView addSubview:_school];
        _school.font = TEXT_FONTSIZE;
        _school.textColor = TITLECOLOR;
        _school.sd_layout
        .leftEqualToView(_teacherName)
        .topSpaceToView(_teacherName, 10)
        .autoHeightRatio(0);
        [_school setSingleLineAutoResizeWithMaxWidth:1000];
        
        //教龄
        _workYears = [[UILabel alloc]init];
        [self.contentView addSubview:_workYears];
        _workYears.font = TEXT_FONTSIZE;
        _workYears.textColor = TITLECOLOR;
        _workYears.sd_layout
        .leftEqualToView(_teacherName)
        .topSpaceToView(_school, 10)
        .autoHeightRatio(0);
        [_workYears setSingleLineAutoResizeWithMaxWidth:400];
        
        //箭头
        _enterArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightArrow"]];
        [self.contentView addSubview:_enterArrow];
        _enterArrow.sd_layout
        .rightSpaceToView(self.contentView, 20)
        .centerYEqualToView(self.contentView)
        .heightIs(20)
        .widthEqualToHeight();
        
        [self setupAutoHeightWithBottomView:_workYears bottomMargin:20];
        
        
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [self.contentView addGestureRecognizer:_tap];
        
    }
    return self;
}
- (void)tap:(UITapGestureRecognizer *)taps{
    
    [_delegate didSelectedCellAtIndexPath:_indexPath];
    
}


-(void)setModel:(Teacher *)model{
    
    _model = model;
    [_headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar_url]];
    _teacherName.text = model.name;
    
    if ([model.gender isEqualToString:@"male"]) {
        [_genderImage setImage:[UIImage imageNamed:@"男"]];
    }else if ([model.gender isEqualToString:@"female"]){
        [_genderImage setImage:[UIImage imageNamed:@"女"]];
    }
    
    _school.text = model.school;
    _workYears.text = [model.teaching_years changeEnglishYearsToChinese];
    
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
