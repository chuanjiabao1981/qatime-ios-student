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
#import "UIImage+Color.h"

@implementation InteractionTeacherListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        /* 教师头像*/
        _headImage = [[UIImageView alloc]init];
//        _headImage.userInteractionEnabled = YES;
        [self.contentView addSubview:_headImage];
        
        _headImage.sd_layout
        .leftSpaceToView(self.contentView,15*ScrenScale)
        .topSpaceToView(self.contentView,15*ScrenScale)
        .widthIs(80)
        .heightEqualToWidth();
        _headImage.sd_cornerRadiusFromHeightRatio = @0.5;
        _headImage.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        _headImage.layer.borderWidth = 0.5;
        //教师名
        _teacherName = [[UILabel alloc]init];
        _teacherName.font = TITLEFONTSIZE;
        [self.contentView addSubview:_teacherName];
        _teacherName.sd_layout
        .leftSpaceToView(_headImage, 15*ScrenScale)
        .topEqualToView(_headImage)
        .autoHeightRatio(0);
        [_teacherName setSingleLineAutoResizeWithMaxWidth:400];
        
        /* 性别图标*/
        _genderImage  = [[UIImageView alloc]init];
        [self.contentView addSubview:_genderImage];
        _genderImage.sd_layout
        .leftSpaceToView(_teacherName, 10*ScrenScale)
        .centerYEqualToView(_teacherName)
        .heightRatioToView(_teacherName, 0.5)
        .widthEqualToHeight();
        
        //教龄
        _workYears = [[UIButton alloc]init];
        _workYears .titleLabel.font = [UIFont systemFontOfSize:12*ScrenScale];
        [_workYears setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [self.contentView addSubview:_workYears];
        _workYears.sd_layout
        .leftEqualToView(_teacherName)
        .centerYEqualToView(_headImage);
        [_workYears setupAutoSizeWithHorizontalPadding:5 buttonHeight:20*ScrenScale];
        _workYears.sd_cornerRadiusFromHeightRatio = @0.5;
        _workYears.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
        _workYears.layer.borderWidth = 0.6;
        _workYears.enabled = NO;
        
        //所在学校
        _school =[[UILabel alloc]init];
        _school.font = TEXT_FONTSIZE_MIN;
        _school.textColor = [UIColor colorWithHexString:@"666666"];
        [self.contentView addSubview:_school];
        _school.sd_layout
        .leftEqualToView(_teacherName)
        .bottomEqualToView(_headImage)
        .rightSpaceToView(self.contentView, 10)
        .heightIs(15*ScrenScale);
        [_school setMaxNumberOfLinesToShow:1];
        [_school updateLayout];
        _school.textAlignment = NSTextAlignmentLeft;
        
        //        /* 所在学校*/
        //        UILabel *schools =[[UILabel alloc]init];
        //        schools.font = TITLEFONTSIZE;
        //        [self addSubview:schools];
        //        schools.sd_layout
        //        .leftEqualToView(_teacherHeadImage)
        //        .topSpaceToView(_teacherHeadImage,20)
        //        .autoHeightRatio(0);
        //        [schools setSingleLineAutoResizeWithMaxWidth:200];
        //        [schools setText:@"所在学校"];
        
        //        /* 执教年数*/
        //        UILabel *workYears = [[UILabel alloc]init];
        //        workYears.font = TITLEFONTSIZE;
        //        [self addSubview:workYears];
        //        workYears.sd_layout
        //        .leftEqualToView(schools)
        //        .topSpaceToView(_workPlaceLabel,20)
        //        .autoHeightRatio(0);
        //        [workYears setSingleLineAutoResizeWithMaxWidth:200];
        //        [workYears setText:@"执教年限"];
        
        //目前不做的教师标签
        //        UILabel *teacherTag = [[UILabel alloc]init];
        //        teacherTag.font = TITLEFONTSIZE;
        //        teacherTag.text = @"教师标签";
        //        [self addSubview:teacherTag];
        //        teacherTag.sd_layout
        //        .leftEqualToView(workYears)
        //        .topSpaceToView(_workYearsLabel,20)
        //        .autoHeightRatio(0);
        //        [teacherTag setSingleLineAutoResizeWithMaxWidth:100];
        //        teacherTag.hidden = YES;
        //
        //        /* 教师简介*/
        //        _descrip =[[UILabel alloc]init];
        //        _descrip.font = TITLEFONTSIZE;
        //        [self addSubview:_descrip];
        //        _descrip.sd_layout
        //        .leftEqualToView(workYears)
        //        .topSpaceToView(_workYearsLabel,20)
        //        .autoHeightRatio(0);
        //        [_descrip setSingleLineAutoResizeWithMaxWidth:200];
        //        _descrip.text = @"自我介绍";
        
        //右箭头
        _arrowBtn = [[UIButton alloc]init];
        [self.contentView addSubview:_arrowBtn];
        _arrowBtn.sd_layout
        .centerYEqualToView(self.contentView)
        .rightSpaceToView(self.contentView, 15*ScrenScale)
        .heightIs(20)
        .widthEqualToHeight();
        [_arrowBtn setImage:[[UIImage imageNamed:@"leftArrow"]imageRedrawWithColor:TITLECOLOR] forState:UIControlStateNormal];
        _arrowBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        [_arrowBtn setEnlargeEdge:40];
        [_arrowBtn addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
        [self setupAutoHeightWithBottomView:_school bottomMargin:20*ScrenScale];
        
    }
    return self;
}
- (void)tap:(id)taps{
    
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
    _school.text = model.school_name;
    [_workYears setTitle:[model.teaching_years changeEnglishYearsToChinese] forState:UIControlStateNormal];
    
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
