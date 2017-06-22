//
//  ReplayLessonsViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/6/22.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ReplayLessonsViewController.h"
#import "UIViewController+HUD.h"
#import "UIControl+RemoveTarget.h"

//屏幕模式
typedef enum : NSUInteger {
    PortraitMode,
    FullScreenMode,
} ScreenMode;
@interface ReplayLessonsViewController (){
    
    /**播放器的底视图*/
    UIView *_playerView;
    
    /**播放url*/
    //NSString *_urlString;
    
    /**屏幕模式*/
    ScreenMode _screenMode;
    /**是否全屏*/
    BOOL isFullScreen;
    
    NSTimeInterval mDuration;
    NSTimeInterval mCurrPos;
    
    /**播放器加载次数*/
    NSInteger faildTime;
    
    /**一个对象*/
    ReplayLesson *_replayLesson;
}

/**播放器相关的属性*/
@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, strong) UIControl *controlOverlay;
@property (nonatomic, strong) UIView *topControlView;
@property (nonatomic, strong) UIView *bottomControlView;
@property (nonatomic, strong) UIButton *playQuitBtn;
@property (nonatomic, strong) UILabel *fileName;

@property (nonatomic, strong) UILabel *currentTime;
@property (nonatomic, strong) UILabel *totalDuration;
@property (nonatomic, strong) UISlider *videoProgress;

@property (nonatomic, strong) UIActivityIndicatorView *bufferingIndicate;
@property (nonatomic, strong) UILabel *bufferingReminder;

@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *pauseBtn;
@property (nonatomic, strong) UIButton *audioBtn;
@property (nonatomic, strong) UIButton *muteBtn;
@property (nonatomic, strong) UIButton *scaleModeBtn;
@property (nonatomic, strong) UIButton *snapshotBtn;

@property (nonatomic, strong) UIButton *resolutionBtn;

/**控制层*/
@property(nonatomic, strong)  NELivePlayerControl *mediaControl;
@end

@implementation ReplayLessonsViewController


-(instancetype)initWithLesson:(ReplayLesson *)replayLesson{
    
    self = [super init];
    if (self) {
        
        _replayLesson = replayLesson;
    }
    return self;
}


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载播放器
    [self setupVideoPlayerWithURL:[NSURL URLWithString:@"http://baobab.wdjcdn.com/1456117847747a_x264.mp4"]];
    
    //加载播放器的监听
    [self addNotifications];
    
    /* 全屏模式的监听-->在runtime机制下不可进行屏幕旋转的时候,强制进行屏幕旋转*/
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil
     ];
    
    /* 支持全屏*/
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SupportedLandscape"];

}

/**加载主视图*/
- (void)setupMainView{
    
    _mainView = [[UIView alloc]init];
    
    
}

/**加载视频播放器*/
- (void)setupVideoPlayerWithURL:(NSURL *)urlString{
    
    if (!_videoPlayer) {
        _videoPlayer = [[NELivePlayerController alloc]initWithContentURL:urlString];
        [NELivePlayerController setLogLevel:NELP_LOG_DEFAULT];//输出详细的加载信息
        _videoPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [_videoPlayer setScalingMode:NELPMovieScalingModeAspectFit];
        
        /* 播放器的设置*/
        [_videoPlayer isLogToFile:NO];
        [_videoPlayer setBufferStrategy:NELPAntiJitter]; //本地视频和点播的速率解析
        [_videoPlayer setScalingMode:NELPMovieScalingModeAspectFit]; //设置画面显示模式，默认原始大小
        [_videoPlayer setShouldAutoplay:YES]; //设置prepareToPlay完成后是否自动播放
        [_videoPlayer setHardwareDecoder:YES]; //设置解码模式，是否开启硬件解码
        [_videoPlayer setPauseInBackground:NO]; //设置切入后台时的状态，暂停还是继续播放
        [_videoPlayer prepareToPlay]; //初始化视频文件
        
        //if (!_playerView) {
            
            [self setupVideoPlayerView];
        //}
    }
    
}

