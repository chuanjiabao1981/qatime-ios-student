//
//  LivePlayerViewController.m
//  NELivePlayerDemo
//
//  Created by NetEase on 15-10-10.
//  Copyright (c) 2015年 netease. All rights reserved.
//

#import "LivePlayerViewController.h"
#import "NELivePlayerControl.h"

#import "NavigationBar.h"

#import <MediaPlayer/MediaPlayer.h>

#import "VideoClassInfo.h"
#import "YYModel.h"
#import "NoticeAndMembers.h"
#import "Notice.h"
#import "Members.h"
#import "NoticeTableViewCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "ClassesListTableViewCell.h"
#import "ClassList.h"
#import "Teacher.h"
#import "Chat_Account.h"
#import "Classes.h"
#import "UIImageView+WebCache.h"
#import "UUInputFunctionView.h"
#import "MJRefresh.h"
#import "UUMessageCell.h"
#import "ChatModel.h"
#import "UUMessageFrame.h"
#import "UUMessage.h"
#import <NIMSDK/NIMSDK.h>
#import "FJFloatingView.h"
#import "BarrageRenderer.h"
#import "ClassNotice.h"

#import "UIControl+RemoveTarget.h"
#import "pinyin.h"
#import "ChineseString.h"
#import "MemberListTableViewCell.h"
#import "NSString+UTF8Coding.h"
#import "NSString+ContainEmoji.h"
//#import "YZInputView.h"
#import "UITextView+YZEmotion.h"
#import "YYTextView+YZEmotion.h"
#import "YZTextAttachment.h"
#import "NSString+TimeStamp.h"

#import "NSAttributedString+EmojiExtension.h"

#import "NSString+YYAdd.h"
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

//#import "ZFPlayer.h"
#import "VideoPlayerViewController.h"
#import "YYTextLayout.h"

#import <AVFoundation/AVFoundation.h>

#import "CYLTableViewPlaceHolder.h"
#import "HaveNoClassView.h"

#define APP_WIDTH self.view.frame.size.width
#define APP_HEIGHT self.view.frame.size.height

#define DefaultTimeInterval 0.2

typedef enum : NSUInteger {
    /**平级视图*/
    SameLevel,
    /**分级视图*/
    DifferentLevel,
    
} ViewsArrangementMode;

@interface LivePlayerViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UUInputFunctionViewDelegate,UUMessageCellDelegate,NIMLoginManager,NIMChatManagerDelegate,NIMConversationManagerDelegate,NIMConversationManager,UITextViewDelegate,NIMChatroomManagerDelegate,NIMLoginManagerDelegate,TTGTextTagCollectionViewDelegate>{
    
    /* token/id*/
    
    NSString *_token;
    NSString *_idNumber;
    
    /* 课程model*/
    VideoClassInfo *_videoClassInfo;
    
    /* 通知消息model*/
    NoticeAndMembers *_noticeAndMembers;
    
    /* 保存该页的课程信息的字典*/
    NSMutableDictionary *_classInfoDic;
    
    /*消息model*/
    Notice *_notices;
    /* 存放消息的数组*/
    NSMutableArray  <Notice *>*_noticesArr;
    
    /* 成员model*/
    Members *_members;
    /* 存放member的数组*/
    NSMutableArray <Members *>*_membersArr;
    /* 存放membersName的数组*/
    NSMutableArray <NSString *>*membersName;
    
    /* 标签图的config*/
    TTGTextTagConfig *_config;
    
    /* 课程 model*/
    Classes *_classes;
    
    /* 保存课程model的数组*/
    NSMutableArray *_classesArr;
    
    /* teacher model*/
    Teacher *_teacher;
    
    /* 聊天账号信息model*/
    Chat_Account *_chat_Account;
    
    /* tableView的header高度*/
    
    CGFloat headerHeight;
    
    ClassList *_classList;
    
    
    /**课程通知图*/
    ClassNotice *_classNotice;
    
    /* 两个视频播放器的排列方式*/
    
    ViewsArrangementMode _viewsArrangementMode;
    
    /* 是否全屏*/
    BOOL isFullScreen;
    
    /* 全屏播放视频的聊天输入框*/
    //    UUInputFunctionView *_barrageText;
    /* 全屏播放视频的聊天发送按键*/
    //    UIButton *_makeABarage;
    
    /* 全屏模式下的刷新按钮*/
    UIButton *refresh_FS;
    
    /* 后台获取的直播状态存储字典*/
    NSDictionary *_statusDic;
    
    /* 状态循环*/
    NSRunLoop *_runLoop;
    
    /* 白板占位图*/
    UIImageView *_boardPlaceholderImage;
    /* 摄像头占位图*/
    UIImageView *_teacherPlaceholderImage;
    
    /* 全屏模式下,双击小窗口切换视频的手势*/
    UITapGestureRecognizer *_doubelTap;
    
    
    /* 切换横竖屏 使用的scrollview的contentsize*/
    CGSize scrollContentSize;
    
    
#pragma mark- 聊天视图
    
    /* 聊天消息会话*/
    
    //构造会话
    NIMSession *_session ;
    
    /* 输入框*/
    UUInputFunctionView *IFView;
    
    /* 临时变量 — 存储搜索出来的用户头像url*/
    NSString *_iconURL;
    
    /* 临时变量  保存所有的用户信息 view4的数组*/
    
    NSMutableArray <Chat_Account *>*_chatList;
    
    /* 所有的聊天表情*/
    NSMutableArray *_faces;
    
    
    /* 聊天框点击和出现次数*/
    NSInteger chatTime;
    
