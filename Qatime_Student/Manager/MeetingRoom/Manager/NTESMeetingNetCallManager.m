//
//  NTESMeetingNetCallManager.m
//  NIMEducationDemo
//
//  Created by fenric on 16/4/24.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESMeetingNetCallManager.h"
#import "NTESMeetingRolesManager.h"
#import "NTESBundleSetting.h"

#define NTESNetcallManager [NIMAVChatSDK sharedSDK].netCallManager

@interface NTESMeetingNetCallManager()<NIMNetCallManagerDelegate>
{
    UInt16 _myVolume;
}

@property (nonatomic, strong) NIMNetCallMeeting *meeting;
@property (nonatomic, weak) id<NTESMeetingNetCallManagerDelegate>delegate;

@end

@implementation NTESMeetingNetCallManager

- (void)joinMeeting:(NSString *)name delegate:(id<NTESMeetingNetCallManagerDelegate>)delegate
{
    if (_meeting) {
        [self leaveMeeting];
    }
    
    [NTESNetcallManager addDelegate:self];
    
    _meeting = [[NIMNetCallMeeting alloc] init];
    _meeting.name = name;
    _meeting.type = NIMNetCallTypeVideo;
    _meeting.actor = [NTESMeetingRolesManager sharedInstance].myRole.isActor;
    
    [self fillNetCallOption:_meeting];
    
    _delegate = delegate;
    
    __weak typeof(self) wself = self;
    
    [[NIMAVChatSDK sharedSDK].netCallManager joinMeeting:_meeting completion:^(NIMNetCallMeeting *meeting, NSError *error) {
        if (error) {
            DDLogError(@"Join meeting %@error: %zd.", meeting.name, error.code);
            _meeting = nil;
            if (wself.delegate) {
                [wself.delegate onJoinMeetingFailed:meeting.name error:error];
            }
        }
        else {
            DDLogInfo(@"Join meeting %@ success, ext:%@", meeting.name, meeting.ext);
            _isInMeeting = YES;
            NTESMeetingRole *myRole = [NTESMeetingRolesManager sharedInstance].myRole;
            DDLogInfo(@"Reset mute:%d, camera disable:%d",!myRole.audioOn,!myRole.videoOn);
            [NTESNetcallManager setMute:!myRole.audioOn];
            [NTESNetcallManager setCameraDisable:!myRole.videoOn];
            
            if (wself.delegate) {
                [wself.delegate onMeetingConntectStatus:YES];
            }
            NSString *myUid = [NTESMeetingRolesManager sharedInstance].myRole.uid;
            DDLogInfo(@"Joined meeting.");
            [[NTESMeetingRolesManager sharedInstance] updateMeetingUser:myUid
                                                               isJoined:YES];

        }
    }];

}

- (void)leaveMeeting
{
    if (_meeting) {
        [NTESNetcallManager leaveMeeting:_meeting];
        _meeting = nil;
    }
    [NTESNetcallManager removeDelegate:self];
    _isInMeeting = NO;
}

- (BOOL)setBypassLiveStreaming:(BOOL)enabled
{
    return [NTESNetcallManager setBypassStreamingEnabled:enabled];
}

#pragma mark - NIMNetCallManagerDelegate
- (void)onUserJoined:(NSString *)uid
             meeting:(NIMNetCallMeeting *)meeting
{
    DDLogInfo(@"user %@ joined meeting", uid);
    if ([meeting.name isEqualToString:_meeting.name]) {
        [[NTESMeetingRolesManager sharedInstance] updateMeetingUser:uid isJoined:YES];
    }
}

- (void)onUserLeft:(NSString *)uid
           meeting:(NIMNetCallMeeting *)meeting
{
    DDLogInfo(@"user %@ left meeting", uid);

    if ([meeting.name isEqualToString:_meeting.name]) {
        [[NTESMeetingRolesManager sharedInstance] updateMeetingUser:uid isJoined:NO];
    }
}

