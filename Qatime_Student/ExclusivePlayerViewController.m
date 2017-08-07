//
//  ExclusivePlayerViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/7/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ExclusivePlayerViewController.h"
#import "NELivePlayerControl.h"
#import "NSNull+Json.h"
#import "YYModel.h"
#import "Chat_Account.h"
#import <NIMSDK/NIMSDK.h>
#import "FJFloatingView.h"
#import "BarrageRenderer.h"
#import "UIControl+RemoveTarget.h"
#import "NSString+UTF8Coding.h"
#import "NSString+ContainEmoji.h"
#import "UITextView+YZEmotion.h"
#import "YYTextView+YZEmotion.h"
#import "YZTextAttachment.h"
#import "NSString+TimeStamp.h"
#import "NSAttributedString+EmojiExtension.h"
#import "YYImage.h"
#import "NSBundle+YYAdd.h"
#import "NSString+YYAdd.h"
#import "NSMutableAttributedString+Extention.h"
#import "NSAttributedString+YYtext.h"
#import "UIViewController+HUD.h"
#import "UIButton+Touch.h"
#import "UIViewController+Login.h"
#import "NSDate+ChangeUTC.h"
#import "NSString+ChangeYearsToChinese.h"
#import "UIViewController+AFHTTP.h"
#import "KSPhotoBrowser.h"
#import "UITextView+Placeholder.h"
#import "UIView+PlaceholderImage.h"
#import <AVFoundation/AVFoundation.h>
#import "UUInputFunctionView.h"
#import "NSNull+Json.h"

typedef enum : NSUInteger {
    /**平级视图*/
    SameLevel,
    /**分级视图*/
    DifferentLevel,
    
} ViewsArrangementMode;

@interface ExclusivePlayerViewController ()<UITableViewDelegate,UITableViewDataSource,NIMLoginManager,NIMChatManagerDelegate,NIMConversationManagerDelegate,NIMConversationManager,UITextViewDelegate,NIMChatroomManagerDelegate,NIMLoginManagerDelegate,TTGTextTagCollectionViewDelegate,KSPhotoBrowserDelegate,UIGestureRecognizerDelegate,NIMMediaManagerDelegate>{
    
    NSString *_token;
    NSString *_idNumber;
    
    
    NSString *_chatTimeID;
    NSString *_classID;
    
    /* 两个视频播放器的排列方式*/
    
    ViewsArrangementMode _viewsArrangementMode;
    
    /* 是否全屏*/
    BOOL isFullScreen;
    
    /* 全屏模式下的刷新按钮*/
    UIButton *refresh_FS;
    
    /* 后台获取的直播状态存储字典*/
    NSDictionary *_statusDic;
    /* 全屏模式下,双击小窗口切换视频的手势*/
    UITapGestureRecognizer *_doubelTap;
    
    /* 切换横竖屏 使用的scrollview的contentsize*/
    CGSize scrollContentSize;
    
    /* 弹幕*/
    BarrageRenderer *_aBarrage;
    BarrageDescriptor *_descriptor;
    
    BOOL barrageRunning;
    
    /* 覆盖层*/
    UIView *_maskView;
    
    /* 播放器状态部分*/
    BOOL boardPlayerInitSuccess;
    BOOL teacherPlayerInitSuccess;
    BOOL bothPlayerInitSuccess;
    
    /* 播放器加载失败次数*/
    NSInteger boardFaildTimes;
    NSInteger teacherFaildTimes;
    
    /* 副播放器开启/关闭*/
    BOOL subScreenON;
    
    /* 语音.. 检测音量*/
    AVAudioRecorder *recorder;
    NSTimer *levelTimer;
    
    //横屏文件名
    NSString *_fileNameString;
    
    //高度监听
    CGFloat headerHeight;
    
    //全屏的时候的输入框
    UUInputFunctionView *_inputView;
    
}

#pragma mark- 播放器部分的属性
/**
 白板播放器底视图
 */
@property(nonatomic, strong) FJFloatingView *boardPlayerView ;

/**
 摄像头播放器底视图
 */
@property (nonatomic, strong) FJFloatingView *teacherPlayerView;


/**
 播放器的控制层
 */
@property (nonatomic, strong) UIControl *controlOverlay;


/**
 播放器控制层的顶部栏
 */
@property (nonatomic, strong) UIView *topControlView;


/**
 播放器控制层的底栏
 */
@property (nonatomic, strong) UIView *bottomControlView;


/**
 退出按钮
 */
@property (nonatomic, strong) UIButton *playQuitBtn;


/**
 文件名->课程名
 */
@property (nonatomic, strong) UILabel *fileName;


/**
 播放按钮
 */
@property (nonatomic, strong) UIButton *playBtn;


/**
 暂停按钮
 */
@property (nonatomic, strong) UIButton *pauseBtn;

/**
 全屏按钮
 */
@property (nonatomic, strong) UIButton *scaleModeBtn;

#pragma mark- 分屏的布局拓展方法和属性更改方法,只改变布局
/* 变成主视图*/
- (void)makeFirstPlayer:(FJFloatingView *)playerView;

/* 变成副视图*/
- (void)makeSecondPlayer:(FJFloatingView *)playerView;

/* 变成可移动视图*/
- (void)makeFloatingPlayer:(FJFloatingView *)playerView;

/* 改变infoview的布局*/
- (void)changInfoViewsWithTopView:(FJFloatingView *)playerView;

@end

@implementation ExclusivePlayerViewController

-(instancetype)initWithClassID:(NSString *)classID andChatTeamID:(NSString *)chatTeamID andBoardAddress:(NSString *)boardAddress andTeacherAddress:(NSString *)teacherAddress{
    self = [super init];
    if (self) {
        _chatTimeID = [NSString stringWithFormat:@"%@",chatTeamID==nil?@"":chatTeamID];
        _classID = [NSString stringWithFormat:@"%@",classID];

        _teacherPullAddress = [NSURL URLWithString:teacherAddress.description];
        _boardPullAddress = [NSURL URLWithString:boardAddress.description];
    }
    return self;
}


- (void)makeData{
    
    
}

- (void)setupPlayer{
    
    self.view.backgroundColor = [UIColor blackColor];
    
    /* 默认的视频排列方式是平级*/
    _viewsArrangementMode = SameLevel;
    
    /* 初始化视频播放器的背景视图*/
    [self setupVideoPlayer];
    
    /* 初始化弹幕*/
    _aBarrage = [[BarrageRenderer alloc]init];
    [self.teacherPlayerView addSubview: _aBarrage.view];
    _descriptor = [[BarrageDescriptor alloc]init];
    /* 默认弹幕开启*/
    [_aBarrage start];
    /* 加载媒体控制器*/
    [self setupMediaControl];
}

- (void)setupChildController{
    
    _chatController = [[ExclusiveChatViewController alloc]initWithChatTeamID:_chatTimeID andClassID:_classID];
    _noticeController = [[ExclusivenNoticeViewController alloc]initWithClassID:_classID];
    _infoController = [[ExclusivePlayerInfoViewController alloc]initWithClassID:_classID];
    _membersController = [[ExclusiveMembersViewController alloc]initWithClassID:_classID];
    
    [self addChildViewController:_chatController];
    [self addChildViewController:_noticeController];
    [self addChildViewController:_infoController];
    [self addChildViewController:_membersController];
    
}

- (void)setupMainView{
    
    //主视图和四个控制器试图加进去
    _mainView = [[ExclusivePlayerView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_mainView];
    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(_teacherPlayerView,0)
    .bottomSpaceToView(self.view, 0);
    
    [_mainView.scrollView addSubview:_chatController.view];
    _chatController.view.sd_layout
    .leftSpaceToView(_mainView.scrollView, 0)
    .topSpaceToView(_mainView.scrollView, 0)
    .bottomSpaceToView(_mainView.scrollView, 0)
    .widthRatioToView(_mainView.scrollView, 1.0);
    
    [_mainView.scrollView addSubview:_noticeController.view];
    _noticeController.view.sd_layout
    .leftSpaceToView(_chatController.view, 0)
    .topEqualToView(_chatController.view)
    .bottomEqualToView(_chatController.view)
    .widthRatioToView(_chatController.view, 1.0);
    
    [_mainView.scrollView addSubview:_infoController.view];
    _infoController.view.sd_layout
    .leftSpaceToView(_noticeController.view, 0)
    .topEqualToView(_noticeController.view)
    .bottomEqualToView(_noticeController.view)
    .widthRatioToView(_noticeController.view, 1.0);
    
    [_mainView.scrollView addSubview:_membersController.view];
    _membersController.view.sd_layout
    .leftSpaceToView(_infoController.view, 0)
    .topEqualToView(_infoController.view)
    .bottomEqualToView(_infoController.view)
    .widthRatioToView(_infoController.view, 1.0);
    
    _mainView.scrollView.contentSize = CGSizeMake(100, 100);
    [_mainView.scrollView setupAutoContentSizeWithRightView:_membersController.view rightMargin:0];
    [_mainView.scrollView setupAutoContentSizeWithBottomView:_chatController.view bottomMargin:0];
    [_mainView.scrollView updateLayout];
    
    typeof(self) __weak weakSelf = self;
    _mainView.segmentControl.indexChangeBlock = ^(NSInteger index) {
        [weakSelf.mainView.scrollView scrollRectToVisible:CGRectMake(weakSelf.mainView.scrollView.width_sd*index, 0, weakSelf.mainView.scrollView.width_sd, weakSelf.mainView.scrollView.height_sd) animated:YES];
    };
    
    _mainView.scrollView.delegate = self;
    
    _inputView = _chatController.inputView.copy;
}


#pragma mark- 播放器的布局和初始化方法
- (void)setupVideoPlayer{
    
    /* 白板播放器view*/
    _boardPlayerView = ({
        
        FJFloatingView *_ =[[FJFloatingView alloc]init];
        [self.view addSubview:_];
        _.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .topSpaceToView(self.view,0)
        .autoHeightRatio(9/16.0);
        _boardPlayerView.tag = 0;
        [_ makePlaceHolderImage:[UIImage imageNamed:@"video_Playerholder"]];
        /* 当前不可移动*/
        _.canMove = NO;
        /* 不可移动的情况下,移除移动手势*/
        [_ removeGestureRecognizer:_boardPlayerView.pan];
        
        /* 白板播放器是主要的播放器（在上面）*/
        _.becomeMainPlayer = YES;
        _;
        
    });
    
    /* 摄像头播放器view*/
    _teacherPlayerView = ({
        
        FJFloatingView *_ =[[FJFloatingView alloc]init];
        
        [self.view addSubview:_];
        
        _.sd_layout
        .leftEqualToView(_boardPlayerView)
        .rightEqualToView(_boardPlayerView)
        .topSpaceToView(_boardPlayerView,0)
        .autoHeightRatio(9/16.0);
        _teacherPlayerView.tag = 1;
        [_ makePlaceHolderImage:[UIImage imageNamed:@"video_Playerholder"]];
        //        [_ sendSubviewToBack:_.placeholderImage];
        
        /* 老师播放器不可移动*/
        _.canMove = NO;
        [_ removeGestureRecognizer:_teacherPlayerView.pan];
        _.layer.borderWidth = 0.6f;
        _.layer.borderColor = [UIColor grayColor].CGColor;
        
        /* 老师播放器为主要播放器*/
        _.becomeMainPlayer=NO;
        _;
        
    });
    
    [self setupBoardPlayer];
    
}

/* 初始化播放器*/

/* 白板播放器初始化*/
- (void)setupBoardPlayer{
    
    /* 白板的 播放器*/
    _liveplayerBoard = [[NELivePlayerController alloc] initWithContentURL:_boardPullAddress];
    _liveplayerBoard.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_liveplayerBoard setScalingMode:NELPMovieScalingModeAspectFit];
    
    [_boardPlayerView makePlaceHolderImage:nil];
    [_boardPlayerView makePlaceHolderImage:[UIImage imageNamed:@"video_LoadingHolder_Landscape"]];
    
    //单独立出来一个条件,在初始化失败的时候,轮询后台接口
    if (_liveplayerBoard == nil) {
        // 返回空则表示初始化失败
        //            NSLog(@"player initilize failed, please tay again!");
        boardFaildTimes++;
        NSLog(@"白板播放器初始化失败!!!!");
        [_boardPlayerView makePlaceHolderImage:nil];
        [_boardPlayerView makePlaceHolderImage:[UIImage imageNamed:@"video_LoadFaild_Landscape"]];
        
        [_liveplayerBoard shutdown];
        
        if (boardFaildTimes>=5) {
            
        }else{
            
            [self setupBoardPlayer];
        }
        
    }else{
        
        NSLog(@"白板播放器初始化成功!!!!");
        [self setupTeacherPlayer];
        boardPlayerInitSuccess = YES;
        [_boardPlayerView makePlaceHolderImage:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"BoardPlayerInitSuccess" object:nil];
        if (![_boardPlayerView.subviews containsObject:_liveplayerBoard.view]) {
            
            [_boardPlayerView addSubview:_liveplayerBoard.view];
            _liveplayerBoard.view.sd_layout
            .leftEqualToView(_boardPlayerView)
            .rightEqualToView(_boardPlayerView)
            .topEqualToView(_boardPlayerView)
            .bottomEqualToView(_boardPlayerView);
            
            [_boardPlayerView bringSubviewToFront:_liveplayerBoard.view];
            //            [_boardPlayerView makePlaceHolderImage:nil];
        }
        
        
    }
    
    /* 白板播放器的设置*/
    [_liveplayerBoard isLogToFile:YES];
    [_liveplayerBoard setBufferStrategy:NELPLowDelay]; //直播低延时模式
    [_liveplayerBoard setScalingMode:NELPMovieScalingModeAspectFit]; //设置画面显示模式，默认原始大小
    [_liveplayerBoard setShouldAutoplay:YES]; //设置prepareToPlay完成后是否自动播放
    [_liveplayerBoard setHardwareDecoder:NO]; //设置解码模式，是否开启硬件解码
    [_liveplayerBoard setPauseInBackground:NO]; //设置切入后台时的状态，暂停还是继续播放
    [_liveplayerBoard prepareToPlay]; //初始化视频文件
    
    
}

