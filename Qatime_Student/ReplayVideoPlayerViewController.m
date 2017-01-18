//
//  VideoPlayerViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/1/18.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ReplayVideoPlayerViewController.h"
#import "UIView+CustomControlView.h"


@interface VideoPlayerViewController ()<ZFPlayerDelegate,ZFPlayerControlViewDelagate>{
    
    /* 是否横屏*/
    BOOL isFullScreen;
    
    /* 播放url*/
    NSURL *_videoURL;
    
    /* 标题*/
    NSString *_titleStr;
    
}

@end

@implementation VideoPlayerViewController

-(instancetype)initWithURL:(NSString *)urlStr  andTitle:(NSString *)title{
    
    self=[super init];
    if (self) {
        
        _videoURL = [NSURL URLWithString:urlStr];
        _titleStr = [NSString stringWithFormat:@"%%",title];
        
        
    }
    return self;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.videoPlayer = [[ZFPlayerView alloc] init];
    [self.view addSubview:self.videoPlayer];
    
//    [self.videoPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(20);
//        make.left.right.equalTo(self.view);
//        // 注意此处，宽高比16：9优先级比1000低就行，在因为iPhone 4S宽高比不是16：9
////        make.height.equalTo(self.videoPlayer.mas_width).multipliedBy(9.0f/16.0f).with.priority(750);
//        
//        make.bottom.equalTo(self.view);
//    }];

    self.videoPlayer.sd_layout
    .topSpaceToView(self.view,20)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);

    
    /* 控制层*/
    ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
    [controlView zf_playerResolutionArray:@[@"标清",@"高清",@"超清"]];
    
    
    /* 视频model*/
    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc]init];
    playerModel.placeholderImage = [UIImage imageNamed:@"PlayerHolder"];
    /* 播放地址*/
    playerModel.videoURL = _videoURL;
    playerModel.videoURL = [NSURL URLWithString:@"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4"];
    //标题
//    playerModel.title = _titleStr;
    
    /* 控制层/播放model/代理设置*/
    self.videoPlayer.playerModel = playerModel;
    self.videoPlayer.controlView = controlView;
    self.videoPlayer.controlView.delegate = self;
    self.videoPlayer.delegate = self;
    
    
    /* 自动播放*/
    [self.videoPlayer autoPlayTheVideo];
    /* 视频填充模式*/
    self.videoPlayer.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
    
    
    /* 监听设备旋转*/
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    
}



/* 返回上一页*/


- (void)zf_controlView:(UIView *)controlView backAction:(UIButton *)sender{
    
    if ([[UIDevice currentDevice]orientation]==UIDeviceOrientationPortrait) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
    }
    
}

- (void)zf_controlView:(UIView *)controlView fullScreenAction:(UIButton *)sender{
    
    if (self.videoPlayer.isFullScreen) {
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
        ZFPlayerShared.isAllowLandscape = !self.videoPlayer.isCellVideo;
        return;
    } else {
        if (self.videoPlayer.isCellVideo) { ZFPlayerShared.isAllowLandscape = YES; }
        
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation == UIDeviceOrientationLandscapeRight) {
            self.orientation = UIInterfaceOrientationLandscapeLeft;
            [self interfaceOrientation:UIInterfaceOrientationLandscapeLeft];
        } else {
            self.orientation = UIInterfaceOrientationLandscapeRight;
            [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        }
    }

    
}

/**
 *  设置横屏的约束
 */
- (void)setOrientationLandscapeConstraint:(UIInterfaceOrientation)orientation
{
    [self toOrientation:orientation];
    self.videoPlayer.isFullScreen = YES;
}

/**
 *  设置竖屏的约束
 */
- (void)setOrientationPortraitConstraint{

    [self toOrientation:UIInterfaceOrientationPortrait];
    self.videoPlayer.isFullScreen = NO;
}

