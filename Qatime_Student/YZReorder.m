//
//  YZReorder.m
//  Qatime_Student
//
//  Created by Shin on 2017/8/16.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "YZReorder.h"
#import <AVFoundation/AVFoundation.h>
#import "UIControl+RemoveTarget.h"
#import "UIAlertController+Blocks.h"

/**
 录音机的 状态
 
 - RecorderStateNormal: 普通状态
 - RecorderStateRecording: 录音中
 - RecorderStatePlaying: 播放中
 - RecorderStateRecordFinished: 录音完成,可以播放
 */
typedef NS_ENUM(NSUInteger, RecorderState) {
    RecorderStateNormal,
    RecorderStateRecording,
    RecorderStatePlaying,
    RecorderStateRecordFinished,
};


@interface YZReorder ()<AVAudioPlayerDelegate>{
    
    NSTimer *_timer; //录音定时器
    NSTimer *_playTimer; //播放定时器
    NSInteger countDown;  //倒计时
    
    NSString *filePath; //录音存放路径
    
    NSInteger _secendTime; //录音时间
    
    NSInteger _playingTime; //音频时长

}

@property (nonatomic, strong) AVAudioSession *session;

@property (nonatomic, strong) AVAudioRecorder *recorder;//录音器

@property (nonatomic, strong) AVAudioPlayer *player; //播放器
@property (nonatomic, strong) NSURL *recordFileUrl; //文件地址

@end


@implementation YZReorder

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
    
    //右侧多功能按钮
    _rightBtn = [[UIButton alloc]init];
    [_recordView addSubview:_rightBtn];
    [_rightBtn setImage:[UIImage imageNamed:@"question_record"] forState:UIControlStateNormal];
    _rightBtn.sd_layout
    .topSpaceToView(_recordView, 5*ScrenScale)
    .rightSpaceToView(_recordView, 5*ScrenScale)
    .bottomSpaceToView(_recordView, 5*ScrenScale)
    .widthEqualToHeight();
    
    _secend = [[UILabel alloc]init];
    _secend.text = @"60'";
    [_recordView addSubview:_secend];
    _secend.font = TEXT_FONTSIZE_MIN;
    _secend.textColor = TITLECOLOR;
    _secend.sd_layout
    .rightSpaceToView(_rightBtn, 10*ScrenScale)
    .centerYEqualToView(_rightBtn)
    .autoHeightRatio(0);
    [_secend setSingleLineAutoResizeWithMaxWidth:200];
    
    _slider = [[YZSlider alloc]init];
    _slider.enabled = NO;
    [_recordView addSubview:_slider];
    _slider.sd_layout
    .rightSpaceToView(_secend, 10*ScrenScale)
    .centerYEqualToView(_secend)
    .heightRatioToView(_secend, 1.0f)
    .leftSpaceToView(_recordView, 10*ScrenScale);
    
    _playBtn = [[UIButton alloc]init];
    [_playBtn setImage:[UIImage imageNamed:@"question_play"] forState:UIControlStateNormal];
    [_recordView addSubview:_playBtn];
    _playBtn.sd_layout
    .topEqualToView(_rightBtn)
    .bottomEqualToView(_rightBtn)
    .leftSpaceToView(_recordView, 10*ScrenScale)
    .widthEqualToHeight();
    _playBtn.hidden = YES;
    
    [_rightBtn addTarget:self action:@selector(startRecording:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark- 录音
/** 开始录音 */
- (void)startRecording:(UIButton *)sender{
    
    NSLog(@"开始录音");
    countDown = 60.f;
    AVAudioSession *session =[AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if (session == nil) {
        NSLog(@"Error creating session: %@",[sessionError description]);
    }else{
        [session setActive:YES error:nil];
    }
    self.session = session;
    //1.获取沙盒地址
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    filePath = [path stringByAppendingString:@"/RRecord.aac"];
    //2.获取文件路径
    self.recordFileUrl = [NSURL fileURLWithPath:filePath];
    //设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey,
                                   // 音频格式
                                   [NSNumber numberWithInt: kAudioFormatMPEG4AAC],AVFormatIDKey,
                                   //采样位数  8、16、24、32 默认为16
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                   // 音频通道数 1 或 2
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                   //录音质量
                                   [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                   nil];
    _recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:recordSetting error:nil];
    _secendTime = 0;
    if (_recorder) {
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
        [_recorder record];
        [self addTimer];
        [self changeRecorder:RecorderStateRecording];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(countDown * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stopRecorder:nil];
        });
    }else{
        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
    }
}