    /* 按钮点击间隔时间*/
    NSTimeInterval timeInterval;
    
    
    
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


#pragma mark- 聊天部分的属性

/**
 刷新聊天记录
 */
@property (strong, nonatomic) MJRefreshHeader *head;


/**
 保存聊天信息的model
 */
@property (strong, nonatomic) ChatModel *chatModel;


/**
 聊天页面
 */
@property(nonatomic,strong) UITableView *chatTableView ;


/**
 表情键盘->与web和安卓统一
 */
@property (strong, nonatomic) YZEmotionKeyboard *emotionKeyboard;


#pragma mark- 用户名排序的部分属性
/* 在线聊天成员姓名排序所需的属性*/

/**
 引导列的保存数组
 */
@property(nonatomic,strong)NSMutableArray *indexArray;


/**
 姓名排列序
 */
@property(nonatomic,strong)NSMutableArray *letterResultArr;


/**
 section的展示框
 */
@property (nonatomic, strong) UILabel *sectionTitleView;


/**
 计时器
 */
//@property (nonatomic, strong) NSTimer *timer;


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

@implementation LivePlayerViewController

CGFloat screenWidth;
CGFloat screenHeight;
bool isHardware = YES;
bool ismute     = NO;

#pragma mark- controller的初始化方法

/**
 初始化器1
 
 @param classID 课程id
 @return 返回初始化实例
 */
-(instancetype)initWithClassID:(NSString *)classID{
    self = [super init];
    if (self) {
        
        _classID = [NSString stringWithFormat:@"%@",classID];
        
        boardFaildTimes = 0;
        teacherFaildTimes = 0;
        
    }
    return self;
}


/**
 初始化器2
 
 @param classID 课程id
 @param boardPullAddress 白板拉流地址
 @param teacherPullAddress 教师摄像头拉流地址
 @return 返回初始化实例
 */
-(instancetype)initWithClassID:(NSString *)classID andBoardPullAddress:(NSURL *)boardPullAddress andTeacherPullAddress:(NSURL *)teacherPullAddress{
    self = [super init];
    if (self) {
        
        _boardPullAddress = boardPullAddress;
        _teacherPullAddress = teacherPullAddress;
        
        _classID =[NSString stringWithFormat:@"%@",classID];
        
        boardFaildTimes = 0;
        teacherFaildTimes = 0;
        
    }
    return self;
    
}

- (void)loadView {
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    //当前屏幕宽高
    screenWidth  = CGRectGetWidth([UIScreen mainScreen].bounds);
    screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    
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

#pragma mark- 播放器的布局和初始化方法
- (void)setupVideoPlayer{
    
    /* 白板播放器view*/
    _boardPlayerView = ({
        
        FJFloatingView *_ =[[FJFloatingView alloc]init];
        _.backgroundColor = [UIColor grayColor];
        //        _.alpha = 0.4;
        [self.view addSubview:_];
        _.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .topSpaceToView(self.view,0)
        .autoHeightRatio(9/16.0);
        _boardPlayerView.tag = 0;
        
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
        _.backgroundColor = [UIColor grayColor];
        _.sd_layout
        .leftEqualToView(_boardPlayerView)
        .rightEqualToView(_boardPlayerView)
        .topSpaceToView(_boardPlayerView,0)
        .autoHeightRatio(9/16.0);
        _teacherPlayerView.tag = 1;
        
        /* 老师播放器不可移动*/
        _.canMove = NO;
        [_ removeGestureRecognizer:_teacherPlayerView.pan];
        _.layer.borderWidth = 0.6f;
        _.layer.borderColor = [UIColor grayColor].CGColor;
        
        /* 老师播放器为主要播放器*/
        _.becomeMainPlayer=NO;
        _;
        
    });
    
    /* 两个占位图*/
    /* 白板占位图*/
    _boardPlaceholderImage =({
        UIImageView *_= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PlayerHolder"]];
        [_boardPlayerView addSubview:_];
        _.sd_layout
        .leftEqualToView(_boardPlayerView)
        .rightEqualToView(_boardPlayerView)
        .topEqualToView(_boardPlayerView)
        .bottomEqualToView(_boardPlayerView);
        _;
        
    });
    
    /* 摄像头占位图*/
    _teacherPlaceholderImage = ({
        
        UIImageView *_=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PlayerHolder"]];
        [_teacherPlayerView addSubview:_];
        _.sd_layout
        .leftEqualToView(_teacherPlayerView)
        .rightEqualToView(_teacherPlayerView)
        .topEqualToView(_teacherPlayerView)
        .bottomEqualToView(_teacherPlayerView);
        
        _;
    });
    
    
}

/* 初始化播放器*/

/* 白板播放器初始化*/
- (void)setupBoardPlayer{
    
    /* 白板的 播放器*/
    _liveplayerBoard = ({
        
        NELivePlayerController *_= [[NELivePlayerController alloc] initWithContentURL:_boardPullAddress];
        
        _.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [_ setScalingMode:NELPMovieScalingModeAspectFit];
        if (_ == nil) {
            // 返回空则表示初始化失败
            //            NSLog(@"player initilize failed, please tay again!");
            boardFaildTimes++;
            NSLog(@"白板播放器初始化失败!!!!");
            [_ shutdown];
            
            if (boardFaildTimes>=10) {
                
            }else{
                
                [self setupBoardPlayer];
            }
            
            
        }else{
            
            NSLog(@"白板播放器初始化成功!!!!");
            //            [self setupTeacherPlayer];
            boardPlayerInitSuccess = YES;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"BoardPlayerInitSuccess" object:nil];
            [_boardPlayerView addSubview:_.view];
            _.view.sd_layout
            .leftEqualToView(_boardPlayerView)
            .rightEqualToView(_boardPlayerView)
            .topEqualToView(_boardPlayerView)
            .bottomEqualToView(_boardPlayerView);
            
        }
        
        /* 白板播放器的设置*/
        [_ isLogToFile:YES];
        [_ setBufferStrategy:NELPLowDelay]; //直播低延时模式
        [_ setScalingMode:NELPMovieScalingModeAspectFit]; //设置画面显示模式，默认原始大小
        [_ setShouldAutoplay:YES]; //设置prepareToPlay完成后是否自动播放
        [_ setHardwareDecoder:isHardware]; //设置解码模式，是否开启硬件解码
        [_ setPauseInBackground:NO]; //设置切入后台时的状态，暂停还是继续播放
        [_ prepareToPlay]; //初始化视频文件
        
        _;
    });
    
}

/* 老师播放器初始化*/
- (void)setupTeacherPlayer{
    
    /* 老师摄像头的 播放器*/
    _liveplayerTeacher = ({
        NELivePlayerController *_= [[NELivePlayerController alloc] initWithContentURL:_teacherPullAddress];
        
        _.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [_ setScalingMode:NELPMovieScalingModeAspectFit];
        if (_ == nil) {
            // 返回空则表示初始化失败
            //            NSLog(@"player initilize failed, please tay again!");
            teacherFaildTimes++;
            NSLog(@"摄像头播放器初始化失败!!!!");
            [_ shutdown];
            
            if (teacherFaildTimes>=10) {
                
            }else{
                [self setupTeacherPlayer];
                
            }
        }else{
            
            NSLog(@"摄像头播放器初始化成功!!!!");
            teacherPlayerInitSuccess = YES;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"TeacherPlayerInitSuccess" object:nil];
            [_teacherPlayerView addSubview:_.view];
            _.view.sd_layout
            .leftEqualToView(_teacherPlayerView)
            .rightEqualToView(_teacherPlayerView)
            .topEqualToView(_teacherPlayerView)
            .bottomEqualToView(_teacherPlayerView);
        }
        
        [_ isLogToFile:YES];
        
        /* 教师播放器的设置*/
        [_ setBufferStrategy:NELPLowDelay]; //直播低延时模式
        [_ setScalingMode:NELPMovieScalingModeAspectFit]; //设置画面显示模式，默认原始大小
        [_ setShouldAutoplay:YES]; //设置prepareToPlay完成后是否自动播放
        [_ setHardwareDecoder:isHardware]; //设置解码模式，是否开启硬件解码
        [_ setPauseInBackground:NO]; //设置切入后台时的状态，暂停还是继续播放
        [_ prepareToPlay]; //初始化视频文件
        
        _;
    });
    
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
        //    [_playBtn addTarget:self action:@selector(onClickPlay:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomControlView addSubview:_];
        _.sd_layout
        .leftSpaceToView(_bottomControlView,0)
        .centerYEqualToView(_bottomControlView)
        .topSpaceToView(_bottomControlView,0)
        .bottomSpaceToView(_bottomControlView,0)
        .widthEqualToHeight();
        _.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
        [_ setEnlargeEdge:10];
        _;
    });
    
    //暂停按钮
    _pauseBtn = ({
        UIButton *_= [UIButton buttonWithType:UIButtonTypeCustom];
        [_ setImage:[UIImage imageNamed:@"btn_player_play"] forState:UIControlStateNormal];
        
        _.alpha = 0.8;
        //    [_pauseBtn addTarget:self action:@selector(onClickPause:) forControlEvents:UIControlEventTouchUpInside];
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
    [self performSelector:@selector(setupTeacherPlayer) withObject:nil afterDelay:0.3];
    //    [self setupTeacherPlayer];
    
    
    
    
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
    [_aBarrage start];
    
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
        
        [_boardPlayerView bringSubviewToFront:_aBarrage.view];
        
        _aBarrage.view.hidden = NO;
        [_aBarrage start];
        
        [self mediaControlTurnToFullScreenModeWithMainView:_boardPlayerView];
        
        [self makeFloatingPlayer:_teacherPlayerView];
        
    }else if (_teacherPlayerView.becomeMainPlayer == YES){
        
        [_teacherPlayerView addSubview:_aBarrage.view];
        
        _aBarrage.view.sd_layout
        .leftEqualToView(_teacherPlayerView)
        .rightEqualToView(_teacherPlayerView)
        .topEqualToView(_teacherPlayerView)
        .bottomEqualToView(_teacherPlayerView);
        [_teacherPlayerView bringSubviewToFront:_aBarrage.view];
        //        [_aBarrage start];
        _aBarrage.view.hidden = NO;
        
        [self mediaControlTurnToFullScreenModeWithMainView:_teacherPlayerView];
        
        [self makeFloatingPlayer:_boardPlayerView];
    }
    
    
    /* 全屏页面布局的变化*/
    
    refresh_FS .hidden = NO;
    _scaleModeBtn.hidden = YES;
    _tileScreen.hidden =YES;
    IFView.btnChangeVoiceState.hidden = YES;
    [IFView changeSendBtnWithPhoto:NO];
    IFView.canNotSendImage = YES;
    
    
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
    [_aBarrage start];
    
    /* 如果是在平级视图*/
    if (_viewsArrangementMode == SameLevel) {
        
        [_teacherPlayerView addSubview:_aBarrage.view];
        _aBarrage.view.sd_layout
        .leftEqualToView(_teacherPlayerView)
        .rightEqualToView(_teacherPlayerView)
        .topEqualToView(_teacherPlayerView)
        .bottomEqualToView(_teacherPlayerView);
        
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
    [_videoInfoView updateLayout];
    [_videoInfoView.scrollView updateLayout];
    
    
    
    [self.videoInfoView.scrollView scrollRectToVisible:CGRectMake(self.videoInfoView.segmentControl.selectedSegmentIndex * self.view.width_sd, 0, self.view.width_sd, self.view.height_sd-64-49) animated:NO];
    
    //    if (isFullScreen == NO) {
    //
    //        typeof(self) __weak weakSelf = self;
    //        [_videoInfoView.segmentControl setIndexChangeBlock:^(NSInteger index) {
    //            NSLog(@"%ld", (long)index);
    //
    //            [weakSelf.videoInfoView.scrollView scrollRectToVisible:CGRectMake(self.view.width_sd * index, 0, weakSelf.view.width_sd, weakSelf.view.height_sd-64-49) animated:YES];
    //        }];
    //    }
    
    
    
    
}

/* 控制层变成全屏模式的方法*/
- (void)mediaControlTurnToFullScreenModeWithMainView:(FJFloatingView *)playerView{
    
    [self.view bringSubviewToFront:_mediaControl];
    
    _mediaControl.hidden  = NO;
    _fileName.hidden = NO;
    
    _topControlView.backgroundColor = [UIColor blackColor];
    _topControlView.alpha = 0.8;
    
    _bottomControlView.backgroundColor = [UIColor blackColor];
    _bottomControlView.alpha = 0.8;
    
    [_mediaControl clearAutoHeigtSettings];
    
    _mediaControl.sd_resetLayout
    .topEqualToView(playerView)
    .bottomEqualToView(playerView)
    .leftEqualToView(playerView)
    .rightEqualToView(playerView);
    [_mediaControl updateLayout];
    
    /* 控制层上加输入框*/
    [IFView removeFromSuperview];
    [_bottomControlView addSubview:IFView];
    [IFView sd_clearAutoLayoutSettings];
    
    IFView.backgroundColor = [UIColor clearColor];
    [IFView clearAutoHeigtSettings];
    
    IFView.sd_layout
    .leftSpaceToView(refresh_FS,0)
    .topSpaceToView(_bottomControlView,5)
    .bottomSpaceToView(_bottomControlView,-5)
    .rightSpaceToView(_barrage,0);
    
    [IFView updateLayout];
    
    /* 语音输入按钮隐藏*/
    IFView.voiceSwitchTextButton.hidden = YES;
    
    
}

/* 控制层切回竖屏模式的方法*/
- (void)mediaControlTurnDownFullScreenModeWithMainView:(FJFloatingView *)playerView{
    
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
    IFView.btnChangeVoiceState.hidden = NO;
    
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
    
    
    /* 聊天输入框变化*/
    [IFView removeFromSuperview];
    [_videoInfoView.view2 addSubview:IFView];
    
    IFView.backgroundColor = [UIColor whiteColor];
    [IFView changeSendBtnWithPhoto:YES];
    IFView.canNotSendImage = NO;
    
    [IFView sd_clearAutoLayoutSettings];
    IFView.sd_layout
    .leftEqualToView(_videoInfoView.view2)
    .rightEqualToView(_videoInfoView.view2)
    .bottomSpaceToView(_videoInfoView.view2,0)
    .heightIs(46);
    
    /* 语音输入按钮显示*/
    IFView.voiceSwitchTextButton.hidden = NO;
    
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
    
    _videoInfoView.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*4, [UIScreen mainScreen].bounds.size.height -  [UIScreen mainScreen].bounds.size.width*9/16.0f-30-4-40);
    
    
    
}

/* infoview的contentsize变小*/
- (void)changInfoViewContentSizeToSmall{
    
    _videoInfoView.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*4, [UIScreen mainScreen].bounds.size.height -  [UIScreen mainScreen].bounds.size.width*9/16.0f*2-30-4-40);
    
    
}

#pragma mark- 切换屏顺序点击事件
- (void)switchBothScreen:(id)sender{
    
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
        
        _boardPlayerView.sd_resetLayout
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
    
    [playerView sd_clearAutoLayoutSettings];
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
        if (_viewsArrangementMode == SameLevel) {
            playerView.sd_layout
            .topSpaceToView(self.view,0)
            .leftEqualToView(self.view)
            .widthRatioToView(self.view,2/5.0f)
            .autoHeightRatio(9/16.0);
            
        }else if (_viewsArrangementMode == DifferentLevel){
            
            playerView.sd_layout
            .topSpaceToView(self.view,0)
            .leftEqualToView(self.view)
            .widthRatioToView(self.view,2/5.0f)
            .autoHeightRatio(9/16.0);
            
            //            /* 如果是白板变小,那么尺寸要变成摄像头当前的尺寸*/
            //            if (playerView == _boardPlayerView) {
            //                playerView.sd_layout
            //                .leftEqualToView(_teacherPlayerView)
            //                .rightEqualToView(_teacherPlayerView)
            //                .topEqualToView(_teacherPlayerView)
            //                .bottomEqualToView(_teacherPlayerView);
            //            }
            //
            //
            //            if (playerView == _teacherPlayerView) {
            //                playerView.sd_layout
            //                .leftEqualToView(_boardPlayerView)
            //                .rightEqualToView(_boardPlayerView)
            //                .topEqualToView(_boardPlayerView)
            //                .bottomEqualToView(_boardPlayerView);
            //            }
        }
    }else{
        /* 在全屏视图下*/
        
        playerView.sd_layout
        .topSpaceToView(self.view,0)
        .leftEqualToView(self.view)
        .widthRatioToView(self.view,2/5.0f)
        .autoHeightRatio(9/16.0);
        
        
    }
    
    
    _chatTableView.sd_layout
    .bottomSpaceToView(_videoInfoView.view2,46);
    [_chatTableView updateLayout];
    
    /* 把可移动的这个视图放到self.view的最上层*/
    [self.view bringSubviewToFront:playerView];
    
}

