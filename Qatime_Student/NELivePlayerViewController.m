//
//  NELivePlayerViewController.m
//  NELivePlayerDemo
//
//  Created by NetEase on 15-10-10.
//  Copyright (c) 2015年 netease. All rights reserved.
//

#import "NELivePlayerViewController.h"
#import "NELivePlayerControl.h"

#import "UITabBarController+ZFPlayerRotation.h"
#import "UINavigationController+ZFPlayerRotation.h"
#import "NavigationBar.h"

#import <MediaPlayer/MediaPlayer.h>
#import "RDVTabBarController.h"
#import "VideoClassInfo.h"
#import "YYModel.h"
#import "NoticeAndMembers.h"
#import "Notice.h"
#import "Members.h"
#import "NoticeTableViewCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "ClassesListTableViewCell.h"
#import "ClassList.h"
#import "Teacher.h"
#import "Chat_Account.h"
#import "Classes.h"
#import "UIImageView+WebCache.h"
#import "UUInputFunctionView.h"
#import "MJRefresh.h"
#import "UUMessageCell.h"
#import "ChatModel.h"
#import "UUMessageFrame.h"
#import "UUMessage.h"



@interface NELivePlayerViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UUInputFunctionViewDelegate,UUMessageCellDelegate>{
    
    NavigationBar *_navigationBar;
    
//    ZFPlayerModel *_playerModel;
    
    /* token*/
    
    NSString *_remember_token;
    
    /* 课程model*/
    
    VideoClassInfo *_videoClassInfo;
    
    /* 通知消息model*/
    NoticeAndMembers *_noticeAndMembers;
    
    
    /*消息model*/
    Notice *_notices;
    /* 存放消息的数组*/
    NSMutableArray  <Notice *>*_noticesArr;
    
    
    /* 成员model*/
    
    Members *_members;
    /* 存放member的数组*/
    NSMutableArray <Members *>*_membersArr;
    
    /* 课程 model*/
    Classes *_classes;
    
    /* 保存课程model的数组*/
    NSMutableArray *_classesArr;
    
    /* teacher model*/
    Teacher *_teacher;
    
    /* 聊天账号信息model*/
    Chat_Account *_chat_Account;
    
    
    /* tableView的header高度*/
    
    CGFloat headerHeight;
    
    ClassList *_classList;
    
    
    
    
    #pragma mark- 聊天视图
    UUInputFunctionView *IFView;
    
}






/* 拉流播放器的私有属性*/
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






#pragma mark- 聊天部分的属性
/* 刷新聊天记录*/
@property (strong, nonatomic) MJRefreshHeader *head;
/* 聊天信息*/
@property (strong, nonatomic) ChatModel *chatModel;
/* 聊天table*/
@property(nonatomic,strong) UITableView *chatTableView ;

@property(nonatomic,strong) NSLayoutConstraint *bottomConstraint ;



@end

@implementation NELivePlayerViewController


NSTimeInterval mDuration;
NSTimeInterval mCurrPos;
CGFloat screenWidth;
CGFloat screenHeight;
bool isHardware = YES;
bool ismute     = NO;

#pragma mark- 拉流播放器的初始化方法

+ (void)presentFromViewController:(UIViewController *)viewController withTitle:(NSString *)title URL:(NSURL *)url andDecodeParm:(NSMutableArray *)decodeParm completion:(void (^)())completion {
    [viewController presentViewController:[[NELivePlayerViewController alloc] initWithURL:url andDecodeParm:decodeParm] animated:YES completion:completion];
}

- (instancetype)initWithURL:(NSURL *)url andDecodeParm:(NSMutableArray *)decodeParm {
    self = [self initWithNibName:@"NELivePlayerViewController" bundle:nil];
    if (self) {
        self.url = url;
        self.decodeType = [decodeParm objectAtIndex:0];
        self.mediaType = [decodeParm objectAtIndex:1];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self syncUIStatus:NO];
    }
    return self;
}





#pragma mark- controller的初始化方法

-(instancetype)initWithClassID:(NSString *)classID{
    self = [super init];
    if (self) {
        
        _classID = [NSString stringWithFormat:@"%@",classID];
        
        
    }
    return self;
}


- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //当前屏幕宽高
    screenWidth  = CGRectGetWidth([UIScreen mainScreen].bounds);
    screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    
    
    /* */
    self.playerView =[[UIView alloc]init];
    [self.view addSubview:self.playerView];
//    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(20);
//        make.left.right.equalTo(self.view);
//        // 这里宽高比16：9，可以自定义视频宽高比
//        make.height.equalTo(self.playerView.mas_width).multipliedBy(9.0f/16.0f);
//    }];
    self.playerView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,64)
    .autoHeightRatio(9/16.0f);
    
    
    
    
    /*[[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-20)];*/
    
    self.mediaControl =[[NELivePlayerControl alloc] init];
    [self.playerView addSubview:self.mediaControl];
    self.mediaControl.sd_layout
    .leftEqualToView(self.playerView)
    .rightEqualToView(self.playerView)
    .topEqualToView(self.playerView)
    .bottomEqualToView(self.playerView);
    
    
    
    /*[[NELivePlayerControl alloc] initWithFrame:CGRectMake(0, 0, screenHeight, screenWidth)];*/
    
    
    [self.mediaControl addTarget:self action:@selector(onClickMediaControl:) forControlEvents:UIControlEventTouchDown];
    
    //控制
    self.controlOverlay =[[UIControl alloc] init];
    [self.mediaControl addSubview:self.controlOverlay];
    
    self.controlOverlay.sd_layout
    .leftEqualToView(_mediaControl)
    .rightEqualToView(_mediaControl)
    .topEqualToView(_mediaControl)
    .bottomEqualToView(_mediaControl);
    
    
    