- (void)onMeetingError:(NSError *)error
               meeting:(NIMNetCallMeeting *)meeting
{
    DDLogInfo(@"meeting error %zd", error.code);
    _isInMeeting = NO;
    [_delegate onMeetingConntectStatus:NO];
}



- (void)onMyVolumeUpdate:(UInt16)volume
{
    _myVolume = volume;    
}

- (void)onSpeakingUsersReport:(nullable NSArray<NIMNetCallUserInfo *> *)report
{
    NSString *myUid = [[NIMSDK sharedSDK].loginManager currentAccount];

    NSMutableDictionary *volumes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[self volumeLevel:_myVolume], myUid, nil];

    for (NIMNetCallUserInfo *info in report) {
        [volumes setObject:[self volumeLevel:info.volume] forKey:info.uid];
    }
    
    [[NTESMeetingRolesManager sharedInstance] updateVolumes:volumes];
}

- (void)onSetBypassStreamingEnabled:(BOOL)enabled result:(NSError *)result
{
    if (result) {
        if (self.delegate) {
            [self.delegate onSetBypassStreamingEnabled:enabled error:result.code];
        }
    }
}

- (void)onNetStatus:(NIMNetCallNetStatus)status user:(NSString *)user
{
    DDLogInfo(@"Net status of %@ is %zd", user, status);
}

#pragma mark - private
- (void)fillNetCallOption:(NIMNetCallMeeting *)meeting
{
    NIMNetCallOption *option = [[NIMNetCallOption alloc] init];
    
    option.disableVideoCropping = ![[NTESBundleSetting sharedConfig] videochatAutoCropping];
    option.autoRotateRemoteVideo = [[NTESBundleSetting sharedConfig] videochatAutoRotateRemoteVideo];
    option.serverRecordAudio     = [[NTESBundleSetting sharedConfig] serverRecordAudio];
    option.serverRecordVideo     = [[NTESBundleSetting sharedConfig] serverRecordVideo];
    option.preferredVideoEncoder = [[NTESBundleSetting sharedConfig] perferredVideoEncoder];
    option.preferredVideoDecoder = [[NTESBundleSetting sharedConfig] perferredVideoDecoder];
    option.videoMaxEncodeBitrate = [[NTESBundleSetting sharedConfig] videoMaxEncodeKbps] * 1000;
    option.startWithBackCamera   = [[NTESBundleSetting sharedConfig] startWithBackCamera];
    option.autoDeactivateAudioSession = [[NTESBundleSetting sharedConfig] autoDeactivateAudioSession];
    option.audioDenoise = [[NTESBundleSetting sharedConfig] audioDenoise];
    option.voiceDetect = [[NTESBundleSetting sharedConfig] voiceDetect];
    option.preferHDAudio = [[NTESBundleSetting sharedConfig] preferHDAudio];
    option.preferredVideoQuality = [[NTESBundleSetting sharedConfig] preferredVideoQuality];
    option.bypassStreamingVideoMixMode = [[NTESBundleSetting sharedConfig] bypassVideoMixMode];
    
    BOOL isManager = [NTESMeetingRolesManager sharedInstance].myRole.isManager;
    
    //会议的观众这里默认用低清发送视频
    if (option.preferredVideoQuality == NIMNetCallVideoQualityDefault) {
        if (!isManager) {
            option.preferredVideoQuality = NIMNetCallVideoQualityLow;
        }
    }
    
    option.bypassStreamingUrl = isManager ? [[NTESMeetingRolesManager sharedInstance] livePushUrl] : nil;
    option.enableBypassStreaming = isManager;
    
    _meeting.option = option;
}


-(NSNumber *)volumeLevel:(UInt16)volume
{
    int32_t volumeLevel = 0;
    volume /= 40;
    while (volume > 0) {
        volumeLevel ++;
        volume /= 2;
    }
    if (volumeLevel > 8) volumeLevel = 8;
    
    return @(volumeLevel);
}

@end