/* 改变infoview的top和位置*/
- (void)changInfoViewsWithTopView:(FJFloatingView *)playerView{
    
    [_videoInfoView sd_clearAutoLayoutSettings];
    dispatch_queue_t floatview = dispatch_queue_create("floatview", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(floatview, ^{
        
        _videoInfoView.sd_layout
        .topSpaceToView(playerView,0)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomEqualToView(self.view);
        
        [_videoInfoView updateLayout];
        
    });
    
    
}

#pragma mark- 隐藏segment和滑动视图
- (void)hideSegementAndScrollViews{
    
    _videoInfoView.segmentControl.hidden = YES;
    _videoInfoView.scrollView.hidden = YES;
    
}

#pragma mark- 显示segment和滑动视图
- (void)showSegmentAndScrollViews{
    
    _videoInfoView.segmentControl.hidden = NO;
    _videoInfoView.scrollView.hidden = NO;
    
    [_videoInfoView.segmentControl updateLayout];
    [_videoInfoView.scrollView updateLayout];
    _videoInfoView.scrollView.contentSize = CGSizeMake(self.view.width_sd*4, _videoInfoView.scrollView.height_sd);
    
    
}


/* 变成横屏*/
- (void)turnToFullScreenMode:(FJFloatingView *)playerView{
    
    playerView.becomeMainPlayer = YES;
    playerView.canMove = NO;
    
    [_mediaControl addTarget:self action:@selector(onClickMediaControl:) forControlEvents:UIControlEventTouchUpInside];
    [_controlOverlay addTarget:self action:@selector(onClickOverlay:) forControlEvents:UIControlEventTouchUpInside];
    
    [playerView sd_clearAutoLayoutSettings];
    playerView.sd_layout
    .topEqualToView(self.view)
    .bottomEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view);
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    NSLog(@"Version = %@", [self.liveplayerTeacher getSDKVersion]);
    
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    
}

- (BOOL)prefersStatusBarHidden{
    
    return YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
    
    [self.liveplayerBoard shutdown]; //退出播放并释放相关资源
    [self.liveplayerBoard.view removeFromSuperview];
    self.liveplayerBoard = nil;
    
    [self.liveplayerTeacher shutdown]; //退出播放并释放相关资源
    [self.liveplayerTeacher.view removeFromSuperview];
    self.liveplayerTeacher = nil;
    
    
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
    
    //    /* 监听白板播放端是否可以移动*/
    //    [_boardPlayerView addObserver:self forKeyPath:@"canMove" options:NSKeyValueObservingOptionNew context:nil];
    //
    //    /* 监听老师播放端是否可以移动*/
    //    [_teacherPlayerView addObserver:self forKeyPath:@"canMove" options:NSKeyValueObservingOptionNew context:nil];
    
    
    /* 避免内存泄漏,弹幕必须调用stop方法*/
    [_aBarrage stop];
    _aBarrage = nil;
    
    /* 取消全屏支持*/
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"SupportedLandscape"];
    
}

//支持设备自动旋转

//  是否支持自动转屏
- (BOOL)shouldAutorotate
{
    
    return YES;
}

// 支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
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
        int val                  = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    
}


- (void)onDeviceOrientationChange{
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown || orientation == UIDeviceOrientationPortraitUpsideDown) { return; }
    
    
    [self.view layoutIfNeeded];
}




//全屏播放视频后，播放器的适配和全屏旋转
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    /* 切换到竖屏*/
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        [_aBarrage stop];
        self.view.backgroundColor = [UIColor blackColor];
        [self.scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale01"] forState:UIControlStateNormal];
        self.scaleModeBtn.titleLabel.tag = 0;
        
        //谁是主视图，谁就恢复到主屏
        if (_boardPlayerView.becomeMainPlayer == YES) {
            [self makeFirstPlayer:_boardPlayerView];
            [self changInfoViewsWithTopView:_boardPlayerView];
            
            _maskView.hidden = YES;
            
            if (_viewsArrangementMode == SameLevel) {
                
                [self makeFloatingPlayer:_teacherPlayerView];
                [self changInfoViewContentSizeToSmall];
                
                
            }if (_viewsArrangementMode == DifferentLevel){
                
                [self makeFloatingPlayer:_teacherPlayerView];
                [self changInfoViewContentSizeToBig];
            }
            
        }else if(_teacherPlayerView.becomeMainPlayer == YES){
            //            [self.view addSubview:_teacherPlayerView];
            //            [self.view addSubview:_boardPlayerView];
            
            [self makeFirstPlayer:_teacherPlayerView];
            [self changInfoViewsWithTopView:_teacherPlayerView];
            [self changInfoViewContentSizeToBig];
            
            _maskView.hidden = YES;
            if (_viewsArrangementMode == SameLevel) {
                //                [self makeSecondPlayer:_boardPlayerView];
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
    
    /* 切换到横屏*/
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        
        [_aBarrage stop];
        self.view.backgroundColor = [UIColor blackColor];
        [self.scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale02"] forState:UIControlStateNormal];
        self.scaleModeBtn.titleLabel.tag = 1;
        
        
        //谁是主视图，谁就全屏
        if (_boardPlayerView.becomeMainPlayer == YES) {
            
            [self.view sendSubviewToBack:_videoInfoView];
            [self turnToFullScreenMode:_boardPlayerView];
            [_teacherPlayerView addGestureRecognizer:_doubelTap];
            
            [_boardPlayerView updateLayout];
            [_teacherPlayerView updateLayout];
            
        }else if(_teacherPlayerView.becomeMainPlayer == YES){
            [self.view sendSubviewToBack:_videoInfoView];
            [self turnToFullScreenMode:_teacherPlayerView];
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

#pragma mark - 播放器的播放/停止/退出等方法

//退出播放
- (void)onClickBack:(id)sender{
    /* 非屏状态下的点击事件*/
    if (isFullScreen == NO) {
        
        [self.navigationController popViewControllerAnimated:YES];
        //
        
        NSLog(@"click back!");
        [self syncUIStatus:YES];
        if (self.presentingViewController) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
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
    
    [IFView.TextViewInput resignFirstResponder];
    //    [_barrageText.TextViewInput resignFirstResponder];
    [IFView changeSendBtnWithPhoto:YES];
}

/* 控制层点击事件*/
- (void)onClickMediaControl:(id)sender{
    NSLog(@"click mediacontrol");
    [self controlOverlayShow];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlOverlayHide) object:nil];
    [self syncUIStatus:NO];
    [self performSelector:@selector(controlOverlayHide) withObject:nil afterDelay:5];
    self.controlOverlay.alpha = 1.0;
    [IFView.TextViewInput resignFirstResponder];
    [IFView changeSendBtnWithPhoto:YES];
    
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
        
        
    }else if (livePlayer == _liveplayerTeacher){
        NSLog(@"摄像头播放器准备开始播放.");
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
    
    UIAlertController *alertController = NULL;
    UIAlertAction *action = NULL;
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
            
            [self performSelector:@selector(checkVideoStatus) withObject:nil afterDelay:30];
            
            
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
            
            alertController = [UIAlertController alertControllerWithTitle:@"注意" message:[NSString stringWithFormat:@"%@播放失败",player] preferredStyle:UIAlertControllerStyleAlert];
            action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self checkVideoStatus];
                
            }];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
            
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
    // Do any additional setup after loading the view, typically from a nib.
    
    /* TabBar单例隐藏*/
    
    
    _videoInfoView.segmentControl.selectedSegmentIndex = 1;
    
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
    
    
#pragma mark- 加载课程数据请求
    /* 根据token和传来的id 发送课程内容请求。*/
    
    [self requestClassInfo];
    
#pragma mark- 以下是页面和功能逻辑
    
    
#pragma mark- 课程信息视图
    
    _videoInfoView = [[VideoInfoView alloc]init];
    [self.view addSubview:_videoInfoView];
    
    _videoInfoView.frame = CGRectMake(0,self.view.width_sd*9/16*2, self.view.width_sd, self.view.height_sd-_teacherPlayerView.height_sd-_boardPlayerView.height_sd);
    
    _videoInfoView.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*4, [UIScreen mainScreen].bounds.size.height -  [UIScreen mainScreen].bounds.size.width*9/16.0f*2-30-4-20);
    
    if (isFullScreen == NO) {
        
        typeof(self) __weak weakSelf = self;
        [ _videoInfoView.segmentControl setIndexChangeBlock:^(NSInteger index) {
            NSLog(@"%ld", (long)index);
            [weakSelf.videoInfoView.scrollView scrollRectToVisible:CGRectMake(weakSelf.view.width_sd * index, 0, weakSelf.view.width_sd, weakSelf.view.height_sd-64-49) animated:YES];
        }];
    }
    
    _videoInfoView.scrollView.delegate = self;
    _videoInfoView.segmentControl.selectedSegmentIndex =0;
    _videoInfoView.segmentControl.selectionIndicatorHeight =2.0f;
    _videoInfoView.scrollView.bounces=NO;
    _videoInfoView.scrollView.alwaysBounceVertical=NO;
    _videoInfoView.scrollView.alwaysBounceHorizontal=NO;
    
    [_videoInfoView.scrollView scrollRectToVisible:CGRectMake(-self.view.width_sd, 0, self.view.width_sd, self.view.height_sd) animated:YES];
    
    /**课程通知图*/
    _classNotice = [[ClassNotice alloc]init];
    [_videoInfoView.view1 addSubview:_classNotice];
    
    _classNotice.sd_layout
    .topEqualToView(_videoInfoView.view1)
    .leftEqualToView(_videoInfoView.view1)
    .rightEqualToView(_videoInfoView.view1)
    .bottomEqualToView(_videoInfoView.view1);
    _classNotice.classNotice.delegate = self;
    _classNotice.classNotice.dataSource = self;
    _classNotice.classNotice.tag = 20;
    
    _classList = [[ClassList alloc]init];
    [_videoInfoView.view3 addSubview:_classList];
    _classList.sd_layout
    .leftEqualToView(_videoInfoView.view3)
    .rightEqualToView(_videoInfoView.view3)
    .topEqualToView(_videoInfoView.view3)
    .bottomEqualToView(_videoInfoView.view3);
    
    _classList.classListTableView.delegate =self;
    _classList.classListTableView.dataSource =self;
    _classList.classListTableView.tag =2;
    
    
    //把聊天页面添加到view2上
    
    _chatTableView = [[UITableView alloc]init];
    _chatTableView.backgroundColor = [UIColor whiteColor];
    
    [_videoInfoView.view2 addSubview:_chatTableView];
    _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    _chatTableView.sd_layout
    .leftEqualToView(_videoInfoView.view2)
    .topEqualToView(_videoInfoView.view2)
    .rightEqualToView(_videoInfoView.view2)
    .bottomSpaceToView(_videoInfoView.view2,64);
    
    _chatTableView.delegate = self;
    _chatTableView.dataSource = self;
    _chatTableView.tag =3;
    UITapGestureRecognizer *tapSpace = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSpace)];
    [_chatTableView addGestureRecognizer:tapSpace];
    
    _infoHeaderView = [[InfoHeaderView alloc]initWithFrame:CGRectMake(0, 0, _videoInfoView.view3.frame.size.width, 800)];
    _infoHeaderView.classTagsView.delegate = self;
    
    //标签设置
    _config = [[TTGTextTagConfig alloc]init];
    _config.tagTextColor = TITLECOLOR;
    _config.tagBackgroundColor = [UIColor whiteColor];
    _config.tagBorderColor = [UIColor colorWithRed:0.88 green:0.60 blue:0.60 alpha:1.00];
    _config.tagShadowColor = [UIColor clearColor];
    _config.tagCornerRadius = 0;
    _config.tagExtraSpace = CGSizeMake(15, 5);
    _config.tagTextFont = TEXT_FONTSIZE;
    
    /* 加入高度变化的监听*/
    [self addObserver:self forKeyPath:@"headerHeight" options:NSKeyValueObservingOptionNew context:nil];
    
    _classList.classListTableView.tableHeaderView = _infoHeaderView;
    
    /* 保存该页面所有数据的字典*/
    _classInfoDic = @{}.mutableCopy;
    
    _notices = [[Notice alloc]init];
    _noticesArr = @[].mutableCopy;
    _members = [[Members alloc]init];
    _membersArr = @[].mutableCopy;
    _classesArr = @[].mutableCopy;
    /* 聊天室成员列表初始化*/
    _chatList  = @[].mutableCopy;
    membersName = @[].mutableCopy;
    