/* 老师播放器初始化*/
- (void)setupTeacherPlayer{
    
    /* 老师摄像头的 播放器*/
    _liveplayerTeacher = [[NELivePlayerController alloc] initWithContentURL:_teacherPullAddress];
    [_teacherPlayerView makePlaceHolderImage:nil];
    [_teacherPlayerView makePlaceHolderImage:[UIImage imageNamed:@"video_LoadingHolder_Landscape"]];
    _liveplayerTeacher.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_liveplayerTeacher setScalingMode:NELPMovieScalingModeAspectFit];
    if (_liveplayerTeacher == nil) {
        // 返回空则表示初始化失败
        //            NSLog(@"player initilize failed, please tay again!");
        teacherFaildTimes++;
        NSLog(@"摄像头播放器初始化失败!!!!");
        [_teacherPlayerView makePlaceHolderImage:nil];
        [_teacherPlayerView makePlaceHolderImage:[UIImage imageNamed:@"video_LoadFaild_Landscape"]];
        [_liveplayerTeacher shutdown];
        
        if (teacherFaildTimes>=5) {
            
        }else{
            [self setupTeacherPlayer];
        }
    }else{
        
        NSLog(@"摄像头播放器初始化成功!!!!");
        teacherPlayerInitSuccess = YES;
        [_teacherPlayerView makePlaceHolderImage:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"TeacherPlayerInitSuccess" object:nil];
        
        if (![_teacherPlayerView.subviews containsObject:_liveplayerTeacher.view]) {
            
            [_teacherPlayerView addSubview:_liveplayerTeacher.view];
            _liveplayerTeacher.view.sd_layout
            .leftEqualToView(_teacherPlayerView)
            .rightEqualToView(_teacherPlayerView)
            .topEqualToView(_teacherPlayerView)
            .bottomEqualToView(_teacherPlayerView);
            
            [_teacherPlayerView bringSubviewToFront:_liveplayerTeacher.view];
            //            [_teacherPlayerView makePlaceHolderImage:nil];
        }
    }
    
    [_liveplayerTeacher isLogToFile:YES];
    
    /* 教师播放器的设置*/
    [_liveplayerTeacher setBufferStrategy:NELPLowDelay]; //直播低延时模式
    [_liveplayerTeacher setScalingMode:NELPMovieScalingModeAspectFit]; //设置画面显示模式，默认原始大小
    [_liveplayerTeacher setShouldAutoplay:YES]; //设置prepareToPlay完成后是否自动播放
    [_liveplayerTeacher setHardwareDecoder:NO]; //设置解码模式，是否开启硬件解码
    [_liveplayerTeacher setPauseInBackground:NO]; //设置切入后台时的状态，暂停还是继续播放
    [_liveplayerTeacher prepareToPlay]; //初始化视频文件
    
    [self.view bringSubviewToFront:_mediaControl];
    [self.view bringSubviewToFront:_controlOverlay];
    
}

