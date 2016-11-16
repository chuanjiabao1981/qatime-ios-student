//
//  RtmpPlayer.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/17.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "RtmpPlayer.h"
#import "NELivePlayerControl.h"

@interface RtmpPlayer (){
    
    CGFloat screenWidth;
    CGFloat screenHeight;
}



@end


@implementation RtmpPlayer

NSTimeInterval mDuration;
NSTimeInterval mCurrPos;
CGFloat screenWidth;
CGFloat screenHeight;
bool isHardware = YES;
bool ismute     = NO;

//当前屏幕宽高

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        screenWidth  = CGRectGetWidth([UIScreen mainScreen].bounds);
        screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
        
        
        [self makePlayerView];
        
        
        
        
        
        
    }
    return self;
}

#pragma mark- 创建播放器视图
- (void)makePlayerView{
    
#pragma mark- 最底下的播放层
    /* 最底下的播放层*/
    _playerView =[[UIView alloc]init];
    [self.view addSubview:_playerView];
    /* 布局与整个视图的尺寸相同*/
    _playerView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self);
    
    /* 视图控制器页面*/
    _mediaControl =[[NELivePlayerControl alloc] init];
    [_playerView addSubview:_mediaControl];
    self.mediaControl.sd_layout
    .leftEqualToView(_playerView)
    .rightEqualToView(_playerView)
    .topEqualToView(_playerView)
    .bottomEqualToView(_playerView);

    
    
    
    
    
    
    

}


@end
