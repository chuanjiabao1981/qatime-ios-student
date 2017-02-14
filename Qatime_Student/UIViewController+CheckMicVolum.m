//
//  UIViewController+CheckMicVolum.m
//  Qatime_Student
//
//  Created by Shin on 2017/2/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "UIViewController+CheckMicVolum.h"
#import <AVFoundation/AVAudioSession.h>
#import <AVFoundation/AVAudioSettings.h>
#import <AVFoundation/AVAudioRecorder.h>

@implementation UIViewController (CheckMicVolum)

- (void)checkMicVolum{
    
    /* 必须添加这句话，否则在模拟器可以，在真机上获取始终是0 */
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
    
    /* 不需要保存录音文件 */
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0], AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax], AVEncoderAudioQualityKey,
                              nil];
    
    
    AVAudioRecorder *recorder;
    NSError *error;
    NSTimer *levelTimer;
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    if (recorder)
    {
        [recorder prepareToRecord];
        recorder.meteringEnabled = YES;
        [recorder record];
        levelTimer = [NSTimer scheduledTimerWithTimeInterval: 1 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
    }
    else
    {  
        NSLog(@"%@", [error description]);  
    }
    
}


@end