/**添加一系列监听*/
- (void)addNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerDidPreparedToPlay:) name:NELivePlayerDidPreparedToPlayNotification object:_videoPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NeLivePlayerloadStateChanged:) name:NELivePlayerLoadStateChangedNotification object:_videoPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerPlayBackFinished:) name:NELivePlayerPlaybackFinishedNotification  object:_videoPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerFirstVideoDisplayed:)name:NELivePlayerFirstVideoDisplayedNotification object:_videoPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerFirstAudioDisplayed:) name:NELivePlayerFirstAudioDisplayedNotification object:_videoPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerReleaseSuccess:) name:NELivePlayerReleaseSueecssNotification object:_videoPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerVideoParseError:) name:NELivePlayerVideoParseErrorNotification object:_videoPlayer];
    
    /* 变为全屏后的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(turnFullScreen:) name:@"FullScreen" object:nil];
    
    /* 切换回竖屏后的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(turnDownFullScreen:) name:@"TurnDownFullScreen" object:nil];
}
/**加载播放器底层视图*/
- (void)setupVideoPlayerView{
    
    _playerView = [[UIView alloc]init];
    [self.view addSubview:_playerView];
    
    _playerView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .heightIs(self.view.width_sd/16.0*9.0);
    
    UIImageView *place = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PlayerHolder"]];
    [_playerView addSubview:place];
    place.sd_layout
    .leftEqualToView(_playerView)
    .rightEqualToView(_playerView)
    .topEqualToView(_playerView)
    .bottomEqualToView(_playerView);
    
    [self setupControl];
    
    [self setupMainView];
    
    /**播放器初始化*/
    
    if (_videoPlayer==nil) {
        // 返回空则表示初始化失败
        faildTime ++;
        NSLog(@"播放器初始化失败!!!!");
        
        if (faildTime>10) {
            
            [self HUDStopWithTitle:@"播放器加载失败"];
            
        }else{
            //再次加载
            [self setupVideoPlayerWithURL:[NSURL URLWithString:@"http://baobab.wdjcdn.com/1456117847747a_x264.mp4"]];
            
        }
        
    }else{
        NSLog(@"播放器初始化成功!!!!");
        [_playerView addSubview:self.videoPlayer.view];
        self.videoPlayer.view.sd_layout
        .leftSpaceToView(_playerView, 0)
        .rightSpaceToView(_playerView, 0)
        .topSpaceToView(_playerView, 0)
        .bottomSpaceToView(_playerView, 0);
        
    }
    
}