//    [[UIControl alloc] initWithFrame:CGRectMake(0, 0, screenHeight, screenWidth)];
    
    
    [self.controlOverlay addTarget:self action:@selector(onClickOverlay:) forControlEvents:UIControlEventTouchDown];
    
    //顶部控制栏
    self.topControlView = [[UIView alloc] init];
//    [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenHeight, 40)];
    self.topControlView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ic_background_black.png"]];
    self.topControlView.alpha = 0.8;
    [self.controlOverlay addSubview:self.topControlView];
    self.topControlView.sd_layout
    .leftEqualToView(self.controlOverlay)
    .rightEqualToView(self.controlOverlay)
    .topEqualToView(self.controlOverlay)
    .bottomEqualToView(self.controlOverlay);
    
    
    //退出按钮
    self.playQuitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playQuitBtn setImage:[UIImage imageNamed:@"btn_player_quit"] forState:UIControlStateNormal];
//    self.playQuitBtn.frame = CGRectMake(10, 0, 40, 40);
    [self.playQuitBtn addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.topControlView addSubview:self.playQuitBtn];
    self.playQuitBtn.sd_layout
    .topEqualToView(self.topControlView)
    .leftSpaceToView(self.topControlView,10)
    .widthIs(40)
    .heightIs(40);
    
    
    //文件名
    self.fileName = [[UILabel alloc] init ];
//                     WithFrame:CGRectMake(70, 0, screenHeight - 140, 40)];
    self.fileName.text = [self.url lastPathComponent];
    self.fileName.textAlignment = NSTextAlignmentCenter; //文字居中
    self.fileName.textColor = [[UIColor alloc] initWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
    self.fileName.font = [UIFont fontWithName:self.fileName.font.fontName size:13.0];
    [self.topControlView addSubview:self.fileName];
    self.fileName.sd_layout
    .centerXEqualToView(self.topControlView)
    .topEqualToView(self.topControlView)
    .bottomEqualToView(self.topControlView)
    .widthIs(screenWidth-100);
    
    //缓冲提示
//    self.bufferingIndicate = [[UIActivityIndicatorView alloc] init];
//    
//    
////                              WithFrame:CGRectMake(0, 0, 30, 30)];
//    [self.bufferingIndicate setCenter:CGPointMake(screenHeight/2, screenWidth/2)];
//    [self.bufferingIndicate setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    self.bufferingIndicate.hidden = YES;
//    
//    self.bufferingReminder = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
//    [self.bufferingReminder setCenter:CGPointMake(screenHeight/2, screenWidth/2 - 50)];
//    self.bufferingReminder.text = @"缓冲中";
//    self.bufferingReminder.textAlignment = NSTextAlignmentCenter; //文字居中
//    self.bufferingReminder.textColor = [UIColor whiteColor];
//    self.bufferingReminder.hidden = YES;

    
    //底部控制栏
    self.bottomControlView = [[UIView alloc] init];
//                              WithFrame:CGRectMake(0, screenWidth - 50, screenHeight, 50)];
    self.bottomControlView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ic_background_black.png"]];
    self.bottomControlView.alpha = 0.8;
    [ self.controlOverlay addSubview:self.bottomControlView];
    self.bottomControlView.sd_layout
    .leftEqualToView(self.controlOverlay)
    .bottomEqualToView(self.controlOverlay)
    .rightEqualToView(self.controlOverlay)
    .heightIs(50);
    
    
    //播放按钮
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"btn_player_pause"] forState:UIControlStateNormal];
//    self.playBtn.frame = CGRectMake(10, 5, 40, 40);
    [self.playBtn addTarget:self action:@selector(onClickPlay:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomControlView addSubview:self.playBtn];
    self.playBtn.sd_layout
    .leftSpaceToView(self.bottomControlView,10)
    .centerYEqualToView(self.bottomControlView)
    .topSpaceToView(self.bottomControlView,10)
    .bottomSpaceToView(self.bottomControlView,10)
    .widthEqualToHeight();
    
    
    
    //暂停按钮
    self.pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.pauseBtn setImage:[UIImage imageNamed:@"btn_player_play"] forState:UIControlStateNormal];
//    self.pauseBtn.frame = CGRectMake(10, 5, 40, 40);
    [self.pauseBtn addTarget:self action:@selector(onClickPause:) forControlEvents:UIControlEventTouchUpInside];
    self.pauseBtn.hidden = YES;
    [self.bottomControlView addSubview:self.pauseBtn];
    self.pauseBtn.sd_layout
    .leftEqualToView(self.playBtn)
    .rightEqualToView(self.playBtn)
    .topEqualToView(self.playBtn)
    .bottomEqualToView(self.playBtn);
    
    
    //当前播放的时间点
    self.currentTime = [[UILabel alloc] init];
