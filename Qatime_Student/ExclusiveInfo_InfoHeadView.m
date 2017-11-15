//
//  ExclusiveInfo_InfoHeadView.m
//  Qatime_Student
//
//  Created by Shin on 2017/11/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ExclusiveInfo_InfoHeadView.h"
#import "NSString+HTML.h"
#import "YYText.h"
#import "NSString+TimeStamp.h"

@implementation ExclusiveInfo_InfoHeadView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
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
        [_liveTimeLabel setSingleLineAutoResizeWithMaxWidth:2000];
        
        clock.sd_layout
        .centerYEqualToView(_liveTimeLabel)
        .heightRatioToView(_liveTimeLabel,0.6)
        .widthEqualToHeight();
        [clock updateLayout];
        
        
        //课程目标
        _taget = [[UILabel alloc]init];
        [self addSubview:_taget];
        _taget.textColor = [UIColor blackColor];
        _taget.font = TITLEFONTSIZE;
        _taget.text = @"课程目标";
        _taget.sd_layout
        .leftEqualToView(desLabel)
        .topSpaceToView(_liveTimeLabel,20)
        .autoHeightRatio(0);
        [_taget setSingleLineAutoResizeWithMaxWidth:100];
        
        _classTarget = [[UILabel alloc]init];
        [self addSubview:_classTarget];
        _classTarget.font = TEXT_FONTSIZE;
        _classTarget.textColor = TITLECOLOR;
        
        _classTarget.sd_layout
        .topSpaceToView(_taget,10)
        .leftEqualToView(_taget)
        .rightSpaceToView(self,20)
        .autoHeightRatio(0);
        
        //适合人群
        UILabel *suit = [[UILabel alloc]init];
        [self addSubview:suit];
        suit.font = TITLEFONTSIZE;
        suit.textColor = [UIColor blackColor];
        suit.text = @"适合人群";
        suit.sd_layout
        .leftEqualToView(_taget)
        .topSpaceToView(_classTarget,20)
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
        
        
        /* 辅导简介*/
        _descriptions=[[UILabel alloc]init];
        _descriptions.font = TITLEFONTSIZE;
        [self addSubview:_descriptions];
        _descriptions.sd_layout
        .leftEqualToView(suit)
        .topSpaceToView(_suitable,20)
        .autoHeightRatio(0);
        [_descriptions setSingleLineAutoResizeWithMaxWidth:100];
        [_descriptions setText:@"辅导简介"];
        
        _classDescriptionLabel =[UILabel new];
        _classDescriptionLabel.font = TEXT_FONTSIZE;
        _classDescriptionLabel.textColor = TITLECOLOR;
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

-(void)setModel:(ExclusiveInfo *)model{
    
    _model = model;
    _gradeLabel.text = model.grade;
    _subjectLabel.text = model.subject;
    _classCount.text = [NSString stringWithFormat:@"共%@课",model.events_count];
    _liveTimeLabel.text = [NSString stringWithFormat:@"%@ 至 %@",model.start_at?[model.start_at.changeTimeStampToDateString substringToIndex:10]:@"",model.end_at?[model.end_at.changeTimeStampToDateString substringToIndex:10]:@""];
    [_liveTimeLabel updateLayout];
    _suitable.text = [model.suit_crowd isEqual:[NSNull null]]?@"无":model.suit_crowd;
    
    NSMutableAttributedString *attDesc;
    if (model.descriptions) {
        if ([[NSString getPureStringwithHTMLString:model.descriptions]isEqualToString:model.descriptions]) {
            //不包html富文本
            _classDescriptionLabel.text = model.descriptions;
            _classDescriptionLabel.isAttributedContent = NO;
        }else{
            attDesc = [[NSMutableAttributedString alloc]initWithData:[model.descriptions?[@"" stringByAppendingString:model.descriptions]:@" " dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            if ([attDesc.yy_font.familyName isEqualToString:@"Times New Roman"]&& attDesc.yy_font.pointSize == 12) {
                attDesc.yy_font = [UIFont fontWithName:@".SF UI Text" size:16*ScrenScale];
                attDesc.yy_color = TITLECOLOR;
            }else if ([attDesc.yy_font.familyName isEqualToString:@"Times New Roman"]&&attDesc.yy_font.pointSize != 12){
                attDesc.yy_font = [UIFont fontWithName:@".SF UI Text" size:attDesc.yy_font.pointSize];
                attDesc.yy_color = TITLECOLOR;
            }
            //判断是否有字号,没有的话加上.
            _classDescriptionLabel.attributedText = attDesc;
            _classDescriptionLabel.isAttributedContent = YES;
        }
    }
    
    [_classDescriptionLabel updateLayout];
    [_features updateLayout];
}
@end