/**加载控制层*/
- (void)setupControl{
    
    /* 媒体控制器*/
    _mediaControl =({
        
        NELivePlayerControl *_ =[[NELivePlayerControl alloc] init];
        [_ addTarget:self action:@selector(onClickMediaControl:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_];
        _.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .topSpaceToView(self.view,0)
        .autoHeightRatio(9/16.0);
        _;
    });
    
    //控制器覆盖层
    _controlOverlay =({
        UIControl *_= [[UIControl alloc] init];
        [_ addTarget:self action:@selector(onClickOverlay:) forControlEvents:UIControlEventTouchUpInside];
        [self performSelector:@selector(controlOverlayHide) withObject:nil afterDelay:5];
        
        [_mediaControl addSubview:_];
        _.sd_layout
        .leftEqualToView(_mediaControl)
        .rightEqualToView(_mediaControl)
        .topEqualToView(_mediaControl)
        .bottomEqualToView(_mediaControl);
        _;
    });
    
    //播放器顶部控制栏
    _topControlView = ({
        
        UIView *_= [[UIView alloc] init];
        _.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _.alpha = 0.8;
        [_controlOverlay addSubview:_];
        _.sd_layout
        .leftEqualToView(_controlOverlay)
        .rightEqualToView(_controlOverlay)
        .topEqualToView(_controlOverlay)
        .heightIs(40);/* 高度40，预留修改*/
        _;
    });
    
    //退出按钮
    _playQuitBtn = ({
        
        UIButton *_ =[UIButton buttonWithType:UIButtonTypeCustom];
        [_ setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        
        _.alpha = 0.8;
        [_ addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
        [_topControlView addSubview:_];
        _.sd_layout
        .leftSpaceToView(_topControlView,0)
        .topEqualToView(_topControlView)
        .heightRatioToView(_topControlView,1.0f)
        .widthEqualToHeight();
        _.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
        [_ setEnlargeEdge:10];
        _;
    });
    
    //缓冲提示
    self.bufferingIndicate = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.bufferingIndicate setCenter:CGPointMake(_mediaControl.centerX_sd, _mediaControl.centerY_sd)];
    [self.bufferingIndicate setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.bufferingIndicate.hidden = YES;
    
    self.bufferingReminder = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    [self.bufferingReminder setCenter:CGPointMake(_mediaControl.centerX_sd, _mediaControl.centerY_sd)];
    self.bufferingReminder.text = @"缓冲中";
    self.bufferingReminder.textAlignment = NSTextAlignmentCenter; //文字居中
    self.bufferingReminder.textColor = [UIColor whiteColor];
    self.bufferingReminder.hidden = YES;
    
    //底部控制栏
    _bottomControlView = ({
        UIView *_ = [[UIView alloc] init];
        _.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
        _.alpha = 0.8;
        [_controlOverlay addSubview:_];
        _.sd_layout
        .leftEqualToView(_controlOverlay)
        .rightEqualToView(_controlOverlay)
        .bottomEqualToView(_controlOverlay)
        .heightIs(40);/* 边栏高度可变*/
        
        _;
    });
    
    //播放按钮
    _playBtn = ({
        UIButton *_ =[[UIButton alloc]init];
        [_ setImage:[UIImage imageNamed:@"ZFPlayer_play"] forState:UIControlStateNormal];
        _.alpha = 0.8;
        [_ addTarget:self action:@selector(onClickPlay:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomControlView addSubview:_];
        _.sd_layout
        .leftSpaceToView(_bottomControlView,8)
        .centerYEqualToView(_bottomControlView)
        .topSpaceToView(_bottomControlView,0)
        .bottomSpaceToView(_bottomControlView,0)
        .widthEqualToHeight();
        _.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
        [_ setEnlargeEdge:10];
        _;
    });
    
    //暂停按钮
    _pauseBtn = ({
        UIButton *_= [[UIButton alloc]init];
        [_ setImage:[UIImage imageNamed:@"ZFPlayer_pause"] forState:UIControlStateNormal];
        
        _.alpha = 0.8;
        [_ addTarget:self action:@selector(onClickPause:) forControlEvents:UIControlEventTouchUpInside];
        _.hidden = YES;
        [_bottomControlView addSubview:_];
        _.sd_layout
        .leftEqualToView(_playBtn)
        .rightEqualToView(_playBtn)
        .topEqualToView(_playBtn)
        .bottomEqualToView(_playBtn);
        _.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
        [_ setEnlargeEdge:20];
        _;
    });
    
    //显示模式按钮
    _scaleModeBtn = ({
        UIButton *_= [UIButton buttonWithType:UIButtonTypeCustom];
        [_ setImage:[UIImage imageNamed:@"scale"] forState:UIControlStateNormal];
        
        [_ addTarget:self action:@selector(onClickScaleMode:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomControlView addSubview:_];
        _.sd_layout
        .rightSpaceToView(self.bottomControlView,0)
        .topSpaceToView(self.bottomControlView,0)
        .bottomSpaceToView(self.bottomControlView,0)
        .widthEqualToHeight();
        _.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
        [_ setEnlargeEdge:10];
        
        _;
    });
    
    
    //当前播放的时间点
    self.currentTime = [[UILabel alloc] init];
    [self.bottomControlView addSubview:self.currentTime];
    self.currentTime.sd_layout
    .centerYEqualToView(_playBtn)
    .leftSpaceToView(_playBtn, 5)
    .autoHeightRatio(0);
    [self.currentTime setSingleLineAutoResizeWithMaxWidth:200];
    self.currentTime.text = @"00:00:00"; //for test
    self.currentTime.textAlignment = NSTextAlignmentCenter;
    self.currentTime.textColor = [[UIColor alloc] initWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
    self.currentTime.font = [UIFont fontWithName:self.currentTime.font.fontName size:10.0];
    
    
    //文件总时长
    self.totalDuration = [[UILabel alloc] init];
    [self.bottomControlView addSubview:self.totalDuration];
    self.totalDuration.sd_layout
    .rightSpaceToView(_scaleModeBtn, 20)
    .topEqualToView(_scaleModeBtn)
    .bottomEqualToView(_scaleModeBtn);
    [self.totalDuration setSingleLineAutoResizeWithMaxWidth:200];
    self.totalDuration.text = @"--:--:--";
    self.totalDuration.textAlignment = NSTextAlignmentCenter;
    self.totalDuration.textColor = [[UIColor alloc] initWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
    self.totalDuration.font = [UIFont fontWithName:self.totalDuration.font.fontName size:10.0];
    
    //播放进度条
    self.videoProgress = [[UISlider alloc] init];
    [self.bottomControlView addSubview:self.videoProgress];
    self.videoProgress.sd_layout
    .leftSpaceToView(self.currentTime, 10)
    .topSpaceToView(self.bottomControlView, 10)
    .bottomSpaceToView(self.bottomControlView, 10)
    .rightSpaceToView(self.totalDuration, 10);
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"btn_player_slider_thumb"] forState:UIControlStateNormal];
    [[UISlider appearance] setMaximumTrackImage:[UIImage imageNamed:@"btn_player_slider_all"] forState:UIControlStateNormal];
    [[UISlider appearance] setMinimumTrackImage:[UIImage imageNamed:@"btn_player_slider_played"] forState:UIControlStateNormal];
    [self.videoProgress addTarget:self action:@selector(onClickSeek:) forControlEvents:UIControlEventTouchUpInside];
    /*
    //    切换清晰度按钮
    self.resolutionBtn = [[UIButton alloc]init];
    //                          WithFrame:CGRectMake(videoScreenHeight-60, 5, 40, 40)];
    [self.resolutionBtn setTitle:@"标清" forState:UIControlStateNormal];
    [self.resolutionBtn setTitleColor:[[UIColor alloc] initWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1] forState:UIControlStateNormal];
    [self.bottomControlView addSubview:self.resolutionBtn];
    [self.resolutionBtn addTarget:self action:@selector(chooseResolution:) forControlEvents:UIControlEventTouchUpInside];
     */
    
    //文件名 、课程名
    /*_fileName = ({
        UILabel *_=[[UILabel alloc] init ];
        _.textAlignment = NSTextAlignmentLeft; //文字居左
        _.textColor = [[UIColor alloc] initWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
        _.font = [UIFont fontWithName:_fileName.font.fontName size:13.0];
        _.hidden = YES;
        [_topControlView addSubview:_];
        _.sd_layout
        .leftSpaceToView(_playQuitBtn,0)
        .topEqualToView(_topControlView)
        .bottomEqualToView(_topControlView)
        .rightSpaceToView(_classListBtn,20);
        _;
    });*/
    
    
}



- (void)viewDidDisappear:(BOOL)animated{
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"SupportedLandscape"];
    
    [self.videoPlayer shutdown]; //退出播放并释放相关资源
    [self.videoPlayer.view removeFromSuperview];
    self.videoPlayer = nil;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerDidPreparedToPlayNotification object:_videoPlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerLoadStateChangedNotification object:_videoPlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerPlaybackFinishedNotification object:_videoPlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerFirstVideoDisplayedNotification object:_videoPlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerFirstAudioDisplayedNotification object:_videoPlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerVideoParseErrorNotification object:_videoPlayer];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:_videoPlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"TurnDownFullScreen" object:_videoPlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"FullScreen" object:_videoPlayer];
    
}


#pragma mark - 播放器的播放/停止/退出等方法

- (void)syncUIStatus:(BOOL)isSync
{
    mDuration = [self.videoPlayer duration];
    NSInteger duration = round(mDuration);
    
    mCurrPos  = [self.videoPlayer currentPlaybackTime];
    NSInteger currPos  = round(mCurrPos);
    
    self.currentTime.text = [NSString stringWithFormat:@"%02d:%02d:%02d", (int)(currPos / 3600), (int)(currPos > 3600 ? (currPos - (currPos / 3600)*3600) / 60 : currPos/60), (int)(currPos % 60)];
    
    if (duration > 0) {
        self.totalDuration.text = [NSString stringWithFormat:@"%02d:%02d:%02d", (int)(duration / 3600), (int)(duration > 3600 ? (duration - 3600 * (duration / 3600)) / 60 : duration/60), (int)(duration > 3600 ? ((duration - 3600 * (duration / 3600)) % 60) :(duration % 60))];
        self.videoProgress.value = mCurrPos;
        self.videoProgress.maximumValue = mDuration;
    } else {
        [self.videoProgress setValue:0.0f];
    }
    
    if ([self.videoPlayer playbackState] == NELPMoviePlaybackStatePlaying) {
        
        self.playBtn.hidden = YES;
        [self.playBtn removeAllTargets];
        
        self.pauseBtn.hidden = NO;
        [_bottomControlView bringSubviewToFront:self.pauseBtn];
        [self.pauseBtn addTarget:self action:@selector(onClickPause:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        self.playBtn.hidden = NO;
        [_bottomControlView bringSubviewToFront:self.playBtn];
        self.pauseBtn.hidden = YES;
        [self.pauseBtn removeAllTargets];
        
        [self.playBtn addTarget:self action:@selector(onClickPlay:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(syncUIStatus:) object:nil];
    if (!self.playQuitBtn.hidden && !isSync) {
        [self performSelector:@selector(syncUIStatus:) withObject:nil afterDelay:0.5];
    }
}

//退出播放
- (void)onClickBack:(id)sender{
    /* 非屏状态下的点击事件*/
    if (isFullScreen == NO) {
        [self.navigationController popViewControllerAnimated:YES];
        //
        
        NSLog(@"click back!");
    
        /* 全屏状态下的点击事件*/
    }else if (isFullScreen == YES){
        
        [self onClickScaleMode:self];
        
    }
}

//开始播放
- (void)onClickPlay:(id)sender{
    NSLog(@"click Play");
    [self.videoPlayer play];
    [self syncUIStatus:NO];
}

//暂停播放
- (void)onClickPause:(id)sender{
    NSLog(@"click pause");
    [self.videoPlayer pause];
    [self syncUIStatus:NO];
}

//触摸overlay
- (void)onClickOverlay:(id)sender{
    NSLog(@"click overlay");
    
    [self controlOverlayHide];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlOverlayHide) object:nil];
}
//显示模式转换
- (void)onClickScaleMode:(id)sender{
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    NSLog(@"%ld",(long)[UIDevice currentDevice].orientation);
    
    switch (self.scaleModeBtn.titleLabel.tag) {
        case 0:
            [self.scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale02"] forState:UIControlStateNormal];
            
            /* 强制转成横屏*/
            if (orientation == UIDeviceOrientationLandscapeRight) {
                [self interfaceOrientation:UIInterfaceOrientationLandscapeLeft];
            } else {
                [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
            }
            
            self.scaleModeBtn.titleLabel.tag = 1;
            break;
        case 1:
            /* 强制转成竖屏*/
            [self.scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale01"] forState:UIControlStateNormal];
            
            if (orientation ==UIInterfaceOrientationLandscapeRight) {
                
                [self interfaceOrientation:UIInterfaceOrientationPortrait];
                
            }else{
                [self interfaceOrientation:UIInterfaceOrientationPortrait];
                
            }
            self.scaleModeBtn.titleLabel.tag = 0;
            break;
            
    }
}
//在点击全屏按钮的情况下，强制改变屏幕方向
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation{
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
        
    }
    
}
//seek操作
- (void)onClickSeek:(id)sender
{
    NSLog(@"click seek");
    NSTimeInterval currentPlayTime = self.videoProgress.value;
    [self.videoPlayer setCurrentPlaybackTime:currentPlayTime];
    [self syncUIStatus:NO];
}

#pragma mark- 控制层点击事件
/* 控制层点击事件*/
- (void)onClickMediaControl:(id)sender{
    NSLog(@"click mediacontrol");
    [self controlOverlayShow];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlOverlayHide) object:nil];
    [self performSelector:@selector(controlOverlayHide) withObject:nil afterDelay:7];
    self.controlOverlay.alpha = 1.0;
    
}

/* 控制层隐藏 带动画*/
- (void)controlOverlayHide{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.controlOverlay.alpha = 0;
        NSLog(@"控制栏隐藏了");
        
        
    }];
    
    [self performSelector:@selector(hideControlOverlay) withObject:nil afterDelay:0.5];
}
/* 控制层出现,带动画*/
- (void)controlOverlayShow{
    
    [self showControlOverlay];
    
    self.controlOverlay.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.controlOverlay.alpha = 1;
        NSLog(@"控制栏出现了");
    }];
    
}