//                        WithFrame:CGRectMake(50, 15, 50, 20)];
    self.currentTime.text = @"00:00:00"; //for test
    self.currentTime.textAlignment = NSTextAlignmentCenter;
    self.currentTime.textColor = [[UIColor alloc] initWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
    self.currentTime.font = [UIFont fontWithName:self.currentTime.font.fontName size:10.0];
    [self.bottomControlView addSubview:self.currentTime];
    self.currentTime.sd_layout
    .leftSpaceToView(self.playBtn,10)
    .widthIs(50)
    .topSpaceToView(self.bottomControlView,15)
    .bottomSpaceToView(self.bottomControlView,15);
    
    
    
    //显示模式
    self.scaleModeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale02"] forState:UIControlStateNormal];
//    self.scaleModeBtn.frame = CGRectMake(screenHeight-50, 5, 40, 40);
    if ([self.mediaType isEqualToString:@"localAudio"]) {
        self.scaleModeBtn.hidden = YES;
    }

    [self.scaleModeBtn addTarget:self action:@selector(onClickScaleMode:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomControlView addSubview:self.scaleModeBtn];
    
    self.scaleModeBtn.sd_layout
    .rightSpaceToView(self.bottomControlView,10)
    .topSpaceToView(self.bottomControlView,10)
    .bottomSpaceToView(self.bottomControlView,10)
    .widthIs(40);
    
    
    //截图
    self.snapshotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.snapshotBtn setImage:[UIImage imageNamed:@"btn_player_snap"] forState:UIControlStateNormal];
//    self.snapshotBtn.frame = CGRectMake(screenHeight-100, 5, 40, 40);
    if ([self.mediaType isEqualToString:@"localAudio"]) {
        self.snapshotBtn.hidden = YES;
    }
    [self.snapshotBtn addTarget:self action:@selector(onClickSnapshot:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomControlView addSubview:self.snapshotBtn];
    
    self.snapshotBtn.sd_layout
    .rightSpaceToView(self.scaleModeBtn,10)
    .topSpaceToView(self.bottomControlView,10)
    .bottomSpaceToView(self.bottomControlView,10)
    .widthIs(40);

    
    
    //静音按钮
    self.muteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.muteBtn setImage:[UIImage imageNamed:@"btn_player_mute01"] forState:UIControlStateNormal];
//    self.muteBtn.frame = CGRectMake(screenHeight-150, 5, 40, 40);
    [self.muteBtn addTarget:self action:@selector(onClickMute:) forControlEvents:UIControlEventTouchUpInside];
    self.muteBtn.hidden = YES;
    [self.bottomControlView addSubview:self.muteBtn];
    
    self.muteBtn.sd_layout
    .rightSpaceToView(self.snapshotBtn,10)
    .topSpaceToView(self.bottomControlView,10)
    .bottomSpaceToView(self.bottomControlView,10)
    .widthIs(40);
    

    //声音打开按钮
    self.audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.audioBtn setImage:[UIImage imageNamed:@"btn_player_mute02"] forState:UIControlStateNormal];
    self.audioBtn.frame = CGRectMake(screenHeight-150, 5, 40, 40);
    [self.audioBtn addTarget:self action:@selector(onClickMute:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomControlView addSubview:self.audioBtn];
   
    self.audioBtn.sd_layout
    .rightSpaceToView(self.snapshotBtn,10)
    .topSpaceToView(self.bottomControlView,10)
    .bottomSpaceToView(self.bottomControlView,10)
    .widthIs(40);

    
//    //文件总时长
//    self.totalDuration = [[UILabel alloc] init];
////                          WithFrame:CGRectMake(screenHeight-215, 15, 50, 20)];
//    self.totalDuration.text = @"--:--:--";
//    self.totalDuration.textAlignment = NSTextAlignmentCenter;
//    self.totalDuration.textColor = [[UIColor alloc] initWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
//    self.totalDuration.font = [UIFont fontWithName:self.totalDuration.font.fontName size:10.0];
//    [self.bottomControlView addSubview:self.totalDuration];
//
//    self.totalDuration.sd_layout
//    .rightSpaceToView(self.audioBtn,10)
//    .topSpaceToView(self.bottomControlView,15)
//    .bottomSpaceToView(self.bottomControlView,15)
//    .widthIs(50);
    
    
    
    //播放进度条
    self.videoProgress = [[UISlider alloc] init];
    //                          WithFrame:CGRectMake(100, 10, screenHeight-320, 30)];
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"btn_player_slider_thumb"] forState:UIControlStateNormal];
    [[UISlider appearance] setMaximumTrackImage:[UIImage imageNamed:@"btn_player_slider_all"] forState:UIControlStateNormal];
    [[UISlider appearance] setMinimumTrackImage:[UIImage imageNamed:@"btn_player_slider_played"] forState:UIControlStateNormal];
    
    [self.videoProgress addTarget:self action:@selector(onClickSeek:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomControlView addSubview:self.videoProgress];
    self.videoProgress.sd_layout
    .leftSpaceToView(self.currentTime,10)
    .rightSpaceToView( self.audioBtn,10)
    .topSpaceToView(self.bottomControlView,10)
    .bottomSpaceToView(self.bottomControlView,10);
    
    

    if ([self.decodeType isEqualToString:@"hardware"]) {
        isHardware = YES;
    }
    else if ([self.decodeType isEqualToString:@"software"]) {
        isHardware = NO;
    }
    
    [self.controlOverlay addSubview:self.topControlView];
    [self.controlOverlay addSubview:self.bottomControlView];
    
    
    [NELivePlayerController setLogLevel:NELP_LOG_DEBUG];
    
    
    self.liveplayer = [[NELivePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"rtmp://va0a19f55.live.126.net/live/834c6312006e4ffe927795a11fd317af"]];
    if (self.liveplayer == nil) { // 返回空则表示初始化失败
        
        [NELivePlayerController setLogLevel:NELP_LOG_DEFAULT];
        
        
        NSLog(@"player initilize failed, please tay again!");
    }
    
//    [self.liveplayer prepareToPlay];
    
    self.liveplayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    self.liveplayer.view.frame = self.playerView.bounds;
    
    [self.liveplayer setScalingMode:NELPMovieScalingModeFill];
    
    self.view.autoresizesSubviews = YES;
    
    [self.mediaControl addSubview:self.controlOverlay];
    [self.view addSubview:self.liveplayer.view];
    [self.view addSubview:self.mediaControl];
    [self.view addSubview:self.bufferingIndicate];
    [self.view addSubview:self.bufferingReminder];
    self.mediaControl.delegatePlayer = self.liveplayer;
    
    
    /* 监听屏幕旋转通知*/
    [self listeningRotating];
    
    /* 改变屏幕方向*/
    [self onDeviceOrientationChange];
    
    
    

}

/**
 *  监听设备旋转通知
 */
- (void)listeningRotating
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
}

