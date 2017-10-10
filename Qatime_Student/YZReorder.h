//
//  YZReorder.h
//  Qatime_Student
//
//  Created by Shin on 2017/8/16.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M13ProgressViewBar.h"
#import <AVFoundation/AVFoundation.h>

//使用lame转成MP3
#include "lame.h"


typedef void(^RecordFinished)(NSString *recordfileURL);

@interface YZReorder : UIViewController

@property (nonatomic, strong) UIView *recordView ;

/** 录音右侧按钮 / 根据录音状态,可变 */
@property (nonatomic, strong) UIButton *rightBtn ;

@property (nonatomic, strong) UIButton *playBtn ;

/** 音频播放时候的滑竿 */
@property (nonatomic, strong) M13ProgressViewBar *slider ;

/** 时间 */
@property (nonatomic, strong) UILabel *secend ;

@property (nonatomic, strong) AVAudioSession *session;

@property (nonatomic, strong) AVAudioRecorder *recorder;//录音器

@property (nonatomic, strong) AVAudioPlayer *player; //播放器
@property (nonatomic, strong) NSURL *recordFileUrl; //文件地址

@property (nonatomic, copy) RecordFinished finishedFile ;







@end