/* 媒体控制器初始化加载方法*/
- (void)setupMediaControl{
    /* 媒体控制器*/
    _mediaControl =({
        
        NELivePlayerControl *_ =[[NELivePlayerControl alloc] init];
        [_ addTarget:self action:@selector(onClickMediaControl:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_];
        _.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .topSpaceToView(self.view,0)
        .autoHeightRatio(9/16.0);
        _;
    });
    
    //控制器覆盖层
    _controlOverlay =({
        UIControl *_= [[UIControl alloc] init];
        [_ addTarget:self action:@selector(onClickOverlay:) forControlEvents:UIControlEventTouchUpInside];
        [self performSelector:@selector(controlOverlayHide) withObject:nil afterDelay:5];
        
        [_mediaControl addSubview:_];
        _.sd_layout
        .leftEqualToView(_mediaControl)
        .rightEqualToView(_mediaControl)
        .topEqualToView(_mediaControl)
        .bottomEqualToView(_mediaControl);
        _;
    });
    
    //播放器顶部控制栏
    _topControlView = ({
        
        UIView *_= [[UIView alloc] init];
        _.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _.alpha = 0.8;
        [_controlOverlay addSubview:_];
        _.sd_layout
        .leftEqualToView(_controlOverlay)
        .rightEqualToView(_controlOverlay)
        .topEqualToView(_controlOverlay)
        .heightIs(40);/* 高度40，预留修改*/
        _;
    });
    
    //退出按钮
    _playQuitBtn = ({
        
        UIButton *_ =[UIButton buttonWithType:UIButtonTypeCustom];
        [_ setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        
        _.alpha = 0.8;
        [_ addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
        [_topControlView addSubview:_];
        _.sd_layout
        .leftSpaceToView(_topControlView,0)
        .topEqualToView(_topControlView)
        .heightRatioToView(_topControlView,1.0f)
        .widthEqualToHeight();
        _.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
        [_ setEnlargeEdge:10];
        _;
    });
    
    //文件名 、课程名
    _fileName = ({
        UILabel *_=[[UILabel alloc] init ];
        _.textAlignment = NSTextAlignmentLeft; //文字居左
        _.textColor = [[UIColor alloc] initWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
        _.font = [UIFont fontWithName:_fileName.font.fontName size:13.0];
        _.hidden = YES;
        [_topControlView addSubview:_];
        _.sd_layout
        .leftSpaceToView(_playQuitBtn,0)
        .topEqualToView(_topControlView)
        .bottomEqualToView(_topControlView)
        .rightSpaceToView(_topControlView,0);
        _;
    });
    
    //在线人数
    _onLineNumber = ({
        UILabel *_ = [[UILabel alloc]init];
        _.textColor = [UIColor whiteColor];
        _.font = [UIFont systemFontOfSize:12*ScrenScale];
        
        [_topControlView addSubview:_];
        _.sd_layout
        .centerYEqualToView(_topControlView)
        .autoHeightRatio(0)
        .rightSpaceToView(_topControlView,10);
        [_ setSingleLineAutoResizeWithMaxWidth:100];
        
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"whiteman"]];
        [_topControlView addSubview:image];
        image.sd_layout
        .rightSpaceToView(_,5)
        .topEqualToView(_)
        .bottomEqualToView(_)
        .widthEqualToHeight();
        
        _;
    });
    
    
    
    //底部控制栏
    _bottomControlView = ({
        UIView *_ = [[UIView alloc] init];
        _.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
        _.alpha = 0.8;
        [_controlOverlay addSubview:_];
        _.sd_layout
        .leftEqualToView(_controlOverlay)
        .rightEqualToView(_controlOverlay)
        .bottomEqualToView(_controlOverlay)
        .heightIs(40);/* 边栏高度可变*/
        
        _;
    });
    
    //播放按钮
    _playBtn = ({
        
        UIButton *_ =[UIButton buttonWithType:UIButtonTypeCustom];
        
        [_ setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        
        _.alpha = 0.8;
        [_ addTarget:self action:@selector(onClickPlay:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomControlView addSubview:_];
        _.sd_layout
        .leftSpaceToView(_bottomControlView,0)
        .centerYEqualToView(_bottomControlView)
        .topSpaceToView(_bottomControlView,0)
        .bottomSpaceToView(_bottomControlView,0)
        .widthEqualToHeight();
        _.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
        [_ setEnlargeEdge:20];
        _;
    });
    
    //暂停按钮
    _pauseBtn = ({
        UIButton *_= [UIButton buttonWithType:UIButtonTypeCustom];
        [_ setImage:[UIImage imageNamed:@"btn_player_play"] forState:UIControlStateNormal];
        
        _.alpha = 0.8;
        [_ addTarget:self action:@selector(onClickPause:) forControlEvents:UIControlEventTouchUpInside];
        _.hidden = YES;
        [_bottomControlView addSubview:_];
        _.sd_layout
        .leftEqualToView(_playBtn)
        .rightEqualToView(_playBtn)
        .topEqualToView(_playBtn)
        .bottomEqualToView(_playBtn);
        _.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
        [_ setEnlargeEdge:10];
        _;
    });
    
    //显示模式按钮
    _scaleModeBtn = ({
        UIButton *_= [UIButton buttonWithType:UIButtonTypeCustom];
        [_ setImage:[UIImage imageNamed:@"scale"] forState:UIControlStateNormal];
        if ([_mediaType isEqualToString:@"localAudio"]) {
            _.hidden = YES;
        }
        [_ addTarget:self action:@selector(onClickScaleMode:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomControlView addSubview:_];
        _.sd_layout
        .rightSpaceToView(self.bottomControlView,0)
        .topSpaceToView(self.bottomControlView,0)
        .bottomSpaceToView(self.bottomControlView,0)
        .widthEqualToHeight();
        _.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
        [_ setEnlargeEdge:10];
        
        _;
    });
    
    //切换屏幕按钮(上下切屏)
    _switchScreen = ({
        UIButton *_=[[UIButton alloc]init];
        [_ setImage:[UIImage imageNamed:@"上下转换"] forState:UIControlStateNormal];
        
        _.alpha = 0.8;
        [_bottomControlView addSubview:_];
        _.sd_layout
        .rightSpaceToView(_scaleModeBtn,0)
        .topSpaceToView(_bottomControlView,0)
        .bottomSpaceToView(_bottomControlView,0)
        .widthEqualToHeight();
        _.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
        /* 切屏添加点击事件*/
        [_ addTarget:self action:@selector(switchBothScreen:) forControlEvents:UIControlEventTouchUpInside];
        [_ setEnlargeEdge:10];
        _;
    });
    
    /* 平铺按钮 （平铺）*/
    _tileScreen = ({
        UIButton *_=[[UIButton alloc]init];
        [_ setImage:[UIImage imageNamed:@"tile"] forState:UIControlStateNormal];
        
        _.alpha = 0.8;
        [_bottomControlView addSubview:_];
        _.sd_layout
        .rightSpaceToView(_switchScreen,0)
        .topSpaceToView(_bottomControlView,0)
        .bottomSpaceToView(_bottomControlView,0)
        .widthEqualToHeight();
        _.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
        /* 添加点击事件*/
        [_ addTarget:self action:@selector(changeLevels:) forControlEvents:UIControlEventTouchUpInside];
        [_ setEnlargeEdge:10];
        _;
    });
    
    /* 刷新按钮*/
    refresh_FS = ({
        UIButton *_ = [[UIButton alloc]init];
        [_bottomControlView addSubview:_];
        _.sd_layout
        .leftSpaceToView(_playBtn,10)
        .topEqualToView(_bottomControlView)
        .bottomEqualToView(_bottomControlView)
        .widthEqualToHeight();
        _.hidden = NO;
        [_ setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
        
        [_ setEnlargeEdge:10];
        /* 刷新点击事件*/
        [_ addTarget:self action:@selector(refreshVideo:) forControlEvents:UIControlEventTouchUpInside];
        _;
    });
    
    /* 弹幕开关*/
    _barrage = ({
        UIButton *_=[[UIButton alloc]init];
        
        [_bottomControlView addSubview:_];
        [_ setImage:[UIImage imageNamed:@"barrage_on"] forState:UIControlStateNormal];
        //    _barrage.layer.borderColor = [UIColor whiteColor].CGColor;
        //    _barrage.layer.borderWidth = 0.8;
        [_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _.backgroundColor = [UIColor clearColor];
        _.alpha = 0.8;
        _.sd_layout
        .rightSpaceToView(_tileScreen,0)
        .heightRatioToView(_tileScreen,1.0)
        .topSpaceToView(_bottomControlView,0)
        .widthRatioToView(_tileScreen,1.0);
        /* 默认开启弹幕*/
        barrageRunning =YES;
        [_ setEnlargeEdge:10];
        
        /* 弹幕按钮的点击事件*/
        [_ addTarget:self action:@selector(barragesSwitch) forControlEvents:UIControlEventTouchUpInside];
        _;
        
    });
    
    /* 副屏幕开关按钮*/
    _subScreenSwitch = ({
        UIButton *_=[[UIButton alloc]init];
        [_controlOverlay addSubview:_];
        [_ setImage:[UIImage imageNamed:@"subsc_on"] forState:UIControlStateNormal];
        subScreenON = YES;
        [_ setContentMode:UIViewContentModeScaleAspectFill];
        
        _.sd_layout
        .centerYEqualToView(_controlOverlay)
        .rightSpaceToView(_controlOverlay,5)
        .widthRatioToView(_barrage,1.0)
        .heightEqualToWidth();
        [_ addTarget:self action:@selector(subScreenControl) forControlEvents:UIControlEventTouchUpInside];
        
        _;
    });
    
}

/* 副屏幕开关按钮*/
- (void)subScreenControl{
    
    /* 如果现在副屏是关闭状态*/
    if (subScreenON == NO) {
        /* 打开副屏*/
        subScreenON = YES;
        [_subScreenSwitch setImage:[UIImage imageNamed:@"subsc_on"] forState:UIControlStateNormal];
        
        /** 在竖屏模式下*/
        if (isFullScreen == NO) {
            /* 在竖屏模式下分两种情况,平级视图和非平级视图
             平级视图关闭副播放器,非平级视图关闭浮动播放器*/
            
            /* 条件:在平级视图下*/
            if (_viewsArrangementMode == SameLevel) {
                if (_boardPlayerView.becomeMainPlayer ==YES) {
                    [self makeSecondPlayer:_teacherPlayerView];
                    [self changInfoViewsWithTopView:_teacherPlayerView];
                    [self changInfoViewContentSizeToSmall];
                    [self makeFirstPlayer:_boardPlayerView];
                    _teacherPlayerView.hidden = NO;
                }else if (_teacherPlayerView.becomeMainPlayer == YES){
                    [self makeSecondPlayer:_boardPlayerView];
                    [self changInfoViewsWithTopView:_boardPlayerView];
                    [self changInfoViewContentSizeToSmall];
                    [self makeFirstPlayer:_teacherPlayerView];
                    _boardPlayerView.hidden = NO;
                }
                
                /* 在非平级视图下*/
            }else if (_viewsArrangementMode == DifferentLevel){
                if (_boardPlayerView.becomeMainPlayer ==YES) {
                    _teacherPlayerView.hidden = NO;
                }else if (_teacherPlayerView.becomeMainPlayer == YES){
                    _boardPlayerView.hidden = NO;
                }
            }
            
        }else if(isFullScreen == YES){
            /* 在全屏模式下*/
            /* 如果白板是主视图,那么关闭教师摄像头*/
            if (_boardPlayerView.becomeMainPlayer ==YES) {
                _teacherPlayerView.hidden = NO;
            }else if (_teacherPlayerView.becomeMainPlayer == YES){
                /* 如果教师摄像头是主视图,那么关闭白板*/
                _boardPlayerView.hidden = NO;
            }
        }
        
    }else if (subScreenON == YES){
        /* 如果现在副屏是开启的*/
        /* 关闭副屏*/
        subScreenON = NO;
        [_subScreenSwitch setImage:[UIImage imageNamed:@"subsc_off"] forState:UIControlStateNormal];
        
        /** 在竖屏模式下*/
        if (isFullScreen == NO) {
            /* 如果是平级视图*/
            if (_viewsArrangementMode == SameLevel) {
                
                if (_boardPlayerView.becomeMainPlayer == YES) {
                    [self makeFloatingPlayer:_teacherPlayerView];
                    _teacherPlayerView.hidden = YES;
                    [self changInfoViewsWithTopView:_boardPlayerView];
                    [self changInfoViewContentSizeToBig];
                    
                }else if (_teacherPlayerView.becomeMainPlayer == YES){
                    
                    [self makeFloatingPlayer:_boardPlayerView];
                    _boardPlayerView.hidden = YES;
                    [self changInfoViewsWithTopView:_teacherPlayerView];
                    [self changInfoViewContentSizeToBig];
                    
                }
                
            }else if (_viewsArrangementMode == DifferentLevel){
                /* 如果是非平级视图*/
                if (_boardPlayerView.becomeMainPlayer == YES) {
                    _teacherPlayerView.hidden = YES;
                }else if (_teacherPlayerView.becomeMainPlayer == YES){
                    _boardPlayerView.hidden = YES;
                }
            }
            
        }else if(isFullScreen == YES){
            /* 在全屏模式下*/
            /* 如果白板是主视图,那么关闭教师摄像头*/
            if (_boardPlayerView.becomeMainPlayer ==YES) {
                _teacherPlayerView.hidden = YES;
            }else if (_teacherPlayerView.becomeMainPlayer == YES){
                /* 如果教师摄像头是主视图,那么关闭白板*/
                _boardPlayerView.hidden = YES;
            }
        }
        
    }
    
}

/* 数据加载完成 播放器二次加载*/
- (void)reloadPlayerView{
    
    /* 加载白板播放器*/
    
    [self setupBoardPlayer];
    
    /*延迟0.3s 加载摄像头播放器*/
    [self performSelector:@selector(setupTeacherPlayer) withObject:nil afterDelay:0.5];
    //    [self setupTeacherPlayer];
    
    //不管是否创建成功,都去后台拿直播状态
    [self performSelector:@selector(checkVideoStatus) withObject:nil afterDelay:10];
}

#pragma mark- 分屏部分
#pragma mark- 当视频变成悬浮窗、非平级视图的监听
- (void)viewLevelChangDifferent:(NSNotification *)notification{
    
    [_aBarrage.view removeFromSuperview];
}

#pragma mark- 当视频变成平级视图的监听
- (void)viewLevelChangSame:(NSNotification *)notification{
    
    [_teacherPlayerView addSubview:_aBarrage.view];
    [_teacherPlayerView bringSubviewToFront:_aBarrage.view];
    
}

#pragma mark- 变成全屏后的监听
- (void)turnFullScreen:(NSNotification *)notification{
    
    [self performSelector:@selector(controlOverlayHide) withObject:nil afterDelay:5];
    
    isFullScreen = YES;
    
    /* 在全屏播放状态下*/
    /* 1、先添加弹幕*/
    /* 2、 添加控制层 并重新布局*/
    
    [_aBarrage.view removeFromSuperview];
    
    if (_boardPlayerView.becomeMainPlayer == YES) {
        
        [_boardPlayerView addSubview:_aBarrage.view];
        
        _aBarrage.view.sd_layout
        .leftEqualToView(_boardPlayerView)
        .rightEqualToView(_boardPlayerView)
        .topEqualToView(_boardPlayerView)
        .bottomEqualToView(_boardPlayerView);
        [_aBarrage.view updateLayout];
        
        [self mediaControlTurnToFullScreenModeWithMainView:_boardPlayerView];
        
        [self makeFloatingPlayer:_teacherPlayerView];
        [_aBarrage start];
        
    }else if (_teacherPlayerView.becomeMainPlayer == YES){
        
        [_teacherPlayerView addSubview:_aBarrage.view];
        
        _aBarrage.view.sd_layout
        .leftEqualToView(_teacherPlayerView)
        .rightEqualToView(_teacherPlayerView)
        .topEqualToView(_teacherPlayerView)
        .bottomEqualToView(_teacherPlayerView);
        [_teacherPlayerView bringSubviewToFront:_aBarrage.view];
        [_aBarrage.view updateLayout];
        [_aBarrage start];
        _aBarrage.view.hidden = NO;
        
        [self mediaControlTurnToFullScreenModeWithMainView:_teacherPlayerView];
        
        [self makeFloatingPlayer:_boardPlayerView];
        
        [_aBarrage start];
    }
    
    /* 全屏页面布局的变化*/
    refresh_FS .hidden = NO;
    _scaleModeBtn.hidden = YES;
    _tileScreen.hidden =YES;
    
    _inputView.btnChangeVoiceState.hidden = YES;
    [_inputView changeSendBtnWithPhoto:NO];
    _inputView.canNotSendImage = YES;
    
    
    //    _barrageText.hidden = NO;
    _switchScreen.sd_layout
    .rightSpaceToView(_bottomControlView,5)
    .bottomEqualToView(_bottomControlView)
    .topEqualToView(_bottomControlView)
    .widthEqualToHeight();
    
    _barrage.sd_layout
    .topEqualToView(_switchScreen)
    .bottomEqualToView(_switchScreen)
    .rightSpaceToView(_switchScreen,0)
    .widthEqualToHeight();
    
    
}

#pragma mark- 切回竖屏后的监听
- (void)turnDownFullScreen:(NSNotification *)notification{
    
    isFullScreen = NO;
    _viewsArrangementMode = DifferentLevel;
    [_aBarrage.view removeFromSuperview];
    /* 如果是在平级视图*/
    if (_viewsArrangementMode == SameLevel) {
        
        [_teacherPlayerView addSubview:_aBarrage.view];
        _aBarrage.view.sd_layout
        .leftEqualToView(_teacherPlayerView)
        .rightEqualToView(_teacherPlayerView)
        .topEqualToView(_teacherPlayerView)
        .bottomEqualToView(_teacherPlayerView);
        [_aBarrage.view updateLayout];
        //        [_teacherPlayerView bringSubviewToFront:_liveplayerTeacher.view];
        
        /* 判断主视图 */
        if (_boardPlayerView.becomeMainPlayer == YES) {
            
            [self mediaControlTurnDownFullScreenModeWithMainView:_boardPlayerView];
            
        }else if(_teacherPlayerView.becomeMainPlayer == YES){
            
            [self mediaControlTurnDownFullScreenModeWithMainView:_teacherPlayerView];
            
        }
        
        /* 如果是非平级视图*/
    }else if (_viewsArrangementMode == DifferentLevel){
        /* 判断主视图 */
        if (_boardPlayerView.becomeMainPlayer == YES) {
            [self mediaControlTurnDownFullScreenModeWithMainView:_boardPlayerView];
            [self makeFloatingPlayer:_teacherPlayerView];
        }else if(_teacherPlayerView.becomeMainPlayer == YES){
            [self mediaControlTurnDownFullScreenModeWithMainView:_teacherPlayerView];
            [self makeFloatingPlayer:_boardPlayerView];
        }
    }
    
    [self.view updateLayout];
    [self.view layoutIfNeeded];
    [_mainView updateLayout];
    [_mainView.scrollView updateLayout];
    
    [_aBarrage start];
    
}

/* 控制层变成全屏模式的方法*/
- (void)mediaControlTurnToFullScreenModeWithMainView:(FJFloatingView *)playerView{
    
    //    [_aBarrage stop];
    
    [self.view bringSubviewToFront:_mediaControl];
    
    _mediaControl.hidden  = NO;
    _fileName.hidden = NO;
    
    _topControlView.backgroundColor = [UIColor blackColor];
    _topControlView.alpha = 0.8;
    
    _bottomControlView.backgroundColor = [UIColor blackColor];
    _bottomControlView.alpha = 0.8;
    
    _mediaControl.sd_resetLayout
    .topEqualToView(playerView)
    .bottomEqualToView(playerView)
    .leftEqualToView(playerView)
    .rightEqualToView(playerView);
    [_mediaControl updateLayout];
    
    /* 控制层上加输入框*/
    [_bottomControlView addSubview:_inputView];
    _inputView.backgroundColor = [UIColor clearColor];
    [_inputView clearAutoHeigtSettings];
    
    _inputView.sd_layout
    .leftSpaceToView(refresh_FS,0)
    .topSpaceToView(_bottomControlView,5)
    .bottomSpaceToView(_bottomControlView,-5)
    .rightSpaceToView(_barrage,0);
    [_inputView updateLayout];
    
    //语音输入按钮隐藏
    _inputView.voiceSwitchTextButton.hidden = YES;
    [_aBarrage start];
    
    _inputView.hidden = NO;
    
}

/* 控制层切回竖屏模式的方法*/
- (void)mediaControlTurnDownFullScreenModeWithMainView:(FJFloatingView *)playerView{
    //[_aBarrage stop];
    _mediaControl.sd_resetLayout
    .topSpaceToView(self.view,0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .autoHeightRatio(9/16.0);
    _fileName.hidden = YES;
    
    [_mediaControl updateLayout];
    
    _controlOverlay.sd_resetLayout
    .topEqualToView(_mediaControl)
    .bottomEqualToView(_mediaControl)
    .leftEqualToView(_mediaControl)
    .rightEqualToView(_mediaControl);
    
    
    [_switchScreen removeAllTargets];
    [_switchScreen addTarget:self action:@selector(switchBothScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    [_tileScreen removeAllTargets];
    [_tileScreen addTarget: self action:@selector(changeLevels:) forControlEvents:UIControlEventTouchUpInside];
    
    refresh_FS.hidden = NO;
    _scaleModeBtn.hidden = NO;
    _tileScreen.hidden =NO;
    _inputView.btnChangeVoiceState.hidden = NO;
    
    /* 恢复布局*/
    _scaleModeBtn.sd_layout
    .rightSpaceToView(self.bottomControlView,0)
    .topSpaceToView(self.bottomControlView,0)
    .bottomSpaceToView(self.bottomControlView,0)
    .widthEqualToHeight();
    
    _tileScreen.sd_layout
    .rightSpaceToView(_switchScreen,0)
    .topSpaceToView(_bottomControlView,0)
    .bottomSpaceToView(_bottomControlView,0)
    .widthEqualToHeight();
    
    _switchScreen.sd_layout
    .rightSpaceToView(_scaleModeBtn,0)
    .topSpaceToView(_bottomControlView,0)
    .bottomSpaceToView(_bottomControlView,0)
    .widthEqualToHeight();
    
    _barrage.sd_layout
    .rightSpaceToView(_tileScreen,0)
    .heightRatioToView(_tileScreen,1.0)
    .topSpaceToView(_bottomControlView,0)
    .widthRatioToView(_tileScreen,1.0);
    
    _inputView.hidden = YES;
    
}

#pragma mark- 切换分屏(平铺)点击事件

/**
 
 切换分屏(平铺)按钮 点击事件  .infoview的覆盖层的点击事件同此
 @param sender 点击来源
 */
- (void)changeLevels:(id)sender{
    
    /* 条件:在非全屏状态下*/
    if (isFullScreen == NO) {
        
        /* 条件1：在平级视图情况下切换分屏*/
        if (_viewsArrangementMode == SameLevel) {
            
            /* 副视图要切换成悬浮视图*/
            
            /* 条件1-1：如果白板是副视图*/
            if (_boardPlayerView.becomeMainPlayer==NO) {
                
                [self makeFloatingPlayer:_boardPlayerView];
                [self changInfoViewsWithTopView:_teacherPlayerView];
                
            }
            /* 条件1-2：如果老师是副视图*/
            if (_teacherPlayerView.becomeMainPlayer==NO) {
                [self makeFloatingPlayer:_teacherPlayerView];
                [self changInfoViewsWithTopView:_boardPlayerView];
                
            }
            
            [self changInfoViewContentSizeToBig];
            
            if ( _viewsArrangementMode == DifferentLevel) {
                
            }else {
                
                _viewsArrangementMode = DifferentLevel;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"DifferentLevel" object:nil];
                
            }
            
            /* 切换成非平级视图后,弹幕不可点不可用*/
            _barrage.enabled = NO;
            [_barrage setImage:[UIImage imageNamed:@"barrage_off"] forState:UIControlStateNormal];
            _maskView.hidden = YES;
            
        }
        
        //    /* 条件2：在非平级视图情况下切换分屏*/
        //
        else if (_viewsArrangementMode == DifferentLevel) {
            
            
            /* 条件2-1：如果白板是主视图*/
            if (_boardPlayerView.becomeMainPlayer == YES) {
                /* 教室切换为副视图*/
                
                [_teacherPlayerView sd_clearAutoLayoutSettings];
                [self makeSecondPlayer:_teacherPlayerView];
                [self makeFirstPlayer:_boardPlayerView];
                [self changInfoViewsWithTopView:_teacherPlayerView];
                [self changInfoViewContentSizeToSmall];
                
                [_aBarrage.view sd_clearAutoLayoutSettings];
                _aBarrage.view.sd_layout
                .leftEqualToView(_teacherPlayerView)
                .rightEqualToView(_teacherPlayerView)
                .topEqualToView(_teacherPlayerView)
                .bottomEqualToView(_teacherPlayerView);
                
                
            }
            /* 条件2-2：如果教师是主视图*/
            else if(_teacherPlayerView.becomeMainPlayer == YES){
                /* 白板切换为副视图*/
                [self makeSecondPlayer:_boardPlayerView];
                [self changInfoViewsWithTopView:_boardPlayerView];
                [self changInfoViewContentSizeToSmall];
                [_aBarrage.view sd_clearAutoLayoutSettings];
                _aBarrage.view.sd_layout
                .leftEqualToView(_teacherPlayerView)
                .rightEqualToView(_teacherPlayerView)
                .topEqualToView(_teacherPlayerView)
                .bottomEqualToView(_teacherPlayerView);
                
            }
            
            if (_viewsArrangementMode == SameLevel) {
                
            }else{
                
                _viewsArrangementMode = SameLevel;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"SameLevel" object:nil];
                
            }
            /* 切换回平级视图,弹幕可用,弹幕按钮可用*/
            _barrage.enabled = YES;
            [_barrage setImage:[UIImage imageNamed:@"barrage_on"] forState:UIControlStateNormal];
            _aBarrage.view.hidden = NO;
            _maskView.hidden = NO;
            
        }
        
        
    }
    
}

/* infoview的contentsize变大*/
- (void)changInfoViewContentSizeToBig{
    
    if (_boardPlayerView.becomeMainPlayer==YES) {
        _mainView.sd_layout
        .topSpaceToView(_boardPlayerView, 0);
        [_mainView updateLayout];
    }else{
        _mainView.sd_layout
        .topSpaceToView(_teacherPlayerView, 0);
        [_mainView updateLayout];
    }
    
}

/* infoview的contentsize变小*/
- (void)changInfoViewContentSizeToSmall{
    
    if (_boardPlayerView.becomeMainPlayer == NO) {
        _mainView.sd_layout
        .topSpaceToView(_boardPlayerView, 0);
        [_mainView updateLayout];
    }else{
        _mainView.sd_layout
        .topSpaceToView(_teacherPlayerView, 0);
        [_mainView updateLayout];
    }
    
}

#pragma mark- 切换屏顺序点击事件
- (void)switchBothScreen:(id)sender{
    
    [_aBarrage stop];
    /* 条件:在非全屏状态下*/
    if (isFullScreen == NO) {
        /* 条件1：如果现在是平级视图,白板和老师进行切换*/
        if (_viewsArrangementMode == SameLevel){
            [self changeArrangement];
            
        }
        /* 条件2：如果现在是非平级视图，两个非平级视图进行切换（大变小、小变大）*/
        if (_viewsArrangementMode == DifferentLevel){
            [self changePlayersMode];
        }
        
        /* 条件:在全屏状态下*/
    }else{
        /* 条件1:白板是主屏*/
        if (_boardPlayerView.becomeMainPlayer == YES) {
            
            [self turnToFullScreenMode:_teacherPlayerView];
            [_teacherPlayerView removeGestureRecognizer:_doubelTap];
            [_boardPlayerView addGestureRecognizer:_doubelTap];
            
            //            [_aBarrage.view removeFromSuperview];
            //            [_teacherPlayerView addSubview:_aBarrage.view];
            //
            //            _aBarrage.view.sd_layout
            //            .leftEqualToView(_teacherPlayerView)
            //            .rightEqualToView(_teacherPlayerView)
            //            .topEqualToView(_teacherPlayerView)
            //            .bottomEqualToView(_teacherPlayerView);
            //            [_aBarrage.view updateLayout];
            [self mediaControlTurnToFullScreenModeWithMainView:_teacherPlayerView];
            [self makeFloatingPlayer:_boardPlayerView];
            
        }else if (_teacherPlayerView.becomeMainPlayer == YES){
            /* 条件2:摄像头是主屏*/
            [self turnToFullScreenMode:_boardPlayerView];
            [_boardPlayerView removeGestureRecognizer:_doubelTap];
            [_teacherPlayerView addGestureRecognizer:_doubelTap];
            
            //            [_aBarrage.view removeFromSuperview];
            //            [_boardPlayerView addSubview:_aBarrage.view];
            //
            //            _aBarrage.view.sd_layout
            //            .leftEqualToView(_boardPlayerView)
            //            .rightEqualToView(_boardPlayerView)
            //            .topEqualToView(_boardPlayerView)
            //            .bottomEqualToView(_boardPlayerView);
            //            [_aBarrage.view updateLayout];
            [self mediaControlTurnToFullScreenModeWithMainView:_boardPlayerView];
            [self makeFloatingPlayer:_teacherPlayerView];
            
        }
        
        
    }
    
    [_aBarrage start];
    
}


#pragma mark- 全屏状态下双击小视频窗口的点击事件
- (void)switchVideoOnFullScreenMode:(UITapGestureRecognizer *)sender{
    
    /* 条件1:白板是主屏*/
    if (_boardPlayerView.becomeMainPlayer == YES) {
        
        [self turnToFullScreenMode:_teacherPlayerView];
        [_teacherPlayerView removeGestureRecognizer:_doubelTap];
        [_boardPlayerView addGestureRecognizer:_doubelTap];
        [_teacherPlayerView addSubview:_aBarrage.view];
        [_aBarrage.view sd_clearAutoLayoutSettings];
        _aBarrage.view.sd_layout
        .leftEqualToView(_teacherPlayerView)
        .rightEqualToView(_teacherPlayerView)
        .topEqualToView(_teacherPlayerView)
        .bottomEqualToView(_teacherPlayerView);
        [_aBarrage.view updateLayout];
        [self mediaControlTurnToFullScreenModeWithMainView:_teacherPlayerView];
        [self makeFloatingPlayer:_boardPlayerView];
        
        
        
    }else if (_teacherPlayerView.becomeMainPlayer == YES){
        /* 条件2:摄像头是主屏*/
        [self turnToFullScreenMode:_boardPlayerView];
        [_boardPlayerView removeGestureRecognizer:_doubelTap];
        [_teacherPlayerView addGestureRecognizer:_doubelTap];
        [_boardPlayerView addSubview:_aBarrage.view];
        [_aBarrage.view sd_clearAutoLayoutSettings];
        _aBarrage.view.sd_layout
        .leftEqualToView(_boardPlayerView)
        .rightEqualToView(_boardPlayerView)
        .topEqualToView(_boardPlayerView)
        .bottomEqualToView(_boardPlayerView);
        [_aBarrage.view updateLayout];
        [self mediaControlTurnToFullScreenModeWithMainView:_boardPlayerView];
        [self makeFloatingPlayer:_teacherPlayerView];
        
        
    }
    
    
    
    
    
}

#pragma mark- 在非平级视图下切换两个视图（大变小、小变大）
- (void)changePlayersMode{
    
    /* 条件1：如果老师是主视图*/
    if (_boardPlayerView.becomeMainPlayer ==NO) {
        
        [_boardPlayerView updateLayout];
        CGRect ovFrame = _boardPlayerView.frame;
        
        
        /* 白板变成主视图*/
        [self makeFirstPlayer:_boardPlayerView];
        
        /* infoview的尺寸变化*/
        [self changInfoViewsWithTopView:_boardPlayerView];
        
        /* 老师变成移动视图*/
        [self makeFloatingPlayer:_teacherPlayerView];
        
        _teacherPlayerView.sd_resetLayout
        .leftSpaceToView(self.view,ovFrame.origin.x)
        .topSpaceToView(self.view,ovFrame.origin.y)
        .widthRatioToView(self.view,2/5.0)
        .autoHeightRatio(9/16.0);
        
        //        [self.view bringSubviewToFront:_teacherPlayerView];
    }
    
    /* 条件2 ：如果白板是主视图*/
    else if (_teacherPlayerView.becomeMainPlayer ==NO) {
        
        [_teacherPlayerView updateLayout];
        
        CGRect ovFrame = _teacherPlayerView.frame;
        
        /* 老师再变成主视图*/
        [self makeFirstPlayer:_teacherPlayerView];
        
        /* infoview的尺寸变化*/
        [self changInfoViewsWithTopView:_teacherPlayerView];
        
        /* 白板先变成可移动视图*/
        [self makeFloatingPlayer:_boardPlayerView];
        
        _boardPlayerView.sd_layout
        .leftSpaceToView(self.view,ovFrame.origin.x)
        .topSpaceToView(self.view,ovFrame.origin.y)
        .widthRatioToView(self.view,2/5.0)
        .autoHeightRatio(9/16.0);
        
        //        [self.view bringSubviewToFront:_boardPlayerView];
        
    }
    
    if ( _viewsArrangementMode == DifferentLevel) {
        
    }else{
        _viewsArrangementMode = DifferentLevel;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DifferentLevel" object:nil];
        
    }
    
}

#pragma mark- 分屏直播的页面变化之后，视频播放器和infoView的布局变化以及大scrollview的contentsize 的变化

/* 两播放器平级视图的情况下进行顺序变化*/
- (void)changeArrangement{
    /* 条件1：如果两个平级不可移动视图，确定为变换后依然是平级不可移动视图*/
    if (_viewsArrangementMode == SameLevel) {
        /* 条件1-1：如果当前白板是主视图*/
        if (_boardPlayerView.becomeMainPlayer == YES) {
            /* 白板变成副视图*/
            [self makeSecondPlayer:_boardPlayerView];
            /* 老师变成主视图*/
            [self makeFirstPlayer:_teacherPlayerView];
            /* infoView的约束变化*/
            [self changInfoViewsWithTopView:_boardPlayerView];
            
        }
        /* 条件1-2：如果当前老师是主视图*/
        else if (_teacherPlayerView.becomeMainPlayer == YES) {
            /* 教师端变成副视图 布局改变*/
            [self makeSecondPlayer:_teacherPlayerView];
            /* 白板变成主视图*/
            [self makeFirstPlayer:_boardPlayerView];
            /* infoView的约束变化*/
            [self changInfoViewsWithTopView:_teacherPlayerView];
        }
        
    }
    
}

#pragma mark- 悬浮视图的拓展方法-实现部分
/* 变成主视图*/
- (void)makeFirstPlayer:(FJFloatingView *)playerView{
    
    //    [self.view bringSubviewToFront:playerView];
    playerView.becomeMainPlayer = YES;
    playerView.canMove =NO;
    
    //    [playerView sd_clearAutoLayoutSettings];
    
    playerView.sd_resetLayout
    .topSpaceToView (self.view,0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .autoHeightRatio(9/16.0f);
    [playerView updateLayout];
    
    [self.view bringSubviewToFront:_mediaControl];
    
}

/* 变成副视图*/
- (void)makeSecondPlayer:(FJFloatingView *)playerView{
    
    //     [self.view bringSubviewToFront:playerView];
    playerView.becomeMainPlayer = NO;
    playerView.canMove =NO;
    [playerView removeGestureRecognizer:playerView.pan];
    
    [playerView sd_clearAutoLayoutSettings];
    
    playerView.sd_layout
    .topSpaceToView (self.view,self.view.width_sd*9/16)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .autoHeightRatio(9/16.0f);
    [playerView updateLayout];
    
    [self.view bringSubviewToFront:_mediaControl];
    
    _viewsArrangementMode = SameLevel;
    
    
}

/* 变成可移动视图*/
- (void)makeFloatingPlayer:(FJFloatingView *)playerView{
    
    playerView.becomeMainPlayer = NO;
    playerView.canMove = YES;
    [playerView addGestureRecognizer:playerView.pan];
    [playerView sd_clearAutoLayoutSettings];
    
    /* 在非全屏状态下*/
    if (isFullScreen == NO) {
        
        /* 副视图变小*/
        playerView.sd_resetLayout
        .topSpaceToView(self.view,0)
        .leftEqualToView(self.view)
        .widthRatioToView(self.view,2/5.0f)
        .autoHeightRatio(9/16.0);
        [playerView updateLayout];
        
    }else{
        /* 在全屏视图下*/
        
        playerView.sd_resetLayout
        .topSpaceToView(self.view,0)
        .leftEqualToView(self.view)
        .widthRatioToView(self.view,1/5.0f)
        .autoHeightRatio(9/16.0);
        
        [playerView updateLayout];
        
        
    }
    
    //    _chatTableView.sd_layout
    //    .bottomSpaceToView(_liveClassInfoView.view2,46);
    //    [_chatTableView updateLayout];
    
    /* 把可移动的这个视图放到self.view的最上层*/
    [self.view bringSubviewToFront:playerView];
    
}

/* 改变infoview的top和位置*/
- (void)changInfoViewsWithTopView:(FJFloatingView *)playerView{
    
   _mainView.sd_layout
    .topSpaceToView(playerView, 0);
    [_mainView updateLayout];
    
    
}

#pragma mark- 隐藏segment和滑动视图
- (void)hideSegementAndScrollViews{
    
    [_mainView removeFromSuperview];
    
}

#pragma mark- 显示segment和滑动视图
- (void)showSegmentAndScrollViews{
    
    [self.view addSubview: _mainView];
    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    if (_teacherPlayerView.becomeMainPlayer == YES) {
        _mainView.sd_layout
        .topSpaceToView(_teacherPlayerView, 0);
        [_mainView updateLayout];
    }else{
        _mainView.sd_layout
        .topSpaceToView(_boardPlayerView, 0);
        [_mainView updateLayout];
        
    }
    
}


/* 变成横屏*/
- (void)turnToFullScreenMode:(FJFloatingView *)playerView{
    
    playerView.becomeMainPlayer = YES;
    playerView.canMove = NO;
    
    [_mediaControl removeAllTargets];
    [_mediaControl addTarget:self action:@selector(onClickMediaControl:) forControlEvents:UIControlEventTouchUpInside];
    [_controlOverlay removeAllTargets];
    [_controlOverlay addTarget:self action:@selector(onClickOverlay:) forControlEvents:UIControlEventTouchUpInside];
    
    [playerView sd_clearAutoLayoutSettings];
    
    playerView.sd_layout
    .topEqualToView(self.view)
    .bottomEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view);
    
    if ([playerView.gestureRecognizers containsObject:_doubelTap]) {
        
        [playerView removeGestureRecognizer:_doubelTap];
    }
    
    //    [_aBarrage.view removeFromSuperview];
    //    [playerView addSubview:_aBarrage.view];
    //    _aBarrage.view.sd_layout
    //    .leftSpaceToView(playerView, 0)
    //    .rightSpaceToView(playerView, 0)
    //    .topSpaceToView(playerView, 0)
    //    .bottomSpaceToView(playerView, 0);
    //    [_aBarrage.view updateLayout];
    //
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (BOOL)prefersStatusBarHidden{
    
    return YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
}

//支持设备自动旋转

//  是否支持自动转屏
- (BOOL)shouldAutorotate
{
    
    return YES;
}

// 支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

// 页面展示的时候默认屏幕方向（当前ViewController必须是通过模态ViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


//显示模式转换
- (void)onClickScaleMode:(id)sender{
    
    [_aBarrage stop];
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    NSLog(@"%ld",(long)[UIDevice currentDevice].orientation);
    
    switch (self.scaleModeBtn.titleLabel.tag) {
        case 0:
            [self.scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale02"] forState:UIControlStateNormal];
            //            [self.liveplayerTeacher setScalingMode:NELPMovieScalingModeAspectFit];
            
            /* 强制转成横屏*/
            if (orientation == UIDeviceOrientationLandscapeRight) {
                [self interfaceOrientation:UIInterfaceOrientationLandscapeLeft];
            } else {
                [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
            }
            
            self.scaleModeBtn.titleLabel.tag = 1;
            break;
        case 1:
            /* 强制转成竖屏*/
            [self.scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale01"] forState:UIControlStateNormal];
            
            if (orientation ==UIInterfaceOrientationLandscapeRight) {
                
                [self interfaceOrientation:UIInterfaceOrientationPortrait];
                
            }else{
                [self interfaceOrientation:UIInterfaceOrientationPortrait];
                
            }
            self.scaleModeBtn.titleLabel.tag = 0;
            break;
            
    }
}

//在点击全屏按钮的情况下，强制改变屏幕方向
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation{
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    
}


- (void)onDeviceOrientationChange{
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown || orientation == UIDeviceOrientationPortraitUpsideDown) {
        
        return;
    }
    [self.view layoutIfNeeded];
}



//全屏播放视频后，播放器的适配和全屏旋转
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    [_aBarrage stop];
    
    /* 切换到竖屏*/
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        //        [_aBarrage stop];
        //        self.view.backgroundColor = [UIColor blackColor];
        [self.scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale01"] forState:UIControlStateNormal];
        self.scaleModeBtn.titleLabel.tag = 0;
        
        //谁是主视图，谁就恢复到主屏
        if (_boardPlayerView.becomeMainPlayer == YES) {
            
            [self makeFirstPlayer:_boardPlayerView];
            [self changInfoViewsWithTopView:_boardPlayerView];
            [self changInfoViewContentSizeToBig];
            
            _maskView.hidden = YES;
            
            if (_viewsArrangementMode == SameLevel) {
                
                [self makeFloatingPlayer:_teacherPlayerView];
                
                
            }if (_viewsArrangementMode == DifferentLevel){
                
                [self makeFloatingPlayer:_teacherPlayerView];
            }
            
        }else if(_teacherPlayerView.becomeMainPlayer == YES){
            
            [self makeFirstPlayer:_teacherPlayerView];
            [self changInfoViewsWithTopView:_teacherPlayerView];
            [self changInfoViewContentSizeToBig];
            
            _maskView.hidden = YES;
            if (_viewsArrangementMode == SameLevel) {
                
                [self makeFloatingPlayer:_boardPlayerView];
            }
            if (_viewsArrangementMode == DifferentLevel){
                
                [self makeFloatingPlayer:_boardPlayerView];
            }
            
        }
        
        /* 显示segment和scrollview*/
        [self showSegmentAndScrollViews];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"TurnDownFullScreen" object:nil];
        
    }
    
    /* 切换到全屏*/
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        
        //        [_aBarrage stop];
        self.view.backgroundColor = [UIColor blackColor];
        [self.scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale02"] forState:UIControlStateNormal];
        self.scaleModeBtn.titleLabel.tag = 1;
        
        /**
         切换两次没有别的目的,只为了防止卡死的bug出现
         */
        isFullScreen = YES;
        //        [self switchBothScreen:self];
        //        [self switchBothScreen:self];
        
        //谁是主视图，谁就全屏
        if (_boardPlayerView.becomeMainPlayer == YES) {
            [self.view sendSubviewToBack:_mainView];
            [self turnToFullScreenMode:_boardPlayerView];
            [self makeFloatingPlayer:_teacherPlayerView];
            
            [_teacherPlayerView addGestureRecognizer:_doubelTap];
            [_boardPlayerView updateLayout];
            [_teacherPlayerView updateLayout];
            
        }else if(_teacherPlayerView.becomeMainPlayer == YES){
            [self.view sendSubviewToBack:_mainView];
            [self turnToFullScreenMode:_teacherPlayerView];
            [self makeFloatingPlayer:_boardPlayerView];
            [_boardPlayerView addGestureRecognizer:_doubelTap];
            //            [_boardPlayerView removeFromSuperview];
            [_boardPlayerView updateLayout];
            [_teacherPlayerView updateLayout];
            
        }
        
        /* 切换到横屏 隐藏segment和scrollview*/
        [self hideSegementAndScrollViews];
        /* 全屏状态  发送消息通知*/
        [[NSNotificationCenter defaultCenter]postNotificationName:@"FullScreen" object:nil];
        
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    if (fromInterfaceOrientation!=UIInterfaceOrientationPortrait) {
        
//        [_mainView updateLayout];
//        [_mainView.scrollView layoutIfNeeded];
//        [_mainView.scrollView updateLayout];
//        _chatController.view.sd_layout
//        .leftSpaceToView(_mainView.scrollView, 0)
//        .topSpaceToView(_mainView.scrollView, 0)
//        .bottomSpaceToView(_mainView.scrollView, 0)
//        .widthRatioToView(_mainView.scrollView, 1.0);
//        [_chatController.view updateLayout];
//        
//        _noticeController.view.sd_layout
//        .leftSpaceToView(_chatController.view, 0)
//        .topEqualToView(_chatController.view)
//        .bottomEqualToView(_chatController.view)
//        .widthRatioToView(_chatController.view, 1.0);
//        [_noticeController.view updateLayout];
        
//        _chatController.inputView.hidden = NO;
//        [_chatController.inputView updateLayout];
        
    }
    
}

#pragma mark - 播放器的播放/停止/退出等方法

//退出播放
- (void)onClickBack:(id)sender{
    [_aBarrage stop];
    //    [_aBarrage.view removeFromSuperview];
    /* 非屏状态下的点击事件*/
    if (isFullScreen == NO) {
        [self returnLastPage];
        [self syncUIStatus:YES];
        /* 全屏状态下的点击事件*/
    }else if (isFullScreen == YES){
        
        [self onClickScaleMode:self];
        
    }
    
}

//开始播放
- (void)onClickPlay:(id)sender{
    NSLog(@"click Play");
    
    [self.liveplayerBoard play];
    [self.liveplayerTeacher play];
    
    
    [self syncUIStatus:NO];
}

//暂停播放
- (void)onClickPause:(id)sender{
    NSLog(@"click pause");
    [self.liveplayerBoard pause];
    [self.liveplayerTeacher pause];
    [self syncUIStatus:NO];
}

//触摸overlay
- (void)onClickOverlay:(id)sender{
    NSLog(@"click overlay");
    
    [self controlOverlayHide];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlOverlayHide) object:nil];
    [_inputView.TextViewInput resignFirstResponder];
    [_inputView changeSendBtnWithPhoto:YES];
}

/* 控制层点击事件*/
- (void)onClickMediaControl:(id)sender{
    NSLog(@"click mediacontrol");
    [self controlOverlayShow];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlOverlayHide) object:nil];
    [self syncUIStatus:NO];
    [self performSelector:@selector(controlOverlayHide) withObject:nil afterDelay:5];
    self.controlOverlay.alpha = 1.0;
    [_inputView.TextViewInput resignFirstResponder];
    [_inputView changeSendBtnWithPhoto:YES];
    
}

/* 控制层隐藏 带动画*/
- (void)controlOverlayHide{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.controlOverlay.alpha = 0;
        NSLog(@"控制栏隐藏了");
    }];
    
    [self performSelector:@selector(hideControlOverlay) withObject:nil afterDelay:0.5];
}
/* 控制层出现,带动画*/
- (void)controlOverlayShow{
    
    [self showControlOverlay];
    
    self.controlOverlay.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.controlOverlay.alpha = 1;
        NSLog(@"控制栏出现了");
    }];
    
}

/* 控制层出现,不带动画*/
- (void)showControlOverlay{
    
    self.controlOverlay.hidden = NO;
    
}

/* 控制层隐藏 不带动画*/
- (void)hideControlOverlay{
    self.controlOverlay.hidden = YES;
}

- (void)syncUIStatus:(BOOL)isSync{
    
    if ([self.liveplayerBoard playbackState] == NELPMoviePlaybackStatePlaying) {
        self.playBtn.hidden = YES;
        self.pauseBtn.hidden = NO;
    }
    else {
        self.playBtn.hidden = NO;
        self.pauseBtn.hidden = YES;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(syncUIStatus:) object:nil];
    if (!self.playQuitBtn.hidden && !isSync) {
        [self performSelector:@selector(syncUIStatus:) withObject:nil afterDelay:0.5];
    }
}

/* 播放器准备播放的回调方法*/
- (void)NELivePlayerDidPreparedToPlay:(NSNotification*)notification{
    //add some methods
    
    NELivePlayerController *livePlayer = [notification object];
    if (livePlayer == _liveplayerBoard) {
        
        NSLog(@"白板播放器准备开始播放.");
        [_boardPlayerView makePlaceHolderImage:nil];
        
    }else if (livePlayer == _liveplayerTeacher){
        NSLog(@"摄像头播放器准备开始播放.");
        [_teacherPlayerView makePlaceHolderImage:nil];
    }
    
    
    /* 切换播放暂停按钮*/
    [self syncUIStatus:NO];
    
    //    [self.liveplayerBoard play]; //开始播放
    //    [self.liveplayerTeacher play]; //开始播放
}


/* 刷新播放功能*/
- (void)refreshVideo:(id)sender{
    
    
}

#pragma mark- 直播结束的回调
- (void)NELivePlayerPlayBackFinished:(NSNotification*)notification{
    
    switch ([[[notification userInfo] valueForKey:NELivePlayerPlaybackDidFinishReasonUserInfoKey] intValue])
    {
        case NELPMovieFinishReasonPlaybackEnded:
            /* 直播结束的回调*/
            
        {
            if ([notification object]==_liveplayerBoard){
                
                [_liveplayerBoard stop];
                
                
            }else if ([notification object]==_liveplayerTeacher){
                
                [_liveplayerTeacher stop];
                
            }
            
            //播放结束后 继续轮询后台接口
            //            [self performSelector:@selector(checkVideoStatus) withObject:nil afterDelay:10];
            
        }
            
            break;
            
        case NELPMovieFinishReasonPlaybackError:{
            /* 播放错误导致失败的回调*/
            NSString *player = nil;
            if ([notification object]==_liveplayerBoard){
                player = [NSString stringWithFormat:@"白板播放器"];
            }else if ([notification object]==_liveplayerTeacher){
                player = [NSString stringWithFormat:@"摄像头播放器"];
            }
            
            //只要结束,不管什么原因 ,照样轮询
            //            [self performSelector:@selector(checkVideoStatus) withObject:nil afterDelay:10];
            
        }
            break;
            
        case NELPMovieFinishReasonUserExited:
            
            break;
            
        default:
            break;
    }
}
/* 播放器加载数据的回调方法*/
- (void)NeLivePlayerloadStateChanged:(NSNotification*)notification{
    
    NELivePlayerController *livePlayer = [notification object];
    
    NELPMovieLoadState nelpLoadState = livePlayer.loadState;
    if (nelpLoadState == NELPMovieLoadStatePlaythroughOK){
        if (livePlayer == _liveplayerBoard) {
            NSLog(@"白板播放器加载视频成功!!!");
        }else if(livePlayer == _liveplayerTeacher){
            NSLog(@"摄像头播放器加载视频成功!!!");
        }
    }else if (nelpLoadState == NELPMovieLoadStateStalled){
        if (livePlayer == _liveplayerBoard) {
            NSLog(@"白板播放器开始加载视频......");
        }else if(livePlayer == _liveplayerTeacher){
            NSLog(@"摄像头播放器开始加载视频......");
        }
        
    }else if (nelpLoadState == NELPMovieLoadStatePlayable){
        
    }
}

- (void)NELivePlayerFirstVideoDisplayed:(NSNotification*)notification{
    //    NSLog(@"first video frame rendered!");
    NELivePlayerController *livePlayer = [notification object];
    if (livePlayer == _liveplayerBoard) {
        NSLog(@"白板播放器开始播放视频!!!");
    }else if(livePlayer == _liveplayerTeacher){
        NSLog(@"摄像头播放器开始播放视频!!!");
    }
    
}


- (void)NELivePlayerFirstAudioDisplayed:(NSNotification*)notification{
    //    NSLog(@"first audio frame rendered!");
}

- (void)NELivePlayerVideoParseError:(NSNotification*)notification{
    NELivePlayerController *livePlayer = [notification object];
    if (livePlayer == _liveplayerBoard) {
        
        NSLog(@"白板播放器视频流解析失败");
    }else if(livePlayer == _liveplayerTeacher){
        NSLog(@"摄像头播放器视频流解析失败");
    }
    
}

- (void)NELivePlayerReleaseSuccess:(NSNotification*)notification{
    
    NELivePlayerController *livePlayer = [notification object];
    if (livePlayer == _liveplayerBoard) {
        NSLog(@"白板播放器资源释放了!!!");
    }else if (livePlayer == _liveplayerTeacher){
        NSLog(@"摄像头播放器资源释放了!!!");
        
    }
    
}

#pragma mark- 以上是播放器的初始化和配置方法、接口等

#pragma mark- 下为页面数据及逻辑等

- (void)viewDidLoad {
    [super viewDidLoad];
    //不允许侧滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self makeData];
    [self setupPlayer];
    [self setupChildController];
    [self setupMainView];
    
    /* 白板播放端的通知*/
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerDidPreparedToPlay:) name:NELivePlayerDidPreparedToPlayNotification object:_liveplayerBoard];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NeLivePlayerloadStateChanged:) name:NELivePlayerLoadStateChangedNotification object:_liveplayerBoard];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerPlayBackFinished:) name:NELivePlayerPlaybackFinishedNotification object:_liveplayerBoard];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerFirstVideoDisplayed:) name:NELivePlayerFirstVideoDisplayedNotification object:_liveplayerBoard];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerFirstAudioDisplayed:) name:NELivePlayerFirstAudioDisplayedNotification object:_liveplayerBoard];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerReleaseSuccess:) name:NELivePlayerReleaseSueecssNotification object:_liveplayerBoard];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerVideoParseError:) name:NELivePlayerVideoParseErrorNotification object:_liveplayerBoard];
    
    /* 老师播放端的通知*/
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerDidPreparedToPlay:) name:NELivePlayerDidPreparedToPlayNotification object:_liveplayerTeacher];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NeLivePlayerloadStateChanged:) name:NELivePlayerLoadStateChangedNotification object:_liveplayerTeacher];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerPlayBackFinished:) name:NELivePlayerPlaybackFinishedNotification object:_liveplayerTeacher];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerFirstVideoDisplayed:) name:NELivePlayerFirstVideoDisplayedNotification object:_liveplayerTeacher];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerFirstAudioDisplayed:) name:NELivePlayerFirstAudioDisplayedNotification object:_liveplayerTeacher];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerReleaseSuccess:) name:NELivePlayerReleaseSueecssNotification object:_liveplayerTeacher];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerVideoParseError:) name:NELivePlayerVideoParseErrorNotification object:_liveplayerTeacher];
    
    
    /* 监听白板播放端是否可以移动*/
    [_boardPlayerView addObserver:self forKeyPath:@"canMove" options:NSKeyValueObservingOptionNew context:nil];
    
    /* 监听老师播放端是否可以移动*/
    [_teacherPlayerView addObserver:self forKeyPath:@"canMove" options:NSKeyValueObservingOptionNew context:nil];
    
    
    
    
    /* 变为非平级视图的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(viewLevelChangDifferent:) name:@"DifferentLevel" object:nil];
    /* 变为平级视图的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(viewLevelChangSame:) name:@"SameLevel" object:nil];
    
    /* 变为全屏后的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(turnFullScreen:) name:@"FullScreen" object:nil];
    
    /* 切换回竖屏后的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(turnDownFullScreen:) name:@"TurnDownFullScreen" object:nil];
    
    /* 全屏弹幕框的监听*/
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(barrageTextEdit:) name:@"BarrageBecomeFirstResponder" object:nil];
    
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    /* 监听播放器的初始化状态*/
    
    /* 白板初始化成功*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(boardPlayerInitSuccess) name:@"BoardPlayerInitSuccess" object:nil];
    
    /* 摄像头初始化成功*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(teacherPlayerInitSuccess) name:@"TeacherPlayerInitSuccess" object:nil];
    
    
    /* 两个播放器都初始化成功*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(allPlayerInitSuccess) name:@"AllPlayerInitSuccess" object:nil];
    
#pragma mark- 以下是页面和功能逻辑
    
    /* 最后,添加一个覆盖层.在视频播放器为平级视图的时候,上方的视频播放器可以点击,下方不可以点击*/
    
    _maskView = ({
        UIView *_= [[UIView alloc]init];
        [_mainView addSubview:_];
        if (_mainView&&_viewsArrangementMode==SameLevel) {
            _.sd_layout
            .leftEqualToView(_mainView)
            .rightEqualToView(_mainView)
            .topEqualToView(_mainView)
            .bottomEqualToView(_mainView);
        }
        UITapGestureRecognizer *maskTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeLevels:)];
        [_ addGestureRecognizer:maskTap];
        _;
    });
    
    /* 聊天信息发送时间间隔*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendeButtonCannotUse) name:@"sendButtonCannotUse" object:nil];
    
    /* app进入后台/回到前台的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidEnterBackground) name:@"ApplicationDidEnterBackground" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidBecomeActive) name:@"ApplicationDidBecomeActive" object:nil];
    
    /* 全屏模式下的双击手势*/
    _doubelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchVideoOnFullScreenMode:)];
    [_doubelTap setNumberOfTapsRequired:2];
    
    
    /* 全屏模式的监听-->在runtime机制下不可进行屏幕旋转的时候,强制进行屏幕旋转*/
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    /* 支持全屏*/
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SupportedLandscape"];
    
    
    /* 添加录音是否开始的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recordStart) name:@"RecordStart" object:nil];
    
    /* 添加录音是否结束的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recordEnd) name:@"RecordEnd" object:nil];
    
    
}



/* 全屏模式下的双击手势,切换两个视图*/
- (void)doubleTap:(UITapGestureRecognizer *)sender{
    
    if ([sender.view isEqual:_teacherPlayerView]) {
        
        [_teacherPlayerView removeGestureRecognizer:_doubelTap];
        [_boardPlayerView addGestureRecognizer:_doubelTap];
        
        
    }else if ([sender.view isEqual:_boardPlayerView]){
        
        [_boardPlayerView removeGestureRecognizer:_doubelTap];
        [_teacherPlayerView addGestureRecognizer:_doubelTap];
        
        
    }
    
    [self performSelector:@selector(switchBothScreen:)];
    
}