/**
 *  屏幕方向发生变化会调用这里
 */
- (void)onDeviceOrientationChange
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown || orientation == UIDeviceOrientationPortraitUpsideDown) { return; }
    
//    if (!ZFPlayerShared.isAllowLandscape) { return; }
//    if (ZFPlayerOrientationIsLandscape || ZFPlayerShared.isLockScreen) {
//        self.shrink = NO;
//        self.fullScreen = YES;
//        [self.backBtn setImage:ZFPlayerImage(@"ZFPlayer_back_full") forState:UIControlStateNormal];
//        [self.topBarView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(20);
//        }];
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//    } else {
//        self.fullScreen = NO;
//        [self.topBarView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(0);
//        }];
//        if (self.isCellVideo) {
//            [self.backBtn setImage:ZFPlayerImage(@"ZFPlayer_close") forState:UIControlStateNormal];
//            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//        } else {
//            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//        }
//    }
    
//    self.lockBtn.hidden = !self.isFullScreen;
//    self.fullScreenBtn.selected = self.isFullScreen;
    [self.view layoutIfNeeded];
}


- (BOOL)prefersStatusBarHidden
{
    // iOS7后,[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    // 已经不起作用了
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    NSLog(@"Version = %@", [self.liveplayer getSDKVersion]);
    [self.liveplayer isLogToFile:YES];
    
    if ([self.mediaType isEqualToString:@"livestream"] ) {
        [self.liveplayer setBufferStrategy:NELPLowDelay]; //直播低延时模式
    }
    else {
        [self.liveplayer setBufferStrategy:NELPAntiJitter]; //点播抗抖动
    }
    [self.liveplayer setScalingMode:NELPMovieScalingModeAspectFit]; //设置画面显示模式，默认原始大小
    [self.liveplayer setShouldAutoplay:YES]; //设置prepareToPlay完成后是否自动播放
    [self.liveplayer setHardwareDecoder:isHardware]; //设置解码模式，是否开启硬件解码
    [self.liveplayer setPauseInBackground:NO]; //设置切入后台时的状态，暂停还是继续播放
    [self.liveplayer prepareToPlay]; //初始化视频文件
    
    
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
    
    [self.liveplayer shutdown]; //退出播放并释放相关资源
    [self.liveplayer.view removeFromSuperview];
    self.liveplayer = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerDidPreparedToPlayNotification object:_liveplayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerLoadStateChangedNotification object:_liveplayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerPlaybackFinishedNotification object:_liveplayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerFirstVideoDisplayedNotification object:_liveplayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerFirstAudioDisplayedNotification object:_liveplayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerVideoParseErrorNotification object:_liveplayer];
}


- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

//全屏播放视频后，播放器的适配和全屏旋转
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
        //        self.fd_interactivePopDisabled = NO;
        //if use Masonry,Please open this annotation
        
        /* 竖屏*/
        [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(64);
        }];
        
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.view.backgroundColor = [UIColor blackColor];
        //        self.fd_interactivePopDisabled = YES;
        //if use Masonry,Please open this annotation
        
        /* 横屏*/
        [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(-20);
        }];
        
    }
}

#pragma mark - IBAction

