//
//  YZPlayerRecorder.h
//  Qatime_Student
//
//  Created by Shin on 2017/8/18.
//  Copyright © 2017年 WWTD. All rights reserved.

//  只能用来播放声音的 录音机 或者说是 播放器

#import <UIKit/UIKit.h>
#import "M13ProgressViewBar.h"
#import <AVFoundation/AVFoundation.h>
#import "UIControl+RemoveTarget.h"
#import "UIAlertController+Blocks.h"


@interface YZPlayerRecorder : UIViewController

@property (nonatomic, strong) UIView *recordView ;

@property (nonatomic, strong) UIButton *playBtn ;

/** 音频播放时候的滑竿 */
@property (nonatomic, strong) M13ProgressViewBar *slider ;

/** 时间 */
@property (nonatomic, strong) UILabel *secend ;

@property (nonatomic, strong) AVAudioSession *session;

@property (nonatomic, strong) AVAudioRecorder *recorder;//录音器

@property (nonatomic, strong) AVAudioPlayer *player; //播放器

@property (nonatomic, strong) NSURL *recordFileUrl; //文件地址


@end