#pragma mark- 在线成员列表页
    
    _memberListView = [[MembersListView alloc]init];
    [_videoInfoView.view4 addSubview:_memberListView];
    _memberListView.sd_layout
    .topEqualToView(_videoInfoView.view4)
    .bottomEqualToView(_videoInfoView.view4)
    .leftEqualToView(_videoInfoView.view4)
    .rightEqualToView(_videoInfoView.view4);
    
    _memberListView.memberListTableView.delegate = self;
    _memberListView.memberListTableView.dataSource = self;
    _memberListView.memberListTableView.tag =10;
    _memberListView.memberListTableView.tableFooterView = [[UIView alloc]init];
    
    
#pragma mark- 聊天UI初始化
    
    //    [self requestHistoryChatList];
    [self addRefreshViews];
    [self loadBaseViewsAndData];
    
    
    
#pragma mark- 自定义表情包的名字初始化
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"emotionToText" ofType:@"plist"];
    
    NSDictionary *dat  = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    
    
    
    _faces = [NSMutableArray arrayWithArray:[dat allValues]];
    
    
    /* 白板视图放到subview数组里最上一层*/
    //    [self.view bringSubviewToFront:_boardPlayerView];
    
    
    
    /* 最后,添加一个覆盖层.在视频播放器为平级视图的时候,上方的视频播放器可以点击,下方不可以点击*/
    
    _maskView = ({
        
        
        UIView *_= [[UIView alloc]init];
        [_videoInfoView addSubview:_];
        if (_videoInfoView&&_viewsArrangementMode==SameLevel) {
            _.sd_layout
            .leftEqualToView(_videoInfoView)
            .rightEqualToView(_videoInfoView)
            .topEqualToView(_videoInfoView)
            .bottomEqualToView(_videoInfoView);
            
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    
    
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


#pragma mark- 请求课程和和内容
- (void)requestClassInfo{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/live_studio/courses/%@/play_info",Request_Header,_classID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        [self loginStates:dic];
        
        NSDictionary *dataDic=[NSDictionary dictionaryWithDictionary:dic[@"data"]];
        _classInfoDic = dataDic.mutableCopy;
        
        if (![dic[@"status"]isEqualToNumber:@1]) {
            /* 请求错误*/
            if (dic[@"error"]) {
                if ([dic[@"error"][@"code"] isEqual:[NSNumber numberWithInteger:1001]]) {
                    /* 登录错误*/
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录错误!\n是否重新登录?" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                        //                        [self.navigationController popViewControllerAnimated:YES];
                    }] ;
                    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [self loginAgain];
                    }] ;
                    
                    [alert addAction:cancel];
                    [alert addAction:sure];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }
            }
            
        }else{
            
            
            NSString *teacherID= [NSString stringWithFormat:@"%@",  dic[@"data"][@"teacher"][@"id"]];
            
            /* 建立会话消息*/
            _session = [NIMSession session:dic[@"data"][@"chat_team_id"] type:NIMSessionTypeTeam];
            
            if (_session) {
                [self initNIMSDK];
                
                [self requestHistoryChatList];
            }
            
            // 使用yymodel解出所有的学生->列表
            _noticeAndMembers = [NoticeAndMembers yy_modelWithDictionary:dic[@"data"][@"chat_team"]];
            
            //使用yymodel解出老师
            Teacher *teacher = [Teacher yy_modelWithJSON:dic[@"data"][@"teacher"]];
            teacher.teacherID =dic[@"data"][@"teacher"][@"id"];
            teacher.accid = dic[@"data"][@"teacher"][@"chat_account"][@"accid"];
            teacher.icon =dic[@"data"][@"teacher"][@"chat_account"][@"icon"];
            _noticesArr=[_noticeAndMembers valueForKey:@"announcement"];
            [_classNotice.classNotice cyl_reloadData];
            
            /* 判断通知公告数量,HUD框提示加载信息*/
            if (_noticesArr==nil||_noticesArr.count ==0) {
                [self loadingHUDStopLoadingWithTitle:@"暂时没有公告!"];
            }
            
            _membersArr = [_noticeAndMembers valueForKey:@"accounts"];
            
            if (_membersArr==nil||_membersArr.count==0) {
                [self loadingHUDStopLoadingWithTitle:@"暂时没有成员加入!"];
            }
            
            
            [_membersArr insertObject:@{@"accid":teacher.accid==nil?@"":teacher.accid,@"name":teacher.name==nil?@"":teacher.name,@"icon":teacher.icon==nil?@"":teacher.icon} atIndex:0];
            
            
            /* 刷新通知信息*/
            [self updateViewsNotice];
            
            /* 刷新在线用户列表*/
            
            [self updateMembersList];
            
            /* 解析 课程 数据*/
            _videoClassInfo = [VideoClassInfo yy_modelWithDictionary:dataDic];
            
            /* 解析 聊天成员 数据*/
            
            _chatList = dataDic[@"chat_team"][@"accounts"];
            
            /* 保存课程信息*/
            _classesArr = dataDic[@"lessons"];
            
            _videoClassInfo.classID = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"id"]];
            
            _videoClassInfo.classDescription = [NSString  stringWithFormat:@"%@",[dataDic valueForKey:@"description"]];
            
            /* 添加课程简介的富文本方法*/
            _videoClassInfo.attributedDescription =[[NSAttributedString alloc] initWithData:[[dataDic valueForKey:@"description"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            /* 课程图的信息赋值*/
            _infoHeaderView.classNameLabel.text = _videoClassInfo.name;
            _infoHeaderView.gradeLabel.text = _videoClassInfo.grade;
            _infoHeaderView.subjectLabel.text = _videoClassInfo.subject;
            _infoHeaderView.classCount.text =[NSString stringWithFormat:@"共%@课", _videoClassInfo.lesson_count];
            
            //课程标签 赋值
            if (_videoClassInfo.tag_list.count==0) {
                _config.tagBorderColor = [UIColor clearColor];
                [_infoHeaderView.classTagsView addTag:@"无" withConfig:_config];
            }else{
                
                [_infoHeaderView.classTagsView addTags:_videoClassInfo.tag_list withConfig:_config];
            }
            
            //课程目标
            _infoHeaderView.classTarget.text = _videoClassInfo.objective==nil?@"无":_videoClassInfo.objective;
            
            //适应人群
            _infoHeaderView.suitable.text = _videoClassInfo.suit_crowd==nil?@"无":_videoClassInfo.suit_crowd;
            if (_videoClassInfo.live_start_time.length>10&&_videoClassInfo.live_end_time.length>10) {
                _infoHeaderView.liveTimeLabel.text = [NSString stringWithFormat:@"%@ 至 %@",[_videoClassInfo.live_start_time substringToIndex:10],[_videoClassInfo.live_end_time substringToIndex:10]];
            }else{
                _infoHeaderView.liveTimeLabel.text = [NSString stringWithFormat:@"%@ 至 %@",_videoClassInfo.live_start_time ,_videoClassInfo.live_end_time];
            }
            
            /* 课程名->播放文件名*/
            _fileName.text = _videoClassInfo.name;
            
            //            if ([_videoClassInfo.status isEqualToString:@"teaching"]||[_videoClassInfo.status isEqualToString:@"pause"]||[_videoClassInfo.status isEqualToString:@"closed"]) {
            //                _infoHeaderView.onlineVideoLabel.text = @"在线直播";
            //            }else if ([_videoClassInfo.status isEqualToString:@"missed"]){
            //                _infoHeaderView.onlineVideoLabel.text = @"未开课";
            //            }else if ([_videoClassInfo.status isEqualToString:@"finished"]||[_videoClassInfo.status isEqualToString:@"billing"]||[_videoClassInfo.status isEqualToString:@"completed"]){
            //                _infoHeaderView.onlineVideoLabel.text = @"已结束";
            //            }else if ([_videoClassInfo.status isEqualToString:@"public"]){
            //                _infoHeaderView.onlineVideoLabel.text = @"招生中";
            //            }
            
            //            _infoHeaderView.liveTimeLabel.text = _videoClassInfo;
            
            //            _infoHeaderView.classDescriptionLabel.text = _videoClassInfo.classDescription;
            
            /* 课程简介,富文本赋值*/
            _infoHeaderView.classDescriptionLabel.attributedText = _videoClassInfo.attributedDescription;
            _infoHeaderView.classDescriptionLabel.isAttributedContent = YES;
            [_infoHeaderView.classDescriptionLabel updateLayout];
            
            /* 请求教师详细信息*/
            
            [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/teachers/%@/profile",Request_Header,teacherID] withHeaderInfo:nil andHeaderfield:nil parameters:nil completeSuccess:^(id  _Nullable responds) {
                
                NSDictionary *teacherDic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
                
                if ([teacherDic[@"status"]isEqualToNumber:@1]) {
                    
                    /* 解析 教师 数据*/
                    _teacher = [Teacher yy_modelWithDictionary:teacherDic[@"data"]];
                    
                    /* 教师简介,增加富文本*/
                    _teacher.attributedDescription = [[NSAttributedString alloc]initWithData:[_teacher.desc dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                    
                    /* 教师信息 赋值*/
                    _infoHeaderView.teacherNameLabel.text =_teacher.name;
                    _infoHeaderView.teaching_year.text = [_teacher.teaching_years changeEnglishYearsToChinese];
                    _infoHeaderView.workPlace .text = _teacher.school;
                    
                    
                    if (_teacher.gender!=nil) {
                        if ([_teacher.gender isEqualToString:@"female"]) {
                            [_infoHeaderView.genderImage setImage:[UIImage imageNamed:@"女"]];
                        }else if ([_teacher.gender isEqualToString:@"male"]){
                            [_infoHeaderView.genderImage setImage:[UIImage imageNamed:@"男"]];
                        }
                    }
                    
                    [_infoHeaderView.teacherHeadImage sd_setImageWithURL:[NSURL URLWithString:_teacher.avatar_url]];
                    //                    _infoHeaderView.selfInterview.text = _teacher.desc;
                    
                    /* 教师简介,使用富文本*/
                    _infoHeaderView.selfInterview.attributedText = _teacher.attributedDescription;
                    
                    // 测试代码 _infoHeaderView.selfInterview.attributedText = [[NSAttributedString alloc]initWithData:[@"<p>halou&nbsp;halou</p><p>haleou</p><p>halekl</p><p><br /></p><p><strong><span><span><br /></span></span></strong></p><p><strong><span><span></span></span></strong></p>" dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }  documentAttributes:nil error:nil ];
                    
                    [_infoHeaderView.selfInterview updateLayout];
                    
                    /* 自动赋值heagerview的高度*/
                    
                    NSNumber *height =[NSNumber numberWithFloat: _infoHeaderView.layoutLine.frame.origin.y+10];
                    
                    [self setValue:height forKey:@"headerHeight"];
                    
                    [self updateViewsInfos];
                    
                }else{
                    /* 获取数据失败*/
                    [self loadingHUDStopLoadingWithTitle:@"获取教师信息失败"];
                }
                
                
            }];
            
            
            [_infoHeaderView layoutIfNeeded];
            
            if (dataDic) {
                
                if ([dataDic[@"is_bought"]boolValue]==NO) {
                    /* 如果用户还没有购买该课程*/
                    /* 已经试听过*/
                    
                    /* 可以试听*/
                    
                    if (dataDic[@"camera_pull_stream"]==nil||[dataDic[@"camera_pull_stream"]isEqual:@""]||[dataDic[@"camera_pull_stream"] isEqual:[NSNull null]]) {
                        
                        _teacherPullAddress =[NSURL URLWithString:@""];
                    }else{
                        _teacherPullAddress =[NSURL URLWithString:dataDic[@"camera_pull_stream"]];
                    }
                    
                    _boardPullAddress = [NSURL URLWithString:dataDic[@"board_pull_stream"]];
                    
                    /* 重新加载播放器*/
                    [self reloadPlayerView];
                    
                }else{
                    
                }
                
            }else{
                /* 用户已购买该课程,可以随意试听*/
                /* 重新加载播放器*/
                [self reloadPlayerView];
            }
            
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

/* 发送按钮在两秒内不可以重复点击*/
- (void)sendeButtonCannotUse{
    
    [self loadingHUDStopLoadingWithTitle:@"请稍后"];
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
    _chat_Account =[Chat_Account yy_modelWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"chat_account"]];
    
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

/* 加载本地数据*/
- (void)requestChatHitstory{
    
    NSArray *messageArr = [[[NIMSDK sharedSDK]conversationManager]messagesInSession:_session message:nil limit:100];
    /* 如果本地没有数据,请求服务器数据,并保存到本地*/
    if (messageArr.count<=2) {
        [self requestHistoryChatList];
    }else{
        
        _chatTableView.hidden = NO;
        [self loadingHUDStopLoadingWithTitle:@""];
        [self makeMessages:messageArr];
        [_chatTableView reloadData];
        [self tableViewScrollToBottom];
    }
    
}

/* 创建消息 --  加载历史消息*/
- (void)makeMessages:(NSArray<NIMMessage *> * ) messages{
    
    for (NIMMessage *message in messages) {
        if (message.messageType == NIMMessageTypeText||message.messageType==NIMMessageTypeImage||message.messageType == NIMMessageTypeAudio) {
            
            /* 如果是文本消息*/
            
            if (message.messageType ==NIMMessageTypeText) {
                
                //                            NSLog(@"\n\n获取到的消息文本是:::%@\n\n",message.text);
                
                /* 如果消息是自己发的*/
                if ([message.from isEqualToString:_chat_Account.accid]) {
                    /* 在本地创建自己的消息*/
                    
                    NSString *title = message.text;
                    if (title==nil) {
                        title =@"";
                    }
                    
                    //创建一个可变的属性字符串
                    NSMutableAttributedString *text = [NSMutableAttributedString new];
                    [text appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:nil]];
                    
                    
                    /* 正则匹配*/
                    NSString * pattern = @"\\[em_\\d{1,2}\\]";
                    NSError *error = nil;
                    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
                    
                    if (!re) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    
                    //通过正则表达式来匹配字符串
                    NSArray *resultArray = [re matchesInString:title options:0 range:NSMakeRange(0, title.length)];
                    //                                    NSLog(@"%@",resultArray);
                    
                    /* 先取出来表情*/
                    
                    NSMutableArray *names = @[].mutableCopy;
                    
                    //根据匹配范围来用图片进行相应的替换
                    for(NSTextCheckingResult *match in resultArray){
                        //获取数组元素中得到range
                        NSRange range = [match range];
                        
                        //获取原字符串中对应的值
                        NSString *subStr = [title substringWithRange:range];
                        //            NSMutableString *subName = [NSMutableString stringWithFormat:@"%@",[subStr substringWithRange:NSMakeRange(1, subStr.length-2)]];
                        NSMutableString *faceName = @"".mutableCopy;
                        
                        faceName = [NSMutableString stringWithFormat:@"[%@]",[subStr substringWithRange:NSMakeRange(4, 1)]];
                        
                        NSDictionary *dicc= @{@"name":faceName,@"range":[NSValue valueWithRange:range]};
                        [names addObject:dicc];
                        
                    }
                    
                    for (NSInteger i = names.count-1; i>=0; i--) {
                        
                        NSString *path = [[NSBundle mainBundle] pathForScaledResource:names[i][@"name"] ofType:@"gif" inDirectory:@"Emotions.bundle"];
                        NSData *data = [NSData dataWithContentsOfFile:path];
                        YYImage *image = [YYImage imageWithData:data scale:2.5];
                        image.preloadAllAnimatedImageFrames = YES;
                        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
                        
                        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.size alignToFont:[UIFont systemFontOfSize:13*ScrenScale] alignment:YYTextVerticalAlignmentCenter];
                        
                        
                        
                        [text replaceCharactersInRange:[names [i][@"range"] rangeValue] withAttributedString:attachText];
                        
                        title = [title stringByReplacingCharactersInRange:[names [i][@"range"] rangeValue] withString:[names[i]valueForKey:@"name"]];
                    }
                    
                    
                    if (title ==nil) {
                        title = @"";
                    }
                    
                    
                    NSDictionary *dic = @{@"strContent": title,
                                          @"type": @(UUMessageTypeText),
                                          @"frome":@(UUMessageFromMe)};
                    
                    //                                NSLog(@"%@",title);
                    [self dealTheFunctionData:dic andMessage:message];
                    
                }
                
                /* 如果消息是别人发的 */
                else {
                    
                    /* 在本地创建对方的消息消息*/
                    NSString *iconURL = @"".mutableCopy;
                    
                    if (_chatList.count!=0) {
                        
                        for (int p = 0; p < _chatList.count; p++) {
                            
                            Chat_Account *temp = [Chat_Account yy_modelWithJSON:_chatList[p]];
                            
                            //                                        NSLog(@"%@",temp.name);
                            
                            if ([temp.name isEqualToString:message.senderName]) {
                                iconURL = temp.icon;
                                
                            }
                        }
                        
                    }
                    
                    //            NSLog(@"%@",iconURL);
                    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self.chatModel getDicWithText:message.text andName:message.senderName andIcon:iconURL type:UUMessageTypeText andTime:[[NSString stringWithFormat:@"%f",message.timestamp]changeTimeStampToDateString]andMessage:message]];
                    
                    
                    //        [self makeOthersMessageWith:1 andMessage:message];
                    [self.chatModel.dataSource addObjectsFromArray:[self.chatModel additems:1 withDictionary:dic]];
                    [self.chatTableView reloadData];
                    //                        [self tableViewScrollToBottom];
                    
                }
                
                
            }else if (message.messageType ==NIMMessageTypeImage){
                /* 如果收到的消息类型是图片的话 */
                
                /* 如果消息是自己发的*/
                
                if ([message.from isEqualToString:_chat_Account.accid]){
                    
                    NSLog(@"自己发过的图片");
                    
                    NIMImageObject *imageObject = message.messageObject;
                    
                    __block UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",imageObject.thumbPath]];
                    
                    //如果没有这个文件的话,直接调用网络url
                    if (image == nil) {
                        image =[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",imageObject.path]];
                        if (image == nil) {
                            
                            NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imageObject.url]];
                            image = [[UIImage alloc]initWithData:data];
                            if (image == nil) {
                                NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imageObject.thumbUrl]];
                                image = [[UIImage alloc]initWithData:data];
                                
                                
                            }
                        }
                    }
                    
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.chatModel getDicWithImage:image andName:message.senderName andIcon:_iconURL type:UUMessageTypePicture andImagePath:imageObject.url andThumbImagePath:imageObject.thumbPath andTime:[[NSString stringWithFormat:@"%f",message.timestamp]changeTimeStampToDateString]andMessage:message]];
                    
                    [dic setObject:@(UUMessageFromMe) forKey:@"from"];
                    
                    [self.chatModel.dataSource addObjectsFromArray:[self.chatModel additems:1 withDictionary:dic]];
                    
                    
                }
                /* 如果消息是别人发的 */
                else{
                    /* 本地创建对方的图片消息*/
                    
                    NSLog(@"收到对方发来的图片");
                    
                    NIMImageObject *imageObject = message.messageObject;
                    
                    
                    UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",imageObject.thumbPath]];
                    //如果没有这个文件的话,直接调用网络url
                    if (image == nil) {
                        image =[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",imageObject.path]];
                        if (image == nil) {
                            
                            NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imageObject.url]];
                            image = [[UIImage alloc]initWithData:data];
                            if (image == nil) {
                                NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imageObject.thumbUrl]];
                                image = [[UIImage alloc]initWithData:data];
                                
                            }
                        }
                    }
                    
                    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self.chatModel getDicWithImage:image andName:message.senderName andIcon:_iconURL type:UUMessageTypePicture andImagePath:imageObject.url andThumbImagePath:imageObject.thumbPath andTime:[[NSString stringWithFormat:@"%f",message.timestamp]changeTimeStampToDateString]andMessage:message]];
                    
                    
                    [self.chatModel.dataSource addObjectsFromArray:[self.chatModel additems:1 withDictionary:dic]];
                    
                    [_chatTableView reloadData];
                    //                    [self tableViewScrollToBottom];
                    
                }
                
            }else if (message.messageType ==NIMMessageTypeAudio){
                /* 如果收到的消息类型是音频的话 */
                
                /* 如果消息是自己发的*/
                
                if ([message.from isEqualToString:_chat_Account.accid]){
                    
                    // NSLog(@"收到对方发来的语音");
                    
                    NIMAudioObject *audioObject = message.messageObject;
                    
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.chatModel getDicWithVoice:[NSData dataWithContentsOfFile:audioObject.path] andName:message.senderName andIcon:_chat_Account.icon type:UUMessageTypeVoice andVoicePath:audioObject.path andTime:[NSString stringWithFormat:@"%ld",(NSInteger)audioObject.duration/1000]andMessage:message]];
                    
                    [dic setObject:@(UUMessageFromMe) forKey:@"from"];
                    
                    [self.chatModel.dataSource addObjectsFromArray:[self.chatModel additems:1 withDictionary:dic]];
                    
                }
                /* 如果消息是别人发的 */
                else{
                    /* 在本地创建对方的语音消息*/
                    
                    NIMAudioObject *audioObject = message.messageObject;
                    
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.chatModel getDicWithVoice:[NSData dataWithContentsOfFile:audioObject.path] andName:message.senderName andIcon:_chat_Account.icon type:UUMessageTypeVoice andVoicePath:audioObject.path andTime:[NSString stringWithFormat:@"%ld",(NSInteger)audioObject.duration/1000]andMessage:message]];
                    
                    [self.chatModel.dataSource addObjectsFromArray:[self.chatModel additems:1 withDictionary:dic]];
                    
                }
            }
            
        }
        
    }
    [_chatTableView reloadData];
    
    [self tableViewScrollToBottom];
    
}