/* 播放器加载状态的监听方法*/
- (void)boardPlayerInitSuccess{
    
    if (teacherPlayerInitSuccess == YES) {
        bothPlayerInitSuccess = YES;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"AllPlayerInitSuccess" object:nil];
    }else{
        
        
    }
    
    
}

/* 摄像头播放器创建成功 */
- (void)teacherPlayerInitSuccess{
    
    if (boardPlayerInitSuccess == YES) {
        bothPlayerInitSuccess = YES;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"AllPlayerInitSuccess" object:nil];
    }
    
}


/* 两个播放器都加载完成后*/
- (void)allPlayerInitSuccess{
    
#pragma mark- 视频播放状态查询功能
    
    /* 两个播放器和控制层和覆盖层都加载完成后,每隔30秒请求一次数据*/
        [self checkVideoStatus];
    
    /**两个播放器和控制层加载完成后,加载在线人数*/
    //    [self checkOnlineNumber];
    
}




/* 发送按钮在两秒内不可以重复点击*/
- (void)sendeButtonCannotUse{
    
    [self HUDStopWithTitle:@"请稍后"];
}

#pragma mark- 语音部分
/* 开始检测麦克风声音*/
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
    
    
    
    NSError *error;
    
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    if (recorder)
    {
        [recorder prepareToRecord];
        recorder.meteringEnabled = YES;
        [recorder record];
        levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.1 target: self selector: @selector(levelTimerCallback) userInfo: nil repeats: YES];
        
        
    }
    else
    {
        NSLog(@"%@", [error description]);
    }
}

