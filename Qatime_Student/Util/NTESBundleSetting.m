//
//  NTESBundleSetting.m
//  NIM
//
//  Created by chris on 15/7/1.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESBundleSetting.h"

@implementation NTESBundleSetting

+ (instancetype)sharedConfig
{
    static NTESBundleSetting *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NTESBundleSetting alloc] init];
    });
    return instance;
}

- (BOOL)serverRecordAudio
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"server_record_audio"] boolValue];
}

- (BOOL)serverRecordVideo
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"server_record_video"] boolValue];
}

- (BOOL)videochatAutoCropping
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"videochat_auto_cropping"] boolValue];
}

- (BOOL)videochatAutoRotateRemoteVideo
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"videochat_auto_rotate_remote_video"] boolValue];
}

- (NIMNetCallVideoQuality)preferredVideoQuality
{
    NSInteger videoQualitySetting = [[[NSUserDefaults standardUserDefaults] objectForKey:@"videochat_preferred_video_quality"] integerValue];
    if ((videoQualitySetting >= NIMNetCallVideoQualityDefault) &&
        (videoQualitySetting <= NIMNetCallVideoQuality720pLevel)) {
        return (NIMNetCallVideoQuality)videoQualitySetting;
    }
    return NIMNetCallVideoQualityDefault;
}


- (BOOL)startWithBackCamera
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"videochat_start_with_back_camera"] boolValue];
}

- (NIMNetCallVideoCodec)perferredVideoEncoder
{
    NSInteger videoEncoderSetting = [[[NSUserDefaults standardUserDefaults] objectForKey:@"videochat_preferred_video_encoder"] integerValue];
    
    if ((videoEncoderSetting >= NIMNetCallVideoCodecDefault) &&
        (videoEncoderSetting <= NIMNetCallVideoCodecHardware)) {
        return (NIMNetCallVideoCodec)videoEncoderSetting;
    }
    return NIMNetCallVideoCodecDefault;
}

- (NIMNetCallVideoCodec)perferredVideoDecoder
{
    NSInteger videoDecoderSetting = [[[NSUserDefaults standardUserDefaults] objectForKey:@"videochat_preferred_video_decoder"] integerValue];
    
    if ((videoDecoderSetting >= NIMNetCallVideoCodecDefault) &&
        (videoDecoderSetting <= NIMNetCallVideoCodecHardware)) {
        return (NIMNetCallVideoCodec)videoDecoderSetting;
    }
    return NIMNetCallVideoCodecDefault;
    
}
- (NSUInteger)videoMaxEncodeKbps
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"videochat_video_encode_max_kbps"] integerValue];
}

- (NSUInteger)localRecordVideoKbps
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"videochat_local_record_video_kbps"] integerValue];
}

- (BOOL)autoDeactivateAudioSession
{
    id setting = [[NSUserDefaults standardUserDefaults] objectForKey:@"videochat_auto_disable_audiosession"];
    
    if (setting) {
        return [setting boolValue];
    }
    else {
        return YES;
    }
}

- (BOOL)audioDenoise
{
    id setting = [[NSUserDefaults standardUserDefaults] objectForKey:@"videochat_audio_denoise"];
    
    if (setting) {
        return [setting boolValue];
    }
    else {
        return YES;
    }

}

- (BOOL)voiceDetect
{
    id setting = [[NSUserDefaults standardUserDefaults] objectForKey:@"videochat_voice_detect"];
    
    if (setting) {
        return [setting boolValue];
    }
    else {
        return YES;
    }

}

- (BOOL)preferHDAudio
{
    id setting = [[NSUserDefaults standardUserDefaults] objectForKey:@"videochat_prefer_hd_audio"];
    
    if (setting) {
        return [setting boolValue];
    }
    else {
        return NO;
    }
}

- (NSUInteger)bypassVideoMixMode
{
    id setting = [[NSUserDefaults standardUserDefaults] objectForKey:@"videochat_bypass_mix_mode"];

    if (setting) {
        return [setting integerValue];
    }
    else {
        return NIMNetCallVideoMixModeLatticeAspectFit;
    }
}

- (BOOL)serverRecordWhiteboardData
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"server_record_rts_data"] boolValue];
}

- (BOOL)testerToolUI
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"tester_tool_ui"] boolValue];
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"\n\n\n" \
            "server_record_audio %d\n" \
            "server_record_video %d\n" \
            "videochat_auto_cropping %d\n" \
            "videochat_auto_rotate_remote_video %d \n" \
            "videochat_preferred_video_quality %zd\n" \
            "videochat_start_with_back_camera %zd\n" \
            "videochat_preferred_video_encoder %zd\n" \
            "videochat_preferred_video_decoder %zd\n" \
            "videochat_video_encode_max_kbps %zd\n" \
            "videochat_local_record_video_kbps %zd\n" \
            "videochat_auto_disable_audiosession %zd\n" \
            "videochat_audio_denoise %zd\n" \
            "videochat_voice_detect %zd\n" \
            "videochat_prefer_hd_audio %zd\n" \
            "videochat_bypass_mix_mode %zd\n" \
            "server_record_rts_data %zd\n" \
            "tester_tool_ui %zd\n" \
            "\n\n\n",
            [self serverRecordAudio],
            [self serverRecordVideo],
            [self videochatAutoCropping],
            [self videochatAutoRotateRemoteVideo],
            [self preferredVideoQuality],
            [self startWithBackCamera],
            [self perferredVideoEncoder],
            [self perferredVideoDecoder],
            [self videoMaxEncodeKbps],
            [self localRecordVideoKbps],
            [self autoDeactivateAudioSession],
            [self audioDenoise],
            [self voiceDetect],
            [self preferHDAudio],
            [self bypassVideoMixMode],
            [self serverRecordWhiteboardData],
            [self testerToolUI]
            ];
}
@end