- (void)requestHistoryChatList{
    
    if (chatTime == 0) {
        
        [self loadingHUDStartLoadingWithTitle:@"正在加载数据"];
        NIMHistoryMessageSearchOption *historyOption = [[NIMHistoryMessageSearchOption  alloc]init];
        historyOption.limit = 100;
        historyOption.order = NIMMessageSearchOrderDesc;
        historyOption.currentMessage = nil;
        historyOption.sync = YES;
        
        /* 获取聊天的历史消息*/
        
        if (_session.sessionId) {
            
            [[NIMSDK sharedSDK].conversationManager fetchMessageHistory:_session option:historyOption result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
                /* 取出云信的accid和token进行字段比较 ，判断是谁发的消息*/
                [self makeMessages:messages];
                
            }];
        }
        
        chatTime++;
        
        [self.chatTableView reloadData];
        
        //        [self tableViewScrollToBottom];
        
        [_chatTableView.mj_header endRefreshing];
        
        [self loadingHUDStopLoadingWithTitle:@"加载完成"];
    }else{
        
        [self.chatTableView reloadData];
        //        [self tableViewScrollToBottom];
        [_chatTableView.mj_header endRefreshing];
        
        [self loadingHUDStopLoadingWithTitle:@"加载完成"];
        
    }
    
    
}

