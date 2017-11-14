//
//  InteractiveInfo_InfoHeadView.m
//  Qatime_Student
//
//  Created by Shin on 2017/11/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "InteractiveInfo_InfoHeadView.h"

@implementation InteractiveInfo_InfoHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /** -课程介绍页- */
        UILabel *desLabel = [[UILabel alloc]init];
        desLabel.font = TITLEFONTSIZE;
        [self addSubview:desLabel];
        desLabel.textColor = [UIColor blackColor];
        desLabel.text = @"基本属性";
        desLabel.sd_layout
        .leftSpaceToView(self,10)
        .topSpaceToView(self,10)
        .autoHeightRatio(0);
        [desLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        /* 年级*/
        UIImageView *book1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self addSubview:book1];
        
        book1.sd_layout
        .leftEqualToView(desLabel);
        
        _gradeLabel =[[UILabel alloc]init];
        _gradeLabel.font = TEXT_FONTSIZE;
        _gradeLabel.textColor = TITLECOLOR;
        [self addSubview:_gradeLabel];
        _gradeLabel.sd_layout
        .leftSpaceToView(book1,5)
        .topSpaceToView(desLabel,10)
        .autoHeightRatio(0);
        [_gradeLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
        [_gradeLabel updateLayout];
        
        book1.sd_layout
        .heightRatioToView(_gradeLabel,0.6)
        .centerYEqualToView(_gradeLabel)
        .widthEqualToHeight();
        [book1 updateLayout];
        
        /* 科目*/
        UIImageView *book2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self addSubview:book2];
        book2.sd_layout
        .centerXEqualToView(self)
        .topEqualToView(book1)
        .bottomEqualToView(book1)
        .widthEqualToHeight();
        
        _subjectLabel = [[UILabel alloc]init];
        _subjectLabel.font = TEXT_FONTSIZE;
        _subjectLabel.textColor = TITLECOLOR;
        [self addSubview:_subjectLabel];
        _subjectLabel.sd_layout
        .topEqualToView(_gradeLabel)
        .bottomEqualToView(_gradeLabel)
        .leftSpaceToView(book2,5);
        [_subjectLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
        
        
        /**总分钟数*/
        _totalMinutesLabel = [[UILabel alloc]init];
        _totalMinutesLabel.font = TEXT_FONTSIZE;
        _totalMinutesLabel.textColor = TITLECOLOR;
        [self addSubview:_totalMinutesLabel];
        _totalMinutesLabel.sd_layout
        .leftEqualToView(_gradeLabel)
        .topSpaceToView(_gradeLabel, 10)
        .autoHeightRatio(0);
        [_totalMinutesLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        UIImageView *book3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self addSubview:book3];
        book3.sd_layout
        .leftEqualToView(book1)
        .rightEqualToView(book1)
        .centerYEqualToView(_totalMinutesLabel)
        .heightRatioToView(_totalMinutesLabel, 0.6);
        
        //每节课的时长
        
        _minutesLabel = [[UILabel alloc]init];
        _minutesLabel.font = TEXT_FONTSIZE;
        _minutesLabel.textColor = TITLECOLOR;
        [self addSubview:_minutesLabel];
        _minutesLabel.sd_layout
        .leftEqualToView(_subjectLabel)
        .topSpaceToView(_subjectLabel, 10)
        .autoHeightRatio(0);
        [_minutesLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        UIImageView *book4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self addSubview:book4];
        book4.sd_layout
        .leftEqualToView(book2)
        .rightEqualToView(book2)
        .centerYEqualToView(_minutesLabel)
        .heightRatioToView(_minutesLabel, 0.6);
        
        
        //总课时
        _classCount= [[UILabel alloc]init];
        _classCount.font = TEXT_FONTSIZE;
        _classCount.textColor = TITLECOLOR;
        [self addSubview:_classCount];
        _classCount.sd_layout
        .leftEqualToView(_totalMinutesLabel)
        .topSpaceToView(_totalMinutesLabel, 10)
        .autoHeightRatio(0);
        [_classCount setSingleLineAutoResizeWithMaxWidth:100];
        
        UIImageView *book5 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self addSubview:book5] ;
        book5.sd_layout
        .leftEqualToView(book3)
        .rightEqualToView(book3)
        .centerYEqualToView(_classCount)
        .heightRatioToView(_classCount, 0.6);
        
        //适合人群
        UILabel *suit = [[UILabel alloc]init];
        [self addSubview:suit];
        suit.font = TITLEFONTSIZE;
        suit.textColor = [UIColor blackColor];
        suit.text = @"适合人群";
        suit.sd_layout
        .leftEqualToView(book5)
        .topSpaceToView(_classCount,20)
        .autoHeightRatio(0);
        [suit setSingleLineAutoResizeWithMaxWidth:100];
        
        _suitable = [[UILabel alloc]init];
        _suitable.font = TEXT_FONTSIZE;
        _suitable.textColor = TITLECOLOR;
        _suitable.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_suitable];
        _suitable.sd_layout
        .leftEqualToView(suit)
        .topSpaceToView(suit,10)
        .autoHeightRatio(0)
        .rightSpaceToView(self,20);
        
        
        //课程目标
        UILabel *taget = [[UILabel alloc]init];
        [self addSubview:taget];
        taget.textColor = [UIColor blackColor];
        taget.font = TITLEFONTSIZE;
        taget.text = @"课程目标";
        taget.sd_layout
        .leftEqualToView(suit)
        .topSpaceToView(_suitable,20)
        .autoHeightRatio(0);
        [taget setSingleLineAutoResizeWithMaxWidth:100];
        
        _classTarget = [[UILabel alloc]init];
        [self addSubview:_classTarget];
        _classTarget.font = TEXT_FONTSIZE;
        _classTarget.textColor = TITLECOLOR;
        
        _classTarget.sd_layout
        .topSpaceToView(taget,10)
        .leftEqualToView(taget)
        .rightSpaceToView(self,20)
        .autoHeightRatio(0);
        
        
        
        /* 辅导简介*/
        _descriptions=[[UILabel alloc]init];
        _descriptions.font = TITLEFONTSIZE;
        [self addSubview:_descriptions];
        _descriptions.sd_layout
        .leftEqualToView(suit)
        .topSpaceToView(_classTarget,20)
        .autoHeightRatio(0);
        [_descriptions setSingleLineAutoResizeWithMaxWidth:100];
        [_descriptions setText:@"详细说明"];
        
        _classDescriptionLabel =[UILabel new];
        _classDescriptionLabel.font = TITLEFONTSIZE;
        _classDescriptionLabel.isAttributedContent = YES;
        [self addSubview:_classDescriptionLabel];
        _classDescriptionLabel.sd_layout
        .leftEqualToView(_descriptions)
        .topSpaceToView(_descriptions,20)
        .autoHeightRatio(0)
        .rightSpaceToView(self,20);
        
        _features = [[UILabel alloc]init];
        _features.font = [UIFont systemFontOfSize:20*ScrenScale];
        _features.textColor = [UIColor blackColor];
        _features.text = @"课程特色";
        [self addSubview:_features];
        _features.sd_layout
        .centerXEqualToView(self)
        .topSpaceToView(_classDescriptionLabel, 40*ScrenScale)
        .autoHeightRatio(0);
        [_features setSingleLineAutoResizeWithMaxWidth:3000];
        [_features updateLayout];
        
    }
    return self;
}

-(void)setModel:(OneOnOneClass *)model{
    _model = model;
    
    _gradeLabel.text = model.grade;
    _subjectLabel.text = model.subject;
    
    _totalMinutesLabel.text = @"共450分钟";
    _minutesLabel.text = @"45分钟/课";
    _classCount.text = [NSString stringWithFormat:@"共%@课",model.lessons_count];
    
    _suitable.text = model.suit_crowd;
    _classTarget.text = model.objective;
    _classDescriptionLabel.attributedText = model.attributeDescriptions;
    
    
    
}

@end
