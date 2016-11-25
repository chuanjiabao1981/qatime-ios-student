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
    [self addSubview:_playerView];
    /* 布局与整个视图的尺寸相同*/
    _playerView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self);
    
    /* 视图控制器*/
    _mediaControl =[[NELivePlayerControl alloc] init];
    [self addSubview:_mediaControl];
    _mediaControl.sd_layout
    .leftEqualToView(_playerView)
    .rightEqualToView(_playerView)
    .topEqualToView(_playerView)
    .bottomEqualToView(_playerView);
    
    //控制器覆盖层
    _controlOverlay =[[UIControl alloc] init];
    [_mediaControl addSubview:_controlOverlay];
    _controlOverlay.sd_layout
    .leftEqualToView(_mediaControl)
    .rightEqualToView(_mediaControl)
    .topEqualToView(_mediaControl)
    .bottomEqualToView(_mediaControl);
    
    
    //顶部控制栏
    _topControlView = [[UIView alloc] init];
    
    _topControlView.backgroundColor = [UIColor clearColor];
    _topControlView.alpha = 0.8;
    [_controlOverlay addSubview:_topControlView];
    _topControlView.sd_layout
    .leftEqualToView(_controlOverlay)
    .rightEqualToView(_controlOverlay)
    .topEqualToView(_controlOverlay)
    .heightIs(40);/* 高度40，预留修改*/
    
    
    //退出按钮
    _playQuitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playQuitBtn setImage:[UIImage imageNamed:@"btn_player_quit"] forState:UIControlStateNormal];
    _playQuitBtn.backgroundColor = [UIColor blackColor];
    _playQuitBtn.alpha = 0.8;
    //    [_playQuitBtn addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
    [_topControlView addSubview:_playQuitBtn];
    _playBtn.sd_layout
    .leftSpaceToView(_topControlView,10)
    .topEqualToView(_topControlView)
    .heightRatioToView(_topControlView,1.0f)
    .widthEqualToHeight();
    _playQuitBtn.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
    
    
    //文件名 、课程名
    _fileName = [[UILabel alloc] init ];
    _fileName.textAlignment = NSTextAlignmentCenter; //文字居中
    _fileName.textColor = [[UIColor alloc] initWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
    _fileName.font = [UIFont fontWithName:_fileName.font.fontName size:13.0];
    [_topControlView addSubview:_fileName];
    self.fileName.sd_layout
    .centerXEqualToView(_topControlView)
    .topEqualToView(_topControlView)
    .bottomEqualToView(_topControlView)
    .widthIs(screenWidth-100);
    
    

    //底部控制栏
    _bottomControlView = [[UIView alloc] initWithFrame:CGRectMake(0, screenWidth - 50, screenHeight, 50)];
    _bottomControlView.backgroundColor = [UIColor clearColor];
    _bottomControlView.alpha = 0.8;
    [_controlOverlay addSubview:_bottomControlView];
    _bottomControlView.sd_layout
    .leftEqualToView(_controlOverlay)
    .rightEqualToView(_controlOverlay)
    .bottomEqualToView(_controlOverlay)
    .heightIs(40);/* 边栏高度可变*/
    
    //播放按钮
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playBtn setImage:[UIImage imageNamed:@"btn_player_pause"] forState:UIControlStateNormal];
    _playBtn.backgroundColor = [UIColor blackColor];
    _playBtn.alpha = 0.8;
//    [_playBtn addTarget:self action:@selector(onClickPlay:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomControlView addSubview:_playBtn];
    _playBtn.sd_layout
    .leftSpaceToView(_bottomControlView,10)
    .centerYEqualToView(_bottomControlView)
    .topSpaceToView(_bottomControlView,10)
    .bottomSpaceToView(_bottomControlView,10)
    .widthEqualToHeight();
    _playBtn.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
    
    
    //暂停按钮
    _pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pauseBtn setImage:[UIImage imageNamed:@"btn_player_play"] forState:UIControlStateNormal];
    _pauseBtn.backgroundColor = [UIColor blackColor];
    _pauseBtn.alpha = 0.8;
