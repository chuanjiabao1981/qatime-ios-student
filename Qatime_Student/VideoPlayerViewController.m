//
//  NELivePlayerViewController.m
//  NELivePlayerDemo
//
//  Created by NetEase on 15-10-10.
//  Copyright (c) 2015年 netease. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "NELivePlayerControl.h"

@interface VideoPlayerViewController (){
    
    NSString *_videoTitle;
    
}

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

@end

@implementation VideoPlayerViewController

NSTimeInterval mDuration;
NSTimeInterval mCurrPos;
CGFloat videoScreenWidth;
CGFloat videoScreenHeight;
bool videoIsHardware = YES;
bool videoIsmute     = NO;

+ (void)presentFromViewController:(UIViewController *)viewController withTitle:(NSString *)title URL:(NSURL *)url andDecodeParm:(NSMutableArray *)decodeParm andTitle:(NSString *)title completion:(void (^)())completion {
    [viewController presentViewController:[[VideoPlayerViewController alloc] initWithURL:url andDecodeParm:decodeParm andTitle:title] animated:YES completion:completion];
}

- (instancetype)initWithURL:(NSURL *)url andDecodeParm:(NSMutableArray *)decodeParm andTitle:(NSString *)title {
    self = [self initWithNibName:@"NELivePlayerViewController" bundle:nil];
    if (self) {
        self.url = url;
        self.decodeType = [decodeParm objectAtIndex:0];
        self.mediaType = [decodeParm objectAtIndex:1];
        _videoTitle = [NSString stringWithFormat:@"%@",title];
        
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

- (void)dealloc{
    
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view.backgroundColor = [UIColor whiteColor];
    //当前屏幕宽高
    videoScreenWidth  = CGRectGetWidth([UIScreen mainScreen].bounds);
    videoScreenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    self.playerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, videoScreenWidth, videoScreenHeight-20)];
    
    self.mediaControl = [[NELivePlayerControl alloc] initWithFrame:CGRectMake(0, 0, videoScreenHeight, videoScreenWidth)];
    [self.mediaControl addTarget:self action:@selector(onClickMediaControl:) forControlEvents:UIControlEventTouchDown];
    
    //控制
    self.controlOverlay = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, videoScreenHeight, videoScreenWidth)];
    [self.controlOverlay addTarget:self action:@selector(onClickOverlay:) forControlEvents:UIControlEventTouchDown];
    
    //顶部控制栏
    self.topControlView    = [[UIView alloc] initWithFrame:CGRectMake(0, 0, videoScreenHeight, 40)];
    self.topControlView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ic_background_black.png"]];
    self.topControlView.alpha = 0.8;
    //退出按钮
    self.playQuitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playQuitBtn setImage:[UIImage imageNamed:@"btn_player_quit"] forState:UIControlStateNormal];
    self.playQuitBtn.frame = CGRectMake(10, 0, 40, 40);
    [self.playQuitBtn addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.topControlView addSubview:self.playQuitBtn];
    
    //文件名
    self.fileName = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, videoScreenHeight - 140, 40)];
    self.fileName.text = _videoTitle;
    self.fileName.textAlignment = NSTextAlignmentCenter; //文字居中
    self.fileName.textColor = [[UIColor alloc] initWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
    self.fileName.font = [UIFont fontWithName:self.fileName.font.fontName size:13.0];
    [self.topControlView addSubview:self.fileName];
    
    //缓冲提示
    self.bufferingIndicate = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.bufferingIndicate setCenter:CGPointMake(videoScreenHeight/2, videoScreenWidth/2)];
    [self.bufferingIndicate setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.bufferingIndicate.hidden = YES;
    
    self.bufferingReminder = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    [self.bufferingReminder setCenter:CGPointMake(videoScreenHeight/2, videoScreenWidth/2 - 50)];
    self.bufferingReminder.text = @"缓冲中";
    self.bufferingReminder.textAlignment = NSTextAlignmentCenter; //文字居中
    self.bufferingReminder.textColor = [UIColor whiteColor];
    self.bufferingReminder.hidden = YES;

    //底部控制栏
    self.bottomControlView = [[UIView alloc] initWithFrame:CGRectMake(0, videoScreenWidth - 50, videoScreenHeight, 50)];
    self.bottomControlView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ic_background_black.png"]];
    self.bottomControlView.alpha = 0.8;
    
    //播放按钮
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"btn_player_pause"] forState:UIControlStateNormal];
    self.playBtn.frame = CGRectMake(10, 5, 40, 40);
    [self.playBtn addTarget:self action:@selector(onClickPlay:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomControlView addSubview:self.playBtn];
    
    //暂停按钮
    self.pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.pauseBtn setImage:[UIImage imageNamed:@"btn_player_play"] forState:UIControlStateNormal];
    self.pauseBtn.frame = CGRectMake(10, 5, 40, 40);
    [self.pauseBtn addTarget:self action:@selector(onClickPause:) forControlEvents:UIControlEventTouchUpInside];
    self.pauseBtn.hidden = YES;
    [self.bottomControlView addSubview:self.pauseBtn];

    