- (void)stopRecorder:(UIButton *)sender{
    [self removeTimer];
    NSLog(@"停止录音");
    _secendTime = 0;
    if ([self.recorder isRecording]) {
        [self.recorder stop];
        [self changeRecorder:RecorderStateRecordFinished];
    }
    //同时 slider归零
    [_slider setValue:0 animated:YES];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        NSLog(@"%@",[NSString stringWithFormat:@"录了 %ld 秒,文件大小为 %.2fKb",countDown - (long)countDown,[[manager attributesOfItemAtPath:filePath error:nil] fileSize]/1024.0]);
    }else{
        
    }
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
    _playingTime = (NSInteger)self.player.duration;
    [_slider setValue:_slider.value+1.0/_playingTime animated:YES];
}

- (void)stopPlaying{
    [self.player stop];
    [self removePlayerTimer];
    [_slider setValue:0 animated:YES];
    [self changeRecorder:RecorderStateRecordFinished];
    
}

- (void)deleteRecord{
    [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"确定删除该条语音?" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"删除"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex!=0) {
            NSError *error = [[NSError alloc]init];
            [[NSFileManager defaultManager]removeItemAtPath:filePath error:&error];
            [self changeRecorder:RecorderStateNormal];
        }
    }];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    if (flag) {
        //停止播放
        [self removePlayerTimer];
        [_slider setValue:0 animated:YES];
        [self changeRecorder:RecorderStateRecordFinished];
    }
}

/**
 *  添加定时器
 */
- (void)addTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshSlider) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)refreshSlider{
    _secendTime++;
    _secend.text = [NSString stringWithFormat:@"%ld'",_secendTime];
    [_slider setValue:_slider.value+1.0/countDown animated:YES];
}

/**
 *  移除定时器
 */
- (void)removeTimer{
    [_timer invalidate];
    _timer = nil;
}

- (void)removePlayerTimer{
    [_playTimer invalidate];
    _playTimer = nil;
}

#pragma mark- 录音的时候 的录音机的变化
- (void)changeRecorder:(RecorderState)state{
    switch (state) {
        case RecorderStateNormal:{
            
            [_rightBtn setImage:[UIImage imageNamed:@"question_record"] forState:UIControlStateNormal];
            _secend.text = @"60'";
            [_rightBtn removeAllTargets];
            [_rightBtn addTarget:self action:@selector(startRecording:) forControlEvents:UIControlEventTouchUpInside];
            _playBtn.hidden = YES;
            _slider.sd_layout
            .leftSpaceToView(_recordView, 10*ScrenScale);
            [_slider updateLayout];
            
        }
            break;
        case RecorderStateRecording:{
            
            [_rightBtn setImage:[UIImage imageNamed:@"question_stop"] forState:UIControlStateNormal];
            [_rightBtn removeAllTargets];
            [_rightBtn addTarget:self action:@selector(stopRecorder:) forControlEvents:UIControlEventTouchUpInside];
            _playBtn.hidden = YES;
            _slider.sd_layout
            .leftSpaceToView(_recordView, 10*ScrenScale);
            [_slider updateLayout];
        }
            break;
        case RecorderStateRecordFinished:{
            
            [_rightBtn setImage:[UIImage imageNamed:@"question_delete"] forState:UIControlStateNormal];
            [_rightBtn removeAllTargets];
            [_rightBtn addTarget:self action:@selector(deleteRecord) forControlEvents:UIControlEventTouchUpInside];
            _playBtn.hidden = NO;
            [_playBtn setImage:[UIImage imageNamed:@"question_play"] forState:UIControlStateNormal];
            [_playBtn addTarget:self action:@selector(playRecord:) forControlEvents:UIControlEventTouchUpInside];
            _slider.sd_layout
            .leftSpaceToView(_playBtn, 10*ScrenScale);
            [_slider updateLayout];
            
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