//搜索消息方法
-(void)searchAllMessages:(NIMMessageSearchOption *)option result:(NIMGlobalSearchMessageBlock)result{
    
}
-(void)searchMessages:(NIMSession *)session option:(NIMMessageSearchOption *)option result:(NIMSearchMessageBlock)result{
    
}

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
            
            IFView.sd_layout
            .bottomSpaceToView(_videoInfoView.view2,keyboardRect.size.height);
            
            [IFView updateLayout];
            [_chatTableView clearAutoHeigtSettings];
            _chatTableView.sd_layout
            .bottomSpaceToView(IFView,0);
            [_chatTableView updateLayout];
            
        }];
        [_chatTableView reloadData];
        [self tableViewScrollToBottom];
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
        
        [IFView changeSendBtnWithPhoto:YES];
        
        
    }else{
        [UIView animateWithDuration:animationDuration animations:^{
            
            IFView.sd_layout
            .bottomSpaceToView(_videoInfoView.view2,0);
            [IFView updateLayout];
            
            [_chatTableView clearAutoHeigtSettings];
            _chatTableView.sd_layout
            .bottomSpaceToView(IFView,0);
            [_chatTableView updateLayout];
        }];
        [_chatTableView reloadData];
        [self tableViewScrollToBottom];
        
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



#pragma mark- 聊天功能的方法

#pragma mark- 聊天ui的设置


/* 聊天UI初始化 + 读取数据初始化*/
- (void)loadBaseViewsAndData{
    self.chatModel = [[ChatModel alloc]init];
    self.chatModel.isGroupChat = YES;
    [self.chatModel populateRandomDataSource];
    
    IFView = [[UUInputFunctionView alloc]initWithSuperVC:self];
    IFView.delegate = self;
    [_videoInfoView.view2 addSubview:IFView];
    [IFView.btnChangeVoiceState addTarget:self action:@selector(emojiKeyboardShow:) forControlEvents:UIControlEventTouchUpInside];
    
    IFView.sd_layout
    .leftEqualToView(_videoInfoView.view2)
    .rightEqualToView(_videoInfoView.view2)
    .bottomSpaceToView(_videoInfoView.view2,0)
    .heightIs(46);
    
    
    //    [self.chatTableView reloadData];
    //    [self tableViewScrollToBottom];
}

/* 添加刷新view*/
- (void)addRefreshViews{
    __weak typeof(self) weakSelf = self;
    
    //load more
    int pageNum = 3;
    
    _head = [MJRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf.chatModel addRandomItemsToDataSource:pageNum];
        
        if (weakSelf.chatModel.dataSource.count > pageNum) {
            
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                [weakSelf.chatTableView reloadData];
            //                [weakSelf.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            //            });
        }
        [weakSelf.head endRefreshing];
    }];
    _chatTableView.mj_header = _head;
    
}

//聊天页面tableView 滚动到底部
- (void)tableViewScrollToBottom{
    if (self.chatModel.dataSource.count==0)
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

#pragma mark - 聊天页面 发送文字聊天信息的回调
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message{
    
    if ([funcView.TextViewInput.text isEqualToString:@""]||funcView.TextViewInput.text==nil) {
        
        [self loadingHUDStopLoadingWithTitle:@"请输入聊天内容!"];
        
    }else{
        
        NIMMessage * text_message = [[NIMMessage alloc] init];
        text_message.messageObject = NIMMessageTypeText;
        text_message.apnsContent = @"发来了一条消息";
        
        NSDictionary *dic ;
        
        /* 解析发送的字符串*/
        
        NSString *title = [funcView.TextViewInput.attributedText getPlainString];
        
        if (title == nil) {
            title = @"";
        }
        
        NSString *barragTitle = title.mutableCopy;
        
        //创建一个可变的属性字符串
        NSMutableAttributedString *text = [NSMutableAttributedString new];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:nil]];
        
        /* 正则匹配*/
        NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        NSError *error = nil;
        NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        
        if (!re) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
        //通过正则表达式来匹配字符串
        NSArray *resultArray = [re matchesInString:title options:0 range:NSMakeRange(0, title.length)];
        NSLog(@"%@",resultArray);
        
        //是否包含富文本
        if (resultArray.count!=0) {
            //包含富文本
            
            NSMutableArray *names = @[].mutableCopy;
            
            //根据匹配范围来用图片进行相应的替换
            for(NSTextCheckingResult *match in resultArray){
                //获取数组元素中得到range
                NSRange range = [match range];
                
                //获取原字符串中对应的值
                NSString *subStr = [title substringWithRange:range];
                NSMutableString *subName = [NSMutableString stringWithFormat:@"%@",[subStr substringWithRange:NSMakeRange(1, subStr.length-2)]];
                NSMutableString *faceName = @"".mutableCopy;
                NSMutableString *barrageFaceName = @"".mutableCopy;
                
                faceName = [NSMutableString stringWithFormat:@"[em_%ld]",subName.integerValue+1];
                barrageFaceName =[NSMutableString stringWithFormat:@"em_%ld",subName.integerValue+1];
                
                
                NSDictionary *dicc= @{@"name":faceName,@"range":[NSValue valueWithRange:range],@"barrageName":barrageFaceName};
                [names addObject:dicc];
                
            }
            
            
            for (NSInteger i = names.count-1; i>=0; i--) {
                
                NSString *path = [[NSBundle mainBundle] pathForScaledResource:names[i][@"name"] ofType:@"gif" inDirectory:@"Emotions.bundle"];
                NSData *data = [NSData dataWithContentsOfFile:path];
                YYImage *image = [YYImage imageWithData:data scale:2.5];
                image.preloadAllAnimatedImageFrames = YES;
                YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
                
                NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.size alignToFont:[UIFont systemFontOfSize:13*ScrenScale] alignment:YYTextVerticalAlignmentCenter];
                
                
                
                [text replaceCharactersInRange:[names [i][@"range"] rangeValue] withAttributedString:attachText];
                
                
                title  = [title stringByReplacingCharactersInRange:[names [i][@"range"] rangeValue] withString:[names[i] valueForKey:@"name"]];
                
                dic = @{@"strContent": [funcView.TextViewInput.attributedText getPlainString],
                        @"type": @(UUMessageTypeText),
                        @"frome":@(UUMessageFromMe),
                        @"strTime":[NSString stringWithFormat:@"%@",[[NSDate date]changeUTC]],
                        @"isRichText":@YES,
                        @"richNum":[NSString stringWithFormat:@"%ld",resultArray.count]};
                
            }
            
            
            
        }else{
            //不包含富文本
            dic = @{@"strContent": [funcView.TextViewInput.attributedText getPlainString],
                    @"type": @(UUMessageTypeText),
                    @"frome":@(UUMessageFromMe),
                    @"strTime":[NSString stringWithFormat:@"%@",[[NSDate date]changeUTC]],
                    @"isRichText":@NO,
                    @"richNum":@"0"};
            
            
            
        }
        
        
        text_message.text = title;
        
        [self dealTheFunctionData:dic andMessage:text_message];
        
        
        //发送消息
        [[NIMSDK sharedSDK].chatManager addDelegate:self];
        [[NIMSDK sharedSDK].chatManager sendMessage:text_message toSession:_session error:nil];
        
#pragma mark- 发消息的同时发弹幕
        
        /* 发弹幕*/
        [self sendBarrage:barragTitle withAttibute:text];
        
        [IFView.TextViewInput setText:@""];
        [IFView.TextViewInput resignFirstResponder];
        [IFView changeSendBtnWithPhoto:YES];
        
    }
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
    
}

#pragma mark- 发送图片聊天信息的回调
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image{
    
    NIMImageObject * imageObject = [[NIMImageObject alloc] initWithImage:image];
    NIMMessage *message = [[NIMMessage alloc] init];
    message.messageObject= imageObject;
    
    NSDictionary *dic = @{@"picture": image,
                          @"type": @(UUMessageTypePicture),
                          @"frome":@(UUMessageFromMe)};
    
    //    [funcView changeSendBtnWithPhoto:YES];
    [self dealTheFunctionData:dic andMessage:message];
    
    
    
    //发送消息
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:_session error:nil];
    
    
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
    
}


#pragma mark- 发送语音消息的回调
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second{
    
    /* 云信发送语音消息*/
    
    
    //    声音文件只支持 aac 和 amr 类型
    NSMutableString *tmpDir = [NSMutableString stringWithString:NSTemporaryDirectory()];
    [tmpDir appendString:@"mp3.amr"];
    
    //构造消息
    NIMAudioObject *audioObject = [[NIMAudioObject alloc] initWithSourcePath:tmpDir];
    NIMMessage *message        = [[NIMMessage alloc] init];
    message.messageObject      = audioObject;
    
    NSDictionary *dic = @{@"voice": voice,
                          @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)second],
                          @"type": @(UUMessageTypeVoice)};
    
    [self dealTheFunctionData:dic andMessage:message];
    
    
    //发送消息
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:_session error:nil];
    
}