/* 控制层出现,不带动画*/
- (void)showControlOverlay{
    self.controlOverlay.hidden = NO;
}

/* 控制层隐藏 不带动画*/
- (void)hideControlOverlay{
    self.controlOverlay.hidden = YES;
}
- (void)NELivePlayerDidPreparedToPlay:(NSNotification*)notification
{
    //add some methods
    NSLog(@"NELivePlayerDidPreparedToPlay");
    [self syncUIStatus:NO];
    [self.videoPlayer play]; //开始播放
}

- (void)NeLivePlayerloadStateChanged:(NSNotification*)notification
{
    NELPMovieLoadState nelpLoadState = _videoPlayer.loadState;
    
    if (nelpLoadState == NELPMovieLoadStatePlaythroughOK)
    {
        NSLog(@"finish buffering");
        self.bufferingIndicate.hidden = YES;
        self.bufferingReminder.hidden = YES;
        [self.bufferingIndicate stopAnimating];
    }
    else if (nelpLoadState == NELPMovieLoadStateStalled)
    {
        NSLog(@"begin buffering");
        self.bufferingIndicate.hidden = NO;
        self.bufferingReminder.hidden = NO;
        [self.bufferingIndicate startAnimating];
    }
}

- (void)NELivePlayerPlayBackFinished:(NSNotification*)notification
{
    UIAlertController *alertController = NULL;
    UIAlertAction *action = NULL;
    switch ([[[notification userInfo] valueForKey:NELivePlayerPlaybackDidFinishReasonUserInfoKey] intValue])
    {
        case NELPMovieFinishReasonPlaybackEnded:
            break;
            
        case NELPMovieFinishReasonPlaybackError:
            alertController = [UIAlertController alertControllerWithTitle:@"注意" message:@"播放失败" preferredStyle:UIAlertControllerStyleAlert];
            action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
            break;
            
        case NELPMovieFinishReasonUserExited:
            break;
            
        default:
            break;
    }
}

