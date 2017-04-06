//
//  InteractionControl.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/29.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "InteractionControl.h"
#import "UIButton+EnlargeTouchArea.h"

@implementation InteractionControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        
        //返回按钮
        [self addSubview:self.returnButton];
        self.returnButton.sd_layout
        .leftSpaceToView(self, 15)
        .topSpaceToView(self, 15)
        .bottomSpaceToView(self, 15)
        .widthEqualToHeight();
        [self.returnButton setEnlargeEdge:15];
        
        //全屏按钮
        [self addSubview:self.scaleButton];
        self.scaleButton.sd_layout
        .topSpaceToView(self, 5)
        .bottomSpaceToView(self, 5)
        .rightSpaceToView(self, 15)
        .widthEqualToHeight();
        [self.scaleButton setEnlargeEdge:15];
        
        //摄像头按钮
        [self addSubview:self.cameraButton];
        self.cameraButton.sd_layout
        .rightSpaceToView(self.scaleButton, 10)
        .topEqualToView(self.scaleButton)
        .bottomEqualToView(self.scaleButton)
        .widthEqualToHeight();
        
        //声音话筒按钮
        [self addSubview:self.voiceButton];
        self.voiceButton.sd_layout
        .topEqualToView(self.cameraButton)
        .bottomEqualToView(self.cameraButton)
        .rightSpaceToView(self.cameraButton,10)
        .widthEqualToHeight();
        
        //标题
        [self addSubview:self.titleLabel];
        _titleLabel.sd_layout
        .leftSpaceToView(self.returnButton, 15)
        .rightSpaceToView(self.voiceButton, 15)
        .centerYEqualToView(self.returnButton)
        .autoHeightRatio(0);
        
    }
    return self;
}


#pragma mark- get method

-(UIButton *)returnButton{
    
    if (!_returnButton) {
        _returnButton = [[UIButton alloc]init];
        [_returnButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_returnButton addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _returnButton;
}

-(UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:15*ScrenScale];
    }
    return _titleLabel;
}

-(UIButton *)scaleButton{
    
    if (!_scaleButton) {
        _scaleButton = [[UIButton alloc]init];
        [_scaleButton setImage:[UIImage imageNamed:@"btn_player_scale01"] forState:UIControlStateNormal];
        [_scaleButton addTarget:self action:@selector(scaleAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scaleButton;
    
}

-(UIButton *)cameraButton{
    
    if (!_cameraButton) {
        _cameraButton = [[UIButton alloc]init];
        [_cameraButton setImage:[UIImage imageNamed:@"camera_on"] forState:UIControlStateNormal];
        [_cameraButton addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraButton;
}

-(UIButton *)voiceButton{
    
    if (!_voiceButton) {
        _voiceButton = [[UIButton alloc]init];
        
        [_voiceButton setImage:[UIImage imageNamed:@"mic_on"] forState:UIControlStateNormal];
        [_voiceButton addTarget:self action:@selector(voiceAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceButton;
}


#pragma mark- action delegate method

- (void)returnAction:(UIButton *)sender{
    
    [_delegate returnLastPage:sender];
    
}

- (void)scaleAction:(UIButton *)sender{
    
    [_delegate scale:sender];
}

- (void)cameraAction:(UIButton *)sender{
    
    [_delegate turnCamera:sender];
}

- (void)voiceAction:(UIButton *)sender{
 
    
    [_delegate turnVoice:sender];
}


@end
