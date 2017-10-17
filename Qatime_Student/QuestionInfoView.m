//
//  QuestionInfoView.m
//  Qatime_Student
//
//  Created by Shin on 2017/9/27.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "QuestionInfoView.h"
#import "NSString+TimeStamp.h"

@implementation QuestionInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _subTitle = [[QuestionSubTitle alloc]initWithFrame:CGRectMake(0, 0, self.width_sd, 100)];
        [self addSubview:_subTitle];
        
        _subTitle.sd_layout
        .topSpaceToView(self, 0)
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .heightIs(100);
        
        _questionContent = [[UILabel alloc]init];
        [self addSubview: _questionContent];
        _questionContent.font = TEXT_FONTSIZE_MIN;
        _questionContent.textColor = [UIColor blackColor];
        _questionContent.sd_layout
        .topSpaceToView(_subTitle, 20*ScrenScale)
        .leftSpaceToView(self, 10*ScrenScale)
        .rightSpaceToView(self, 10*ScrenScale)
        .autoHeightRatio(0);
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
       
        _photosView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _photosView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_photosView];
        _photosView.sd_layout
        .topSpaceToView(_questionContent, 10*ScrenScale)
        .leftSpaceToView(self, 10*ScrenScale)
        .rightSpaceToView(self, 10*ScrenScale)
        .heightIs((UIScreenWidth-40*ScrenScale-10)/5.f);
        
        _recorder = [[YZReorder alloc]init];
        [self addSubview:_recorder.view];
        _recorder.view.sd_layout
        .leftSpaceToView(self, 10*ScrenScale)
        .rightSpaceToView(self, 10*ScrenScale)
        .topSpaceToView(_photosView, 10*ScrenScale)
        .heightIs(40);
        
        //目前先隐藏 , 根据问题实际内容修改.
//        _photosView.hidden = YES;
//        _recorder.view.hidden = YES;
        
//        [self setupAutoHeightWithBottomView:_questionContent bottomMargin:20*ScrenScale];
        
    }
    return self;
}


- (void)setModel:(Questions *)model{
    _model = model;
    _subTitle.title.text = model.title;
    _subTitle.creat_at.text = [NSString stringWithFormat:@"创建时间: %@",[model.created_at changeTimeStampToDateString]];
    _subTitle.name.text = model.user_name;
    _questionContent.text = model.body;
    
    //先判断问题吧.
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
        model.haveRecord = NO;
    }
    
    //问题部分.整自动布局....
    if (model.haveBody) {
        _questionContent.hidden = NO;
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
                .topSpaceToView(_questionContent, 15);
                [_recorder.view updateLayout];
                [self setupAutoHeightWithBottomView:_recorder.view bottomMargin:10];
            }else{
                _recorder.view.hidden = YES;
                [self setupAutoHeightWithBottomView:_questionContent bottomMargin:20];
            }
            
        }
        
    }else{
        _questionContent.hidden = YES;
        _photosView.sd_layout
        .topSpaceToView(_subTitle, 20*ScrenScale);
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
                .topSpaceToView(_questionContent, 15);
                [_recorder.view updateLayout];
                [self setupAutoHeightWithBottomView:_recorder.view bottomMargin:10];
            }else{
                _recorder.view.hidden = YES;
                [self setupAutoHeightWithBottomView:_questionContent bottomMargin:20];
            }
        }
    }
    
}



@end
