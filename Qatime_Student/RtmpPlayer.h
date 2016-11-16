//
//  RtmpPlayer.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/17.
//  Copyright © 2016年 WWTD. All rights reserved.
//



/* 封装播放器*/

#import <UIKit/UIKit.h>
#import "NELivePlayer.h"
#import "NELivePlayerController.h"
#import "NELivePlayerControl.h"



@interface RtmpPlayer : UIView <NELivePlayer>

/* 播放器 的属性 */
@property(nonatomic, strong) NSURL *url;
@property(nonatomic, strong) NSString *decodeType;
@property(nonatomic, strong) NSString *mediaType;
@property(nonatomic, strong) NELivePlayerController <NELivePlayer> *liveplayer;


/* 拉流播放器的私有属性*/
@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, strong) UIControl *controlOverlay;
@property (nonatomic, strong) UIView *topControlView;
@property (nonatomic, strong) UIView *bottomControlView;
@property (nonatomic, strong) UIButton *playQuitBtn;
@property (nonatomic, strong) UILabel *fileName;
@property (nonatomic, strong) UILabel *currentTime;
@property (nonatomic, strong) UILabel *totalDuration;
@property (nonatomic, strong) UISlider *videoProgress;
@property (nonatomic, strong) UIActivityIndicatorView *bufferingIndicate;
@property (nonatomic, strong) UILabel *bufferingReminder;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *pauseBtn;
@property (nonatomic, strong) UIButton *audioBtn;
@property (nonatomic, strong) UIButton *muteBtn;
@property (nonatomic, strong) UIButton *scaleModeBtn;
@property (nonatomic, strong) UIButton *snapshotBtn;

@property(nonatomic, strong)  NELivePlayerControl *mediaControl;




@end
