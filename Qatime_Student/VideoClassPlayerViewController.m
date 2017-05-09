
//
//  VideoClassPlayerViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/12.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "VideoClassPlayerViewController.h"
#import "VideoClassPlayerView.h"
#import "VideoClassProgressTableViewCell.h"
#import "VideoClassFullScreenListTableViewCell.h"
#import "UIView+PlaceholderImage.h"
#import "UIViewController+HUD.h"
#import "TeachersPublicViewController.h"

//屏幕模式
typedef enum : NSUInteger {
    PortraitMode,
    FullScreenMode,
} ScreenMode;

@interface VideoClassPlayerViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    
    /**播放器的底视图*/
    UIView *_playerView;
    
    /**课程数据*/
    NSMutableArray <VideoClass *>*_classListArray;
    
    /**教师详情数据*/
    Teacher *_teacher;
    
    /**课程详情信息*/
    VideoClassInfo *_classInfo;
    
    /**选中的条目->正在播放的条目*/
    NSIndexPath *_indexPath;
    
    /**屏幕模式*/
    ScreenMode _screenMode;
    
    /**播放源数组*/
    //    NSMutableArray *datas;
    
    /**初始化的播放源*/
    NSString *_urlString;
    
    /**是否全屏*/
    BOOL isFullScreen;
    
    NSTimeInterval mDuration;
    NSTimeInterval mCurrPos;
    
    /**播放器加载次数*/
    NSInteger faildTime;
}
/**主视图*/
@property (nonatomic, strong) VideoClassPlayerView *mainView ;

/**全屏模式下的选课列表*/
@property (nonatomic, strong) UITableView *classList ;


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

/**全屏状态下的课程列表按钮*/
@property (nonatomic, strong) UIButton *classListBtn ;

/**控制层*/
@property(nonatomic, strong)  NELivePlayerControl *mediaControl;

@end

@implementation VideoClassPlayerViewController

//初始化方法
-(instancetype)initWithClasses:(__kindof NSArray<VideoClass *> *)classes andTeacher:(Teacher *)teacher andVideoClassInfos:(VideoClassInfo *)classInfo andURLString:(NSString * _Nullable)URLString andIndexPath:(NSIndexPath * _Nullable)indexPath{
    
    self = [super init];
    if (self) {
        
        _classListArray = [NSMutableArray arrayWithArray:classes];
        _teacher = teacher;
        _classInfo = classInfo;
        
        if (URLString ==nil) {
            
            _urlString = [NSString stringWithFormat:@"%@",_classListArray[0].video.name_url];
            
        }else{
            _urlString = [NSString stringWithFormat:@"%@",URLString];
        }
        
        
        if (indexPath == nil) {
            _indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        }else{
            
            _indexPath = indexPath;
        }
        
    }
    return self;
    
}




- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _screenMode = PortraitMode;
    
     faildTime = 0;
    
    //加载播放器
    [self setupVideoPlayerWithURL:_urlString];
    
    //加载播放器的监听
    [self addNotifications];
    
    /* 全屏模式的监听-->在runtime机制下不可进行屏幕旋转的时候,强制进行屏幕旋转*/
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil
     ];
    
    /* 支持全屏*/
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SupportedLandscape"];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([change[@"new"] integerValue]==0) {
        
        NSLog(@"切回竖屏模式");
    }else{
        NSLog(@"切换至全屏模式");
    }
    
}

