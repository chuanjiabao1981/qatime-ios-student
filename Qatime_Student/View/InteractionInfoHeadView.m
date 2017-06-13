//
//  InteractionInfoHeadView.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/28.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "InteractionInfoHeadView.h"
#import "UIImageView+WebCache.h"
#import "NSString+ChangeYearsToChinese.h"

@interface InteractionInfoHeadView (){
    
    TTGTextTagConfig *_config;
    
}

@end

@implementation InteractionInfoHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
#pragma mark- 辅导班的详情页面
        
        self.backgroundColor = [UIColor whiteColor];
        /* 辅导班概况 的所有label*/
        
        /* 课程名*/
        _classNameLabel = [[UILabel alloc]init];
        _classNameLabel.font = TITLEFONTSIZE;
        [self addSubview: _classNameLabel];
        _classNameLabel.sd_layout
        .leftSpaceToView(self,10)
        .rightSpaceToView(self,20)
        .topSpaceToView(self,20)
        .autoHeightRatio(0);
        
        //基本属性
        UILabel *info = [[UILabel alloc]init];
        [self addSubview:info];
        info.font = TITLEFONTSIZE;
        info.text = @"基本属性";
        info.sd_layout
        .leftSpaceToView(self,10)
        .topSpaceToView(_classNameLabel,20)
        .autoHeightRatio(0);
        [info setSingleLineAutoResizeWithMaxWidth:100];
        
        /* 年级*/
        UIImageView *book1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self addSubview:book1];
        book1.sd_layout
        .leftEqualToView(info);
        
        _gradeLabel =[[UILabel alloc]init];
        _gradeLabel.font = TEXT_FONTSIZE;
        _gradeLabel.textColor = TITLECOLOR;
        [self addSubview:_gradeLabel];
        _gradeLabel.sd_layout
        .leftSpaceToView(book1,5)
        .topSpaceToView(info,10)
        .autoHeightRatio(0);
        [_gradeLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
        
        book1.sd_layout
        .heightRatioToView(_gradeLabel,0.6)
        .centerYEqualToView(_gradeLabel)
        .widthEqualToHeight();
        [book1 updateLayout];
        
        /**科目*/
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
        .leftSpaceToView(book2,5)
        .autoHeightRatio(0);
        [_subjectLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
        
        /**总课时长*/
        _classDuring=[[UILabel alloc]init];
        _classDuring.font = TEXT_FONTSIZE;
        _classDuring.textColor = TITLECOLOR;
        [self addSubview:_classDuring];
        _classDuring.sd_layout
        .leftEqualToView(_gradeLabel)
        .topSpaceToView(_gradeLabel,10)
        .autoHeightRatio(0);
        [_classDuring setSingleLineAutoResizeWithMaxWidth:200];
        
        UIImageView *book3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self addSubview:book3];
        
        book3.sd_layout
        .centerXEqualToView(book1)
        .widthRatioToView(book2, 1.0f)
        .heightEqualToWidth()
        .centerYEqualToView(_classDuring);

        
        /**每节课时长*/
        _classPerDuring = [[UILabel alloc]init];
        _classPerDuring.font = TEXT_FONTSIZE;
        _classPerDuring.textColor = TITLECOLOR;
        [self addSubview:_classPerDuring];
        _classPerDuring.sd_layout
        .leftEqualToView(_subjectLabel)
        .topEqualToView(_classDuring)
        .autoHeightRatio(0);
        [_classPerDuring setSingleLineAutoResizeWithMaxWidth:200];
        
        UIImageView *book3_3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self addSubview:book3_3];
        book3_3.sd_layout
        .leftEqualToView(book2)
        .rightEqualToView(book2)
        .centerYEqualToView(_classPerDuring)
        .heightEqualToWidth();

        
        /**课时*/
        _classCountLabel = [[UILabel alloc]init];
        _classCountLabel.font = TEXT_FONTSIZE;
        _classCountLabel.textColor =TITLECOLOR;
        [self addSubview:_classCountLabel];
        _classCountLabel.sd_layout
        .leftEqualToView(_classDuring)
        .topSpaceToView(_classDuring,10)
        .autoHeightRatio(0);
        [_classCountLabel setSingleLineAutoResizeWithMaxWidth:500];
        
        UIImageView *image4  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self addSubview:image4];
        image4.sd_layout
        .leftEqualToView(book1)
        .rightEqualToView(book1)
        .heightRatioToView(book1,1.0)
        .centerYEqualToView(_classCountLabel)
        .widthRatioToView(book1,1.0);
        
        
        //课程目标
        UILabel *taget = [[UILabel alloc]init];
        [self addSubview:taget];
        taget.textColor = [UIColor blackColor];
        taget.font = TITLEFONTSIZE;
        taget.text = @"课程目标";
        taget.sd_layout
        .topSpaceToView(_classCountLabel,20)
        .leftEqualToView(info)
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
        
        //适合人群
        UILabel *suit = [[UILabel alloc]init];
        [self addSubview:suit];
        suit.font = TITLEFONTSIZE;
        suit.textColor = [UIColor blackColor];
        suit.text = @"适合人群";
        suit.sd_layout
        .leftEqualToView(taget)
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
        [_descriptions setText:@"辅导简介"];
        [self addSubview:_descriptions];
        _descriptions.sd_layout
        .leftEqualToView(suit)
        .topSpaceToView(_suitable,20)
        .autoHeightRatio(0);
        [_descriptions setSingleLineAutoResizeWithMaxWidth:100];
        
        _classDescriptionLabel =[[UILabel alloc]init];
        _classDescriptionLabel.font = TITLEFONTSIZE;
        _classDescriptionLabel.isAttributedContent = YES;
        [self addSubview:_classDescriptionLabel];
        _classDescriptionLabel.sd_layout
        .leftEqualToView(_descriptions)
        .topSpaceToView(_descriptions,10)
        .autoHeightRatio(0)
        .rightSpaceToView(self,20);
        
        //自动刷新自身的高度
        [self setupAutoHeightWithBottomView:_classDescriptionLabel bottomMargin:20];
        
        
    }
    return self;
}


//赋值
- (void)setClassModel:(OneOnOneClass *)classModel{
    
    _classModel = classModel;
    _classNameLabel.text = classModel.name;
    _gradeLabel.text = classModel.grade;
    [_gradeLabel updateLayout];
    _subjectLabel.text = classModel.subject;
    [_subjectLabel updateLayout];
    
    _classPerDuring.text = @"45分钟/课";
    _classCountLabel.text = [NSString stringWithFormat:@"共%@课",classModel.lessons_count];
    _classDuring.text = @"共450分钟";
    
    
//    [_classTagsView addTags:classModel.tag_list withConfig:_config];
    
    _classTarget.text = classModel.objective;
    _suitable.text = classModel.suit_crowd;
    
    //课程简介富文本
    NSMutableAttributedString *attDesc = [[NSMutableAttributedString alloc]initWithData:[classModel.descriptions dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }  documentAttributes:nil error:nil];
    _classDescriptionLabel.attributedText = attDesc;
    

}


@end