//退出播放
- (void)onClickBack:(id)sender
{
    NSLog(@"click back!");
    // [self syncUIStatus:YES];
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

//seek操作
- (void)onClickSeek:(id)sender
{
    NSLog(@"click seek");
    if ([self.mediaType isEqualToString:@"livestream"]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注意" message:@"直播流不支持seek操作." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    NSTimeInterval currentPlayTime = self.videoProgress.value;
    [self.liveplayer setCurrentPlaybackTime:currentPlayTime];
    [self syncUIStatus:NO];
}

//开始播放
- (void)onClickPlay:(id)sender
{
    NSLog(@"click pause");
    [self.liveplayer play];
    [self syncUIStatus:NO];
}

//暂停播放
- (void)onClickPause:(id)sender
{
    NSLog(@"click pause");
    [self.liveplayer pause];
    [self syncUIStatus:NO];
}

//静音
- (void)onClickMute:(id)sender
{
    NSLog(@"click mute");
    if (ismute) {
        [self.liveplayer setMute:!ismute];
        self.muteBtn.hidden = YES;
        self.audioBtn.hidden = NO;
        ismute = NO;
    }
    else {
        [self.liveplayer setMute:!ismute];
        self.muteBtn.hidden = NO;
        self.audioBtn.hidden = YES;
        ismute = YES;
    }
}

//显示模式
- (void)onClickScaleMode:(id)sender
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    switch (self.scaleModeBtn.titleLabel.tag) {
        case 0:
            [self.scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale02"] forState:UIControlStateNormal];
            [self.liveplayer setScalingMode:NELPMovieScalingModeNone];
            
            //            UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
            
            if (orientation == UIDeviceOrientationLandscapeRight) {
                [self interfaceOrientation:UIInterfaceOrientationLandscapeLeft];
            } else {
                [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
            }
            
            self.scaleModeBtn.titleLabel.tag = 1;
            break;
        case 1:
            [self.scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale01"] forState:UIControlStateNormal];
            [self.liveplayer setScalingMode:NELPMovieScalingModeAspectFit];
            
            
            if (orientation == UIDeviceOrientationLandscapeRight) {
                [self interfaceOrientation:UIInterfaceOrientationLandscapeLeft];
            } else {
                [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
            }
            
            
            self.scaleModeBtn.titleLabel.tag = 0;
            break;
        default:
            [self.scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale02"] forState:UIControlStateNormal];
            [self.liveplayer setScalingMode:NELPMovieScalingModeAspectFit];
            
            //            UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
            if (orientation == UIDeviceOrientationLandscapeRight) {
                [self interfaceOrientation:UIInterfaceOrientationLandscapeLeft];
            } else {
                [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
            }
            
            
            
            self.scaleModeBtn.titleLabel.tag = 0;
            break;
    }
}

//强制改变屏幕方向

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    // arc下
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
        /* 横屏*/
        self.playerView.sd_layout
        .leftEqualToView(self.view)
        .topEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomEqualToView(self.view);
//        [self.view  layoutIfNeeded];
        
        
        
    } else if (orientation == UIInterfaceOrientationPortrait) {
        // 设置竖屏
        
        
        /* 竖屏*/
        self.playerView.sd_layout
        .leftEqualToView(self.view)
        .topEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomEqualToView(self.view);
//        [self.view  layoutIfNeeded];
        
        
        
        
        
        
        
        
    }
    /*
     // 非arc下
     if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
     [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
     withObject:@(orientation)];
     }
     
     // 直接调用这个方法通不过apple上架审核
     [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
     */
}




//截图
- (void)onClickSnapshot:(id)sender
{
    NSLog(@"click snap");
    
    UIImage *snapImage = [self.liveplayer getSnapshot];
    
    UIImageWriteToSavedPhotosAlbum(snapImage, nil, nil, nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"截图已保存到相册" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
    
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

//触摸overlay
- (void)onClickOverlay:(id)sender
{
    NSLog(@"click overlay");
    self.controlOverlay.hidden = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlOverlayHide) object:nil];
}

- (void)onClickMediaControl:(id)sender
{
    NSLog(@"click mediacontrol");
    self.controlOverlay.hidden = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlOverlayHide) object:nil];
    [self syncUIStatus:NO];
    [self performSelector:@selector(controlOverlayHide) withObject:nil afterDelay:8];
}

- (void)controlOverlayHide
{
    self.controlOverlay.hidden = YES;
}

- (void)syncUIStatus:(BOOL)isSync
{
    mDuration = [self.liveplayer duration];
    NSInteger duration = round(mDuration);
    
    mCurrPos  = [self.liveplayer currentPlaybackTime];
    NSInteger currPos  = round(mCurrPos);
    
    self.currentTime.text = [NSString stringWithFormat:@"%02d:%02d:%02d", (int)(currPos / 3600), (int)(currPos > 3600 ? (currPos - (currPos / 3600)*3600) / 60 : currPos/60), (int)(currPos % 60)];
    
    if (duration > 0) {
        self.totalDuration.text = [NSString stringWithFormat:@"%02d:%02d:%02d", (int)(duration / 3600), (int)(duration > 3600 ? (duration - 3600 * (duration / 3600)) / 60 : duration/60), (int)(duration > 3600 ? ((duration - 3600 * (duration / 3600)) % 60) :(duration % 60))];
        self.videoProgress.value = mCurrPos;
        self.videoProgress.maximumValue = mDuration;
    } else {
        [self.videoProgress setValue:0.0f];
    }
    
    if ([self.liveplayer playbackState] == NELPMoviePlaybackStatePlaying) {
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

- (void)NELivePlayerDidPreparedToPlay:(NSNotification*)notification
{
    //add some methods
    NSLog(@"NELivePlayerDidPreparedToPlay");
    [self syncUIStatus:NO];
    [self.liveplayer play]; //开始播放
}

- (void)NeLivePlayerloadStateChanged:(NSNotification*)notification
{
    NELPMovieLoadState nelpLoadState = _liveplayer.loadState;
    
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
            if ([self.mediaType isEqualToString:@"livestream"]) {
                alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"直播结束" preferredStyle:UIAlertControllerStyleAlert];
                action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    if (self.presentingViewController) {
                        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                    }}];
                [alertController addAction:action];
                [self presentViewController:alertController animated:YES completion:nil];
            }
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
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerReleaseSueecssNotification object:_liveplayer];
}















//  是否支持自动转屏
//- (BOOL)shouldAutorotate
//{
//    // 调用ZFPlayerSingleton单例记录播放状态是否锁定屏幕方向
//    return !ZFPlayerShared.isLockScreen;
//}

// 支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


//全屏播放视频后，播放器的适配和全屏旋转
//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
//        self.view.backgroundColor = [UIColor whiteColor];
//        //        self.fd_interactivePopDisabled = NO;
//        //if use Masonry,Please open this annotation
//
//        [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view).offset(64);
//        }];
//
//    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
//        self.view.backgroundColor = [UIColor blackColor];
//        //        self.fd_interactivePopDisabled = YES;
//        //if use Masonry,Please open this annotation
//
//        [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view).offset(0);
//        }];
//
//    }
//}


#pragma mark- 以上是播放器的初始化和配置方法、接口等

#pragma mark- 下为页面数据及逻辑等

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
  
    
    /* TabBar单例隐藏*/
    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
    
    
    /* 播放器的监听*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerDidPreparedToPlay:) name:NELivePlayerDidPreparedToPlayNotification object:_liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NeLivePlayerloadStateChanged:) name:NELivePlayerLoadStateChangedNotification object:_liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerPlayBackFinished:) name:NELivePlayerPlaybackFinishedNotification object:_liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerFirstVideoDisplayed:) name:NELivePlayerFirstVideoDisplayedNotification object:_liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerFirstAudioDisplayed:) name:NELivePlayerFirstAudioDisplayedNotification object:_liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerReleaseSuccess:) name:NELivePlayerReleaseSueecssNotification object:_liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerVideoParseError:) name:NELivePlayerVideoParseErrorNotification object:_liveplayer];
    
    
    ////////////////////////////////////
    
    #pragma mark- 以下是页面和功能逻辑
    self.view.backgroundColor= [UIColor whiteColor];
    _navigationBar = [[NavigationBar alloc]init];
    [self.view addSubview:_navigationBar];
    
    _navigationBar.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .heightIs(64);
    
    /* 取出token*/
    
    _remember_token=[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"];
    //    测试用id
    //    _classID = @"25" ;
    
#pragma mark- 课程信息视图
    
    _videoInfoView = [[VideoInfoView alloc]init];
    [self.view addSubview:_videoInfoView];
    _videoInfoView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.playerView,0)
    .bottomSpaceToView(self.view,0);
    
    _videoInfoView.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*4, [UIScreen mainScreen].bounds.size.height -  [UIScreen mainScreen].bounds.size.width*9/16.0f-64-30-4);
    
    
    typeof(self) __weak weakSelf = self;
    [ _videoInfoView.segmentControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.videoInfoView.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.view.bounds) * index, 0, CGRectGetWidth(weakSelf.view.bounds), CGRectGetHeight(weakSelf.view.frame)-64-49) animated:YES];
    }];
    
    _videoInfoView.scrollView.delegate = self;
    _videoInfoView.segmentControl.selectedSegmentIndex =0;
    _videoInfoView.segmentControl.selectionIndicatorHeight =2.0f;
    _videoInfoView.scrollView.bounces=NO;
    _videoInfoView.scrollView.alwaysBounceVertical=NO;
    _videoInfoView.scrollView.alwaysBounceHorizontal=NO;
    
    [_videoInfoView.scrollView scrollRectToVisible:CGRectMake(-CGRectGetWidth(self.view.bounds), 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) animated:YES];
    
    _videoInfoView.noticeTabelView.tag =1;
    _videoInfoView.noticeTabelView .delegate = self;
    _videoInfoView.noticeTabelView.dataSource = self;
    
    
    
    _classList = [[ClassList alloc]init];
    [_videoInfoView.view3 addSubview:_classList];
    _classList.sd_layout
    .leftEqualToView(_videoInfoView.view3)
    .rightEqualToView(_videoInfoView.view3)
    .topEqualToView(_videoInfoView.view3)
    .bottomEqualToView(_videoInfoView.view3);
    
   
    
    
    
    _classList.classListTableView.delegate =self;
    _classList.classListTableView.dataSource =self;
    _classList.classListTableView.tag =2;
    
    
    //把聊天页面添加到view2上
    
    _chatTableView = [[UITableView alloc]init];
    

    [_videoInfoView.view2 addSubview:_chatTableView];
    _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [ _chatTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.and.left.and.right.mas_equalTo(0);
//        make.bottom.mas_offset(-64);
//        
//    }];

    _chatTableView.sd_layout
    .leftEqualToView(_videoInfoView.view2)
    .topEqualToView(_videoInfoView.view2)
    .rightEqualToView(_videoInfoView.view2)
    .bottomSpaceToView(_videoInfoView.view2,64);
    
    _chatTableView.delegate = self;
    _chatTableView.dataSource = self;
    _chatTableView.tag =3;
    
 
    
    
    _infoHeaderView = [[InfoHeaderView alloc]initWithFrame:CGRectMake(0, 0, _videoInfoView.view3.frame.size.width, 800)];
    
    /* 加入高度变化的监听*/
    [self addObserver:self forKeyPath:@"headerHeight" options:NSKeyValueObservingOptionNew context:nil];
    
    
    _classList.classListTableView.tableHeaderView = _infoHeaderView;
    
    
    
    
    /* 根据token和传来的id 发送课程内容请求。*/
    [self requestClassInfo];
    _notices = [[Notice alloc]init];
    _noticesArr = @[].mutableCopy;
    _members = [[Members alloc]init];
    _membersArr = @[].mutableCopy;
    _classesArr = @[].mutableCopy;
    
    
    
    
    #pragma mark- 聊天功能初始化
    
    
    [self initBar];
    [self addRefreshViews];
    [self loadBaseViewsAndData];

    
    
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    
    
    //增加监听，当键盘出现或改变时收出消息
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShow:)
     
                                                 name:UIKeyboardWillShowNotification
     
                                               object:nil];
    
    
    
    //增加监听，当键退出时收出消息
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillHide:)
     
                                                 name:UIKeyboardWillHideNotification
     
                                               object:nil];
    
    
}

