//
//  AnswerInfoView.m
//  Qatime_Student
//
//  Created by Shin on 2017/9/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "AnswerInfoView.h"
#import "NSString+TimeStamp.h"

@implementation AnswerInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *tit = [[UILabel alloc]init];
        [self addSubview:tit];
        tit.font = TITLEFONTSIZE;
        tit.textColor = [UIColor blackColor];
        tit.sd_layout
        .leftSpaceToView(self, 10*ScrenScale)
        .topSpaceToView(self, 10*ScrenScale)
        .autoHeightRatio(0);
        [tit setSingleLineAutoResizeWithMaxWidth:200];
        tit.text = @"回答:";
        
        _created_at= [[UILabel alloc]init];
        [self addSubview:_created_at];
        _created_at.font = TEXT_FONTSIZE;
        _created_at.textColor = TITLECOLOR;
        _created_at.sd_layout
        .leftSpaceToView(self, 10*ScrenScale)
        .topSpaceToView(tit, 10*ScrenScale)
        .autoHeightRatio(0);
        [_created_at setSingleLineAutoResizeWithMaxWidth:600];
        
        _answer =[[UILabel alloc]init];
        [self addSubview:_answer];
        _answer.font = TEXT_FONTSIZE;
        _answer.textColor = TITLECOLOR;
        _answer.textAlignment = NSTextAlignmentLeft;
        _answer.sd_layout
        .leftSpaceToView(self, 10*ScrenScale)
        .topSpaceToView(_created_at, 15*ScrenScale)
        .rightSpaceToView(self, 10*ScrenScale)
        .autoHeightRatio(0);
        
        [self setupAutoHeightWithBottomView:_answer bottomMargin:20];
         
    }
    return self;
}

-(void)setModel:(Answers *)model{
    _model = model;
    _created_at.text = [@"回复时间" stringByAppendingString: model.created_at.changeTimeStampToDateString];
    _answer.text = model.body;
}

@end
