//
//  YZReorder.m
//  Qatime_Student
//
//  Created by Shin on 2017/8/16.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "YZReorder.h"

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



@end


@implementation YZReorder


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

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
    _secend.text = @"60''";
    [_recordView addSubview:_secend];
    _secend.font = TEXT_FONTSIZE_MIN;
    _secend.textColor = TITLECOLOR;
    _secend.sd_layout
    .rightSpaceToView(_rightBtn, 10*ScrenScale)
    .centerYEqualToView(_rightBtn)
    .autoHeightRatio(0);
    [_secend setSingleLineAutoResizeWithMaxWidth:200];
    
    _slider = [[M13ProgressViewBar alloc]initWithFrame:CGRectZero];
    [_recordView addSubview:_slider];
    _slider.sd_layout
    .rightSpaceToView(_secend, 10*ScrenScale)
    .centerYEqualToView(_secend)
    .heightRatioToView(_secend, 1.0f)
    .leftSpaceToView(_recordView, 10*ScrenScale);
    [_slider updateLayout];
    _slider.progressDirection = M13ProgressViewBarProgressDirectionLeftToRight;
    _slider.progressBarCornerRadius = 0.0;
    _slider.showPercentage = NO;
    [_slider setProgress:0.0 animated:YES];

    
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
    filePath = [path stringByAppendingString:@"/RRecord.pcm"];
    //2.获取文件路径
    self.recordFileUrl = [NSURL fileURLWithPath:filePath];
    //设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                   [NSNumber numberWithFloat: 44100.0],AVSampleRateKey,
                                   // 音频格式
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   //采样位数  8、16、24、32 默认为16
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                   // 音频通道数 1 或 2
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                   //录音质量
                                   [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                   nil];
    _recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:recordSetting error:nil];
    if (_recorder) {
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
        [self addTimer];
        [_recorder record];
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
    _playingTime = _secendTime;
//    _secendTime = 0;
    if ([self.recorder isRecording]) {
        [self.recorder stop];
        [self changeRecorder:RecorderStateRecordFinished];
    }
    //同时 slider归零
    [_slider setProgress:0.0 animated:YES];
    [_slider performAction:M13ProgressViewActionNone animated:YES];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        NSLog(@"%@",[NSString stringWithFormat:@"录了 %ld 秒,文件大小为 %.2fKb",countDown - (long)countDown,[[manager attributesOfItemAtPath:filePath error:nil] fileSize]/1024.0]);
        
        //转换音频文件
       [self audioPCMtoMP3:filePath];
        
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
    _playingTime--;
    [_slider setProgress:_slider.progress+1.0/_secendTime animated:YES];
    _secend.text = [NSString stringWithFormat:@"%ld''",_playingTime];
}

- (void)stopPlaying{
    [self.player stop];
    [self removePlayerTimer];
    [_slider setProgress:0.0 animated:YES];
    [self changeRecorder:RecorderStateRecordFinished];
    [_slider performAction:M13ProgressViewActionNone animated:YES];
    _secend.text = [NSString stringWithFormat:@"%ld''",_secendTime];
    _playingTime = _secendTime;
    
}

- (void)deleteRecord{
    [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"确定删除该条语音?" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"删除"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex!=0) {
            NSError *error = [[NSError alloc]init];
            NSError *error2 = [[NSError alloc]init];
            [[NSFileManager defaultManager]removeItemAtPath:filePath error:&error];
             [[NSFileManager defaultManager]removeItemAtPath:self.recordFileUrl.absoluteString  error:&error2];
            [self changeRecorder:RecorderStateNormal];
        }
    }];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    if (flag) {
        //停止播放
        [self removePlayerTimer];
        [_slider setProgress:0.0 animated:YES];
        [_slider performAction:M13ProgressViewActionNone animated:YES];
        [self changeRecorder:RecorderStateRecordFinished];
        _secend.text = [NSString stringWithFormat:@"%ld''",_secendTime];
        _playingTime = _secendTime;
    }
}

/**
 *  添加定时器
 */
- (void)addTimer{
    _secendTime = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshSlider) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)refreshSlider{
    _secendTime++;
    if (_secendTime>60) {
        _secendTime = 60;
    }
    _secend.text = [NSString stringWithFormat:@"%ld''",_secendTime];
    [_slider setProgress:_slider.progress+1.0/countDown animated:YES];
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
            _secend.text = @"60''";
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

//转换部分

- (NSString *)audioPCMtoMP3:(NSString *)wavPath {
    NSString *cafFilePath = wavPath;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *mp3FilePath = [path stringByAppendingString:@"/RRecord.mp3"];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if([fileManager removeItemAtPath:mp3FilePath error:nil]){
        NSLog(@"删除原MP3文件");
    }
    @try {
        int read, write;
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 22050.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        if([fileManager removeItemAtPath:wavPath error:nil]){
            NSLog(@"删除原pcm文件");
        }
        self.recordFileUrl = [NSURL URLWithString:mp3FilePath];
        
        _finishedFile(mp3FilePath);
        return mp3FilePath;
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
