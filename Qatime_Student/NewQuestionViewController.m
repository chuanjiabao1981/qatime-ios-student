//
//  NewQuestionViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/8/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "NewQuestionViewController.h"
#import "NavigationBar.h"
#import "QuestionPhotosCollectionViewCell.h"
#import "LCActionSheet.h"
#import "KSPhotoBrowser.h"
#import "UIViewController+HUD.h"
#import <AVFoundation/AVFoundation.h>
#import "UIControl+RemoveTarget.h"
#import "UIAlertController+Blocks.h"
#import "ZLPhotoPickerBrowserViewController.h"


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

@interface NewQuestionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate,AVAudioPlayerDelegate,ZLPhotoPickerBrowserViewControllerDelegate>{
    
    NavigationBar *_navigationBar;
    
    NSMutableArray *_phototsArray;
    
    NSTimer *_timer; //录音定时器
    NSTimer *_playTimer; //播放定时器
    NSInteger countDown;  //倒计时
    
    NSString *filePath; //录音存放路径
    
    NSInteger _secendTime; //录音时间
    
    NSInteger _playingTime; //音频时长
    
//    PYPhotoBrowseView *_photoBroseView;
    
}
@property (nonatomic, strong) AVAudioSession *session;

@property (nonatomic, strong) AVAudioRecorder *recorder;//录音器

@property (nonatomic, strong) AVAudioPlayer *player; //播放器
@property (nonatomic, strong) NSURL *recordFileUrl; //文件地址

@property (nonatomic, strong) NavigationBar * photoBar ;//图片预览页面的navigation


@end

@implementation NewQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNDGRAY;
    
    [self makeData];
    [self setupView];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
}

- (void)makeData{
    
    _phototsArray = @[].mutableCopy;
}

- (void)setupView{
    //navigation
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview:_navigationBar];
    _navigationBar.titleLabel.text = @"提问";
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.rightButton setImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    //mainView
    _mainView = [[NewQuestionView alloc]init];
    [self.view addSubview:_mainView];
    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(_navigationBar, 0)
    .bottomSpaceToView(self.view, 0);
    
    _mainView.title.delegate = self ;
    _mainView.questions.delegate = self;
    
    _mainView.photosView.delegate = self;
    _mainView.photosView.dataSource = self;
    
    [_mainView.photosView registerClass:[QuestionPhotosCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    
    [_mainView.rightBtn addTarget:self action:@selector(startRecording:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark- UITextField 
-(void)textDidChange:(id<UITextInput>)textInput{
    
    if (_mainView.title.text.length>20) {
        _mainView.title.text = [_mainView.title.text substringToIndex:20];
        [self HUDStopWithTitle:@"问题标题最多20字"];
    }
}


- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView == _mainView.questions) {
        if (textView.text.length>100) {
            textView.text = [textView.text substringToIndex:100];
            [self HUDStopWithTitle:@"问题最多100字"];
        }
    }
}


#pragma mark- collectionview datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger items;
    if (_phototsArray.count == 0) {
        items = 1;
    }else{
        items = _phototsArray.count + 1;
    }
    return items;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"cellID";
    QuestionPhotosCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (_phototsArray.count == 0) {
        cell.image.image = [UIImage imageNamed:@"question_addphoto"];
        cell.deleteBtn.hidden = YES;
    }else{
        if (indexPath.row == _phototsArray.count) {
            cell.image.image = [UIImage imageNamed:@"question_addphoto"];
            cell.deleteBtn.hidden = YES;
        }else{
            cell.deleteBtn.hidden = NO;
            cell.image.image = _phototsArray[indexPath.row];
            cell.deleteBtn.tag = indexPath.row;
            [cell.deleteBtn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return cell;
}

- (void)deleteImage:(UIButton *)sender{
    
    [_phototsArray removeObjectAtIndex:sender.tag];
    [_mainView.photosView reloadData];
    
}

#pragma mark- collectionview delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //没照片的时候
    if (_phototsArray.count == 0) {
        if (indexPath.row == 0) {
          [self showSheet];
        }
    }else{
        if (indexPath.row == _phototsArray.count) {
            [self showSheet];
        }else{
            //预览照片啊
            //用ZLPhoto
            NSMutableArray *photos = @[].mutableCopy;
            ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
            // 淡入淡出效果
             pickerBrowser.status = UIViewAnimationAnimationStatusZoom;
            // 数据源/delegate
            for (QuestionPhotosCollectionViewCell *cell in collectionView.visibleCells) {
                if (cell.deleteBtn.hidden == NO) {
                    ZLPhotoPickerBrowserPhoto *mod = [[ZLPhotoPickerBrowserPhoto alloc]init];
                    mod.toView = cell.image;
                    mod.photoImage = cell.image.image;
                    [photos addObject:mod];
                }
            }
            
            pickerBrowser.editing = YES;
            pickerBrowser.photos = photos;
            // 能够删除
            pickerBrowser.delegate = self;
            // 当前选中的值
            pickerBrowser.currentIndex = indexPath.row;
            // 展示控制器
            [pickerBrowser showPickerVc:self];

        }
    }
}

/**
 *  删除indexPath对应索引的图片
 *
 *  @param index 要删除的索引值
 */
- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index{
    
    [_phototsArray removeObjectAtIndex:index];
    [_mainView.photosView reloadData];
    
}

- (void)showSheet{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    
    picker.delegate = self;
    LCActionSheet *sheet = [[LCActionSheet alloc]initWithTitle:@"选择头像" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        
        switch (buttonIndex) {
            case 0:
                return ;
                break;
                
            case 1:{
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
            }
                break;
            case 2:{
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
            }
                break;
            case 3:{
                picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                
            }
                break;
        }
        [self presentViewController:picker animated:YES completion:^{}];
        
    } otherButtonTitleArray:@[@"照相机",@"图库",@"相册"]];
    
    [sheet show];
}

//图片回调
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSLog(@"%@",info);
    
    @try {
        [picker dismissViewControllerAnimated:YES completion:^{
        }];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [_phototsArray addObject:image];
        [_mainView.photosView reloadData];
    } @catch (NSException *exception) {

    } @finally {
        
    }
    
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
    [_mainView.slider setValue:0 animated:YES];
    
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
    
    [_mainView.slider setValue:_mainView.slider.value+1.0/_playingTime animated:YES];
    
    

}

- (void)stopPlaying{
    
    [self.player stop];
    [self removePlayerTimer];
    [_mainView.slider setValue:0 animated:YES];
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
        [_mainView.slider setValue:0 animated:YES];
        [self changeRecorder:RecorderStateRecordFinished];
    }
    
}

