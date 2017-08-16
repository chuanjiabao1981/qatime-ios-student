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
        UIView *titleLine = [[UIView alloc]init];
        [self addSubview:titleLine];
        titleLine.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        titleLine.layer.borderWidth = 1;
        titleLine.backgroundColor = [UIColor whiteColor];
        titleLine.sd_layout
        .leftSpaceToView(self, 15*ScrenScale)
        .topSpaceToView(self, 20*ScrenScale)
        .heightIs(40)
        .rightSpaceToView(self, 15*ScrenScale);
        
        _title = [[UITextField alloc]init];
        [titleLine addSubview:_title];
        _title.backgroundColor = [UIColor whiteColor];
        _title.placeholder = @"输入提问标题（最多20字）";
        _title.sd_layout
        .leftSpaceToView(titleLine, 10*ScrenScale)
        .rightSpaceToView(titleLine, 10*ScrenScale)
        .topSpaceToView(titleLine, 10*ScrenScale)
        .bottomSpaceToView(titleLine, 10*ScrenScale);
        
        
        //问题 和 边框
        UIView *questionLine = [[UIView alloc]init];
        [self addSubview:questionLine];
        questionLine.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        questionLine.layer.borderWidth = 1;
        questionLine.backgroundColor = [UIColor whiteColor];
        questionLine.sd_layout
        .leftEqualToView(titleLine)
        .rightEqualToView(titleLine)
        .topSpaceToView(titleLine, 15*ScrenScale)
        .heightIs(200);
        
        _questions = [[UITextView alloc]init];
        [questionLine addSubview:_questions];
        _questions.backgroundColor = [UIColor whiteColor];
        _questions.font = TEXT_FONTSIZE;
        _questions.placeholderLabel.font = TEXT_FONTSIZE;
        _questions.placeholder = @"输入提问标题（最多100字）";
        _questions.sd_layout
        .leftSpaceToView(questionLine, 10*ScrenScale)
        .topSpaceToView(questionLine, 10*ScrenScale)
        .rightSpaceToView(questionLine, 10*ScrenScale)
        .bottomSpaceToView(questionLine, 10*ScrenScale);
        [questionLine updateLayout];
        
        //照片
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake((WIDTHS -30*ScrenScale-40)/5.f, (WIDTHS -30*ScrenScale-40)/5.f);
        layout.minimumInteritemSpacing = 10;
        _photosView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _photosView.backgroundColor = [UIColor clearColor];
        _photosView.scrollEnabled = NO;
        [self addSubview:_photosView];
        _photosView.sd_layout
        .leftEqualToView(questionLine)
        .rightEqualToView(questionLine)
        .topSpaceToView(questionLine, 20*ScrenScale)
        .heightIs((WIDTHS -30*ScrenScale-40)/5.f);
                
        //录音
        _recordView = [[UIView alloc]init];
        [self addSubview:_recordView];
        _recordView.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        _recordView.layer.borderWidth = 1;
        _recordView.backgroundColor = [UIColor whiteColor];
        _recordView.sd_layout
        .leftEqualToView(titleLine)
        .rightEqualToView(titleLine)
        .topSpaceToView(_photosView, 20*ScrenScale)
        .heightRatioToView(titleLine, 1.0f);
        
        
        //右侧多功能按钮
        _rightBtn = [[UIButton alloc]init];
        [_recordView addSubview:_rightBtn];
        [_rightBtn setImage:[UIImage imageNamed:@"question_record"] forState:UIControlStateNormal];
        _rightBtn.sd_layout
        .topSpaceToView(_recordView, 5*ScrenScale)
        .rightSpaceToView(_recordView, 5*ScrenScale)
        .bottomSpaceToView(_recordView, 5*ScrenScale)
        .widthEqualToHeight();
        
        _secend = [[UILabel alloc]init];
        _secend.text = @"60'";
        [_recordView addSubview:_secend];
        _secend.font = TEXT_FONTSIZE_MIN;
        _secend.textColor = TITLECOLOR;
        _secend.sd_layout
        .rightSpaceToView(_rightBtn, 10*ScrenScale)
        .centerYEqualToView(_rightBtn)
        .autoHeightRatio(0);
        [_secend setSingleLineAutoResizeWithMaxWidth:200];
        
        _slider = [[YZSlider alloc]init];
        _slider.enabled = NO;
        [_recordView addSubview:_slider];
        _slider.sd_layout
        .rightSpaceToView(_secend, 10*ScrenScale)
        .centerYEqualToView(_secend)
        .heightRatioToView(_secend, 1.0f)
        .leftSpaceToView(_recordView, 10*ScrenScale);
        
        _playBtn = [[UIButton alloc]init];
        [_playBtn setImage:[UIImage imageNamed:@"question_play"] forState:UIControlStateNormal];
        [_recordView addSubview:_playBtn];
        _playBtn.sd_layout
        .topEqualToView(_rightBtn)
        .bottomEqualToView(_rightBtn)
        .leftSpaceToView(_recordView, 10*ScrenScale)
        .widthEqualToHeight();
        _playBtn.hidden = YES;
        
        [self setupAutoContentSizeWithBottomView:_recordView bottomMargin:20];
        
        
    }
    return self;
}

@end
