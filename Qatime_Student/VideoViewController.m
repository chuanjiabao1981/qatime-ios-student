//
//  VideoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/10.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "VideoViewController.h"
#import "UIViewController+ZFPlayerRotation.h"
#import "UITabBarController+ZFPlayerRotation.h"
#import "UINavigationController+ZFPlayerRotation.h"
#import "NavigationBar.h"

#import <MediaPlayer/MediaPlayer.h>
#import "RDVTabBarController.h"

@interface VideoViewController ()<ZFPlayerControlViewDelagate,ZFPlayerDelegate>{
    
    NavigationBar *_navigationBar;
    
}

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor whiteColor];
    _navigationBar = [[NavigationBar alloc]init];
    [self.view addSubview:_navigationBar];
    
    
    _navigationBar.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .heightIs(64);
    
    
    
    self.playerView = [[ZFPlayerView alloc] init];
    self.playerView.hasPreviewView = YES;
    
    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
    
    [self.view addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_offset(0,64);
        make.left.right.equalTo(self.view);
        // 这里宽高比16：9，可以自定义视频宽高比
        make.height.equalTo(self.playerView.mas_width).multipliedBy(9.0f/16.0f);
    }];
    
  
    
    
    
    // 指定控制层（可自定义）
    ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
    self.playerView.controlView = controlView;
    
    
    
    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc]init];
    playerModel.videoURL =[NSURL URLWithString:@"http://baobab.wdjcdn.com/14571455324031.mp4"];
    
    
    
    // 设置视频model
    self.playerView.playerModel = playerModel;
   
    // 设置代理
    self.playerView.delegate= self;
    
    
    
    
    
}
/* 返回按钮*/
- (void)zf_playerBackAction{
    
    [self.playerView resetPlayer];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//  是否支持自动转屏
- (BOOL)shouldAutorotate
{
    // 调用ZFPlayerSingleton单例记录播放状态是否锁定屏幕方向
    return !ZFPlayerShared.isLockScreen;
}

// 支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

//// 页面展示的时候默认屏幕方向（当前ViewController必须是通过模态ViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationPortrait;
//}


//全屏播放视频后，播放器的适配和全屏旋转
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
//        self.fd_interactivePopDisabled = NO;
        //if use Masonry,Please open this annotation
        
         [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.view).offset(20);
         }];
        
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.view.backgroundColor = [UIColor blackColor];
//        self.fd_interactivePopDisabled = YES;
        //if use Masonry,Please open this annotation
       
         [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.view).offset(0);
         }];
        
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
