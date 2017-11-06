//
//  VideoClassBuyBar.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/13.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "VideoClassBuyBar.h"

@implementation VideoClassBuyBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = SEPERATELINECOLOR;
        [self addSubview:line];
        line.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(self, 0)
        .heightIs(0.5);
        
        _rightButton = [[UIButton alloc]init];
        _rightButton.titleLabel.font = TEXT_FONTSIZE;
        _rightButton.layer.borderColor = NAVIGATIONRED.CGColor;
        _rightButton.layer.borderWidth = 1;
        [_rightButton setTitle:@"立即学习" forState:UIControlStateNormal];
        [_rightButton setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
        [self addSubview:_rightButton];
        _rightButton.sd_layout
        .topSpaceToView(self, 10*ScrenScale)
        .bottomSpaceToView(self, 10*ScrenScale)
        .rightSpaceToView(self, 10*ScrenScale)
        .widthIs(self.width_sd/4-15*ScrenScale);
        [_rightButton updateLayout];
        
        [_rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _leftButton = [[UIButton alloc]init];
        _leftButton.titleLabel.font = TEXT_FONTSIZE;
        [self addSubview:_leftButton];
        _leftButton.sd_layout
        .topEqualToView(_rightButton)
        .bottomEqualToView(_rightButton)
        .rightSpaceToView(_rightButton, 10*ScrenScale)
        .widthRatioToView(_rightButton, 1.0);
        [_leftButton updateLayout];
        
        [_leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _shareButton = [[UIButton alloc]init];
        [_shareButton setImage:[UIImage imageNamed:@"share_black"] forState:UIControlStateNormal];
        [self addSubview:_shareButton];
        _shareButton.sd_layout
        .leftSpaceToView(self, 15*ScrenScale)
        .topSpaceToView(self, 10*ScrenScale)
        .bottomSpaceToView(self, 10*ScrenScale)
        .widthEqualToHeight();
        [_shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)leftButtonAction:(UIButton *)sender{
    
    [_delegate enterTaste:sender];
    
}

- (void)rightButtonAction:(UIButton *)sender{
    
    [_delegate enterStudy:sender];
}

- (void)shareButtonAction:(UIButton *)sender{
    
    [_delegate shareVideoClass:sender];
}




@end