/* 键盘出现*/

- (void)keyboardWillShow:(NSNotification *)aNotification{
    
    //获取键盘高度
    
    NSDictionary *info = [aNotification userInfo];
    
    //获取动画时间
    
    float duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //获取动画开始状态的frame
    
    CGRect beginRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    //获取动画结束状态的frame
    
    CGRect endRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    //计算高度差
    
    CGFloat offsety =  endRect.origin.y - beginRect.origin.y ;
    
    NSLog(@"键盘高度:%f 高度差:%f\n",beginRect.origin.y,offsety);
    
    //下面的动画，整个View上移动
    
    [UIView animateWithDuration:duration animations:^{
        
        _chatTableView.sd_layout
        .topEqualToView(_videoInfoView.view2)
        .leftEqualToView(_videoInfoView.view2)
        .rightEqualToView(_videoInfoView.view2)
        .bottomSpaceToView(_videoInfoView.view2,-offsety+46);
        
        [self tableViewScrollToBottom];
        
        IFView.sd_layout
        .bottomSpaceToView(_videoInfoView.view2,-offsety);
        
        
        [_chatTableView updateLayout];
        [IFView updateLayout];
        
        
        
    }];
    
    
}

/* 键盘隐藏*/
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    [UIView animateWithDuration:0.8 animations:^{
        
        _chatTableView.sd_layout
        .topEqualToView(_videoInfoView.view2)
        .leftEqualToView(_videoInfoView.view2)
        .rightEqualToView(_videoInfoView.view2)
        .bottomSpaceToView(_videoInfoView.view2,46);
        
        [self tableViewScrollToBottom];
        
        IFView.sd_layout
        .bottomSpaceToView(_videoInfoView.view2,0);
        
        
        [_chatTableView updateLayout];
        [IFView updateLayout];
        
        
        
    }];
    
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