/**
 *  添加定时器
 */
- (void)addTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshSlider) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)refreshSlider{
    
    _secendTime++;
    _mainView.secend.text = [NSString stringWithFormat:@"%ld'",_secendTime];
    
    [_mainView.slider setValue:_mainView.slider.value+1.0/countDown animated:YES];
    
}

/**
 *  移除定时器
 */
- (void)removeTimer
{
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
            
            [_mainView.rightBtn setImage:[UIImage imageNamed:@"question_record"] forState:UIControlStateNormal];
            _mainView.secend.text = @"60'";
            [_mainView.rightBtn removeAllTargets];
            [_mainView.rightBtn addTarget:self action:@selector(startRecording:) forControlEvents:UIControlEventTouchUpInside];
            _mainView.playBtn.hidden = YES;
            _mainView.slider.sd_layout
            .leftSpaceToView(_mainView.recordView, 10*ScrenScale);
            [_mainView.slider updateLayout];
            
        }
            break;
        case RecorderStateRecording:{
            
            [_mainView.rightBtn setImage:[UIImage imageNamed:@"question_stop"] forState:UIControlStateNormal];
            [_mainView.rightBtn removeAllTargets];
            [_mainView.rightBtn addTarget:self action:@selector(stopRecorder:) forControlEvents:UIControlEventTouchUpInside];
            _mainView.playBtn.hidden = YES;
            _mainView.slider.sd_layout
            .leftSpaceToView(_mainView.recordView, 10*ScrenScale);
            [_mainView.slider updateLayout];
        }
            break;
        case RecorderStateRecordFinished:{
            
            [_mainView.rightBtn setImage:[UIImage imageNamed:@"question_delete"] forState:UIControlStateNormal];
            [_mainView.rightBtn removeAllTargets];
            [_mainView.rightBtn addTarget:self action:@selector(deleteRecord) forControlEvents:UIControlEventTouchUpInside];
            _mainView.playBtn.hidden = NO;
            [_mainView.playBtn setImage:[UIImage imageNamed:@"question_play"] forState:UIControlStateNormal];
            [_mainView.playBtn addTarget:self action:@selector(playRecord:) forControlEvents:UIControlEventTouchUpInside];
            _mainView.slider.sd_layout
            .leftSpaceToView(_mainView.playBtn, 10*ScrenScale);
            [_mainView.slider updateLayout];
            
        }
            break;
        case RecorderStatePlaying:{
            [_mainView.playBtn setImage:[UIImage imageNamed:@"question_stop"] forState:UIControlStateNormal];
            [_mainView.playBtn removeAllTargets];
            [_mainView.playBtn addTarget:self action:@selector(stopPlaying) forControlEvents:UIControlEventTouchUpInside];
            
        }
            break;
    }
    
}

-(NavigationBar *)photoBar{
    
    if (!_photoBar) {
        _photoBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
        [_photoBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_photoBar.rightButton setImage:[UIImage imageNamed:@"垃圾桶"] forState:UIControlStateNormal];
        _photoBar.hidden = YES;
        _photoBar.titleLabel.text = @"图片预览";
    }
    return _photoBar;
}



- (void)returnLastPage{
    
    [self.navigationController popViewControllerAnimated:YES];
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
