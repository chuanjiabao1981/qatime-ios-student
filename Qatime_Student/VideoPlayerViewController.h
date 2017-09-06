//
//  NELivePlayerViewController.h
//  NELivePlayerDemo
//
//  Created by NetEase on 15-10-10.
//  Copyright (c) 2015年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NELivePlayer.h"
#import "NELivePlayerController.h"


@class NELivePlayerControl;
@interface VideoPlayerViewController : UIViewController

@property(nonatomic, strong) NSURL *url;
@property(nonatomic, strong) NSString *decodeType;
@property(nonatomic, strong) NSString *mediaType;
@property(nonatomic, strong) id<NELivePlayer> liveplayer;
@property(nonatomic, strong) dispatch_source_t timer;

- (id)initWithURL:(NSURL *)url andDecodeParm:(NSMutableArray *)decodeParm andTitle:(NSString *)title;

+ (void)presentFromViewController:(UIViewController *)viewController withTitle:(NSString *)title URL:(NSURL *)url andDecodeParm:(NSMutableArray *)decodeParm andTitle:(NSString *)title completion:(void(^)())completion;


//给子类重写方法
- (void)controlOverlayHide;

@property(nonatomic, strong) IBOutlet NELivePlayerControl *mediaControl;

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

@property (nonatomic, strong) UIButton *resolutionBtn;
@property (nonatomic, strong) NSString *videoTitle;



@end