//    [_pauseBtn addTarget:self action:@selector(onClickPause:) forControlEvents:UIControlEventTouchUpInside];
    _pauseBtn.hidden = YES;
    [_bottomControlView addSubview:_pauseBtn];
    _pauseBtn.sd_layout
    .leftEqualToView(_playBtn)
    .rightEqualToView(_playBtn)
    .topEqualToView(_playBtn)
    .bottomEqualToView(_playBtn);
    _pauseBtn.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
    
    
    //显示模式按钮
    _scaleModeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale02"] forState:UIControlStateNormal];
    if ([_mediaType isEqualToString:@"localAudio"]) {
        _scaleModeBtn.hidden = YES;
    }
//    [_scaleModeBtn addTarget:self action:@selector(onClickScaleMode:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomControlView addSubview:_scaleModeBtn];
    self.scaleModeBtn.sd_layout
    .rightSpaceToView(self.bottomControlView,0)
    .topSpaceToView(self.bottomControlView,0)
    .bottomSpaceToView(self.bottomControlView,0)
    .widthEqualToHeight();
    _scaleModeBtn.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
    
    
    //切换屏幕按钮
    _switchScreen = [[UIButton alloc]init];
    [_switchScreen setImage:[UIImage imageNamed:@"上下转换"] forState:UIControlStateNormal];
    _switchScreen.backgroundColor = [UIColor blackColor];
    _switchScreen.alpha = 0.8;
    [_bottomControlView addSubview:_switchScreen];
    _switchScreen.sd_layout
    .rightSpaceToView(_scaleModeBtn,0)
    .topEqualToView(_scaleModeBtn)
    .bottomEqualToView(_scaleModeBtn)
    .widthEqualToHeight();
    _switchScreen.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
    
    
    /* 双屏屏幕按钮*/
    _tileScreen= [[UIButton alloc]init];
    [_tileScreen setImage:[UIImage imageNamed:@"重叠"] forState:UIControlStateNormal];
    _tileScreen.backgroundColor = [UIColor blackColor];
    _tileScreen.alpha = 0.8;
    [_bottomControlView addSubview:_tileScreen];
    _tileScreen.sd_layout
    .rightSpaceToView(_switchScreen,0)
    .topEqualToView(_switchScreen)
    .bottomEqualToView(_switchScreen)
    .widthEqualToHeight();
     _tileScreen.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
    
    
    /* 弹幕开关*/
    _barrage = [[UISwitch alloc]init];
    _barrage.backgroundColor = [UIColor clearColor];
    [_bottomControlView addSubview:_barrage];
    _barrage.thumbTintColor = [UIColor grayColor];
    _barrage.backgroundColor = [UIColor blackColor];
    _barrage.alpha = 0.8;
    _barrage.sd_layout
    .rightSpaceToView(_tileScreen,10)
    .topEqualToView(_bottomControlView)
    .bottomEqualToView(_bottomControlView)
    .widthRatioToView(_tileScreen,2.0);
    
    
    
    
    
    



    
    
    
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    _liveplayer = [[NELivePlayerController alloc] initWithContentURL:_url];
    if (_liveplayer == nil) {
        
        // 返回空则表示初始化失败
        NSLog(@"player initilize failed, please tay again!");
        
    }
    _liveplayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _liveplayer.view.frame = _playerView.bounds;
    [_liveplayer setScalingMode:NELPMovieScalingModeFill];
    
    self.autoresizesSubviews = YES;
    
    [NELivePlayerController setLogLevel:NELP_LOG_DEBUG];
    
    
    /* 播放器*/
    
    _liveplayer = [[NELivePlayerController alloc] initWithContentURL:_url];
    if (_liveplayer == nil) {
        // 返回空则表示初始化失败
        NSLog(@"player initilize failed, please tay again!");
    }
    _liveplayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

    _liveplayer.view.frame = _playerView.bounds;
    [_liveplayer setScalingMode:NELPMovieScalingModeAspectFit];
    [self addSubview:_liveplayer.view];
    _liveplayer.view.sd_layout
    .leftEqualToView(_playerView)
    .rightEqualToView(_playerView)
    .topEqualToView(_playerView)
    .bottomEqualToView(_playerView);
    
    
    /* 指定媒体控制层的播放代理*/
//    _mediaControl.delegatePlayer = _liveplayer;
    
    
    
}


@end