- (void)toOrientation:(UIInterfaceOrientation)orientation
{
    // 获取到当前状态条的方向
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    // 判断如果当前方向和要旋转的方向一致,那么不做任何操作
    if (currentOrientation == orientation) { return; }
    
    // 根据要旋转的方向,使用Masonry重新修改限制
    if (orientation != UIInterfaceOrientationPortrait) {//
        // 这个地方加判断是为了从全屏的一侧,直接到全屏的另一侧不用修改限制,否则会出错;
        if (currentOrientation == UIInterfaceOrientationPortrait) {
//            [self.videoPlayer removeFromSuperview];
//            ZFBrightnessView *brightnessView = [ZFBrightnessView sharedBrightnessView];
//            [[UIApplication sharedApplication].keyWindow insertSubview:self.videoPlayer belowSubview:brightnessView];
//            [self.videoPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.width.equalTo(@(ScreenHeight));
//                make.height.equalTo(@(ScreenWidth));
//                make.center.equalTo([UIApplication sharedApplication].keyWindow);
//            }];
            
            
        }
    }
    // iOS6.0之后,设置状态条的方法能使用的前提是shouldAutorotate为NO,也就是说这个视图控制器内,旋转要关掉;
    // 也就是说在实现这个方法的时候-(BOOL)shouldAutorotate返回值要为NO
    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
    // 获取旋转状态条需要的时间:
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    // 更改了状态条的方向,但是设备方向UIInterfaceOrientation还是正方向的,这就要设置给你播放视频的视图的方向设置旋转
    // 给你的播放视频的view视图设置旋转
    self.videoPlayer.transform = CGAffineTransformIdentity;
    self.videoPlayer.transform = [self getTransformRotationAngle];
    // 开始旋转
    [UIView commitAnimations];
    
//    [UIView animateWithDuration:0.3 animations:^{
    
        self.videoPlayer.sd_layout
        .widthIs(ScreenHeight)
        .heightIs(ScreenWidth);
    
    [self.videoPlayer.controlView updateLayout];
//    }];


}

/**
 * 获取变换的旋转角度
 *
 * @return 角度
 */
- (CGAffineTransform)getTransformRotationAngle
{
    // 状态条的方向已经设置过,所以这个就是你想要旋转的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // 根据要进行旋转的方向来计算旋转的角度
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if(orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}

#pragma mark 屏幕转屏相关

/**
 *  屏幕转屏
 *
 *  @param orientation 屏幕方向
 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
        // 设置横屏
        [self setOrientationLandscapeConstraint:orientation];
    } else if (orientation == UIInterfaceOrientationPortrait) {
        // 设置竖屏
        [self setOrientationPortraitConstraint];
    }
}

/**
 *  屏幕方向发生变化会调用这里
 */
- (void)onDeviceOrientationChange
{
    if (!self.videoPlayer) { return; }
    if (ZFPlayerShared.isLockScreen) { return; }
    if (self.videoPlayer.didEnterBackground) { return; };
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown ) { return; }
    
    switch (interfaceOrientation) {
            case UIInterfaceOrientationPortraitUpsideDown:{
            }
            break;
            case UIInterfaceOrientationPortrait:{
                if (self.videoPlayer.isFullScreen) {
                    [self toOrientation:UIInterfaceOrientationPortrait];
                    
                }
            }
            break;
            case UIInterfaceOrientationLandscapeLeft:{
                if (self.videoPlayer.isFullScreen == NO) {
                    [self toOrientation:UIInterfaceOrientationLandscapeLeft];
                    self.videoPlayer.isFullScreen = YES;
                } else {
                    [self toOrientation:UIInterfaceOrientationLandscapeLeft];
                }
                
            }
            break;
            case UIInterfaceOrientationLandscapeRight:{
                if (self.videoPlayer.isFullScreen == NO) {
                    [self toOrientation:UIInterfaceOrientationLandscapeRight];
                    self.videoPlayer.isFullScreen = YES;
                } else {
                    [self toOrientation:UIInterfaceOrientationLandscapeRight];
                }
            }
            break;
        default:
            break;
    }
}




/* 点击切换分辨率*/
- (void)zf_controlView:(UIView *)controlView resolutionAction:(UIButton *)sender{
    
    /* 三个分辨率按钮的tag值是200/201/202 */

    ZFPlayerModel *newModel = [[ZFPlayerModel alloc]init];
    switch (sender.tag) {
            case 200:{
                
            }
            
            break;
            
            case 201:{
                
            }
            break;
            case 202:{
                
            }
            break;
    }
    

    
    [self.videoPlayer resetToPlayNewVideo:newModel];

    // 切换完分辨率自动播放
    [self.videoPlayer autoPlayTheVideo];

    
    
}



//  是否支持自动转屏
- (BOOL)shouldAutorotate
{
    // 调用ZFPlayerSingleton单例记录播放状态是否锁定屏幕方向
    return NO;
}

// 支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

// 页面展示的时候默认屏幕方向（当前ViewController必须是通过模态ViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
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