//    //当前播放的时间点
//    self.currentTime = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, 50, 20)];
//    self.currentTime.text = @"00:00:00"; //for test
//    self.currentTime.textAlignment = NSTextAlignmentCenter;
//    self.currentTime.textColor = [[UIColor alloc] initWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
//    self.currentTime.font = [UIFont fontWithName:self.currentTime.font.fontName size:10.0];
//    [self.bottomControlView addSubview:self.currentTime];
    
    //播放进度条
    self.videoProgress = [[UISlider alloc] initWithFrame:CGRectMake(50, 10, videoScreenHeight-200, 30)];
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"btn_player_slider_thumb"] forState:UIControlStateNormal];
    [[UISlider appearance] setMaximumTrackImage:[UIImage imageNamed:@"btn_player_slider_all"] forState:UIControlStateNormal];
    [[UISlider appearance] setMinimumTrackImage:[UIImage imageNamed:@"btn_player_slider_played"] forState:UIControlStateNormal];
    
    [self.videoProgress addTarget:self action:@selector(onClickSeek:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomControlView addSubview:self.videoProgress];

    
    //文件总时长
    self.totalDuration = [[UILabel alloc] initWithFrame:CGRectMake(videoScreenHeight-140, 10, 70, 25)];
    self.totalDuration.text = @"--:--:--";
    self.totalDuration.textAlignment = NSTextAlignmentCenter;
    self.totalDuration.textColor = [[UIColor alloc] initWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
    self.totalDuration.font = [UIFont fontWithName:self.totalDuration.font.fontName size:13.0];
    [self.bottomControlView addSubview:self.totalDuration];
    
    
//    //声音打开按钮
//    self.audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.audioBtn setImage:[UIImage imageNamed:@"btn_player_mute02"] forState:UIControlStateNormal];
//    self.audioBtn.frame = CGRectMake(videoScreenHeight-150, 5, 40, 40);
//    [self.audioBtn addTarget:self action:@selector(onClickMute:) forControlEvents:UIControlEventTouchUpInside];
//    [self.bottomControlView addSubview:self.audioBtn];
//    
//    //静音按钮
//    self.muteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.muteBtn setImage:[UIImage imageNamed:@"btn_player_mute01"] forState:UIControlStateNormal];
//    self.muteBtn.frame = CGRectMake(videoScreenHeight-150, 5, 40, 40);
//    [self.muteBtn addTarget:self action:@selector(onClickMute:) forControlEvents:UIControlEventTouchUpInside];
//    self.muteBtn.hidden = YES;
//    [self.bottomControlView addSubview:self.muteBtn];
    
//    //截图
//    self.snapshotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.snapshotBtn setImage:[UIImage imageNamed:@"btn_player_snap"] forState:UIControlStateNormal];
//    self.snapshotBtn.frame = CGRectMake(videoScreenHeight-100, 5, 40, 40);
//    if ([self.mediaType isEqualToString:@"localAudio"]) {
//        self.snapshotBtn.hidden = YES;
//    }
//    [self.snapshotBtn addTarget:self action:@selector(onClickSnapshot:) forControlEvents:UIControlEventTouchUpInside];
//    [self.bottomControlView addSubview:self.snapshotBtn];
    
//    //显示模式
//    self.scaleModeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale02"] forState:UIControlStateNormal];
//    self.scaleModeBtn.frame = CGRectMake(videoScreenHeight-50, 5, 40, 40);
//    if ([self.mediaType isEqualToString:@"localAudio"]) {
//        self.scaleModeBtn.hidden = YES;
//    }
//
//    [self.scaleModeBtn addTarget:self action:@selector(onClickScaleMode:) forControlEvents:UIControlEventTouchUpInside];
//    [self.bottomControlView addSubview:self.scaleModeBtn];
    
    //切换清晰度按钮
//    self.resolutionBtn = [[UIButton alloc]initWithFrame:CGRectMake(videoScreenHeight-60, 5, 40, 40)];
//    [self.resolutionBtn setTitle:@"高清" forState:UIControlStateNormal];
//    [self.resolutionBtn setTitleColor:[[UIColor alloc] initWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1] forState:UIControlStateNormal];
//    [self.bottomControlView addSubview:self.resolutionBtn];
//    [self.resolutionBtn addTarget:self action:@selector(chooseResolution:) forControlEvents:UIControlEventTouchUpInside];
    

    if ([self.decodeType isEqualToString:@"hardware"]) {
        videoIsHardware = YES;
    }
    else if ([self.decodeType isEqualToString:@"software"]) {
        videoIsHardware = NO;
    }
    
    [self.controlOverlay addSubview:self.topControlView];
    [self.controlOverlay addSubview:self.bottomControlView];
    
    [NELivePlayerController setLogLevel:NELP_LOG_DEBUG];

    self.liveplayer = [[NELivePlayerController alloc] initWithContentURL:self.url];
    if (self.liveplayer == nil) { // 返回空则表示初始化失败
        NSLog(@"player initilize failed, please tay again!");
    }
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
    [self.liveplayer setHardwareDecoder:videoIsHardware]; //设置解码模式，是否开启硬件解码
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"viewDidLoad");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerDidPreparedToPlay:)
                                                 name:NELivePlayerDidPreparedToPlayNotification
                                               object:_liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NeLivePlayerloadStateChanged:)
                                                 name:NELivePlayerLoadStateChangedNotification
                                               object:_liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerPlayBackFinished:)
                                                 name:NELivePlayerPlaybackFinishedNotification
                                               object:_liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerFirstVideoDisplayed:)
                                                 name:NELivePlayerFirstVideoDisplayedNotification
                                               object:_liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerFirstAudioDisplayed:)
                                                 name:NELivePlayerFirstAudioDisplayedNotification
                                               object:_liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerReleaseSuccess:)
                                                 name:NELivePlayerReleaseSueecssNotification
                                               object:_liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerVideoParseError:)
                                                 name:NELivePlayerVideoParseErrorNotification
                                               object:_liveplayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
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
    NSLog(@"click play");
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
    if (videoIsmute) {
        [self.liveplayer setMute:!videoIsmute];
        self.muteBtn.hidden = YES;
        self.audioBtn.hidden = NO;
        videoIsmute = NO;
    }
    else {
        [self.liveplayer setMute:!videoIsmute];
        self.muteBtn.hidden = NO;
        self.audioBtn.hidden = YES;
        videoIsmute = YES;
    }
}