- (void)NELivePlayerFirstVideoDisplayed:(NSNotification*)notification
{
    NSLog(@"first video frame rendered!");
}

- (void)NELivePlayerFirstAudioDisplayed:(NSNotification*)notification
{
    NSLog(@"first audio frame rendered!");
}

- (void)NELivePlayerVideoParseError:(NSNotification*)notification
{
    NSLog(@"video parse error!");
}

- (void)NELivePlayerReleaseSuccess:(NSNotification*)notification
{
    NSLog(@"resource release success!!!");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerReleaseSueecssNotification object:_videoPlayer];
}

// 支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

-(BOOL)shouldAutorotate{
    
    return YES;
}

- (void)onDeviceOrientationChange{
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown || orientation == UIDeviceOrientationPortraitUpsideDown) { return; }
    
    [self.view layoutIfNeeded];
}

//全屏播放视频后，播放器的适配和全屏旋转
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    /* 切换到竖屏*/
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self.scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale01"] forState:UIControlStateNormal];
        self.scaleModeBtn.titleLabel.tag = 0;
        
        /* 显示segment和scrollview*/
        //[self showSegmentAndScrollViews];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"TurnDownFullScreen" object:nil];
        
    }
    
    /* 切换到横屏*/
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        
        self.view.backgroundColor = [UIColor whiteColor];
        [self.scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale02"] forState:UIControlStateNormal];
        self.scaleModeBtn.titleLabel.tag = 1;
        
        /* 切换到横屏 隐藏segment和scrollview*/
       // [self hideSegementAndScrollViews];
        /* 全屏状态  发送消息通知*/
        [[NSNotificationCenter defaultCenter]postNotificationName:@"FullScreen" object:nil];
        
        
    }
}

