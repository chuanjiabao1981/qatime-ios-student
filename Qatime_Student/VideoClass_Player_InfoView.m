//
//  VideoClass_Player_InfoView.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/13.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "VideoClass_Player_InfoView.h"

@implementation VideoClass_Player_InfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentSize = CGSizeMake(self.width_sd, self.height_sd);
        
        //课程名
        _className = [[UILabel alloc]init];
        _className.textColor = [UIColor blackColor];
        _className.font = TITLEFONTSIZE;
        _className.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_className];
        _className.sd_layout
        .leftSpaceToView(self, 10)
        .topSpaceToView(self, 20)
        .rightSpaceToView(self, 10)
        .autoHeightRatio(0);
        
        //基本属性
        UILabel *desLabel = [[UILabel alloc]init];
        [self addSubview:desLabel];
        desLabel.textColor = [UIColor blackColor];
        desLabel.text = @"基本属性";
        desLabel.sd_layout
        .leftEqualToView(_className)
        .topSpaceToView(_className,20)
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
        
        /* 课时*/
        UIImageView *book3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self addSubview:book3];
        book3.sd_layout
        .leftEqualToView(book1);
        
        _classCount=[[UILabel alloc]init];
        _classCount.font = TEXT_FONTSIZE;
        _classCount.textColor = TITLECOLOR;
        [self addSubview:_classCount];
        _classCount.sd_layout
        .leftEqualToView(_gradeLabel)
        .topSpaceToView(_gradeLabel,10)
        .autoHeightRatio(0);
        [_classCount setSingleLineAutoResizeWithMaxWidth:150];
        
        book3.sd_layout
        .centerYEqualToView(_classCount)
        .heightRatioToView(_classCount,0.6)
        .widthEqualToHeight();
        [book3 updateLayout];
        
        /* 直播时间*/
        UIImageView *clock  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self addSubview:clock];
        clock.sd_layout
        .leftEqualToView(book3);
        
        _liveTimeLabel = [[UILabel alloc]init];
        [self addSubview:_liveTimeLabel];
        _liveTimeLabel.font = TEXT_FONTSIZE;
        _liveTimeLabel.textColor = TITLECOLOR;
        _liveTimeLabel.sd_layout
        .leftEqualToView(_classCount)
        .topSpaceToView(_classCount,10)
        .autoHeightRatio(0);
        [_liveTimeLabel setSingleLineAutoResizeWithMaxWidth:300];
        
        clock.sd_layout
        .centerYEqualToView(_liveTimeLabel)
        .heightRatioToView(_liveTimeLabel,0.6)
        .widthEqualToHeight();
        [clock updateLayout];

        
        
        
        
        
    }
    return self;
}

@end