#pragma mark- 聊天功能的方法

- (void)initBar
{
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:@[@" private ",@" group "]];
    [segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    segment.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segment;
    
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:nil];
}
- (void)segmentChanged:(UISegmentedControl *)segment
{
    self.chatModel.isGroupChat = segment.selectedSegmentIndex;
    [self.chatModel.dataSource removeAllObjects];
    [self.chatModel populateRandomDataSource];
    [self.chatTableView reloadData];
}

- (void)addRefreshViews
{
    __weak typeof(self) weakSelf = self;
    
    //load more
    int pageNum = 3;
    
    _head = [MJRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf.chatModel addRandomItemsToDataSource:pageNum];
        
        if (weakSelf.chatModel.dataSource.count > pageNum) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:pageNum inSection:0];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.chatTableView reloadData];
                [weakSelf.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            });
        }
        [weakSelf.head endRefreshing];
    }];
    _chatTableView.mj_header = _head;
  
}

- (void)loadBaseViewsAndData
{
    self.chatModel = [[ChatModel alloc]init];
    self.chatModel.isGroupChat = NO;
    [self.chatModel populateRandomDataSource];
    
    IFView = [[UUInputFunctionView alloc]initWithSuperVC:self];
    IFView.delegate = self;
    [_videoInfoView.view2 addSubview:IFView];
    

    
    IFView.sd_layout
    .leftEqualToView(_videoInfoView.view2)
    .rightEqualToView(_videoInfoView.view2)
    .bottomSpaceToView(_videoInfoView.view2,0)
    .heightIs(46);
    
    
    
    
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}



//tableView 滚动到底部
- (void)tableViewScrollToBottom
{
    if (self.chatModel.dataSource.count==0)
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark - InputFunctionViewDelegate
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message
{
    NSDictionary *dic = @{@"strContent": message,
                          @"type": @(UUMessageTypeText)};
    funcView.TextViewInput.text = @"";
    [funcView changeSendBtnWithPhoto:YES];
    [self dealTheFunctionData:dic];
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image
{
    NSDictionary *dic = @{@"picture": image,
                          @"type": @(UUMessageTypePicture)};
    [self dealTheFunctionData:dic];
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second
{
    NSDictionary *dic = @{@"voice": voice,
                          @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)second],
                          @"type": @(UUMessageTypeVoice)};
    [self dealTheFunctionData:dic];
}

- (void)dealTheFunctionData:(NSDictionary *)dic
{
    [self.chatModel addSpecifiedItem:dic];
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}



#pragma mark- 请求课程和和内容
- (void)requestClassInfo{
    
    NSLog(@"%@",_classID);
    
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_remember_token forHTTPHeaderField:@"Remember-Token"];
    
    [manager GET:[NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/live_studio/courses/%@/realtime",_classID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSString *status = [NSString stringWithFormat:@"%@",[dic valueForKey:@"status"]];
        
        NSLog(@"%@",dic);
        
        
        if (![status isEqualToString:@"1"]) {
            
        }else{
            //        使用yymodel解
            _noticeAndMembers = [NoticeAndMembers yy_modelWithDictionary:dic[@"data"]];
            NSLog(@"%@,@%@",_noticeAndMembers.announcements,_noticeAndMembers.members);
            
            _noticesArr=[_noticeAndMembers valueForKey:@"announcements"];
            
            NSLog(@"%@",_noticesArr);
            
            
            _membersArr = [_noticeAndMembers valueForKey:@"members"];
            NSLog(@"%@",_membersArr);
            
            [self updateViewsNotice];
            
            
        }
        
        
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:_remember_token forHTTPHeaderField:@"Remember-Token"];
        [manager GET:[NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/live_studio/courses/%@/play_info",_classID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSString *status = [NSString stringWithFormat:@"%@",[dic valueForKey:@"status"]];
            
            NSDictionary *dataDic=[NSDictionary dictionaryWithDictionary:dic[@"data"]];
            
            NSLog(@"%@",dic);
            
            if (![status isEqualToString:@"1"]) {
                /* 请求错误*/
                
            }else{
                
                /* 解析 课程 数据*/
                _videoClassInfo = [VideoClassInfo yy_modelWithDictionary:dataDic];
                //                _classes = [Classes yy_modelWithJSON:dataDic[@"lessons"]];
                
                /* 解析 教师 数据*/
                _teacher = [Teacher yy_modelWithDictionary:dataDic[@"teacher"]];
                /* 解析 聊天账号 数据*/
                _chat_Account = [Chat_Account yy_modelWithDictionary:[dataDic[@"teacher"]valueForKey:@"chat_account"]];
                
                /* 保存课程信息*/
                _classesArr = dataDic[@"lessons"];
                
                NSLog(@"%@",_videoClassInfo);
                _videoClassInfo.classID = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"id"]];
                
                _videoClassInfo.classDescription = [NSString  stringWithFormat:@"%@",[dataDic valueForKey:@"description"]];
                
                /* 课程图的信息赋值*/
                _infoHeaderView.classNameLabel.text = _videoClassInfo.name;
                _infoHeaderView.gradeLabel.text = _videoClassInfo.grade;
                _infoHeaderView.completed_conunt.text = _videoClassInfo.completed_lesson_count;
                _infoHeaderView.classCount.text = _videoClassInfo.lesson_count;
                _infoHeaderView.subjectLabel.text = _videoClassInfo.subject;
                _infoHeaderView.onlineVideoLabel.text = _videoClassInfo.status;
                _infoHeaderView.liveStartTimeLabel.text = _videoClassInfo.live_start_time;
                _infoHeaderView.liveEndTimeLabel.text = _videoClassInfo.live_end_time;
                _infoHeaderView.classDescriptionLabel.text = _videoClassInfo.classDescription;
                
                
                /* 教师信息 赋值*/
                _infoHeaderView.teacherNameLabel.text =_teacher.name;
                _infoHeaderView.teaching_year.text = _teacher.teaching_years;
                _infoHeaderView.workPlace .text = _teacher.school;
                [_infoHeaderView.teacherHeadImage sd_setImageWithURL:[NSURL URLWithString:_teacher.avatar_url]];
                _infoHeaderView.selfInterview.text = _teacher.desc;
                
                
                [_infoHeaderView layoutIfNeeded];
                
                
                
                /* 自动赋值高度*/
                
                NSNumber *height =[NSNumber numberWithFloat: _infoHeaderView.layoutLine.frame.origin.y];
                
                [self setValue:height forKey:@"headerHeight"];
                
                [self updateViewsInfos];
                
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}


/* 高度变化的监听回调*/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    NSLog(@"%@",change);
    headerHeight = [[change valueForKey:@"new"] floatValue];
    
    [_infoHeaderView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), headerHeight)];
    
    _classList.classListTableView.tableHeaderView =_infoHeaderView;
    
    _classList.classListTableView.tableHeaderView.height_sd =headerHeight;
    
    NSLog(@"%@", [_classList.classListTableView.tableHeaderView valueForKey:@"frame"]);
    
    
    NSLog(@"%f", _infoHeaderView.layoutLine.autoHeight);
    
    NSLog(@"%@",[_infoHeaderView.workPlace valueForKey:@"frame"]);
    NSLog(@"%@",[_infoHeaderView.layoutLine valueForKey:@"frame"]);
    
    
    
    [self updateViewsInfos];
    
    
}