/* 检测系统麦克风的音量值  */
- (void)levelTimerCallback{
    
    [recorder updateMeters];
    
    float   level;                // The linear 0.0 .. 1.0 value we need.
    float   minDecibels = -80.0f; // Or use -60dB, which I measured in a silent room.
    float   decibels    = [recorder averagePowerForChannel:0];
    
    if (decibels < minDecibels)
    {
        level = 0.0f;
    }
    else if (decibels >= 0.0f)
    {
        level = 1.0f;
    }
    else
    {
        float   root            = 2.0f;
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        float   amp             = powf(10.0f, 0.05f * decibels);
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
        
        level = powf(adjAmp, 1.0f / root);
    }
    
    /* level 范围[0 ~ 1], 转为[0 ~120] 之间 */
    dispatch_async(dispatch_get_main_queue(), ^{
        //        [_textLabel setText:[NSString stringWithFormat:@"%f", level*120]];
        
        NSLog(@"分贝数 :%f",level*120);
        
    });
}

- (void)checkMic{
    
    [self checkMicVolum];
    
    
}

//开始录制的方法
- (void)recordStart{
    
    [self checkMic];
    
}
//语音录制结束的方法
- (void)recordEnd{
    
    [levelTimer invalidate];
    levelTimer = nil;
    
}