#pragma mark- 开始/关闭弹幕功能
- (void)barragesSwitch{
    
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
            
            _aBarrage.view.hidden = YES;
            
        }
        
        
        /* 在全屏的条件下*/
    }else{
        
        
        
        if (_boardPlayerView .becomeMainPlayer == YES) {
            [_aBarrage.view removeFromSuperview];
            
            [_boardPlayerView addSubview:_aBarrage.view];
            _aBarrage.view.hidden = YES;
            [_boardPlayerView bringSubviewToFront:_aBarrage.view];
            
        }else if (_teacherPlayerView.becomeMainPlayer == YES){
            
            [_teacherPlayerView addSubview:_aBarrage.view];
            [_aBarrage.view clearAutoHeigtSettings];
            _aBarrage.view.sd_layout
            .leftEqualToView(_teacherPlayerView)
            .rightEqualToView(_teacherPlayerView)
            .topEqualToView(_teacherPlayerView)
            .bottomEqualToView(_teacherPlayerView);
            [_aBarrage.view updateLayout];
            _aBarrage.view.hidden = NO;
            [_teacherPlayerView bringSubviewToFront:_aBarrage.view];
        }
        
    }
    
    
    _descriptor.spriteName = NSStringFromClass(BarrageWalkTextSprite.self);
    _descriptor.params[@"text"] =message;
    _descriptor.params[@"textColor"] = [UIColor whiteColor];  //弹幕颜色
    _descriptor.params[@"side"] = BarrageWalkSideDefault;
    _descriptor.params[@"speed"] = @60;
    //    _descriptor.params[@"attributedText"] = attribute;
    
    if (isFullScreen) {
        _descriptor.params[@"fontSize"]= @22;
    }else{
        _descriptor.params[@"fontSize"]= @16;
    }
    
    
    
    //    _descriptor.params[@"direction"] = @(BarrageWalkDirectionR2L);
    
    if (isFullScreen) {
        
        _aBarrage.canvasMargin = UIEdgeInsetsMake(30, 0, CGRectGetHeight(self.view.frame)/3.0f, 0);
        
    }else if (!isFullScreen){
        _aBarrage.canvasMargin = UIEdgeInsetsMake(30, 0, (CGRectGetWidth(self.view.frame)/16*9.0f)/3.0f, 0);
    }
    
    
    //    [_aBarrage start];
    
    [_aBarrage receive:_descriptor];
    
    
    
    
}

/* 给自己添加消息*/

- (void)dealTheFunctionData:(NSDictionary *)dic andMessage:(NIMMessage *)message{
    
    
    if ([dic[@"type"]isEqual:[NSNumber numberWithInteger:0]]) {
        
        /* 重写了UUMolde的添加自己的item方法 */
        [self.chatModel addSpecifiedItem:dic andIconURL:_chat_Account.icon andName:_chat_Account.name andMessage:message ];
    }else if ([dic[@"type"]isEqual:[NSNumber numberWithInteger:1]]){
        
        [self.chatModel addSpecifiedImageItem:dic andIconURL:_chat_Account.icon andName:_chat_Account.name andMessage:message];
        
        
    }else if ([dic[@"type"]isEqualToNumber:@2]){
        /* 语音类型消息*/
        [self.chatModel addSpecifiedVoiceItem:dic andIconURL:_chat_Account.icon andName:_chat_Account.name andMessage:message];
    }
    
    
    [self.chatTableView reloadData];
    //    [self tableViewScrollToBottom];
    
    
    
}

// 获取表情字符串
- (NSString *)emotionText:(UITextView *)textView{
    
    NSLog(@"%@",textView.attributedText);
    
    NSMutableString *strM = [NSMutableString string];
    
    [textView.attributedText  enumerateAttributesInRange:NSMakeRange(0, textView.attributedText.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSString *str = nil;
        
        YZTextAttachment *attachment = attrs[@"NSAttachment"];
        
        if (attachment) { // 表情
            str = attachment.emotionStr;
            [strM appendString:str];
        } else { // 文字
            str = [textView.attributedText.string substringWithRange:range];
            [strM appendString:str];
        }
        
    }];
    
    NSLog(@"%@",strM);
    
    
    return strM;
    
}

#pragma mark- 云信的回调方法
/* 发送消息成功的回调*/
- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(nullable NSError *)error{
    
    NSLog(@"%@",message.text);
    
    
    NSLog(@"%@",error);
    
    
}

/* 获取到消息的回调*/
- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages{
    
    for (int i = 0; i<messages.count; i++) {
        
        NSString *iconURL = @"".mutableCopy;
        NIMMessage *message =messages[i];
        
        /* 筛选用户信息,拿到用户名*/
        if (_chatList.count!=0) {
            
            for (int p = 0; p < _chatList.count; p++) {
                
                Chat_Account *temp = [Chat_Account yy_modelWithJSON:_chatList[p]];
                
                NSLog(@"%@",temp.name);
                
                if ([temp.name isEqualToString:message.senderName]) {
                    iconURL = temp.icon;
                    
                }
            }
        }
        
        
        /* 如果收到的是文本消息*/
        if (message.messageType == NIMMessageTypeText) {
            
            /* 在本地创建对方的消息消息*/
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self.chatModel getDicWithText:message.text andName:message.senderName andIcon:iconURL type:UUMessageTypeText  andTime:[[NSString stringWithFormat:@"%f",message.timestamp]changeTimeStampToDateString]andMessage:message]];
            
            
            [self.chatModel.dataSource addObjectsFromArray:[self.chatModel additems:1 withDictionary:dic]];
            
            [self.chatTableView reloadData];
            [self tableViewScrollToBottom];
            
            /* 同时发送弹幕*/
            
            [self sendBarrage:messages[i].text withAttibute:nil];
            
        }
        
        /* 如果收到的是图片消息*/
        else if (message.messageType == NIMMessageTypeImage){
            
        }
        
    }
    
}

/* 发送消息进度*/
- (void)sendMessage:(NIMMessage *)message progress:(CGFloat)progress{
    
    NSLog(@"发送进度::%f",progress);
}

/* 接收到消息后 ，在本地创建消息*/
- (void)makeOthersMessageWith:(NSInteger)msgNum andMessage:(UUMessage *)message{
    
    [self.chatModel.dataSource addObject:message];
    
}

/* 接收回调*/
- (BOOL)fetchMessageAttachment:(NIMMessage *)message error:(NSError **)error{
    
    
    return YES;
}

/* 接收图片的进度回调*/
- (void)fetchMessageAttachment:(NIMMessage *)message progress:(CGFloat)progress{
    
    NSLog(@"接收进度::%f",progress);
    
}

/* 接收图片完成后的回调*/
- (void)fetchMessageAttachment:(NIMMessage *)message didCompleteWithError:(NSError *)error{
    
    
    if (message.messageType == NIMMessageTypeImage) {
        NSLog(@"收到图片");
        
        NIMImageObject *imageObject = message.messageObject;
        
        NSLog(@"%@",imageObject.thumbPath);
        NSLog(@"%@",imageObject.path);
        
        
        UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",imageObject.thumbPath]];
        
        /* 在本地创建对方的消息消息*/
        NSString *iconURL = @"".mutableCopy;
        NSString *senderName = @"".mutableCopy;
        for (Members *mod in _membersArr) {
            if ([message.from isEqualToString:[mod valueForKey:@"accid"]]) {
                iconURL = [mod valueForKey:@"icon"];
                senderName = [mod valueForKey:@"name"];
            }
        }
        
        
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self.chatModel getDicWithImage:image andName:senderName andIcon:iconURL type:UUMessageTypePicture andImagePath:imageObject.url andThumbImagePath:imageObject.thumbPath andTime:[[NSString stringWithFormat:@"%f",message.timestamp]changeTimeStampToDateString]andMessage:message]];
        
        [self.chatModel.dataSource addObjectsFromArray:[self.chatModel additems:1 withDictionary:dic]];
    }else if (message.messageType == NIMMessageTypeAudio){
        /* 收到语音消息*/
        NSLog(@"收到语音");
        
        /* 在本地创建对方的消息消息*/
        NSString *iconURL = @"".mutableCopy;
        NSString *senderName = @"".mutableCopy;
        for (Members *mem in _membersArr) {
            if ([message.from isEqualToString:[mem valueForKey:@"accid"]]) {
                iconURL = [mem valueForKey:@"icon"];
                senderName = [mem valueForKey:@"name"];
            }
        }
        
        NIMAudioObject *audioObject = message.messageObject;
        //audioObject.path 本地音频地址
        NSLog(@"%@",audioObject.path);
        
        //创建消息字典
        
        NSDictionary *dic = [self.chatModel getDicWithVoice:[NSData dataWithContentsOfFile:audioObject.path] andName:senderName andIcon:iconURL type:UUMessageTypeVoice andVoicePath:audioObject.path andTime:[NSString stringWithFormat:@"%ld",(NSInteger)audioObject.duration/1000]andMessage:message];
        
        [self.chatModel.dataSource addObjectsFromArray:[self.chatModel additems:1 withDictionary:dic]];
        
    }
    
    
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
    
    
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
        
        [_infoHeaderView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), headerHeight+20)];
        
        _classList.classListTableView.tableHeaderView =_infoHeaderView;
        
        _classList.classListTableView.tableHeaderView.height_sd =headerHeight;
        
        
        [self updateViewsInfos];
    }
    
    
}

/* 刷新在线用户列表*/
- (void)updateMembersList{
    
    if (_membersArr.count!=0) {
        
        [_memberListView.memberListTableView reloadData];
        
    }
    
}

/* tableview刷新视图*/

- (void)updateViewsNotice{
    
    [_classNotice.classNotice reloadData];
    //    [_videoInfoView.noticeTabelView setNeedsDisplay];
    
    
}

- (void)updateViewsInfos{
    
    [_classList.classListTableView reloadData];
    [_classList.classListTableView  setNeedsDisplay];
    [_classList.classListTableView  setNeedsLayout];
    
    
}


#pragma mark- tableview delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    if (tableView.tag==1) {
        Notice *model =[Notice yy_modelWithJSON:_noticesArr[indexPath.row]];
        // 获取cell高度
        return  [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[NoticeTableViewCell class] contentViewWidth: [UIScreen mainScreen].bounds.size.width];
        
    }
    
    
    if (tableView.tag ==2) {
        if (_classesArr.count ==0) {
            
        }else{
            
            Classes *mod =[Classes yy_modelWithJSON: _classesArr[indexPath.row]];
            // 获取cell高度
            return  [tableView cellHeightForIndexPath:indexPath model:mod keyPath:@"classModel" cellClass:[ClassesListTableViewCell class] contentViewWidth: [UIScreen mainScreen].bounds.size.width];
            
        }
        
    }
    if (tableView.tag ==3) {
        return [self.chatModel.dataSource[indexPath.row] cellHeight];
    }
    
    if (tableView.tag==10) {
        return  50;
    }
    
    
    
    return 0;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 2) {
        
        ClassesListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if ([_classInfoDic[@"is_bought"]boolValue]==YES) {
            /* 已购买*/
            [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/lessons/%@/replay",Request_Header,cell.classModel.classID] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
                
                if ([dic[@"status"]isEqualToNumber:@1]) {
                    
                    if ([dic[@"data"][@"replayable"]boolValue]== YES) {
                        
                        if ([dic[@"data"][@"left_replay_times"]integerValue]>0) {
                            
                            if (dic[@"data"][@"replay"]==nil) {
                                
                            }else{
                                
                                NSMutableArray *decodeParm = [[NSMutableArray alloc] init];
                                [decodeParm addObject:@"hardware"];
                                [decodeParm addObject:@"videoOnDemand"];
                                
                                VideoPlayerViewController *video  = [[VideoPlayerViewController alloc]initWithURL:[NSURL URLWithString:dic[@"data"][@"replay"][@"orig_url"]] andDecodeParm:decodeParm andTitle:dic[@"data"][@"name"]];
                                [self presentViewController:video animated:YES completion:^{
                                    
                                }];
                            }
                        }else{
                            
                            [self loadingHUDStopLoadingWithTitle:@"回放次数已耗尽"];
                            
                        }
                        
                    }else{
                        [self loadingHUDStopLoadingWithTitle:@"暂无回放视频"];
                    }
                }else{
                    [self loadingHUDStopLoadingWithTitle:@"服务器正忙,请稍后再试"];
                }
                
            }];
            
            
        }else{
            //            [self loadingHUDStopLoadingWithTitle:@"您尚未购买该课程!"];
        }
        
        
    }
    
    
    if (tableView.tag ==3) {
        
        [self.view endEditing:YES];
    }
    
    if (tableView.tag==10) {
        
        
    }
    
    
}
//列表占位图
- (UIView *)makePlaceHolderView{
    
    HaveNoClassView *view = [[HaveNoClassView alloc]init];
    //    view.titleLabel.text = @"当前无内容";
    
    return view;
}

