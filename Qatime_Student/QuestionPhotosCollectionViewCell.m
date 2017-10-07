//
//  QuestionPhotosCollectionViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/8/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "QuestionPhotosCollectionViewCell.h"


@implementation QuestionPhotosCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _image = [[UIImageView alloc]init];
        [self.contentView addSubview:_image];
        _image.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .topSpaceToView(self.contentView, 5)
        .bottomSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 5);
        
        _deleteBtn = [[UIButton alloc]init];
        [self.contentView addSubview:_deleteBtn];
        [_deleteBtn setImage:[UIImage imageNamed:@"question_photo_delete"] forState:UIControlStateNormal];
        _deleteBtn.sd_layout
        .rightSpaceToView(self.contentView, 0)
        .topSpaceToView(self.contentView, 0)
        .heightRatioToView(self.contentView, 0.3f)
        .widthEqualToHeight();
        
        [_deleteBtn setEnlargeEdge:10];
        
        _effectView = [[UIView alloc]init];
        _effectView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
        [self.contentView addSubview:_effectView];
        _effectView.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .topSpaceToView(self.contentView, 0)
        .bottomSpaceToView(self.contentView, 0);
        _effectView.hidden = YES;
        
        _progress = [[M13ProgressViewRing alloc]init];
        _progress.showPercentage = YES;
        [_effectView addSubview:_progress];
        _progress.sd_layout
        .leftSpaceToView(_effectView, 5*ScrenScale)
        .rightSpaceToView(_effectView, 5*ScrenScale)
        .topSpaceToView(_effectView, 5*ScrenScale)
        .bottomSpaceToView(_effectView, 5*ScrenScale);
        
        _faildEffectView = [[UIView alloc]init];
        _faildEffectView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
        [self.contentView addSubview:_effectView];
        _faildEffectView.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .topSpaceToView(self.contentView, 0)
        .bottomSpaceToView(self.contentView, 0);
        _faildEffectView.hidden = YES;
        
        _faidBtn = [[UIButton alloc]init];
        [_faildEffectView addSubview:_faidBtn];
        [_faidBtn setTitle:@"重试" forState:UIControlStateNormal];
        [_faidBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _faidBtn.sd_layout
        .leftSpaceToView(_faildEffectView, 0)
        .rightSpaceToView(_faildEffectView, 0)
        .topSpaceToView(_faildEffectView, 10)
        .bottomSpaceToView(_faildEffectView, 10);
        
        
    }
    return self;
}

@end