#pragma mark- 聊天及sdk
/* 初始化聊天sdk*/
- (void)initNIMSDK{
    
#pragma mark- 聊天功能初始化和自动登录
    /* 取出存储的chatAccount*/
//    _chat_Account =[Chat_Account yy_modelWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"chat_account"]];
    
    /* 查询登录状态*/
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"NIMSDKLogin"]) {
        
        [[NIMSDK sharedSDK].chatManager addDelegate:self];
        
    }else{
        
        /* 强制自动登录一次*/
        [[NIMSDK sharedSDK].loginManager addDelegate:self];
        NIMAutoLoginData *loginData = [[NIMAutoLoginData alloc]init];
        loginData.account = [[NSUserDefaults standardUserDefaults]objectForKey:@"chat_account"][@"accid"];
        loginData.token =[[NSUserDefaults standardUserDefaults]objectForKey:@"chat_account"][@"token"];
        [[NIMSDK sharedSDK].loginManager autoLogin:loginData];
        
    }
    
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    [[NIMSDK sharedSDK].chatroomManager addDelegate:self];
    
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //增加监听，当键退出时收出消息
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillHide:)  name:UIKeyboardWillHideNotification  object:nil];
    
    
}

#pragma mark- 请求历史数据的方法

/* 键盘出现*/
- (void)keyboardWillShow:(NSNotification *)notification {
    
    // 获取通知的信息字典
    NSDictionary *userInfo = [notification userInfo];
    
    // 获取键盘弹出后的rect
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    // 获取键盘弹出动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    if (isFullScreen == YES) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControlOverlay) object:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlOverlayHide) object:nil];
        
        [UIView animateWithDuration:animationDuration animations:^{
            
            self.view.frame = CGRectMake(0, -keyboardRect.size.height, self.view.width_sd, self.view.height_sd);
            
        }];
        
    }else{
        
        [UIView animateWithDuration:animationDuration animations:^{
            [_inputView updateLayout];
        }];
    }
    
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    // 获取通知信息字典
    NSDictionary* userInfo = [notification userInfo];
    
    // 获取键盘隐藏动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    
    if (isFullScreen) {
        [UIView animateWithDuration:animationDuration animations:^{
            
            self.view.frame = CGRectMake(0, 0, self.view.width_sd, self.view.height_sd);
        }];
        
            [_inputView changeSendBtnWithPhoto:YES];
        
        
    }else{
        [UIView animateWithDuration:animationDuration animations:^{
            
//            _inputView.sd_layout
//            .bottomSpaceToView(_liveClassInfoView.view2,0);
//            [IFView updateLayout];
            
        }];
        
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



#pragma mark- 聊天功能的方法

#pragma mark- 聊天ui的设置


#pragma mark- 开始/关闭弹幕功能
- (void)barragesSwitch{
    
    if (isFullScreen == YES) {
        
        if (_aBarrage.view.hidden == YES) {
            _aBarrage.view.hidden = NO;
        }
        if (barrageRunning==YES) {
            [_barrage setImage:[UIImage imageNamed:@"barrage_off"] forState:UIControlStateNormal];
        }else{
            [_aBarrage start];
            barrageRunning = YES;
            [_barrage setImage:[UIImage imageNamed:@"barrage_on"] forState:UIControlStateNormal];
        }
        
    }else{
        if (barrageRunning == YES) {
            _aBarrage.view.hidden = YES;
            barrageRunning =NO;
            [_barrage setImage:[UIImage imageNamed:@"barrage_off"] forState:UIControlStateNormal];
            [_aBarrage stop];
        }else if (barrageRunning == NO){
            _aBarrage.view.hidden = NO;
            barrageRunning = YES;
            [_barrage setImage:[UIImage imageNamed:@"barrage_on"] forState:UIControlStateNormal];
            [_aBarrage start];
        }
        
    }
}
#pragma mark- 发送弹幕方法
- (void)sendBarrage:(NSString *)message withAttibute:(NSAttributedString *)attribute{
    
    NSLog(@"%@",[self.view valueForKey:@"frame"]);
    
    NSLog(@"%@",message);
    
    /* 弹幕添加条件
     * 1、平铺视图在老师视频上
     * 2、在全屏视图上
     * 3、分屏小窗口的时候没有弹幕
     */
    
    /* 前提条件：必须是平级视图*/
    /* 如果不是在全屏的情况下*/
    if (isFullScreen== NO) {
        
        if (_viewsArrangementMode != DifferentLevel) {
            
            [_aBarrage.view removeFromSuperview];
            [_teacherPlayerView addSubview:_aBarrage.view];
            [_aBarrage.view sd_clearAutoLayoutSettings];
            _aBarrage.view.sd_layout
            .leftEqualToView(_teacherPlayerView)
            .rightEqualToView(_teacherPlayerView)
            .topEqualToView(_teacherPlayerView)
            .bottomEqualToView(_teacherPlayerView);
            [_aBarrage.view updateLayout];
            _aBarrage.view.hidden = NO;
            [_teacherPlayerView bringSubviewToFront:_aBarrage.view];
            
        }else{
            
            
        }
        
        /* 在全屏的条件下*/
    }else{
        
        if (_boardPlayerView .becomeMainPlayer == YES) {
            if ([_boardPlayerView.subviews containsObject:_aBarrage.view]) {
                
            }else{
                
                [_boardPlayerView addSubview:_aBarrage.view];
                _aBarrage.view.sd_layout
                .leftEqualToView(_boardPlayerView)
                .rightEqualToView(_boardPlayerView)
                .topEqualToView(_boardPlayerView)
                .bottomEqualToView(_boardPlayerView);
                [_aBarrage.view updateLayout];
            }
            //            if (_aBarrage.view.hidden == YES) {
            //
            //                _aBarrage.view.hidden = NO;
            //            }
            //            [_boardPlayerView bringSubviewToFront:_aBarrage.view];
            
        }else if (_teacherPlayerView.becomeMainPlayer == YES){
            
            if ([_teacherPlayerView .subviews containsObject:_aBarrage.view]) {
                
            }else{
                
                if (_aBarrage.view.superview!=nil) {
                    [_aBarrage.view removeFromSuperview];
                }
                
                [_teacherPlayerView addSubview:_aBarrage.view];
                _aBarrage.view.sd_layout
                .leftEqualToView(_teacherPlayerView)
                .rightEqualToView(_teacherPlayerView)
                .topEqualToView(_teacherPlayerView)
                .bottomEqualToView(_teacherPlayerView);
                [_aBarrage.view updateLayout];
                
            }
            
            //            if (_aBarrage.view.hidden == YES) {
            //
            //                _aBarrage.view.hidden = NO;
            //            }
            
        }
        
    }
    
    _descriptor.spriteName = NSStringFromClass(BarrageWalkTextSprite.self);
    _descriptor.params[@"text"] =message;
    _descriptor.params[@"textColor"] = [UIColor whiteColor];  //弹幕颜色
    _descriptor.params[@"side"] = BarrageWalkSideDefault;
    _descriptor.params[@"speed"] = @60;
    
    if (isFullScreen) {
        _descriptor.params[@"fontSize"]= @22;
    }else{
        _descriptor.params[@"fontSize"]= @16;
    }
    
    if (isFullScreen) {
        
        _aBarrage.canvasMargin = UIEdgeInsetsMake(30, 0, CGRectGetHeight(self.view.frame)/3.0f, 0);
        
    }else if (!isFullScreen){
        _aBarrage.canvasMargin = UIEdgeInsetsMake(30, 0, (CGRectGetWidth(self.view.frame)/16*9.0f)/3.0f, 0);
    }
    
    [_aBarrage start];
    [_aBarrage receive:_descriptor];
    
    
}

/* 高度变化的监听回调*/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    
    NSLog(@"%@",change);
    /* 如果监听到的floatview是否可以移动*/
    if ([keyPath isEqualToString:@"canMove"]) {
        
        if ([[change valueForKey:@"new"] isEqual:@0]) {
            
            [_boardPlayerView removeGestureRecognizer:_boardPlayerView.pan];
            
            [self.view bringSubviewToFront:_boardPlayerView];
            _boardPlayerView.sd_layout
            .leftEqualToView(self.view)
            .rightEqualToView(self.view)
            .topSpaceToView(self.teacherPlayerView,0)
            .autoHeightRatio(9/16.0);
            [_boardPlayerView updateLayout];
            
        }
        
    }
    
    
    if ([keyPath isEqualToString:@"headerHeight"]) {
        NSLog(@"%@",change);
        headerHeight = [[change valueForKey:@"new"] floatValue];
        
        [_mainView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), headerHeight+20)];
        
