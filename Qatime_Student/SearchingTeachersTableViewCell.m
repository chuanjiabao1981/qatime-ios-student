//
//  SearchingTeachersTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/6/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "SearchingTeachersTableViewCell.h"
#import "UIColor+HcdCustom.h"
#import "UIImageView+WebCache.h"
#import "NSString+ChangeYearsToChinese.h"

@implementation SearchingTeachersTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //头像
        _headImage = [[UIImageView alloc]init];
        [self.contentView addSubview:_headImage];
        _headImage.sd_layout
        .leftSpaceToView(self.contentView, 10*ScrenScale)
        .topSpaceToView(self.contentView, 15*ScrenScale)
        .bottomSpaceToView(self.contentView, 15*ScrenScale)
        .widthEqualToHeight();
        _headImage.sd_cornerRadiusFromHeightRatio = @0.5;
        _headImage.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        _headImage.layer.borderWidth = 0.5;
        
        //教师名
        _teacherName = [[UILabel alloc]init];
        [self.contentView addSubview:_teacherName];
        _teacherName.font = TEXT_FONTSIZE;
        _teacherName.textColor = [UIColor blackColor];
        _teacherName.sd_layout
        .leftSpaceToView(_headImage, 10*ScrenScale)
        .topEqualToView(_headImage)
        .autoHeightRatio(0);
        [_teacherName setSingleLineAutoResizeWithMaxWidth:400];
        
        //性别图
        _genderImage = [[UIImageView alloc]init];
        [self.contentView addSubview:_genderImage];
        _genderImage.sd_layout
        .leftSpaceToView(_teacherName, 10*ScrenScale)
        .centerYEqualToView(_teacherName)
        .heightRatioToView(_teacherName, 0.5)
        .widthEqualToHeight();
        
        //教龄
        _teachingYears = [[UIButton alloc]init];
        _teachingYears .titleLabel.font = [UIFont systemFontOfSize:12*ScrenScale];
        [_teachingYears setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [self.contentView addSubview:_teachingYears];
        _teachingYears.sd_layout
        .leftEqualToView(_teacherName)
        .centerYEqualToView(_headImage);
        [_teachingYears setupAutoSizeWithHorizontalPadding:5 buttonHeight:20*ScrenScale];
        _teachingYears.sd_cornerRadiusFromHeightRatio = @0.5;
        _teachingYears.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
        _teachingYears.layer.borderWidth = 0.6;
        _teachingYears.enabled = NO;
        
        //教师详情
        _teacherInfo = [[UILabel alloc]init];
        _teacherInfo.font = TEXT_FONTSIZE_MIN;
        _teacherInfo.textColor = [UIColor colorWithHexString:@"666666"];
        [self.contentView addSubview:_teacherInfo];
        _teacherInfo.sd_layout
        .leftEqualToView(_teacherName)
        .bottomEqualToView(_headImage)
        .rightSpaceToView(self.contentView, 10)
        .heightIs(15*ScrenScale);
        
        [_teacherInfo setMaxNumberOfLinesToShow:1];
        [_teacherInfo updateLayout];
        _teacherInfo.textAlignment = NSTextAlignmentLeft;
        
        
        //万能分割线
        UIView *line = [[UIView alloc]init];
        [self.contentView addSubview:line];
        line.backgroundColor = SEPERATELINECOLOR_2;
        line.sd_layout
        .leftSpaceToView(_headImage, 0)
        .bottomSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .heightIs(0.5);
        
    }
    
    return self;
}


-(void)setModel:(TeachersSearch *)model{
    
    _model = model;
    
    [_headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar_url]];
    _teacherName.text = model.name;
    [_teachingYears setTitle:[model.teaching_years changeEnglishYearsToChinese] forState:UIControlStateNormal];
    _teacherInfo.text = [[[[[model.category stringByAppendingString:model.subject==nil?@"":model.subject]stringByAppendingString:@" | "]stringByAppendingString:model.province==nil?@"":model.province]stringByAppendingString:model.city==nil?@"":model.city]stringByAppendingString:model.school==nil?@"":model.school];
    
    if (model.gender) {
        if ([model.gender isEqualToString:@"male"]) {
            [_genderImage setImage:[UIImage imageNamed:@"男"]];
        }else{
            [_genderImage setImage:[UIImage imageNamed:@"女"]];
        }
    }else{
        
    }
    
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