/* 刷新视图*/

- (void)updateViewsNotice{
    
    [_videoInfoView.noticeTabelView reloadData];
    [_videoInfoView.noticeTabelView setNeedsDisplay];
    [_videoInfoView.noticeTabelView setNeedsLayout];
    
}

- (void)updateViewsInfos{
    
    
    [_classList.classListTableView reloadData];
    [_classList.classListTableView  setNeedsDisplay];
    [_classList.classListTableView  setNeedsLayout];
    
    
}




#pragma mark- tableview的代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    NSLog(@"rows:%lu",(unsigned long)_noticesArr.count);
    
    
    NSInteger rows=0;
    
    if (tableView.tag==1) {
        
        if (_noticesArr.count==0) {
            rows = 0;
        }else{
            
            rows=_noticesArr.count;
        }
    }
    
    if (tableView.tag ==2) {
        if (_classesArr.count==0) {
            rows = 0;
        }else{
            
            rows=_classesArr.count;
        }
        
        
    }
    
    if (tableView.tag ==3) {
        rows = self.chatModel.dataSource.count;
    }
    
    NSLog(@"%ld",rows);
    
    return rows;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    //    NSInteger heights = 0;
    
    
    if (tableView.tag==1) {
        Notice *model =[Notice yy_modelWithJSON:_noticesArr[indexPath.row]];
        // 获取cell高度
        return  [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[NoticeTableViewCell class] contentViewWidth: [UIScreen mainScreen].bounds.size.width];
        
    }
    
    
    if (tableView.tag ==2) {
        if (_classesArr.count ==0) {
            
        }else{
            
            Classes *mod =[Classes yy_modelWithJSON: _classesArr[indexPath.row]];
            // 获取cell高度
            return  [tableView cellHeightForIndexPath:indexPath model:mod keyPath:@"classModel" cellClass:[ClassesListTableViewCell class] contentViewWidth: [UIScreen mainScreen].bounds.size.width];
            
        }
        
    }
    if (tableView.tag ==3) {
        return [self.chatModel.dataSource[indexPath.row] cellHeight];
    }
    return 0;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag ==3) {
        
        [self.view endEditing:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
   
  
    [self.view endEditing:YES];
}


#pragma mark - cellDelegate
- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSString *)userId{
    // headIamgeIcon is clicked
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:cell.messageFrame.message.strName message:@"headImage clicked" delegate:nil cancelButtonTitle:@"sure" otherButtonTitles:nil];
    [alert show];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    
    static NSString *cellIdenfier = @"cell";
    
    static NSString *cellID = @"cellID";
    
    
    UITableViewCell *tableCell = [[UITableViewCell alloc]init];
    
    if (tableView.tag == 1) {
        NoticeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
        if (cell==nil) {
            cell=[[NoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            
            if (_noticesArr.count==0) {
                
            }else{
                
                Notice *mod =[Notice yy_modelWithJSON: _noticesArr[indexPath.row]];
                NSLog(@"%@",_noticesArr[indexPath.row]);
                
                cell.model = mod;
                cell.sd_tableView = tableView;
                cell.sd_indexPath = indexPath;
                
            }
        }
        
        return cell;
    }
    
    
    if (tableView.tag ==2) {
        
        /* cell的重用队列*/
        
        ClassesListTableViewCell * idcell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (idcell==nil) {
            idcell=[[ClassesListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
            
            if (_classesArr.count==0) {
                
            }else{
                
                Classes *mod =[Classes yy_modelWithJSON: _classesArr[indexPath.row]];
                NSLog(@"%@",_classesArr[indexPath.row]);
                
                idcell.classModel = mod;
                idcell.sd_tableView = tableView;
                idcell.sd_indexPath = indexPath;
                
            }
        }
        return idcell;
        
        
    }
    
    
    if (tableView .tag ==3) {
        UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
        if (cell == nil) {
            cell = [[UUMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
            cell.delegate = self;
            
            
            
            
        }
        [cell setMessageFrame:self.chatModel.dataSource[indexPath.row]];
        
        return cell;

    }
    
    return  tableCell;
    
}


#pragma mark- 视频之外的部分
// 滑动代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [_videoInfoView.segmentControl setSelectedSegmentIndex:page animated:YES];
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
