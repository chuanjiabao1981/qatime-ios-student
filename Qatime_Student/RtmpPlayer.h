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
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *pauseBtn;
@property (nonatomic, strong) UIButton *scaleModeBtn;
@property (nonatomic, strong)  NELivePlayerControl *mediaControl;

/* 切换屏幕按钮*/
@property(nonatomic,strong) UIButton *switchScreen ;

/* 双屏平铺按钮*/
@property(nonatomic,strong) UIButton *tileScreen ;

/* 弹幕开关*/
@property(nonatomic,strong) UISwitch *barrage ;







@end