#pragma mark- 变成全屏后的监听
- (void)turnFullScreen:(NSNotification *)notification{
    
    [self performSelector:@selector(controlOverlayHide) withObject:nil afterDelay:5];
    
    isFullScreen = YES;
    
    /* 全屏页面布局的变化*/
    _scaleModeBtn.hidden = YES;
    [self playerViewTurnFullScreenLayout];
    
    [self mediaControlTurnToFullScreenModeWithMainView:_playerView];
    
}


#pragma mark- 切回竖屏后的监听
- (void)turnDownFullScreen:(NSNotification *)notification{
    
    isFullScreen = NO;
    
    [self.view updateLayout];
    [self.view layoutIfNeeded];

    [self playerViewTurnPotraitScreenLayout];
    _scaleModeBtn.hidden = NO;
   
    [self mediaControlTurnDownFullScreenModeWithMainView:_playerView];
 
}

/**播放器变为全屏布局*/
- (void)playerViewTurnFullScreenLayout{
    
    _playerView.sd_resetLayout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0);
    [_playerView updateLayout];
    
}

/**播放器变为竖屏布局*/
- (void)playerViewTurnPotraitScreenLayout{
    
    _playerView.sd_resetLayout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .autoHeightRatio(9/16.f);
    
    [_playerView updateLayout];
    [_videoPlayer.view updateLayout];
    
}