////显示模式
//- (void)onClickScaleMode:(id)sender
//{
//    switch (self.scaleModeBtn.titleLabel.tag) {
//        case 0:
//            [self.scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale01"] forState:UIControlStateNormal];
//            [self.liveplayer setScalingMode:NELPMovieScalingModeNone];
//            
//            self.scaleModeBtn.titleLabel.tag = 1;
//            break;
//        case 1:
//            [self.scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale02"] forState:UIControlStateNormal];
//            [self.liveplayer setScalingMode:NELPMovieScalingModeAspectFit];
//            self.scaleModeBtn.titleLabel.tag = 0;
//            break;
//        default:
//            [self.scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale02"] forState:UIControlStateNormal];
//            [self.liveplayer setScalingMode:NELPMovieScalingModeAspectFit];
//            self.scaleModeBtn.titleLabel.tag = 0;
//            break;
//    }
//}
//
////截图
//- (void)onClickSnapshot:(id)sender
//{
//    NSLog(@"click snap");
//    
//    UIImage *snapImage = [self.liveplayer getSnapshot];
//    
//    UIImageWriteToSavedPhotosAlbum(snapImage, nil, nil, nil);
//    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"截图已保存到相册" preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
//    
//    [alertController addAction:action];
//    [self presentViewController:alertController animated:YES completion:nil];
//}

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

/* 切换清晰度功能*/
- (void)chooseResolution:(UIButton *)sender{
   
    
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

// 支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


@end