//        _classList.classListTableView.tableHeaderView =_infoHeaderView;
//        
//        _classList.classListTableView.tableHeaderView.height_sd =headerHeight;
        
        
        [self updateViewsInfos];
    }
    
    
}

/* 刷新在线用户列表*/
- (void)updateMembersList{
    
//    if (_membersArr.count!=0) {
//        
//        [_memberListView.memberListTableView reloadData];
//        
//    }
    
}

/* tableview刷新视图*/

- (void)updateViewsNotice{
    
//    [_classNotice.classNotice cyl_reloadData];
    //    [_liveClassInfoView.noticeTabelView setNeedsDisplay];
    
}

- (void)updateViewsInfos{
    
//    [_classList.classListTableView reloadData];
    
    
}


#pragma mark- tableview delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}





- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}




/* 文本输入框取消响应*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

/* 点击空白处,文本框取消响应*/
- (void)tapSpace{
    
        [_inputView.TextViewInput resignFirstResponder];
        [_inputView changeSendBtnWithPhoto:YES];
}


#pragma mark- 查询播放状态功能的方法实现 --播放器初始化状态
- (void)checkVideoStatus{
    
    /* 向后台发送请求,请求视频直播状态*/
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/live_studio/customized_groups/%@/realtime",Request_Header,_classID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        [self loginStates:dic];
        
        NSLog(@"向服务器请求视频直播状态成功!");
        
        //        地址:
        //        未直播 0
        //        直播中 1
        //        已关闭 2
        //        GET /api/v1/live_studio/courses/:id/live_status
        //        GET /live_studio/courses/:id/live_status
        //        返回值:
        //        {
        //
        //            "status": 1,
        //            "data": {
        //                "board": 1,
        //                "camera": 0
        //            }
        //        }
        
        
        //新的状态查询接口返回数据
        //        {
        //            "status": 1,
        //            "data": {
        //                "live_info": {
        //                    "id": "82",
        //                    "name": "第一课",
        //                    "status": "missed",
        //                    "board": "0",
        //                    "camera": "0",
        //                    "t": "1490336337"
        //                },
        //                "online_users": [
        //                                 "2878"
        //                                 ],
        //                "timestamp": 1490595407
        //            }
        //        }
        
        if ([dic[@"status"] isEqualToNumber:@1]) {
            
            /* 获取数据成功,执行下一步操作*/
            
            _statusDic = [NSDictionary dictionaryWithDictionary:dic[@"data"][@"live_info"]];
            
            
            //检查播放器播放状态
            [self switchStatuseWithDictionary:_statusDic];
            
            //检查在线人数
            [self switchOnlineNumbersWithArrayrs:dic[@"data"][@"online_users"]];
            
            //            完事儿,每隔五秒轮询一次
            [self performSelector:@selector(checkVideoStatus) withObject:nil afterDelay:5];
            
        }else{
            /* 获取数据失败*/
            [self performSelector:@selector(checkVideoStatus) withObject:nil afterDelay:5];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self performSelector:@selector(checkVideoStatus) withObject:nil afterDelay:5];
    }];
    
}