/* 控制层变成全屏模式的方法*/
- (void)mediaControlTurnToFullScreenModeWithMainView:(__kindof UIView *)playerView{
    
    _mediaControl.hidden  = NO;
    _fileName.hidden = NO;
    [self.view bringSubviewToFront:_mediaControl];
    
    
    _topControlView.backgroundColor = [UIColor blackColor];
    _topControlView.alpha = 0.8;
    
    _bottomControlView.backgroundColor = [UIColor blackColor];
    _bottomControlView.alpha = 0.8;
    
    [_mediaControl clearAutoHeigtSettings];
    
    _mediaControl.sd_resetLayout
    .topEqualToView(playerView)
    .bottomEqualToView(playerView)
    .leftEqualToView(playerView)
    .rightEqualToView(playerView);
    [_mediaControl updateLayout];
    
    _resolutionBtn.hidden = NO;
    
    
}

/* 控制层切回竖屏模式的方法*/
- (void)mediaControlTurnDownFullScreenModeWithMainView:(__kindof UIView *)playerView{
    
    _resolutionBtn.hidden  = YES;
    
    _mediaControl.sd_resetLayout
    .topSpaceToView(self.view,0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .autoHeightRatio(9/16.0);
    _fileName.hidden = YES;
    
    [_mediaControl updateLayout];
    
    _controlOverlay.sd_resetLayout
    .topEqualToView(_mediaControl)
    .bottomEqualToView(_mediaControl)
    .leftEqualToView(_mediaControl)
    .rightEqualToView(_mediaControl);
    
    /* 恢复布局*/
    _scaleModeBtn.sd_layout
    .rightSpaceToView(self.bottomControlView,0)
    .topSpaceToView(self.bottomControlView,0)
    .bottomSpaceToView(self.bottomControlView,0)
    .widthEqualToHeight();
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