- (BOOL)enableScrollWhenPlaceHolderViewShowing{
    
    return YES;
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}

#pragma mark- tagview delegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView updateContentSize:(CGSize)contentSize{
    
    if (textTagCollectionView == _infoHeaderView.classTagsView) {
        [textTagCollectionView clearAutoHeigtSettings];
        textTagCollectionView.sd_layout
        .heightIs(contentSize.height);
    }
    
}





#pragma mark - tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    NSInteger rows=0;
    
    if (tableView.tag==1) {
        
        if (_noticesArr.count==0) {
            rows = 0;
        }else{
            
            rows=_noticesArr.count;
        }
    }
    
    if (tableView.tag ==2) {
        if (_classesArr.count==0) {
            rows = 0;
        }else{
            
            rows=_classesArr.count;
        }
        
        
    }
    
    if (tableView.tag ==3) {
        
        if (self.chatModel.dataSource.count == 0) {
            rows = 0;
        }else{
            
            rows = self.chatModel.dataSource.count;
        }
        
    }
    if (tableView.tag ==10) {
        if (_membersArr.count==0) {
            
            rows = 0;
        }else{
            rows = _membersArr.count;
        }
    }
    
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tableCell = [[UITableViewCell alloc]init];
    
    switch (tableView.tag) {
        case 20:{
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            NoticeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[NoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
                if (_noticesArr.count==0) {
                    
                    [_classNotice.classNotice cyl_reloadData];
                    
                }else if (_noticesArr.count>indexPath.row){
                    
                    Notice *mod =[Notice yy_modelWithJSON: _noticesArr[indexPath.row]];
                    
                    cell.model = mod;
                    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                    
                }
            }
            return cell;
            
            
        }
            break;
            
        case 2:{
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            /* cell的重用队列*/
            
            ClassesListTableViewCell * idcell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (idcell==nil) {
                idcell=[[ClassesListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
                if (_classesArr.count>indexPath.row) {
                    
                    Classes *mod =[Classes yy_modelWithJSON: _classesArr[indexPath.row]];
                    
                    mod.classID =_classesArr[indexPath.row][@"id"];
                    
                    idcell.classModel = mod;
                    [idcell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                    
                    /* 用总的信息来判断,是否显示可以试听的按钮*/
                    if (_classInfoDic) {
                        if (_classInfoDic[@"is_bought"]) {
                            if ([_classInfoDic[@"is_bought"]boolValue]==YES) {
                                
                                if (idcell.model.replayable == YES) {
                                    
                                    idcell.replay.hidden = NO;
                                }else{
                                    idcell.replay.hidden = YES;
                                }
                            }else{
                                idcell.replay.hidden = YES;
                            }
                        }else{
                            idcell.replay.hidden = YES;
                        }
                        
                    }
                    
                }
            }
            return idcell;
            
        }
            break;
        case 3:{
            
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell == nil) {
                cell = [[UUMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            }
            
            if (self.chatModel.dataSource.count>indexPath.row) {
                
                cell.delegate = self;
                [cell setMessageFrame:self.chatModel.dataSource[indexPath.row]];
                
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            }
            
            
            return cell;
            
        }
            break;
        case 10:{
            
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            MemberListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            
            if (cell==nil) {
                cell =[[MemberListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
            }
            
            if (_membersArr.count==0) {
                
                [_memberListView.memberListTableView cyl_reloadData];
                
                
            }else if (_membersArr.count>indexPath.row) {
                
                cell.model = [Members yy_modelWithJSON:_membersArr[indexPath.row]];
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                if (indexPath.row == 0) {
                    cell.character.text = @"老师";
                    cell.name.textColor = BUTTONRED;
                    cell.character.textColor = BUTTONRED;
                }else{
                    cell.character.text = @"学生";
                    
                }
            }
            
            return cell;
            
        }
            break;
    }
    return  tableCell;
    
}


#pragma mark - UITableViewDelegate


// segment的滑动代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (isFullScreen == NO) {
        
        if (scrollView == _videoInfoView.scrollView) {
            
            CGFloat pageWidth = scrollView.frame.size.width;
            NSInteger page = scrollView.contentOffset.x / pageWidth;
            
            [_videoInfoView.segmentControl setSelectedSegmentIndex:page animated:YES];
            
            if (_videoInfoView.segmentControl.selectedSegmentIndex ==1) {
                if (chatTime ==0) {
                    
                    [_chatTableView.mj_header beginRefreshing];
                    
                }
            }
        }
    }
    
}

/* 文本输入框取消响应*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (![IFView.TextViewInput.text isEqualToString:@""]) {
        
        [IFView.TextViewInput resignFirstResponder];
        [IFView changeSendBtnWithPhoto:YES];
        
    }else{
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ChatNone" object:nil];
    }
    
    [self.view endEditing:YES];
    
}

/* 点击空白处,文本框取消响应*/
- (void)tapSpace{
    
    [IFView.TextViewInput resignFirstResponder];
    [IFView changeSendBtnWithPhoto:YES];
}


#pragma mark- emoji表情键盘部分的方法

#pragma mark-  懒加载键盘
- (YZEmotionKeyboard *)emotionKeyboard
{
    // 创建表情键盘
    if (_emotionKeyboard == nil) {
        
        YZEmotionKeyboard *emotionKeyboard = [YZEmotionKeyboard emotionKeyboard];
        
        emotionKeyboard.sendContent = ^(NSString *content){
            // 点击发送会调用，自动把文本框内容返回给你
            
            NSLog(@"%@",content);
        };
        
        _emotionKeyboard = emotionKeyboard;
    }
    return _emotionKeyboard;
}


//点击表情按钮的点击事件
- (void)emojiKeyboardShow:(UIButton *)sender{
    
    
    [IFView.TextViewInput becomeFirstResponder];
    if (sender.superview == IFView) {
        
        //        IFView.TextViewInput.text = @"" ;
        
        if (IFView.TextViewInput.inputView == nil) {
            IFView.TextViewInput.yz_emotionKeyboard = self.emotionKeyboard;
            [sender setBackgroundImage:[UIImage imageNamed:@"toolbar-text"] forState:UIControlStateNormal];
            
        } else {
            IFView.TextViewInput.inputView = nil;
            [IFView.TextViewInput reloadInputViews];
            [sender setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
            
        }
        
        
        
        /* ifview的输入框作为表情键盘的输入框*/
        
        
    }
}




#pragma mark- 查询播放状态功能的方法实现 --播放器初始化状态
- (void)checkVideoStatus{
    /* 向后台发送请求,请求视频直播状态*/
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/live_studio/courses/%@/status",Request_Header,_classID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
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
            
            
        }else{
            /* 获取数据失败*/
            
            [self checkVideoStatus];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

#pragma mark- 向后台查询直播状态和操作的方法
- (void)switchStatuseWithDictionary:(NSDictionary *)statusDic{
    
    UIAlertController *alertController = NULL;
    UIAlertAction *action = NULL;
    
    /* 状态都是1  都是正在直播中的时候*/
    if ([statusDic[@"board"] isEqual:[NSNumber numberWithInteger:1]]&&[statusDic[@"camera"]isEqual:[NSNumber numberWithInteger:1]]) {
        
        //两个播放器继续播放
        [_liveplayerBoard play];
        
        [_liveplayerTeacher play];
        
        /* 不用再向服务器发送查询请求*/
        NSLog(@"白板读取状态:%u",_liveplayerBoard.loadState);
        NSLog(@"白板播放状态:%u",_liveplayerBoard.playbackState);
        
        NSLog(@"摄像头读取状态:%u",_liveplayerTeacher.loadState);
        NSLog(@"摄像头播放状态:%u",_liveplayerTeacher.playbackState);
        
        if (_liveplayerBoard.playbackState != NELPMoviePlaybackStatePlaying) {
            [self playVideo:_liveplayerBoard];
        }
        if (_liveplayerTeacher.playbackState != NELPMoviePlaybackStatePlaying){
            
            [self playVideo:_liveplayerTeacher];
        }
        
    }
    
    
    /* 如果有一个播放器是直播状态*/
    if ([statusDic[@"board"] isEqual:[NSNumber numberWithInteger:1]]||[statusDic[@"camera"]isEqual:[NSNumber numberWithInteger:1]]) {
        if ([statusDic[@"board"] isEqual:[NSNumber numberWithInteger:1]]) {
            
            _liveplayerBoard.shouldAutoplay = YES;
            [_liveplayerBoard prepareToPlay];
            
        }
        if ([statusDic[@"camera"]isEqual:[NSNumber numberWithInteger:1]]) {
            
            _liveplayerTeacher.shouldAutoplay = YES;
            [_liveplayerTeacher prepareToPlay];
        }
        
    }
    
    
    /* 如果有一个播放器是未直播状态*/
    if ([statusDic[@"board"] isEqual:[NSNumber numberWithInteger:0]]||[statusDic[@"camera"]isEqual:[NSNumber numberWithInteger:0]]) {
        
        /**
         测试 5s一次 正常值30s一次
         
         @param checkVideoStatus
         @return void
         */
        
        [self performSelector:@selector(checkVideoStatus) withObject:nil afterDelay:5];
    }
    
    /* 直播结束的状态*/
    
    if ([statusDic[@"board"] isEqual:[NSNumber numberWithInteger:2]]||[statusDic[@"camera"]isEqual:[NSNumber numberWithInteger:2]]) {
        
        if ([statusDic[@"board"] isEqual:[NSNumber numberWithInteger:2]]) {
            
            [_liveplayerBoard stop];
            
        }
        if ([statusDic[@"camera"]isEqual:[NSNumber numberWithInteger:2]]) {
            
            [_liveplayerTeacher stop];
            
        }
        
        /**
         测试 5s一次 正常值30s一次
         
         @param checkVideoStatus
         @return void
         */
        [self performSelector:@selector(checkVideoStatus) withObject:nil afterDelay:5];
        
    }
    
    if ([statusDic[@"board"] isEqual:[NSNumber numberWithInteger:2]]&&[statusDic[@"camera"]isEqual:[NSNumber numberWithInteger:2]]) {
        alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"直播结束" preferredStyle:UIAlertControllerStyleAlert];
        action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            if (self.presentingViewController) {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }}];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        
        /* 两个播放流都结束之后,继续访问后台服务器直播状态*/
        
        [self performSelector:@selector(checkVideoStatus) withObject:nil afterDelay:5];
        
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
    
    [IFView.inputView resignFirstResponder];
    [IFView changeSendBtnWithPhoto:YES];
    
    [self.view endEditing:YES];
    
}


/* 把弹幕给释放掉*/
-(void)dealloc{
    /* 防止内存泄漏,移除所有监听*/
    [_boardPlayerView removeObserver:self forKeyPath:@"canMove" ];
    [_teacherPlayerView removeObserver:self forKeyPath:@"canMove" ];
    [self removeObserver:self forKeyPath:@"headerHeight"];
    _aBarrage = nil;
    NSLog(@"干掉弹幕");
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