#pragma mark- 向后台查询直播状态和操作的方法
- (void)switchStatuseWithDictionary:(NSDictionary *)statusDic{
    
    UIAlertController *alertController = NULL;
    UIAlertAction *action = NULL;
    ///新的状态加载
    
    //同时直播的时候
    if ([statusDic[@"board"]isEqualToString:@"1"]&&[statusDic[@"camera"]isEqualToString:@"1"]) {
        /* 不用再向服务器发送查询请求*/
        NSLog(@"白板读取状态:%u",_liveplayerBoard.loadState);
        NSLog(@"白板播放状态:%u",_liveplayerBoard.playbackState);
        NSLog(@"摄像头读取状态:%u",_liveplayerTeacher.loadState);
        NSLog(@"摄像头播放状态:%u",_liveplayerTeacher.playbackState);
        
        //如果正常直播但是播放不正常,就直接加载一次 然后播放,或者继续播放
        
        if (_liveplayerBoard!=nil) {
            if (_liveplayerBoard.isPlaying == YES) {
            }else{
                [self setupBoardPlayer];
                [_boardPlayerView makePlaceHolderImage:nil];
                [_liveplayerBoard shouldAutoplay];
                
            }
        }else{
            [self setupBoardPlayer];
            [_boardPlayerView makePlaceHolderImage:nil];
            [_liveplayerBoard shouldAutoplay];
        }
        
        if (_liveplayerTeacher!=nil) {
            if (_liveplayerTeacher.isPlaying ==YES) {
            }else{
                [self setupTeacherPlayer];
                [_teacherPlayerView makePlaceHolderImage:nil];
                [_liveplayerTeacher shouldAutoplay];
                
            }
        }else{
            [self setupTeacherPlayer];
            [_teacherPlayerView makePlaceHolderImage:nil];
            [_liveplayerTeacher shouldAutoplay];
            
        }
        
        
        if (_liveplayerBoard.playbackState != NELPMoviePlaybackStatePlaying) {
            [self playVideo:_liveplayerBoard];
        }
        if (_liveplayerTeacher.playbackState != NELPMoviePlaybackStatePlaying){
            
            [self playVideo:_liveplayerTeacher];
        }
        
        _fileNameString = statusDic[@"name"];
        if ([_fileName.text isEqualToString:_fileNameString]) {
            
        }else{
            _fileName.text = _fileNameString==nil?@"暂无直播":_fileNameString;
        }
        
        
    }else if ([statusDic[@"board"]isEqualToString:@"0"]&&[statusDic[@"camera"]isEqualToString:@"0"]){
        //都成了初始状态了
        if (_liveplayerBoard!=nil) {
            [_liveplayerBoard stop];
        }
        [_boardPlayerView makePlaceHolderImage:[UIImage imageNamed:@"video_Playerholder"]];
        
        if (_liveplayerTeacher!=nil) {
            [_liveplayerTeacher stop];
        }
        [_teacherPlayerView makePlaceHolderImage:[UIImage imageNamed:@"video_Playerholder"]];
        
        
        _fileNameString = @"暂无直播";
        if ([_fileName.text isEqualToString:_fileNameString]) {
            
        }else{
            _fileName.text = @"暂无直播";
        }
        
    }else if ([statusDic[@"board"]isEqualToString:@"2"]&&[statusDic[@"camera"]isEqualToString:@"2"]){
        
        alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"直播结束" preferredStyle:UIAlertControllerStyleAlert];
        action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            if (self.presentingViewController) {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }}];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        
        //两个都成了关闭状态了
        if (_liveplayerBoard!=nil) {
            [_liveplayerBoard shutdown];
            [_liveplayerBoard.view removeFromSuperview];
            _liveplayerBoard = nil;
        }
        [_boardPlayerView makePlaceHolderImage:[UIImage imageNamed:@"video_ClosedVideo"]];
        
        if (_liveplayerTeacher!=nil) {
            [_liveplayerTeacher shutdown];
            [_liveplayerTeacher.view removeFromSuperview];
            _liveplayerTeacher = nil;
        }
        [_teacherPlayerView makePlaceHolderImage:[UIImage imageNamed:@"video_ClosedVideo"]];
        
        _fileNameString = @"暂无直播";
        if ([_fileName.text isEqualToString:_fileNameString]) {
            
        }else{
            _fileName.text = @"暂无直播";
        }
        
    }
    else{
        
        //其他的状态吧
        
        /**
         测试 5s一次 正常值30s一次
         继续轮询该接口
         @param checkVideoStatus
         @return void
         */
        
        
        //白板的各种状态
        if ([statusDic[@"board"]isEqualToString:@"0"]) {
            //白板未开启
            if (_liveplayerBoard!=nil) {
                [_liveplayerBoard stop];
            }
            [_boardPlayerView makePlaceHolderImage:[UIImage imageNamed:@"video_Playerholder"]];
        }else if ([statusDic[@"board"]isEqualToString:@"1"]){
            //白板正常直播
            if (_liveplayerBoard==nil) {
                [self setupBoardPlayer];
            }
            [_liveplayerBoard play];
            if (_liveplayerBoard.playbackState != NELPMoviePlaybackStatePlaying) {
                [self playVideo:_liveplayerBoard];
            }
        }else if ([statusDic[@"board"]isEqualToString:@"2"]){
            //直播已经结束了
            if (_liveplayerBoard!=nil) {
                [_liveplayerBoard stop];
            }
            [_boardPlayerView makePlaceHolderImage:[UIImage imageNamed:@"video_ClosedVideo"]];
        }
        
        //摄像头的各种状态
        if ([statusDic[@"camera"]isEqualToString:@"0"]) {
            //摄像头未开启
            if (_liveplayerTeacher!=nil) {
                [_liveplayerTeacher stop];
            }
            [_teacherPlayerView makePlaceHolderImage:[UIImage imageNamed:@"video_Playerholder"]];
            
        }else if ([statusDic[@"camera"]isEqualToString:@"0"]){
            //白板正常直播
            if (_liveplayerTeacher==nil) {
                [self setupTeacherPlayer];
            }
            [_liveplayerTeacher play];
            if (_liveplayerTeacher.playbackState != NELPMoviePlaybackStatePlaying) {
                [self playVideo:_liveplayerTeacher];
            }
        }else if ([statusDic[@"camera"]isEqualToString:@"2"]){
            //直播已经结束了
            if (_liveplayerTeacher!=nil) {
                [_liveplayerTeacher stop];
            }
            [_teacherPlayerView makePlaceHolderImage:[UIImage imageNamed:@"video_ClosedVideo"]];
            
        }
        
        _fileNameString = statusDic[@"name"];
        if ([_fileName.text isEqualToString:_fileNameString]) {
            
        }else{
            _fileName.text = _fileNameString==nil?@"暂无直播":_fileNameString;
        }
        
    }
    
}


/**
 根据轮询数据查询在线观看人数
 
 @param memberArray 在线成员ID数组
 */
- (void)switchOnlineNumbersWithArrayrs:(NSArray *)memberArray{
    
    NSLog(@"获取在线人数成功,当前在线人数:%ld",[memberArray count]);
    //在线人数
    _onLineNumber.text = [NSString stringWithFormat:@"%ld", [memberArray count]];
    
}


/* 播放器播放方法*/
- (void)playVideo:(NELivePlayerController <NELivePlayer> *)liveplayer{
    
    NSLog(@"尝试播放暂停的播放器");
    [liveplayer play];
    
}

/* 应用程序进入后台*/
- (void)applicationDidEnterBackground{
    
    [_liveplayerBoard pause];
    [_liveplayerTeacher pause];
    
    
}

/* 应用程序进入前台*/
- (void) applicationDidBecomeActive{
    
    [_liveplayerBoard play];
    [_liveplayerTeacher play];
    
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_inputView.inputView resignFirstResponder];
    [_inputView changeSendBtnWithPhoto:YES];
    
    [self.view endEditing:YES];
    
}



/**浏览大图*/
-(void)showImage:(UIImageView *)imageView andImage:(UIImage *)image{
    
    NSMutableArray *items = @[].mutableCopy;
    KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView image:image];
    [items addObject:item];
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:0];
    [browser showFromViewController:self];
    
}

/** 返回上一页 */
- (void)returnLastPage{
    
    
    /* 防止内存泄漏,移除所有监听*/
    @try {
        [_boardPlayerView removeObserver:self forKeyPath:@"canMove" ];
        [_teacherPlayerView removeObserver:self forKeyPath:@"canMove" ];
        [self removeObserver:self forKeyPath:@"headerHeight"];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    @try {
        [self.liveplayerBoard shutdown]; //退出播放并释放相关资源
        [self.liveplayerBoard.view removeFromSuperview];
        self.liveplayerBoard = nil;
        
        [self.liveplayerTeacher shutdown]; //退出播放并释放相关资源
        [self.liveplayerTeacher.view removeFromSuperview];
        self.liveplayerTeacher = nil;
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    @try {
        /* 取消老师播放器的监听*/
        [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerDidPreparedToPlayNotification object:_liveplayerTeacher];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerLoadStateChangedNotification object:_liveplayerTeacher];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerPlaybackFinishedNotification object:_liveplayerTeacher];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerFirstVideoDisplayedNotification object:_liveplayerTeacher];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerFirstAudioDisplayedNotification object:_liveplayerTeacher];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerVideoParseErrorNotification object:_liveplayerTeacher];
        
        /* 取消白板播放器的监听*/
        [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerDidPreparedToPlayNotification object:_liveplayerBoard];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerLoadStateChangedNotification object:_liveplayerBoard];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerPlaybackFinishedNotification object:_liveplayerBoard];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerFirstVideoDisplayedNotification object:_liveplayerBoard];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerFirstAudioDisplayedNotification object:_liveplayerBoard];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerVideoParseErrorNotification object:_liveplayerBoard];
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    /* 避免内存泄漏,弹幕必须调用stop方法*/
    [_aBarrage stop];
    _aBarrage = nil;
    
    /* 取消全屏支持*/
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"SupportedLandscape"];
    
    [self.navigationController popViewControllerAnimated:YES];
}


/* 把弹幕给释放掉*/
-(void)dealloc{
    
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == _mainView.scrollView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        [_mainView.segmentControl setSelectedSegmentIndex:page animated:YES];
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
