//
//  VideoClassPlayerViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/12.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "VideoClassPlayerViewController.h"

@interface VideoClassPlayerViewController ()<ZFPlayerDelegate>{
    
    //播放器模型
    ZFPlayerModel *_playerModel;
}

@end

@implementation VideoClassPlayerViewController

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //加载播放器
    [self setupVideoPlayer];
    
}

/**播放器设置*/
- (void)setupVideoPlayer{
    
    self.videoPlayer = [[ZFPlayerView alloc] init];
    [self.view addSubview:self.videoPlayer];
    [self.videoPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.equalTo(self.videoPlayer.mas_width).multipliedBy(9.0f/16.0f);
    }];
    // 初始化控制层view
    // 考虑自定义
    ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
    [self.videoPlayer addSubview:controlView];
    [controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.videoPlayer);
    }];
    
    // 初始化播放模型
    _playerModel = [[ZFPlayerModel alloc]init];
    _playerModel.videoURL = [NSURL URLWithString:@""];
    _playerModel.title = @"";
    [self.videoPlayer playerControlView:controlView playerModel:_playerModel];
    
    // 设置代理
    self.videoPlayer.delegate = self;
    // 自动播放
    [self.videoPlayer autoPlayTheVideo];
    
    // 下载功能，如需要此功能设置这里
    self.videoPlayer.hasDownload = YES;
    // 预览图
    self.videoPlayer.hasPreviewView = YES;
    
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
