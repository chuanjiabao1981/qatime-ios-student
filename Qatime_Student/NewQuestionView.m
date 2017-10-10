//
//  NewQuestionView.m
//  Qatime_Student
//
//  Created by Shin on 2017/8/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "NewQuestionView.h"
#import "UITextView+Placeholder.h"


#define WIDTHS [UIScreen mainScreen].bounds.size.width

@implementation NewQuestionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BACKGROUNDGRAY;
        
        self.contentSize = CGSizeMake(frame.size.width, 100);
        //title和边框
        _titleLine = [[UIView alloc]init];
        [self addSubview:_titleLine];
        _titleLine.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        _titleLine.layer.borderWidth = 1;
        _titleLine.backgroundColor = [UIColor whiteColor];
        _titleLine.sd_layout
        .leftSpaceToView(self, 15*ScrenScale)
        .topSpaceToView(self, 20*ScrenScale)
        .heightIs(40)
        .rightSpaceToView(self, 15*ScrenScale);
        
        _title = [[UITextField alloc]init];
        [_titleLine addSubview:_title];
        _title.backgroundColor = [UIColor whiteColor];
        _title.font = TEXT_FONTSIZE;
        _title.placeholder = @"输入提问标题（最多20字）";
        _title.sd_layout
        .leftSpaceToView(_titleLine, 10*ScrenScale)
        .rightSpaceToView(_titleLine, 10*ScrenScale)
        .topSpaceToView(_titleLine, 10*ScrenScale)
        .bottomSpaceToView(_titleLine, 10*ScrenScale);
        
        
        //问题 和 边框
        _questionLine = [[UIView alloc]init];
        [self addSubview:_questionLine];
        _questionLine.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        _questionLine.layer.borderWidth = 1;
        _questionLine.backgroundColor = [UIColor whiteColor];
        _questionLine.sd_layout
        .leftEqualToView(_titleLine)
        .rightEqualToView(_titleLine)
        .topSpaceToView(_titleLine, 15*ScrenScale)
        .heightIs(200);
        
        _questions = [[UITextView alloc]init];
        [_questionLine addSubview:_questions];
        _questions.backgroundColor = [UIColor whiteColor];
        _questions.font = TEXT_FONTSIZE;
        _questions.placeholderLabel.font = TEXT_FONTSIZE;
        _questions.placeholder = @"输入提问内容";
        _questions.sd_layout
        .leftSpaceToView(_questionLine, 10*ScrenScale)
        .topSpaceToView(_questionLine, 10*ScrenScale)
        .rightSpaceToView(_questionLine, 10*ScrenScale)
        .bottomSpaceToView(_questionLine, 10*ScrenScale);
        [_questionLine updateLayout];
        
        //照片
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake((WIDTHS -30*ScrenScale-40)/5.f, (WIDTHS -30*ScrenScale-40)/5.f);
        layout.minimumInteritemSpacing = 10;
        _photosView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _photosView.backgroundColor = [UIColor clearColor];
        _photosView.scrollEnabled = NO;
        [self addSubview:_photosView];
        _photosView.sd_layout
        .leftEqualToView(_questionLine)
        .rightEqualToView(_questionLine)
        .topSpaceToView(_questionLine, 20*ScrenScale)
        .heightIs((WIDTHS -30*ScrenScale-40)/5.f);
                
        _recorder = [[YZReorder alloc]init];
        [self addSubview:_recorder.view];
        _recorder.view.sd_layout
        .leftEqualToView(_questionLine)
        .rightEqualToView(_questionLine)
        .topSpaceToView(_photosView, 20*ScrenScale)
        .heightRatioToView(_titleLine, 1.0);
        
//        _photosView.hidden = YES;
//        _recorder.view.hidden = YES;
        
        [self setupAutoContentSizeWithBottomView:_recorder.view bottomMargin:20];
        
    }
    return self;
}

@end
