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
     
        UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake((UIScreenWidth-20*ScrenScale-10)*0.5, (UIScreenWidth-20*ScrenScale-10)*0.5);
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        
        _photosView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _photosView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_photosView];
        _photosView.sd_layout
        .topSpaceToView(_answer, 10*ScrenScale)
        .leftSpaceToView(self, 10*ScrenScale)
        .rightSpaceToView(self, 10*ScrenScale)
        .heightIs((UIScreenWidth-20*ScrenScale-10)*0.5*3+20);
        
        _recorder = [[YZReorder alloc]init];
        [self addSubview:_recorder.view];
        _recorder.view.sd_layout
        .leftEqualToView(_photosView)
        .rightEqualToView(_photosView)
        .topSpaceToView(_photosView, 10*ScrenScale)
        .heightIs(40);
        
        [self setupAutoHeightWithBottomView:_recorder.view bottomMargin:20];
        
    }
    return self;
}

-(void)setModel:(Answers *)model{
    _model = model;
    _created_at.text = [@"回复时间" stringByAppendingString: model.created_at.changeTimeStampToDateString];
    _answer.text = model.body;
    
//    再判断答案
    if (model.body) {
        model.haveBody = YES;
    }else{
        model.haveBody = NO;
    }
    if (model.attachments) {
        for (NSDictionary *atts in model.attachments) {
            if ([atts[@"file_type"]isEqualToString:@"png"]||[atts[@"file_type"]isEqualToString:@"jpg"]||[atts[@"file_type"]isEqualToString:@"jpeg"]) {
                model.havePhotos = YES;
            }else if ([atts[@"file_type"]isEqualToString:@"mp3"]){
                model.haveRecord = YES;
            }
        }
    }else{
        model.havePhotos = NO;
        model.haveRecord = NO;    }
//    答案部分.整自动布局....
    if (model.haveBody) {
        _answer.hidden = NO;
        if (model.havePhotos) {
            _photosView.hidden = NO;
            if (model.haveRecord) {
                _recorder.view.hidden = NO;
                [self setupAutoHeightWithBottomView:_recorder.view bottomMargin:10];
            }else{
                _recorder.view.hidden = YES;
                [self setupAutoHeightWithBottomView:_photosView bottomMargin:10];
            }
        }else{
            _photosView.hidden = YES;
            if (model.haveRecord) {
                _recorder.view.hidden = NO;
                _recorder.view.sd_layout
                .topSpaceToView(_answer, 15);
                [_recorder.view updateLayout];
                [self setupAutoHeightWithBottomView:_recorder.view bottomMargin:10];
            }else{
                    _recorder.view.hidden = YES;
                [self setupAutoHeightWithBottomView:_answer bottomMargin:20];
            }
        }
    }else{
        _answer.hidden = YES;
        _photosView.sd_layout
        .topSpaceToView(_created_at, 20*ScrenScale);
        [_photosView updateLayout];
        if (model.havePhotos) {
            _photosView.hidden = NO;
            if (model.haveRecord) {
                _recorder.view.hidden = NO;
                [self setupAutoHeightWithBottomView:_recorder.view bottomMargin:10];
            }else{
                _recorder.view.hidden = YES;
                [self setupAutoHeightWithBottomView:_photosView bottomMargin:10];
            }
        }else{
            _photosView.hidden = YES;
            if (model.haveRecord) {
                _recorder.view.hidden = NO;
                _recorder.view.sd_layout
                .topSpaceToView(_created_at, 15);
                [_recorder.view updateLayout];
                [self setupAutoHeightWithBottomView:_recorder.view bottomMargin:10];
            }else{
                _recorder.view.hidden = YES;
                [self setupAutoHeightWithBottomView:_answer bottomMargin:20];
            }
        }
    }
}

@end
