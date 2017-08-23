//
//  YZPlayerRecorder.m
//  Qatime_Student
//
//  Created by Shin on 2017/8/18.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "YZPlayerRecorder.h"
/**
 录音机的 状态
 
 - RecorderStateNormal: 普通状态
 - RecorderStatePlaying: 播放中
 
 */
typedef NS_ENUM(NSUInteger, RecorderState) {
    RecorderStateNormal,
    RecorderStatePlaying,
};

@interface YZPlayerRecorder ()<AVAudioPlayerDelegate>{
    
    NSTimer *_playTimer; //播放定时器
    NSInteger _secendTime; //录音时间
    NSInteger _playingTime; //音频时长
}

@end

@implementation YZPlayerRecorder

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self setupViews];

}
//加载视图
- (void)setupViews{
    
    //录音
    _recordView = [[UIView alloc]init];
    [self.view addSubview:_recordView];
    _recordView.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
    _recordView.layer.borderWidth = 1;
    _recordView.backgroundColor = [UIColor whiteColor];
    _recordView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    
    _playBtn = [[UIButton alloc]init];
    [_playBtn setImage:[UIImage imageNamed:@"question_play"] forState:UIControlStateNormal];
    [_recordView addSubview:_playBtn];
    _playBtn.sd_layout
    .topSpaceToView(self.view, 10*ScrenScale)
    .bottomSpaceToView(self.view, 10*ScrenScale)
    .leftSpaceToView(_recordView, 10*ScrenScale)
    .widthEqualToHeight();
    
    [_playBtn addTarget:self action:@selector(playRecord:) forControlEvents:UIControlEventTouchUpInside];
    
    _secend = [[UILabel alloc]init];
    _secend.text = @"60''";
    [_recordView addSubview:_secend];
    _secend.font = TEXT_FONTSIZE_MIN;
    _secend.textColor = TITLECOLOR;
    _secend.sd_layout
    .rightSpaceToView(self.view, 10*ScrenScale)
    .centerYEqualToView(self.view)
    .autoHeightRatio(0);
    [_secend setSingleLineAutoResizeWithMaxWidth:200];
    
    _slider = [[M13ProgressViewBar alloc]initWithFrame:CGRectZero];
    [_recordView addSubview:_slider];
    _slider.sd_layout
    .rightSpaceToView(_secend, 10*ScrenScale)
    .centerYEqualToView(_secend)
    .heightRatioToView(_secend, 1.0f)
    .leftSpaceToView(_playBtn, 10*ScrenScale);
    [_slider updateLayout];
    _slider.progressDirection = M13ProgressViewBarProgressDirectionLeftToRight;
    _slider.progressBarCornerRadius = 0.0;
    _slider.showPercentage = NO;
    [_slider setProgress:0.0 animated:YES];
    
   
}

- (void)playRecord:(UIButton *)sender {
    NSLog(@"播放录音");
    [self.recorder stop];
    if ([self.player isPlaying])return;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordFileUrl error:nil];
    self.player.delegate = self;
    NSLog(@"%li",self.player.data.length/1024);
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.player play];
    [self addPlayTimer];
    [self changeRecorder:RecorderStatePlaying];
}

- (void)addPlayTimer{
    _playTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(playingSlider) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_playTimer forMode:NSRunLoopCommonModes];
    
}

- (void)playingSlider{
    _playingTime--;
    [_slider setProgress:_slider.progress+1.0/_secendTime animated:YES];
    _secend.text = [NSString stringWithFormat:@"%ld''",_playingTime];
}

- (void)stopPlaying{
    [self.player stop];
    [self removePlayerTimer];
    [_slider setProgress:0.0 animated:YES];
    [self changeRecorder:RecorderStateNormal];
    [_slider performAction:M13ProgressViewActionNone animated:YES];
    _secend.text = [NSString stringWithFormat:@"%ld''",_secendTime];
    _playingTime = _secendTime;
    
}
- (void)removePlayerTimer{
    [_playTimer invalidate];
    _playTimer = nil;
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    if (flag) {
        //停止播放
        [self removePlayerTimer];
        [_slider setProgress:0.0 animated:YES];
        [_slider performAction:M13ProgressViewActionNone animated:YES];
        [self changeRecorder:RecorderStateNormal];
        _secend.text = [NSString stringWithFormat:@"%ld''",_secendTime];
        _playingTime = _secendTime;
    }
}
#pragma mark- 录音的时候 的录音机的变化
- (void)changeRecorder:(RecorderState)state{
    switch (state) {
        case RecorderStateNormal:{
            _secend.text = @"60''";
            [_playBtn removeAllTargets];
            [_playBtn setImage:[UIImage imageNamed:@"question_play"] forState:UIControlStateNormal];
            [_playBtn addTarget:self action:@selector(playRecord:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case RecorderStatePlaying:{
            [_playBtn setImage:[UIImage imageNamed:@"question_stop"] forState:UIControlStateNormal];
            [_playBtn removeAllTargets];
            [_playBtn addTarget:self action:@selector(stopPlaying) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
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
