//
//  BilibiliViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/11.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "BilibiliViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

#import <Accelerate/Accelerate.h>

@interface BilibiliViewController ()

@property (atomic, strong) id <IJKMediaPlayback> player1;
@property (atomic, strong) id <IJKMediaPlayback> player2;

@property (atomic, strong) UIView *playerView1;

@property (atomic, strong) UIView *playerView2;



@end

@implementation BilibiliViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置ijkPlayer控制器
    _player1= [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"rtmp:/a0a19f55.live.126.net/live/834c6312006e4ffe927795a11fd317af"] withOptions:nil];
    
    _player2= [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"rtmp:/a0a19f55.live.126.net/live/834c6312006e4ffe927795a11fd317af"] withOptions:nil];
    //用ijkPlayer控制器创建一个播放器视图
    UIView *playerview1 = [self.player1 view];
    UIView *playerview2 = [self.player2 view];
    
    //实例化一个屏幕大小的view
    UIView *displayView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame)/16*9.0f)];
    UIView *displayView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame)/16*9.0f)];
    
    //让这个全局的PlayerView是一个覆盖全屏的view
    self.playerView1 = displayView1;
    self.playerView2 = displayView2;
    
    //把这个全局的PlayerView添加到控制器的view
    [self.view addSubview:self.playerView1];
    [self.view addSubview:self.playerView2];
    
    // 自动调整自己的宽度和高度
    playerview1.frame = self.playerView1.bounds;
    playerview2.frame = self.playerView2.bounds;
    
    _playerView1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _playerView2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    
    //把播放器视图添加到全局的PlayerView上
    [self.playerView1 insertSubview:playerview1 atIndex:1];
    [self.playerView2 insertSubview:playerview2 atIndex:1];
    
    //设置播放器的填充模式
    [_player1 setScalingMode:IJKMPMovieScalingModeAspectFill];
    [_player2 setScalingMode:IJKMPMovieScalingModeAspectFill];


    
    
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