/**加载视频播放器*/
- (void)setupVideoPlayerWithURL:(NSString *)urlString{
    
    if (!_videoPlayer) {
        _videoPlayer = [[NELivePlayerController alloc]initWithContentURL:[NSURL URLWithString:urlString]];
        
        _videoPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [_videoPlayer setScalingMode:NELPMovieScalingModeAspectFit];
        
        /* 播放器的设置*/
        [_videoPlayer isLogToFile:YES];
        [_videoPlayer setBufferStrategy:NELPLowDelay]; //直播低延时模式
        [_videoPlayer setScalingMode:NELPMovieScalingModeAspectFit]; //设置画面显示模式，默认原始大小
        [_videoPlayer setShouldAutoplay:YES]; //设置prepareToPlay完成后是否自动播放
        [_videoPlayer setHardwareDecoder:NO]; //设置解码模式，是否开启硬件解码
        [_videoPlayer setPauseInBackground:NO]; //设置切入后台时的状态，暂停还是继续播放
        [_videoPlayer prepareToPlay]; //初始化视频文件
        
        if (!_playerView) {
            
            [self setupVideoPlayerView];
        }
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
    
    //文件名 、课程名
    _fileName = ({
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
        .rightSpaceToView(_topControlView,0);
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
        [_playBtn addTarget:self action:@selector(onClickPlay:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomControlView addSubview:_];
        _.sd_layout
        .leftSpaceToView(_bottomControlView,0)
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
        [_pauseBtn addTarget:self action:@selector(onClickPause:) forControlEvents:UIControlEventTouchUpInside];
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
    self.currentTime = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, 50, 20)];
    [self.bottomControlView addSubview:self.currentTime];
    self.currentTime.sd_layout
    .centerYEqualToView(_playBtn)
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
    self.totalDuration.font = [UIFont fontWithName:self.totalDuration.font.fontName size:13.0];
    
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
    
    
//    切换清晰度按钮
    self.resolutionBtn = [[UIButton alloc]init];
//                          WithFrame:CGRectMake(videoScreenHeight-60, 5, 40, 40)];
    [self.resolutionBtn setTitle:@"标清" forState:UIControlStateNormal];
    [self.resolutionBtn setTitleColor:[[UIColor alloc] initWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1] forState:UIControlStateNormal];
    [self.bottomControlView addSubview:self.resolutionBtn];
    [self.resolutionBtn addTarget:self action:@selector(chooseResolution:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //课程列表
    _classList = [[UITableView alloc]init];
    [_controlOverlay addSubview:_classList];
    _classList.delegate = self;
    _classList.dataSource =self;
    _classList.tag = 3;
    _classList.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    _classList.alpha = 0.8f;
    _classList.sd_layout
    .rightSpaceToView(_controlOverlay, 0)
    .topSpaceToView(_topControlView, 0)
    .bottomSpaceToView(_bottomControlView, 0)
    .widthRatioToView(_controlOverlay, 1/3.0);
    _classList.hidden  = YES;
    _classList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //弹出课程列表的按钮
    _classListBtn = [[UIButton alloc]init];
    [_topControlView addSubview:_classListBtn];
    [_classListBtn setImage:[UIImage imageNamed:@"class"] forState:UIControlStateNormal];
    [_classListBtn addTarget:self action:@selector(onClickClassList:) forControlEvents:UIControlEventTouchUpInside];
    _classListBtn .sd_layout
    .rightSpaceToView(_topControlView, 30*ScrenScale)
    .topSpaceToView(_topControlView, 10)
    .bottomSpaceToView(_topControlView, 10)
    .widthEqualToHeight();
    [_classListBtn setEnlargeEdge:20];
    _classListBtn.hidden = YES;
    
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
        self.pauseBtn.hidden = NO;
    }
    else {
        self.playBtn.hidden = NO;
        self.pauseBtn.hidden = YES;
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
//        if (self.presentingViewController) {
//            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//        }
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

/**显示课程列表*/
- (void)onClickClassList:(id)sender{
    
    if (isFullScreen == YES) {
    
        if (_classList.hidden == YES) {
            _classList.hidden = NO;
        }else{
            
            _classList.hidden = YES;
        }
        
    }
}




/**加载播放器底层视图*/
- (void)setupVideoPlayerView{
    
    _playerView = [[UIView alloc]init];
//    [_playerView makePlaceHolderImage:[UIImage imageNamed:@"PlayerHolder"]];
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
            
            [self loadingHUDStopLoadingWithTitle:@"播放器加载失败"];
            
        }else{
            //再次加载
            [self setupVideoPlayerWithURL:_urlString];
            
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

/* 切换清晰度功能*/
- (void)chooseResolution:(UIButton *)sender{
    
    
}


/**加载主视图*/
- (void)setupMainView{
    
    _mainView = [[VideoClassPlayerView alloc]init];
    [self.view addSubview:_mainView];
    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(_playerView, 0)
    .bottomSpaceToView(self.view, 0);
    
    _mainView.classVideoListTableView.delegate = self;
    _mainView.classVideoListTableView.dataSource = self;
    _mainView.classVideoListTableView.tag = 1;
    
    _mainView.scrollView.delegate = self;
    _mainView.scrollView.tag = 2;
    
    _mainView.model = _classInfo;
    
    typeof(self) __weak weakSelf = self;
    _mainView.segmentControl.indexChangeBlock = ^(NSInteger index) {
        [weakSelf.mainView.scrollView scrollRectToVisible:CGRectMake(weakSelf.view.width_sd*index, 0, weakSelf.view.width_sd, weakSelf.mainView.scrollView.height_sd) animated:YES];
    };
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(teacherInfo)];
    _mainView.infoView.teacherHeadImage.userInteractionEnabled = YES;
    [_mainView.infoView.teacherHeadImage addGestureRecognizer:tap];
    
}

/**加载教师详情页*/
- (void)teacherInfo{
    
    TeachersPublicViewController *controller = [[TeachersPublicViewController alloc]initWithTeacherID:_teacher.teacherID];
    [self.navigationController pushViewController:controller animated:YES];
    
}

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
    
    _classList.hidden = YES;
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
        [self showSegmentAndScrollViews];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"TurnDownFullScreen" object:nil];
        
    }
    
    /* 切换到横屏*/
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        
        self.view.backgroundColor = [UIColor whiteColor];
        [self.scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale02"] forState:UIControlStateNormal];
        self.scaleModeBtn.titleLabel.tag = 1;
        
        /* 切换到横屏 隐藏segment和scrollview*/
        [self hideSegementAndScrollViews];
        /* 全屏状态  发送消息通知*/
        [[NSNotificationCenter defaultCenter]postNotificationName:@"FullScreen" object:nil];
        
        
    }
}

#pragma mark- 隐藏segment和滑动视图
- (void)hideSegementAndScrollViews{
    
    _mainView.segmentControl.hidden = YES;
    _mainView.scrollView.hidden = YES;
    
}

#pragma mark- 显示segment和滑动视图
- (void)showSegmentAndScrollViews{
    
    _mainView.segmentControl.hidden = NO;
    _mainView.scrollView.hidden = NO;
    
    [_mainView.segmentControl updateLayout];
    [_mainView.scrollView updateLayout];
    _mainView.scrollView.contentSize = CGSizeMake(self.view.width_sd*4, _mainView.scrollView.height_sd);
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
    [_mainView updateLayout];
    [_mainView.scrollView updateLayout];
    
    [self playerViewTurnPotraitScreenLayout];
    _scaleModeBtn.hidden = NO;
    [self.mainView.scrollView scrollRectToVisible:CGRectMake(self.mainView.segmentControl.selectedSegmentIndex * self.view.width_sd, 0, self.view.width_sd, self.view.height_sd-64-49) animated:NO];
    
    [self mediaControlTurnDownFullScreenModeWithMainView:_playerView];
    
    [_mainView.classVideoListTableView reloadData];
    
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
    _classListBtn.hidden = NO;
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
    _classListBtn.hidden = YES;
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



#pragma mark- UITableView datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _classListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tableCell;
    
    if (tableView.tag == 1) {
        
        /* cell的重用队列*/
        static NSString *cellIdenfier = @"cell";
        VideoClassProgressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
        if (cell==nil) {
            cell=[[VideoClassProgressTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        
        if (_classListArray.count>indexPath.row) {
            cell.numbers.text = [NSString stringWithFormat:@"%ld",indexPath.row];
            cell.model = _classListArray[indexPath.row];
        }
        
        if (indexPath == _indexPath) {
            cell.className.textColor = NAVIGATIONRED;
        }
        tableCell = cell;
    }
    
    if (tableView.tag == 3) {
        /* cell的重用队列*/
        static NSString *cellIdenfier = @"tableCell";
        VideoClassFullScreenListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
        if (cell==nil) {
            cell=[[VideoClassFullScreenListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"tableCell"];
        }
        
        if (_classListArray.count>indexPath.row) {
            cell.numbers.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
            cell.model = _classListArray[indexPath.row];
        }
        
        
        tableCell = cell;
    }
    
    
    return  tableCell;
}


#pragma mark- UITableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:self.view.width_sd tableView:tableView];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoClassProgressTableViewCell *cell;
    
    if (tableView.tag ==1) {
        VideoClassProgressTableViewCell *classcell = [tableView cellForRowAtIndexPath:indexPath];
        for (VideoClassProgressTableViewCell *cells in _mainView.classVideoListTableView.visibleCells) {
            cells.className.textColor = [UIColor blackColor];
        }
        classcell.className.textColor = NAVIGATIONRED;
        
    }else if (tableView.tag == 3){
        VideoClassProgressTableViewCell *classcell = [tableView cellForRowAtIndexPath:indexPath];
        for (VideoClassProgressTableViewCell *cells in _classList.visibleCells) {
            cells.className.textColor = [UIColor whiteColor];
        }
        classcell.className.textColor = NAVIGATIONRED;
    }
    [_videoPlayer shutdown];
    [_videoPlayer.view removeFromSuperview];
    _videoPlayer = nil;
    
    _videoPlayer = [[NELivePlayerController alloc]initWithContentURL:[NSURL URLWithString:cell.model.video.name_url]];

    _videoPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_videoPlayer setScalingMode:NELPMovieScalingModeAspectFit];
    
    /* 播放器的设置*/
    [_videoPlayer isLogToFile:YES];
    [_videoPlayer setBufferStrategy:NELPLowDelay]; //直播低延时模式
    [_videoPlayer setScalingMode:NELPMovieScalingModeAspectFit]; //设置画面显示模式，默认原始大小
    [_videoPlayer setShouldAutoplay:YES]; //设置prepareToPlay完成后是否自动播放
    [_videoPlayer setHardwareDecoder:NO]; //设置解码模式，是否开启硬件解码
    [_videoPlayer setPauseInBackground:NO]; //设置切入后台时的状态，暂停还是继续播放
    [_videoPlayer prepareToPlay]; //初始化视频文件
    
    [_playerView addSubview:_videoPlayer.view];
    
    _videoPlayer.view.sd_layout
    .leftSpaceToView(_playerView, 0)
    .topSpaceToView(_playerView, 0)
    .bottomSpaceToView(_playerView, 0)
    .rightSpaceToView(_playerView, 0);
    [_videoPlayer.view updateLayout];
    
    _fileName.text = cell.model.name;
    
}


#pragma mark- UIScrollView delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 2) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        [_mainView.segmentControl setSelectedSegmentIndex:page animated:YES];
    }
}



//返回按钮的回调
- (void)zf_playerBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//切换清晰度的回调
- (void)zf_playerChooseSharpness:(UIButton *)sender{
    
    if ([sender.titleLabel.text isEqualToString:@"标清"]) {
        //切换至标清播放源
    }else if ([sender.titleLabel.text isEqualToString:@"高清"]){
        //切换至高清播放源
    }
}

//点击课程列表
- (void)zf_playerDownload:(NSString *)url{
    
}

-(void)dealloc{
    
    //    [self.videoPlayer removeObserver:self forKeyPath:@"isFullScreen"];
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
