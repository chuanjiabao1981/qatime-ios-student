//
//  NELivePlayerViewController.m
//  NELivePlayerDemo
//
//  Created by NetEase on 15-10-10.
//  Copyright (c) 2015年 netease. All rights reserved.
//

#import "NELivePlayerViewController.h"
#import "NELivePlayerControl.h"



#import "NavigationBar.h"

#import <MediaPlayer/MediaPlayer.h>
#import "RDVTabBarController.h"
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
#import "NIMSDK.h"
#import "FJFloatingView.h"
#import "BarrageRenderer.h"

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

#import "NSAttributedString+EmojiExtension.h"

#import "NSString+YYAdd.h"
#import "YYImage.h"
#import "NSBundle+YYAdd.h"
#import "NSString+YYAdd.h"
#import "NSMutableAttributedString+Extention.h"
#import "NSAttributedString+YYtext.h"




#define APP_WIDTH self.view.frame.size.width
#define APP_HEIGHT self.view.frame.size.height

typedef enum : NSUInteger {
    SameLevel,
    DifferentLevel,
    
    
} ViewsArrangementMode;



@interface NELivePlayerViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UUInputFunctionViewDelegate,UUMessageCellDelegate,NIMLoginManager,NIMChatManagerDelegate,NIMConversationManagerDelegate,NIMConversationManager,UITextViewDelegate>{
    
    //    NavigationBar *_navigationBar;
    
    
    /* token*/
    
    NSString *_remember_token;
    
    /* 课程model*/
    
    VideoClassInfo *_videoClassInfo;
    
    /* 通知消息model*/
    NoticeAndMembers *_noticeAndMembers;
    
    
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
    
    
    
    /* 两个视频播放器的排列方式*/
    
    ViewsArrangementMode _viewsArrangementMode;
    
    /* 是否全屏*/
    BOOL isFullScreen;
    
    /* 全屏播放视频的聊天输入框*/
    UUInputFunctionView *_barrageText;
    /* 全屏播放视频的聊天发送按键*/
    UIButton *_makeABarage;
    
    /* 全屏模式下的刷新按钮*/
    UIButton *refresh_FS;
    
    
    
    /* 后台获取的直播状态存储字典*/
    NSDictionary *_statusDic;
    
    /* 状态循环*/
    NSRunLoop *_runLoop;
    
    
    
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
    
    
  
    
    
    
    
    /* 弹幕*/
    
    BarrageRenderer *_aBarrage;
    BarrageDescriptor *_descriptor;
    
    BOOL barrageRunning;
    
}

/* 在线聊天成员姓名排序所需的属性*/
@property(nonatomic,strong)NSMutableArray *indexArray;
@property(nonatomic,strong)NSMutableArray *letterResultArr;

@property (nonatomic, strong) UILabel *sectionTitleView;
@property (nonatomic, strong) NSTimer *timer;






/* 拉流播放器 老师*/
@property (nonatomic, strong) FJFloatingView *teacherPlayerView;

/* 拉流播放器的私有属性*/

@property (nonatomic, strong) UIControl *controlOverlay;
@property (nonatomic, strong) UIView *topControlView;
@property (nonatomic, strong) UIView *bottomControlView;
@property (nonatomic, strong) UIButton *playQuitBtn;
@property (nonatomic, strong) UILabel *fileName;

@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *pauseBtn;

@property (nonatomic, strong) UIButton *scaleModeBtn;


/* 拉流播放器view  白板*/

@property(nonatomic, strong) FJFloatingView *boardPlayerView ;




#pragma mark- 聊天部分的属性
/* 刷新聊天记录*/
@property (strong, nonatomic) MJRefreshHeader *head;
/* 聊天信息*/
@property (strong, nonatomic) ChatModel *chatModel;
/* 聊天table*/
@property(nonatomic,strong) UITableView *chatTableView ;

@property(nonatomic,strong) NSLayoutConstraint *bottomConstraint ;
@property(nonatomic,weak) id <NIMLoginManagerDelegate> loginDelegate ;

/* 与web端同步的表情专用的键盘*/
@property (strong, nonatomic) YZEmotionKeyboard *emotionKeyboard;







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






@implementation NELivePlayerViewController

NSTimeInterval mDuration;
NSTimeInterval mCurrPos;
CGFloat screenWidth;
CGFloat screenHeight;
bool isHardware = YES;
bool ismute     = NO;

#pragma mark- controller的初始化方法

-(instancetype)initWithClassID:(NSString *)classID{
    self = [super init];
    if (self) {
        
        _classID = [NSString stringWithFormat:@"%@",classID];
        
    }
    return self;
}

-(instancetype)initWithClassID:(NSString *)classID andBoardPullAddress:(NSURL *)boardPullAddress andTeacherPullAddress:(NSURL *)teacherPullAddress{
    self = [super init];
    if (self) {
        
//        _classID = [NSString stringWithFormat:@"%@",classID];
//        _boardPullAddress = boardPullAddress;
//        _teacherPullAddress = teacherPullAddress;
        
        
    }
    return self;

}





- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //当前屏幕宽高
    screenWidth  = CGRectGetWidth([UIScreen mainScreen].bounds);
    screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    /* 默认的视频排列方式是平级*/
    
    _viewsArrangementMode = SameLevel;
    
    
    

    
    /* 添加视图层级的监听*/
    
    /* 变为非平级视图的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(viewLevelChangDifferent:) name:@"DifferentLevel" object:nil];
    /* 变为平级视图的监听*/
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(viewLevelChangSame:) name:@"SameLevel" object:nil];
    
    /* 变为全屏后的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(turnFullScreen:) name:@"FullScreen" object:nil];
    
    /* 切换回竖屏后的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(turnDownFullScreen:) name:@"TurnDownFullScreen" object:nil];
    
    /* 全屏弹幕框的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(barrageTextEdit:) name:@"BarrageBecomeFirstResponder" object:nil];
    
    /* 初始化视频播放器*/
    
    [self setupVideoPlayer];
    
    /* 初始化弹幕*/
    
    [self setupBarrage];

    
}


#pragma mark- 播放器的布局和初始化方法

- (void)setupVideoPlayer{
    
    /* 白板播放器背景view*/
    
    _boardPlayerView = [[FJFloatingView alloc]init];
    _boardPlayerView.backgroundColor = [UIColor grayColor];
    //    _boardPlayerView.layer.borderColor = [UIColor grayColor].CGColor;
    //    _boardPlayerView.layer.borderWidth = 0.6f;
    _boardPlayerView.alpha = 0.4;
    [self.view addSubview:_boardPlayerView];
    
    _boardPlayerView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,20)
    .autoHeightRatio(9/16.0);
    _boardPlayerView.tag = 0;
    
    
    /* 当前不可移动*/
    _boardPlayerView.canMove = NO;
    
    [_boardPlayerView removeGestureRecognizer:_boardPlayerView.pan];
    
    /* 白板播放器是主要的播放器（在上面）*/
    _boardPlayerView.becomeMainPlayer = YES;
    
    //    rtmp://va0a19f55.live.126.net/live/02dce8e380034cf9b2ef1f9c26c4234c
    /* 白板的 播放器*/
    
    
    
    /* 教师摄像头的 播放层*/
    _teacherPlayerView =[[FJFloatingView alloc]init];
    [self.view addSubview:_teacherPlayerView];
    _teacherPlayerView.backgroundColor = [UIColor grayColor];
    //    _teacherPlayerView.alpha = 0.4;
    //     布局与整个视图的尺寸相同
    _teacherPlayerView.sd_layout
    .leftEqualToView(_boardPlayerView)
    .rightEqualToView(_boardPlayerView)
    .topSpaceToView(_boardPlayerView,0)
    .autoHeightRatio(9/16.0);
    _teacherPlayerView.tag = 1;
    /* 老师播放器不可移动*/
    _teacherPlayerView.canMove = NO;
    [_teacherPlayerView removeGestureRecognizer:_teacherPlayerView.pan];
    _teacherPlayerView.layer.borderWidth = 0.6f;
    _teacherPlayerView.layer.borderColor = [UIColor grayColor].CGColor;
    
    /* 老师播放器为主要播放器*/
    _teacherPlayerView.becomeMainPlayer=NO;
    
    
    /* 老师摄像头的 播放器*/
    
    dispatch_queue_t teacher = dispatch_queue_create("teacher", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(teacher, ^{
        
        
        _liveplayerTeacher = [[NELivePlayerController alloc] initWithContentURL:_teacherPullAddress];
        _liveplayerTeacher.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        //    _liveplayer.view.frame = _playerView.bounds;
        [_liveplayerTeacher setScalingMode:NELPMovieScalingModeAspectFit];
        [self.view addSubview:_liveplayerTeacher.view];
        
        if (_liveplayerTeacher == nil) {
            // 返回空则表示初始化失败
            NSLog(@"player initilize failed, please tay again!");
        }else{
            _liveplayerTeacher.view.sd_layout
            .leftEqualToView(_teacherPlayerView)
            .rightEqualToView(_teacherPlayerView)
            .topEqualToView(_teacherPlayerView)
            .bottomEqualToView(_teacherPlayerView);
        }
        
        
        _liveplayerBoard = [[NELivePlayerController alloc] initWithContentURL:_boardPullAddress];
        _liveplayerBoard.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [_liveplayerBoard setScalingMode:NELPMovieScalingModeAspectFit];
        [_boardPlayerView addSubview:_liveplayerBoard.view];
        
        
        if (_liveplayerBoard == nil) {
            // 返回空则表示初始化失败
            NSLog(@"player initilize failed, please tay again!");
        }else{
            _liveplayerBoard.view.sd_layout
            .leftEqualToView(_boardPlayerView)
            .rightEqualToView(_boardPlayerView)
            .topEqualToView(_boardPlayerView)
            .bottomEqualToView(_boardPlayerView);
        }
        
        
        
    });
    
    /* 媒体控制器*/
    _mediaControl =[[NELivePlayerControl alloc] init];
    [self.view addSubview:_mediaControl];
    _mediaControl.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,20)
    .autoHeightRatio(9/16.0);
    
    
    
    //控制器覆盖层
    _controlOverlay =[[UIControl alloc] init];
    [_mediaControl addSubview:_controlOverlay];
    _controlOverlay.sd_layout
    .leftEqualToView(_mediaControl)
    .rightEqualToView(_mediaControl)
    .topEqualToView(_mediaControl)
    .bottomEqualToView(_mediaControl);
    
    
    
    
    //顶部控制栏
    _topControlView = [[UIView alloc] init];
    
    _topControlView.backgroundColor = [UIColor clearColor];
    _topControlView.alpha = 0.8;
    [_controlOverlay addSubview:_topControlView];
    _topControlView.sd_layout
    .leftEqualToView(_controlOverlay)
    .rightEqualToView(_controlOverlay)
    .topEqualToView(_controlOverlay)
    .heightIs(40);/* 高度40，预留修改*/
    
    
    //退出按钮
    _playQuitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playQuitBtn setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    _playQuitBtn.backgroundColor = [UIColor blackColor];
    _playQuitBtn.alpha = 0.8;
    [_playQuitBtn addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
    [_topControlView addSubview:_playQuitBtn];
    _playQuitBtn.sd_layout
    .leftSpaceToView(_topControlView,10)
    .topEqualToView(_topControlView)
    .heightRatioToView(_topControlView,1.0f)
    .widthEqualToHeight();
    _playQuitBtn.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
    
    
    //文件名 、课程名
    _fileName = [[UILabel alloc] init ];
    _fileName.textAlignment = NSTextAlignmentCenter; //文字居中
    _fileName.textColor = [[UIColor alloc] initWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
    _fileName.font = [UIFont fontWithName:_fileName.font.fontName size:13.0];
    [_topControlView addSubview:_fileName];
    self.fileName.sd_layout
    .centerXEqualToView(_topControlView)
    .topEqualToView(_topControlView)
    .bottomEqualToView(_topControlView)
    .widthIs(screenWidth-100);
    
    
    
    //底部控制栏
    _bottomControlView = [[UIView alloc] initWithFrame:CGRectMake(0, screenWidth - 50, screenHeight, 50)];
    _bottomControlView.backgroundColor = [UIColor clearColor];
    _bottomControlView.alpha = 0.8;
    [_controlOverlay addSubview:_bottomControlView];
    _bottomControlView.sd_layout
    .leftEqualToView(_controlOverlay)
    .rightEqualToView(_controlOverlay)
    .bottomEqualToView(_controlOverlay)
    .heightIs(40);/* 边栏高度可变*/
    
    //播放按钮
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    _playBtn.backgroundColor = [UIColor blackColor];
    _playBtn.alpha = 0.8;
    //    [_playBtn addTarget:self action:@selector(onClickPlay:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomControlView addSubview:_playBtn];
    _playBtn.sd_layout
    .leftSpaceToView(_bottomControlView,0)
    .centerYEqualToView(_bottomControlView)
    .topSpaceToView(_bottomControlView,0)
    .bottomSpaceToView(_bottomControlView,0)
    .widthEqualToHeight();
    _playBtn.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
    
    
    //暂停按钮
    _pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pauseBtn setImage:[UIImage imageNamed:@"btn_player_play"] forState:UIControlStateNormal];
    _pauseBtn.backgroundColor = [UIColor blackColor];
    _pauseBtn.alpha = 0.8;
    //    [_pauseBtn addTarget:self action:@selector(onClickPause:) forControlEvents:UIControlEventTouchUpInside];
    _pauseBtn.hidden = YES;
    [_bottomControlView addSubview:_pauseBtn];
    _pauseBtn.sd_layout
    .leftEqualToView(_playBtn)
    .rightEqualToView(_playBtn)
    .topEqualToView(_playBtn)
    .bottomEqualToView(_playBtn);
    _pauseBtn.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
    
    
    //显示模式按钮
    _scaleModeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_scaleModeBtn setImage:[UIImage imageNamed:@"scale"] forState:UIControlStateNormal];
    if ([_mediaType isEqualToString:@"localAudio"]) {
        _scaleModeBtn.hidden = YES;
    }
    [_scaleModeBtn addTarget:self action:@selector(onClickScaleMode:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomControlView addSubview:_scaleModeBtn];
    self.scaleModeBtn.sd_layout
    .rightSpaceToView(self.bottomControlView,0)
    .topSpaceToView(self.bottomControlView,0)
    .bottomSpaceToView(self.bottomControlView,0)
    .widthEqualToHeight();
    _scaleModeBtn.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
    
    
    //切换屏幕按钮(上下切屏)
    _switchScreen = [[UIButton alloc]init];
    [_switchScreen setImage:[UIImage imageNamed:@"上下转换"] forState:UIControlStateNormal];
    _switchScreen.backgroundColor = [UIColor blackColor];
    _switchScreen.alpha = 0.8;
    [_bottomControlView addSubview:_switchScreen];
    _switchScreen.sd_layout
    .rightSpaceToView(_scaleModeBtn,0)
    .topSpaceToView(_bottomControlView,0)
    .bottomSpaceToView(_bottomControlView,0)
    .widthEqualToHeight();
    _switchScreen.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
    /* 切屏添加点击事件*/
    [_switchScreen addTarget:self action:@selector(switchBothScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    
    /* 平铺按钮 （平铺）*/
    _tileScreen= [[UIButton alloc]init];
    [_tileScreen setImage:[UIImage imageNamed:@"tile"] forState:UIControlStateNormal];
    _tileScreen.backgroundColor = [UIColor blackColor];
    _tileScreen.alpha = 0.8;
    [_bottomControlView addSubview:_tileScreen];
    _tileScreen.sd_layout
    .rightSpaceToView(_switchScreen,0)
    .topSpaceToView(_bottomControlView,0)
    .bottomSpaceToView(_bottomControlView,0)
    .widthEqualToHeight();
    _tileScreen.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
    /* 添加点击事件*/
    [_tileScreen addTarget:self action:@selector(changeLevels:) forControlEvents:UIControlEventTouchUpInside];
    
    
    /* 刷新按钮*/
    refresh_FS = [[UIButton alloc]init];
    [_bottomControlView addSubview:refresh_FS];
    refresh_FS.sd_layout
    .leftSpaceToView(_playBtn,10)
    .topEqualToView(_bottomControlView)
    .bottomEqualToView(_bottomControlView)
    .widthEqualToHeight();
    refresh_FS.hidden = YES;
    [refresh_FS setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    
    /* 刷新点击事件*/
    [refresh_FS addTarget:self action:@selector(refreshVideo:) forControlEvents:UIControlEventTouchUpInside];

 
    
}


/* 数据加载完成 播放器二次加载*/
- (void)reloadPlayerView{
    
    _liveplayerTeacher = [[NELivePlayerController alloc] initWithContentURL:_teacherPullAddress];
    
    if (_liveplayerTeacher == nil) {
        // 返回空则表示初始化失败
        NSLog(@"player initilize failed, please tay again!");
    }else{
        _liveplayerTeacher.view.sd_layout
        .leftEqualToView(_teacherPlayerView)
        .rightEqualToView(_teacherPlayerView)
        .topEqualToView(_teacherPlayerView)
        .bottomEqualToView(_teacherPlayerView);
    }
   
    _liveplayerBoard = [[NELivePlayerController alloc] initWithContentURL:_boardPullAddress];
    
    if (_liveplayerBoard == nil) {
        // 返回空则表示初始化失败
        NSLog(@"player initilize failed, please tay again!");
    }else{
        _liveplayerBoard.view.sd_layout
        .leftEqualToView(_boardPlayerView)
        .rightEqualToView(_boardPlayerView)
        .topEqualToView(_boardPlayerView)
        .bottomEqualToView(_boardPlayerView);
    }
    
    
    
    
    

}

#pragma mark- 加载弹幕

- (void)setupBarrage{
    
    /* 弹幕开关*/
    _barrage = [[UIButton alloc]init];
    _barrage.backgroundColor = [UIColor clearColor];
    [_bottomControlView addSubview:_barrage];
    [_barrage setImage:[UIImage imageNamed:@"barrage_on"] forState:UIControlStateNormal];
    //    _barrage.layer.borderColor = [UIColor whiteColor].CGColor;
    //    _barrage.layer.borderWidth = 0.8;
    [_barrage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _barrage.backgroundColor = [UIColor clearColor];
    _barrage.alpha = 0.8;
    _barrage.sd_layout
    .rightSpaceToView(_tileScreen,0)
    .heightRatioToView(_tileScreen,1.0)
    .topSpaceToView(_bottomControlView,0)
    .widthRatioToView(_tileScreen,1.0);
    /* 默认开启弹幕*/
    barrageRunning =YES;
    
    /* 弹幕按钮的点击事件*/
    [_barrage addTarget:self action:@selector(barragesSwitch) forControlEvents:UIControlEventTouchUpInside];
    
    


    
}




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
    
    isFullScreen = YES;
    
    /* 在全屏播放状态下*/
    /* 1、先添加弹幕*/
    /* 2、 添加控制层 并重新布局*/
    
    [_aBarrage.view removeFromSuperview];
    
    if (_boardPlayerView.becomeMainPlayer == YES) {
        
        [_boardPlayerView addSubview:_aBarrage.view];
        [_boardPlayerView bringSubviewToFront:_aBarrage.view];
        _aBarrage.view.hidden = NO;
//        [_aBarrage start];
        
        [self mediaControlTurnToFullScreenModeWithMainView:_boardPlayerView];
        
        
        
    }else if (_teacherPlayerView.becomeMainPlayer == YES){
        
        [_teacherPlayerView addSubview:_aBarrage.view];
        [_teacherPlayerView bringSubviewToFront:_aBarrage.view];
//        [_aBarrage start];
        _aBarrage.view.hidden = NO;
        
        [self mediaControlTurnToFullScreenModeWithMainView:_teacherPlayerView];
        
        
    }
    
   
    /* 全屏页面布局的变化*/
    
    refresh_FS .hidden = NO;
    _scaleModeBtn.hidden = YES;
    _tileScreen.hidden =YES;
    _barrageText.hidden = NO;
    
    

    
    
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


/* 刷新功能*/
- (void)refreshVideo:(id)sender{
    
    
    
}

#pragma mark- 切回竖屏后的监听

- (void)turnDownFullScreen:(NSNotification *)notification{
    
    
    isFullScreen = NO;
   
    /* 如果是在平级视图*/
    if (_viewsArrangementMode == SameLevel) {
        
        [_teacherPlayerView addSubview:_aBarrage.view];
        [_teacherPlayerView bringSubviewToFront:_aBarrage.view];
        
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
    
    refresh_FS.hidden = YES;
    
    _scaleModeBtn.hidden = NO;
    _tileScreen.hidden =NO;

    
    _barrageText.hidden = YES;
    
}



/* 控制层变成全屏模式的方法*/
- (void)mediaControlTurnToFullScreenModeWithMainView:(FJFloatingView *)playerView{
    
    [self.view bringSubviewToFront:_mediaControl];
    
    _mediaControl.hidden  = NO;
    
    _topControlView.backgroundColor = [UIColor blackColor];
    _topControlView.alpha = 0.8;
    
    _bottomControlView.backgroundColor = [UIColor blackColor];
    _bottomControlView.alpha = 0.8;
    
    [_mediaControl clearAutoHeigtSettings];
    _mediaControl.sd_layout
    .topEqualToView(playerView)
    .bottomEqualToView(playerView)
    .leftEqualToView(playerView)
    .rightEqualToView(playerView);
    [_mediaControl updateLayout];

    
}

/* 控制层切回竖屏模式的方法*/
- (void)mediaControlTurnDownFullScreenModeWithMainView:(FJFloatingView *)playerView{

    
    /* 取消延迟隐藏的delay selector*/
    if ([self performSelector:@selector(controlOverlayHide) ]) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlOverlayHide) object:nil];
    }
    
    /* 控制层取消所有响应*/
    [_mediaControl removeAllTargets];
    [_controlOverlay removeAllTargets];
    
    _controlOverlay.hidden = NO;
    
    _topControlView.backgroundColor = [UIColor clearColor];
    
    _bottomControlView.backgroundColor = [UIColor clearColor];
    
    _mediaControl.sd_resetNewLayout
    .topSpaceToView(self.view ,20)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .autoHeightRatio(9/16.0f);
    [_mediaControl updateLayout];
    
    [_switchScreen removeAllTargets];
    [_switchScreen addTarget:self action:@selector(switchBothScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    [_tileScreen removeAllTargets];
    [_tileScreen addTarget: self action:@selector(changeLevels:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
}





#pragma mark- 切换分屏(平铺)点击事件
- (void)changeLevels:(UIButton *)sender{
    
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
            
        }
        /* 条件2-2：如果教师是主视图*/
        else if(_teacherPlayerView.becomeMainPlayer == YES){
            /* 白板切换为副视图*/
            [self makeSecondPlayer:_boardPlayerView];
            [self changInfoViewsWithTopView:_boardPlayerView];
            [self changInfoViewContentSizeToSmall];

            
        }
    
        if (_viewsArrangementMode == SameLevel) {
            
        }else{
            
            _viewsArrangementMode = SameLevel;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"SameLevel" object:nil];
            
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
- (void)switchBothScreen:(UIButton *)sender{
    
    /* 条件1：如果现在是平级视图,白板和老师进行切换*/
    if (_viewsArrangementMode == SameLevel){
        [self changeArrangement];
        
    }
     /* 条件2：如果现在是非平级视图，两个非平级视图进行切换（大变小、小变大）*/
    if (_viewsArrangementMode == DifferentLevel){
        
        [self changePlayersMode];
    }
    
    
}

#pragma mark- 在非平级视图下切换两个视图（大变小、小变大）
- (void)changePlayersMode{
    
    
    /* 条件1：如果老师是主视图*/
    if (_boardPlayerView.becomeMainPlayer ==NO) {
        [self makeFirstPlayer:_boardPlayerView];
//        [self.view bringSubviewToFront:_boardPlayerView];

        [self changInfoViewsWithTopView:_boardPlayerView];
//        [self.view bringSubviewToFront:_mediaControl];

        [self makeFloatingPlayer:_teacherPlayerView];
    }
    
        /* 条件2 ：如果白板是主视图*/
        else if (_teacherPlayerView.becomeMainPlayer ==NO) {
            [self makeFirstPlayer:_teacherPlayerView];
//            [self.view bringSubviewToFront:_teacherPlayerView];
            
            [self changInfoViewsWithTopView:_teacherPlayerView];
//            [self.view bringSubviewToFront:_mediaControl];

            [self makeFloatingPlayer:_boardPlayerView];
    
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
    playerView.sd_layout
    .topSpaceToView (self.view,20)
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
    .topSpaceToView (self.view,CGRectGetWidth(self.view.frame)/16*9.0+20)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .autoHeightRatio(9/16.0f);
    [playerView updateLayout];
    
    [self.view bringSubviewToFront:_mediaControl];
    
}

/* 变成可移动视图*/
- (void)makeFloatingPlayer:(FJFloatingView *)playerView{
    
    playerView.becomeMainPlayer = NO;
    playerView.canMove = YES;
    [playerView addGestureRecognizer:playerView.pan];
        [playerView sd_clearAutoLayoutSettings];
    /* 副视图变小*/
    dispatch_queue_t small = dispatch_queue_create("small", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(small, ^{
        
        playerView.sd_layout
        .topSpaceToView(self.view,20)
        .leftEqualToView(self.view)
        .widthRatioToView(self.view,2/5.0f)
        .autoHeightRatio(9/16.0);
    });
    
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


/* 变成横屏*/
- (void)turnToFullScreenMode:(FJFloatingView *)playerView{
    
    [_mediaControl addTarget:self action:@selector(onClickMediaControl:) forControlEvents:UIControlEventTouchUpInside];
    [_controlOverlay addTarget:self action:@selector(onClickOverlay:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [playerView sd_clearAutoLayoutSettings];
    playerView.sd_layout
    .topEqualToView(self.view)
    .bottomEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view);
    
    
    
    
}








- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    NSLog(@"Version = %@", [self.liveplayerTeacher getSDKVersion]);
    [self.liveplayerTeacher isLogToFile:YES];
    [self.liveplayerBoard isLogToFile:YES];
    
    
    /* 白板播放器的设置*/
    [self.liveplayerBoard setBufferStrategy:NELPLowDelay]; //直播低延时模式
    [self.liveplayerBoard setScalingMode:NELPMovieScalingModeAspectFit]; //设置画面显示模式，默认原始大小
    [self.liveplayerBoard setShouldAutoplay:NO]; //设置prepareToPlay完成后是否自动播放
    [self.liveplayerBoard setHardwareDecoder:isHardware]; //设置解码模式，是否开启硬件解码
    [self.liveplayerBoard setPauseInBackground:NO]; //设置切入后台时的状态，暂停还是继续播放
    [self.liveplayerBoard prepareToPlay]; //初始化视频文件
    
    /* 教师播放器的设置*/
    [self.liveplayerTeacher setBufferStrategy:NELPLowDelay]; //直播低延时模式
    [self.liveplayerTeacher setScalingMode:NELPMovieScalingModeAspectFit]; //设置画面显示模式，默认原始大小
    [self.liveplayerTeacher setShouldAutoplay:NO]; //设置prepareToPlay完成后是否自动播放
    [self.liveplayerTeacher setHardwareDecoder:isHardware]; //设置解码模式，是否开启硬件解码
    [self.liveplayerTeacher setPauseInBackground:NO]; //设置切入后台时的状态，暂停还是继续播放
    [self.liveplayerTeacher prepareToPlay]; //初始化视频文件
    
    
    
    
    
    
    
    
    
    
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
    
    /* 干掉runloop*/
    [_runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate date]];
    [_runLoop runUntilDate:[NSDate date]];
    
    
}

/* 是否支持自动转屏*/
- (BOOL)shouldAutorotate
{
    return YES;
}

/* 默认的屏幕方向*/
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}


// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


//显示模式转换
- (void)onClickScaleMode:(id)sender
{
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

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
   
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

//全屏播放视频后，播放器的适配和全屏旋转
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    
    /* 切换到竖屏*/
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self.scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale01"] forState:UIControlStateNormal];
        self.scaleModeBtn.titleLabel.tag = 0;
        
        [self.view updateLayout];
        [self.view layoutIfNeeded];
        
        
        
        
        //谁是主视图，谁就恢复到主屏
        if (_boardPlayerView.becomeMainPlayer == YES) {
            
            
            
            [self.view addSubview:_teacherPlayerView];
            
            [self makeFirstPlayer:_boardPlayerView];
            if (_viewsArrangementMode == SameLevel) {
                

            }
            if (_viewsArrangementMode == DifferentLevel){
                
                [self makeFloatingPlayer:_teacherPlayerView];
            }
            
      
            
            
        }else if(_teacherPlayerView.becomeMainPlayer == YES){
            
            [self.view addSubview:_boardPlayerView];
            
            [self makeFirstPlayer:_teacherPlayerView];
            if (_viewsArrangementMode == SameLevel) {
                
                
            }
            if (_viewsArrangementMode == DifferentLevel){
                
                [self makeFloatingPlayer:_boardPlayerView];
            }
            
          

        }
        

        [[NSNotificationCenter defaultCenter]postNotificationName:@"TurnDownFullScreen" object:nil];
        
        
    }
    
    /* 切换到横屏*/
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.view.backgroundColor = [UIColor blackColor];
        [self.scaleModeBtn setImage:[UIImage imageNamed:@"btn_player_scale02"] forState:UIControlStateNormal];
        self.scaleModeBtn.titleLabel.tag = 1;
        
        
        //        谁是主视图，谁就全屏
        
        if (_boardPlayerView.becomeMainPlayer == YES) {
            
            [self.view sendSubviewToBack:_videoInfoView];
            [self turnToFullScreenMode:_boardPlayerView];
            [_teacherPlayerView removeFromSuperview];
            [_boardPlayerView updateLayout];
            [_teacherPlayerView updateLayout];

            
            
        }else if(_teacherPlayerView.becomeMainPlayer == YES){
            [self.view sendSubviewToBack:_videoInfoView];
            [self turnToFullScreenMode:_teacherPlayerView];
            [_boardPlayerView removeFromSuperview];
            [_boardPlayerView updateLayout];
            [_teacherPlayerView updateLayout];

            
        }

        
        /* 全屏状态  发送消息通知*/
        [[NSNotificationCenter defaultCenter]postNotificationName:@"FullScreen" object:nil];
       
        
        
        
    }
}






#pragma mark - IBAction

//退出播放
- (void)onClickBack:(id)sender
{
    /* 非屏状态下的点击事件*/
    if (isFullScreen == NO) {
        
        [self.navigationController popViewControllerAnimated:YES];
        [self.rdv_tabBarController setTabBarHidden:NO animated:NO];
        
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
- (void)onClickPlay:(id)sender
{
    NSLog(@"click Play");
    
    [self.liveplayerBoard play];
    [self.liveplayerTeacher play];
    
    
    [self syncUIStatus:NO];
}

//暂停播放
- (void)onClickPause:(id)sender
{
    NSLog(@"click pause");
    [self.liveplayerBoard pause];
    [self.liveplayerTeacher pause];
    [self syncUIStatus:NO];
}






//触摸overlay
- (void)onClickOverlay:(id)sender
{
    NSLog(@"click overlay");
        self.controlOverlay.hidden = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlOverlayHide) object:nil];
    
     [_barrageText.TextViewInput resignFirstResponder];
}

- (void)onClickMediaControl:(id)sender
{
    NSLog(@"click mediacontrol");
    self.controlOverlay.hidden = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlOverlayHide) object:nil];
    [self syncUIStatus:NO];
   
    [self performSelector:@selector(controlOverlayHide) withObject:nil afterDelay:5];
    
}

- (void)controlOverlayHide
{
    self.controlOverlay.hidden = YES;
    NSLog(@"控制栏隐藏了");
}

- (void)syncUIStatus:(BOOL)isSync
{
   
    
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

- (void)NELivePlayerDidPreparedToPlay:(NSNotification*)notification
{
    //add some methods
    NSLog(@"NELivePlayerDidPreparedToPlay");
    [self syncUIStatus:NO];
    
//    [self.liveplayerBoard play]; //开始播放
//    [self.liveplayerTeacher play]; //开始播放
}


#pragma mark- 直播结束的回调
- (void)NELivePlayerPlayBackFinished:(NSNotification*)notification
{
    
    
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
            
        case NELPMovieFinishReasonPlaybackError:
            /* 播放错误导致失败的回调*/
            alertController = [UIAlertController alertControllerWithTitle:@"注意" message:@"播放失败" preferredStyle:UIAlertControllerStyleAlert];
            action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
            break;
            
        case NELPMovieFinishReasonUserExited:
            break;
            
        default:
            break;
    }
}

- (void)NELivePlayerFirstVideoDisplayed:(NSNotification*)notification
{
    NSLog(@"first video frame rendered!");
}

- (void)NELivePlayerFirstAudioDisplayed:(NSNotification*)notification
{
    NSLog(@"first audio frame rendered!");
}

- (void)NELivePlayerVideoParseError:(NSNotification*)notification
{
    NSLog(@"video parse error!");
}

- (void)NELivePlayerReleaseSuccess:(NSNotification*)notification
{
    NSLog(@"resource release success!!!");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerReleaseSueecssNotification object:_liveplayerTeacher];
      [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerReleaseSueecssNotification object:_liveplayerBoard];
}






#pragma mark- 以上是播放器的初始化和配置方法、接口等

#pragma mark- 下为页面数据及逻辑等

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    /* 建立会话消息*/
    _session = [NIMSession session:@"7962752" type:NIMSessionTypeTeam];
    
    
    /* TabBar单例隐藏*/
    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
    
    
    /* 播放器的监听*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerDidPreparedToPlay:) name:NELivePlayerDidPreparedToPlayNotification object:_liveplayerTeacher];
    
    
    /* 白板播放端的通知*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerPlayBackFinished:) name:NELivePlayerPlaybackFinishedNotification object:_liveplayerBoard];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerFirstVideoDisplayed:) name:NELivePlayerFirstVideoDisplayedNotification object:_liveplayerBoard];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerFirstAudioDisplayed:) name:NELivePlayerFirstAudioDisplayedNotification object:_liveplayerBoard];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerReleaseSuccess:) name:NELivePlayerReleaseSueecssNotification object:_liveplayerBoard];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerVideoParseError:) name:NELivePlayerVideoParseErrorNotification object:_liveplayerBoard];
    
    /* 老师播放端的通知*/
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerPlayBackFinished:) name:NELivePlayerPlaybackFinishedNotification object:_liveplayerTeacher];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerFirstVideoDisplayed:) name:NELivePlayerFirstVideoDisplayedNotification object:_liveplayerTeacher];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerFirstAudioDisplayed:) name:NELivePlayerFirstAudioDisplayedNotification object:_liveplayerTeacher];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerReleaseSuccess:) name:NELivePlayerReleaseSueecssNotification object:_liveplayerTeacher];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NELivePlayerVideoParseError:) name:NELivePlayerVideoParseErrorNotification object:_liveplayerTeacher];
    
    
    /* 监听白板播放端是否可以移动*/
    [_boardPlayerView addObserver:self forKeyPath:@"canMove" options:NSKeyValueObservingOptionNew context:nil];
    
    /* 监听老师播放端是否可以移动*/
    [_teacherPlayerView addObserver:self forKeyPath:@"canMove" options:NSKeyValueObservingOptionNew context:nil];
    
    
    
    #pragma mark- 加载课程数据请求
    /* 根据token和传来的id 发送课程内容请求。*/
    
    dispatch_queue_t requestQueue = dispatch_queue_create("request", DISPATCH_QUEUE_SERIAL);
    dispatch_async(requestQueue, ^{
        
        [self requestClassInfo];
        
    }) ;

    
    
    
    
    
   
    
    
    
    ////////////////////////////////////
    
#pragma mark- 以下是页面和功能逻辑
    
    
    /* 取出token*/
    
    _remember_token=[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"];
//        测试用id
//        _classID = @"25" ;
    
#pragma mark- 课程信息视图
    
    _videoInfoView = [[VideoInfoView alloc]init];
    [self.view addSubview:_videoInfoView];
    _videoInfoView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.teacherPlayerView,0)
    .bottomSpaceToView(self.view,0);
    
    _videoInfoView.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*4, [UIScreen mainScreen].bounds.size.height -  [UIScreen mainScreen].bounds.size.width*9/16.0f*2-30-4-20);
    
    
    typeof(self) __weak weakSelf = self;
    [ _videoInfoView.segmentControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.videoInfoView.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.view.bounds) * index, 0, CGRectGetWidth(weakSelf.view.bounds), CGRectGetHeight(weakSelf.view.frame)-64-49) animated:YES];
    }];
    
    _videoInfoView.scrollView.delegate = self;
    _videoInfoView.segmentControl.selectedSegmentIndex =0;
    _videoInfoView.segmentControl.selectionIndicatorHeight =2.0f;
    _videoInfoView.scrollView.bounces=NO;
    _videoInfoView.scrollView.alwaysBounceVertical=NO;
    _videoInfoView.scrollView.alwaysBounceHorizontal=NO;
    
    [_videoInfoView.scrollView scrollRectToVisible:CGRectMake(-CGRectGetWidth(self.view.bounds), 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) animated:YES];
    
    _videoInfoView.noticeTabelView.tag =1;
    _videoInfoView.noticeTabelView .delegate = self;
    _videoInfoView.noticeTabelView.dataSource = self;
    
    
    
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
    
    
    
    
    _infoHeaderView = [[InfoHeaderView alloc]initWithFrame:CGRectMake(0, 0, _videoInfoView.view3.frame.size.width, 800)];
    
    /* 加入高度变化的监听*/
    [self addObserver:self forKeyPath:@"headerHeight" options:NSKeyValueObservingOptionNew context:nil];
    
    
    _classList.classListTableView.tableHeaderView = _infoHeaderView;
    
    
    
    
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
    

    /* 中间的筛选后的 那个view*/
    self.sectionTitleView = ({
        UILabel *sectionTitleView = [[UILabel alloc] initWithFrame:CGRectMake((APP_WIDTH-100)/2, (APP_HEIGHT-100)/2,100,100)];
        sectionTitleView.textAlignment = NSTextAlignmentCenter;
        sectionTitleView.font = [UIFont boldSystemFontOfSize:60];
        sectionTitleView.textColor = [UIColor blueColor];
        sectionTitleView.backgroundColor = [UIColor whiteColor];
        sectionTitleView.layer.cornerRadius = 6;
        sectionTitleView.layer.borderWidth = 1.f/[UIScreen mainScreen].scale;
        _sectionTitleView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        sectionTitleView.shadowColor = [UIColor blackColor];
        sectionTitleView.shadowOffset = CGSizeMake(10, 10);
        sectionTitleView;
    });
    [self.navigationController.view addSubview:self.sectionTitleView];
    self.sectionTitleView.hidden = YES;

    
    
    
    
    
    
    
    // 监听表情键盘的弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    
    
#pragma mark- 聊天UI初始化
    
    [self addRefreshViews];
    [self loadBaseViewsAndData];
    
    
#pragma mark- 自定义表情包的名字初始化

  NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"emotionToText" ofType:@"plist"];
    
    NSDictionary *dat  = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    NSLog(@"%@",dat);
   
    
    _faces = [NSMutableArray arrayWithArray:[dat allValues]];
    
    
    
    
    
#pragma mark- 聊天功能初始化和自动登录
    /* 取出存储的chatAccount*/
    _chat_Account =[Chat_Account yy_modelWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"chat_account"]];
    
    
    //APP主动发起自动登录
    [[[NIMSDK sharedSDK] loginManager] login:_chat_Account.accid token:_chat_Account.token completion:^(NSError *error) {
        NSLog(@"%@",error);
        if (error == NULL) {
            
            
            
            
        }
        
    }];
    
    /* 白板视图放到subview数组里最上一层*/
    //    [self.view bringSubviewToFront:_boardPlayerView];
    
    
    
    
    
    
    #pragma mark- 视频播放状态查询功能
    
    
    /* 每隔30秒请求一次数据*/
    
//    [self requestPullStatus];
    
    [self checkVideoStatus];
    
    
    
    
    
    
    
}





-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    //增加监听，当键盘出现或改变时收出消息
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShow:)
     
                                                 name:UIKeyboardWillShowNotification
     
                                               object:nil];
    
    
    
    //增加监听，当键退出时收出消息
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillHide:)
     
                                                 name:UIKeyboardWillHideNotification
     
                                               object:nil];
    
    
    
    
/* 请求历史聊天记录*/
    /* 该方法目前有bug*/
//    [self requestHistoryChatList];
    
    
    /* 给聊天页面添加下拉方法*/
   MJRefreshStateHeader *header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
       
//       聊天页面的下拉刷新，也是请求历史数据
       [self requestHistoryChatList];
       
       
   }];
  
    
    _chatTableView.mj_header = header;
    
 
    
    
    
}



#pragma mark- 请求历史数据的方法

- (void)requestHistoryChatList{
    
    NIMHistoryMessageSearchOption *historyOption = [[NIMHistoryMessageSearchOption  alloc]init];
    historyOption.limit = 100;
    historyOption.order = NIMMessageSearchOrderDesc;
    
    
    /* 获取聊天的历史消息*/
    
    
    [[NIMSDK sharedSDK].conversationManager fetchMessageHistory:_session option:historyOption result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
        
        /* 取出云信的accid和token进行字段比较 ，判断是谁发的消息*/
        
        for (NIMMessage *message in messages) {
            
            NSLog(@"%@",message.from);
            NSLog(@"%@",_chat_Account.token);
            
            
            
            /* 如果消息是自己发的*/
            if ([message.from isEqualToString:_chat_Account.accid]) {
                /* 在本地创建自己的消息*/
                
                NSString *title = message.text;
                
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
                NSLog(@"%@",resultArray);
                
                
                
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
                    
                    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.size alignToFont:[UIFont systemFontOfSize:12] alignment:YYTextVerticalAlignmentCenter];
                    
                    
                    
                    [text replaceCharactersInRange:[names [i][@"range"] rangeValue] withAttributedString:attachText];
                    
                    title = [title stringByReplacingCharactersInRange:[names [i][@"range"] rangeValue] withString:[names[i]valueForKey:@"name"]];
                }
                
                
                
                if (title ==nil) {
                    title = @"";
                }
                
                
                NSDictionary *dic = @{@"strContent": title,
                                      @"type": @(UUMessageTypeText),
                                      @"frome":@(UUMessageFromMe)};
                
                NSLog(@"%@",title);
                [self dealTheFunctionData:dic];
                
                
                
                
            }
            
            /* 如果消息是别人发的 */
            else{
                
                
                
                NSLog(@"%@",message.senderName);
                
                
                
                
                /* 在本地创建对方的消息消息*/
                NSString *iconURL = @"".mutableCopy;
                
                
                if (_chatList.count!=0) {
                    
                    for (int p = 0; p < _chatList.count; p++) {
                        
                        Chat_Account *temp = [Chat_Account yy_modelWithJSON:_chatList[p]];
                        
                        NSLog(@"%@",temp.name);
                        
                        if ([temp.name isEqualToString:message.senderName]) {
                            iconURL = temp.icon;
                            
                        }
                    }
                    
                }
                
                //            NSLog(@"%@",iconURL);
                NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self.chatModel getDicWithText:message.text andName:message.senderName andIcon:@"www.baidu.com"]];
                
                
                //        [self makeOthersMessageWith:1 andMessage:message];
                [self.chatModel.dataSource addObjectsFromArray:[self.chatModel additems:1 withDictionary:dic]];
                
                [self.chatTableView reloadData];
                [self tableViewScrollToBottom];
                
                
                
                //                /* 同时发送弹幕*/
                //
                //                [self sendBarrage:message.text withAttibute:nil];
            }
            
        }
    }];
    
    
    
}


/* 键盘出现*/

- (void)keyboardWillShow:(NSNotification *)aNotification{
    
    //获取键盘高度
    
    NSDictionary *info = [aNotification userInfo];
    
    //获取动画时间
    
    float duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //获取动画开始状态的frame
    
    CGRect beginRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    //获取动画结束状态的frame
    
    CGRect endRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    //计算高度差
    
    CGFloat offsety =  endRect.origin.y - beginRect.origin.y ;
    
    NSLog(@"键盘高度:%f 高度差:%f\n",beginRect.origin.y,offsety);
    
    
    /* 全屏播放界面*/
    if (isFullScreen) {
        
        CGRect fileRect = self.view.frame;
        
        fileRect.origin.y += offsety;
        
        //下面的动画，整个View上移动
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.view.frame = fileRect;
            
        }];
    }
    
    
    
    
    dispatch_queue_t keyboard = dispatch_queue_create("keyBoard", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(keyboard, ^{
        
        [UIView animateWithDuration:duration animations:^{
            
            NSLog(@"%@",[NSThread currentThread]);
            _chatTableView.sd_layout
            .topEqualToView(_videoInfoView.view2)
            .leftEqualToView(_videoInfoView.view2)
            .rightEqualToView(_videoInfoView.view2)
            .bottomSpaceToView(_videoInfoView.view2,-offsety+46);
            
            [self tableViewScrollToBottom];
            
            IFView.sd_layout
            .bottomSpaceToView(_videoInfoView.view2,-offsety);
            
            
            [_chatTableView updateLayout];
            [IFView updateLayout];
            
            
        }];
        
        
        
    });
    
    
    
#pragma mark- 非主视频播放器变化尺寸，segment刷新尺寸
    
    /* 如果白板是主视频播放器*/
    if (_boardPlayerView.becomeMainPlayer == YES) {
        
        
        
        
    }
    
    
    
}

/* 键盘隐藏*/
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    
    if (isFullScreen) {
        [self.view setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    }
    
    
    
    
    [UIView animateWithDuration:0.8 animations:^{
        
        _chatTableView.sd_layout
        .topEqualToView(_videoInfoView.view2)
        .leftEqualToView(_videoInfoView.view2)
        .rightEqualToView(_videoInfoView.view2)
        .bottomSpaceToView(_videoInfoView.view2,46);
        
        [self tableViewScrollToBottom];
        
        IFView.sd_layout
        .bottomSpaceToView(_videoInfoView.view2,0);
        
        
        [_chatTableView updateLayout];
        [IFView updateLayout];
        
        
        
    }];
    
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


#pragma mark- 聊天功能的方法









/* 添加刷新view*/
- (void)addRefreshViews
{
    __weak typeof(self) weakSelf = self;
    
    //load more
    int pageNum = 3;
    
    _head = [MJRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf.chatModel addRandomItemsToDataSource:pageNum];
        
        if (weakSelf.chatModel.dataSource.count > pageNum) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:pageNum inSection:0];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.chatTableView reloadData];
                [weakSelf.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            });
        }
        [weakSelf.head endRefreshing];
    }];
    _chatTableView.mj_header = _head;
    
}

/* 读取聊天数据数据*/
- (void)loadBaseViewsAndData
{
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
    
    
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}



//聊天页面tableView 滚动到底部
- (void)tableViewScrollToBottom
{
    if (self.chatModel.dataSource.count==0)
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark - 聊天页面 发送聊天信息的回调
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message
{
    

    
    
   NSLog(@"%@", [funcView.TextViewInput.attributedText getPlainString]);
    
    
    NSDictionary *dic = @{@"strContent": [funcView.TextViewInput.attributedText getPlainString],
                          @"type": @(UUMessageTypeText),
                          @"frome":@(UUMessageFromMe)};

//    [funcView changeSendBtnWithPhoto:YES];
    [self dealTheFunctionData:dic];
    
    NIMMessage * text_message = [[NIMMessage alloc] init];
    text_message.text = [funcView.TextViewInput.attributedText getPlainString];
    text_message.messageObject = NIMMessageTypeText;
    text_message.apnsContent = @"发来了一条消息";
    
    /* 解析发送的字符串*/
    
    NSString *title = text_message.text;
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
        
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.size alignToFont:[UIFont systemFontOfSize:12] alignment:YYTextVerticalAlignmentCenter];
        
        
        
        [text replaceCharactersInRange:[names [i][@"range"] rangeValue] withAttributedString:attachText];
        
        
        title  = [title stringByReplacingCharactersInRange:[names [i][@"range"] rangeValue] withString:[names[i] valueForKey:@"name"]];
        
    }
    
    text_message.text = title;
    
    
    
    
    
    
    //发送消息
    
    [[NIMSDK sharedSDK].chatManager sendMessage:text_message toSession:_session error:nil];
    
    
    
    //    [[[NIMSDK sharedSDK] chatManager] addDelegate:self];
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    
    
    
    #pragma mark- 发消息的同时发弹幕
    
    /* 发弹幕*/
    [self sendBarrage:barragTitle withAttibute:text];
    
    [IFView.TextViewInput setText:@""];
    [IFView.TextViewInput resignFirstResponder];
    
    
    
}











// 获取表情字符串
- (NSString *)emotionText:(UITextView *)textView
{
    
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



#pragma mark- 发弹幕方法
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
            [_teacherPlayerView bringSubviewToFront:_aBarrage.view];
            
        }else{
            
            [_aBarrage.view removeFromSuperview];
            
        }
        
        
        /* 在全屏的条件下*/
    }else{
        
        if (_boardPlayerView .becomeMainPlayer == YES) {
            [_aBarrage.view removeFromSuperview];
            
            [_boardPlayerView addSubview:_aBarrage.view];
            [_boardPlayerView bringSubviewToFront:_aBarrage.view];
            
        }else if (_teacherPlayerView.becomeMainPlayer == YES){
            
             [_teacherPlayerView addSubview:_aBarrage.view];
            [_teacherPlayerView bringSubviewToFront:_aBarrage.view];
        }
        
    }
    
    
    _descriptor.spriteName = NSStringFromClass(BarrageWalkTextSprite.self);
    _descriptor.params[@"text"] =message;
    _descriptor.params[@"textColor"] = [UIColor whiteColor];  //弹幕颜色
    _descriptor.params[@"side"] = BarrageWalkSideDefault;
    _descriptor.params[@"speed"] = @60;
    _descriptor.params[@"attributedText"] = attribute;
    
    if (isFullScreen) {
        _descriptor.params[@"fontSize"]= @22;
    }else{
        
    }
    
    
    
    _descriptor.params[@"direction"] = @(BarrageWalkDirectionR2L);
    
    if (isFullScreen) {
        
        _aBarrage.canvasMargin = UIEdgeInsetsMake(30, 0, CGRectGetHeight(self.view.frame)/3.0f, 0);
        
    }else if (!isFullScreen){
    _aBarrage.canvasMargin = UIEdgeInsetsMake(30, 0, (CGRectGetWidth(self.view.frame)/16*9.0f)/3.0f, 0);
    }
    
    [_aBarrage receive:_descriptor];
    
    
    [_aBarrage start];
    
    
}


/* 发送消息成功的回调*/

- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(nullable NSError *)error{
    
    NSLog(@"%@",message.text);
    
    
    NSLog(@"%@",error);
    
    
}

/* 获取到消息的回调*/

- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages{
    
    for (int i = 0; i<messages.count; i++) {
        NSString *iconURL = @"".mutableCopy;
        
        
        NSLog(@"%@",messages[i]);
        NSLog(@"%@",messages[i].senderName);
        
        if (_chatList.count!=0) {
            
            for (int p = 0; p < _chatList.count; p++) {
                
                Chat_Account *temp = [Chat_Account yy_modelWithJSON:_chatList[p]];
                
                NSLog(@"%@",temp.name);
                
                if ([temp.name isEqualToString:messages[i].senderName]) {
                    iconURL = temp.icon;
                    
                }
            }
            
        }
        
        
        /* 在本地创建对方的消息消息*/
        
        NSLog(@"%@",iconURL);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self.chatModel getDicWithText:messages[i].text andName:messages[i].senderName andIcon:iconURL]];
        
        
        //        [self makeOthersMessageWith:1 andMessage:message];
        [self.chatModel.dataSource addObjectsFromArray:[self.chatModel additems:1 withDictionary:dic]];
        
        [self.chatTableView reloadData];
        [self tableViewScrollToBottom];
        
        
        
        /* 同时发送弹幕*/
        
        [self sendBarrage:messages[i].text withAttibute:nil];
        
    }
    
    
    
    
}


/* 接收到消息后 ，在本地创建消息*/
- (void)makeOthersMessageWith:(NSInteger)msgNum andMessage:(UUMessage *)message{
    
    [self.chatModel.dataSource addObject:message];
    
    
    
}


- (BOOL)fetchMessageAttachment:(NIMMessage *)message error:(NSError **)error{
    
    
    return YES;
}




#pragma mark- 聊天ui的设置
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image
{
    NSDictionary *dic = @{@"picture": image,
                          @"type": @(UUMessageTypePicture)};
    [self dealTheFunctionData:dic];
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second
{
    NSDictionary *dic = @{@"voice": voice,
                          @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)second],
                          @"type": @(UUMessageTypeVoice)};
    [self dealTheFunctionData:dic];
}

- (void)dealTheFunctionData:(NSDictionary *)dic
{
    [self.chatModel addSpecifiedItem:dic andIconURL:_chat_Account.icon andName:_chat_Account.name ];/* 重写了UUMolde的添加自己的item方法 */
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}





#pragma mark- 请求课程和和内容
- (void)requestClassInfo{
    
    NSLog(@"%@",_classID);
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_remember_token forHTTPHeaderField:@"Remember-Token"];
    
    [manager GET:[NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/live_studio/courses/%@/play_info",_classID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSString *status = [NSString stringWithFormat:@"%@",[dic valueForKey:@"status"]];
        
        NSLog(@"%@",dic);
        
        
        if (![status isEqualToString:@"1"]) {
            
        }else{
            //        使用yymodel解
            _noticeAndMembers = [NoticeAndMembers yy_modelWithDictionary:dic[@"data"]];
            NSLog(@"%@,@%@",_noticeAndMembers.announcements,_noticeAndMembers.members);
            
            _noticesArr=[_noticeAndMembers valueForKey:@"announcements"];
            
            NSLog(@"%@",_noticesArr);
            
            
            _membersArr = [_noticeAndMembers valueForKey:@"members"];
            
            for (int i = 0; i<_membersArr.count; i++) {
                
                NSString *nameStr =[NSString stringWithFormat: @"%@", [_membersArr[i] valueForKey:@"name"]];
                
                if (membersName) {
                    
                    [membersName addObject:nameStr];
                    
                }
            }
            /* 刷新通知信息*/
            [self updateViewsNotice];
            
            /* 刷新在线用户列表*/
            
            [self updateMembersList];
            
            
        }
        
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:_remember_token forHTTPHeaderField:@"Remember-Token"];
        [manager GET:[NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/live_studio/courses/%@/play_info",_classID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSString *status = [NSString stringWithFormat:@"%@",[dic valueForKey:@"status"]];
            
            NSDictionary *dataDic=[NSDictionary dictionaryWithDictionary:dic[@"data"]];
            
            NSLog(@"%@",dic);
            
            if (![status isEqualToString:@"1"]) {
                /* 请求错误*/
                
            }else{
                
                /* 解析 课程 数据*/
                _videoClassInfo = [VideoClassInfo yy_modelWithDictionary:dataDic];
                //                _classes = [Classes yy_modelWithJSON:dataDic[@"lessons"]];
                
                /* 解析 教师 数据*/
                _teacher = [Teacher yy_modelWithDictionary:dataDic[@"teacher"]];
                //
                /* 解析 聊天成员 数据*/
                
                _chatList = dataDic[@"chat_team"][@"accounts"];
                NSLog(@"%@",_chatList);
                
                
                
                /* 保存课程信息*/
                _classesArr = dataDic[@"lessons"];
                
                NSLog(@"%@",_videoClassInfo);
                _videoClassInfo.classID = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"id"]];
                
                _videoClassInfo.classDescription = [NSString  stringWithFormat:@"%@",[dataDic valueForKey:@"description"]];
                
                /* 课程图的信息赋值*/
                _infoHeaderView.classNameLabel.text = _videoClassInfo.name;
                _infoHeaderView.gradeLabel.text = _videoClassInfo.grade;
                _infoHeaderView.completed_conunt.text = _videoClassInfo.completed_lesson_count;
                _infoHeaderView.classCount.text = _videoClassInfo.lesson_count;
                _infoHeaderView.subjectLabel.text = _videoClassInfo.subject;
                _infoHeaderView.onlineVideoLabel.text = _videoClassInfo.status;
                _infoHeaderView.liveStartTimeLabel.text = _videoClassInfo.live_start_time;
                _infoHeaderView.liveEndTimeLabel.text = _videoClassInfo.live_end_time;
                _infoHeaderView.classDescriptionLabel.text = _videoClassInfo.classDescription;
                
                
                /* 教师信息 赋值*/
                _infoHeaderView.teacherNameLabel.text =_teacher.name;
                _infoHeaderView.teaching_year.text = _teacher.teaching_years;
                _infoHeaderView.workPlace .text = _teacher.school;
                [_infoHeaderView.teacherHeadImage sd_setImageWithURL:[NSURL URLWithString:_teacher.avatar_url]];
                _infoHeaderView.selfInterview.text = _teacher.desc;
                
                
                [_infoHeaderView layoutIfNeeded];
                
                
                
                /* 自动赋值高度*/
                
                NSNumber *height =[NSNumber numberWithFloat: _infoHeaderView.layoutLine.frame.origin.y];
                
                [self setValue:height forKey:@"headerHeight"];
                
                [self updateViewsInfos];
                
                
//                在这里可以修改播放器的播放地址.
                /* 
                 *
                 *
                 *
                 *
                 *
                 *
                 */
                
                if (dataDic) {
                    
                    /* 已经试听过*/
                    if ([dataDic[@"tasted"]boolValue ]==YES) {
                        
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已试听过该课程!" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            
                        }] ;
                        
                        
                        [alert addAction:sure];
                        
                        [self presentViewController:alert animated:YES completion:nil];

                        
                    }else{
                       
                        /* 未试听过*/
                        
                        if (dataDic[@"camera_pull_stream"]==nil||[dataDic[@"camera_pull_stream"]isEqual:@""]||[dataDic[@"camera_pull_stream"] isEqual:[NSNull null]]) {
                            
                            _teacherPullAddress =[NSURL URLWithString:@""];
                        }else{
                            _teacherPullAddress =[NSURL URLWithString:dataDic[@"camera_pull_stream"]];
                        }
                        
                        _boardPullAddress = [NSURL URLWithString:dataDic[@"board_pull_stream"]];
                        
                        
                        
                        /* 重新加载播放器*/
                        [self reloadPlayerView];
                        
                    }
                    
                    
                    
                    
                }
                
                
                
                
                
                
                
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
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
        
        [_infoHeaderView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), headerHeight)];
        
        _classList.classListTableView.tableHeaderView =_infoHeaderView;
        
        _classList.classListTableView.tableHeaderView.height_sd =headerHeight;
        
        NSLog(@"%@", [_classList.classListTableView.tableHeaderView valueForKey:@"frame"]);
        
        
        NSLog(@"%f", _infoHeaderView.layoutLine.autoHeight);
        
        NSLog(@"%@",[_infoHeaderView.workPlace valueForKey:@"frame"]);
        NSLog(@"%@",[_infoHeaderView.layoutLine valueForKey:@"frame"]);
        
        
        
        [self updateViewsInfos];
    }
    
    
}

/* 刷新在线用户列表*/
- (void)updateMembersList{
    
    if (membersName.count!=0) {
        
        NSLog(@"%@",membersName);
        
        self.indexArray = [ChineseString IndexArray:membersName];
        self.letterResultArr = [ChineseString LetterSortArray:membersName];
        
        [self updateMemberListViews];
        
    }
    
}





/* tableview刷新视图*/

- (void)updateViewsNotice{
    
    [_videoInfoView.noticeTabelView reloadData];
    [_videoInfoView.noticeTabelView setNeedsDisplay];
    [_videoInfoView.noticeTabelView setNeedsLayout];
    
}

- (void)updateViewsInfos{
    
    
    [_classList.classListTableView reloadData];
    [_classList.classListTableView  setNeedsDisplay];
    [_classList.classListTableView  setNeedsLayout];
    
    
}

- (void)updateMemberListViews{
    [_memberListView.memberListTableView reloadData];
//    [_memberListView.memberListTableView setNeedsLayout];
//    [_memberListView.memberListTableView setNeedsDisplay];
    
    
}




#pragma mark- tableview的代理方法


-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    NSArray *arr = @[].mutableCopy;
    
    if (tableView.tag ==10) {
        
        arr = self.indexArray;
        
    }
    return arr;
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *key  = @"".mutableCopy;
    if (tableView.tag == 10) {
        key =  [self.indexArray objectAtIndex:section];
    }
    
    return key;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    if (tableView.tag ==10) {
        return [self.indexArray count];
    }else{
        
        return 1;
    }
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    NSLog(@"rows:%lu",(unsigned long)_noticesArr.count);
    
    
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
        rows = self.chatModel.dataSource.count;
    }
    if (tableView.tag ==10) {
        rows = [[self.letterResultArr objectAtIndex:section] count];
    }
    
    
    
    NSLog(@"%ld",rows);
    
    return rows;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    //    NSInteger heights = 0;
    
    
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
    
    if (tableView.tag ==3) {
        
        [self.view endEditing:YES];
    }
    
    if (tableView.tag==10) {
        
        NSLog(@"---->%@",[[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]delegate:nil cancelButtonTitle:@"YES" otherButtonTitles:nil];
        [alert show];

    }
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    
    [self.view endEditing:YES];
}


#pragma mark - 聊天页面用户头像的点击事件


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    
    static NSString *cellIdenfier = @"cell";
    
    static NSString *cellID = @"cellID";
    static NSString *cellIdentifierID = @"Cell";
    
    
    UITableViewCell *tableCell = [[UITableViewCell alloc]init];
    
    if (tableView.tag == 1) {
        NoticeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
        if (cell==nil) {
            cell=[[NoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            
            if (_noticesArr.count==0) {
                
            }else{
                
                Notice *mod =[Notice yy_modelWithJSON: _noticesArr[indexPath.row]];
                NSLog(@"%@",_noticesArr[indexPath.row]);
                
                cell.model = mod;
                cell.sd_tableView = tableView;
                cell.sd_indexPath = indexPath;
                
            }
        }
        
        return cell;
    }
    
    
    if (tableView.tag ==2) {
        
        /* cell的重用队列*/
        
        ClassesListTableViewCell * idcell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (idcell==nil) {
            idcell=[[ClassesListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
            
            if (_classesArr.count==0) {
                
            }else{
                
                Classes *mod =[Classes yy_modelWithJSON: _classesArr[indexPath.row]];
                NSLog(@"%@",_classesArr[indexPath.row]);
                
                idcell.classModel = mod;
                idcell.sd_tableView = tableView;
                idcell.sd_indexPath = indexPath;
                
            }
        }
        return idcell;
        
        
    }
    
    
    if (tableView .tag ==3) {
        
        
        UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
        if (cell == nil) {
            cell = [[UUMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
            cell.delegate = self;
            
            
            
            
        }
        [cell setMessageFrame:self.chatModel.dataSource[indexPath.row]];
        
        return cell;
        
    }
    
    if (tableView.tag ==10) {
        
        MemberListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierID];
        
        if (cell==nil) {
            cell =[[MemberListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellID"];
            
            
            cell.name.text = [[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        }
        
        return cell;
        
    }
    
    return  tableCell;
    
}

#pragma mark -
#pragma mark - UITableViewDelegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lab = [UILabel new];
    lab.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lab.text = [self.indexArray objectAtIndex:section];
    lab.textColor = [UIColor whiteColor];
    return lab;
}






- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    
    if (tableView.tag ==10) {
        
        [self showSectionTitle:title];
        return index;
    }
    return 0;
}
#pragma mark - 关于姓名排序
- (void)timerHandler:(NSTimer *)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.3 animations:^{
            self.sectionTitleView.alpha = 0;
        } completion:^(BOOL finished) {
            self.sectionTitleView.hidden = YES;
        }];
    });
}

-(void)showSectionTitle:(NSString*)title{
    [self.sectionTitleView setText:title];
    self.sectionTitleView.hidden = NO;
    self.sectionTitleView.alpha = 1;
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerHandler:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}




#pragma mark- 视频之外的部分
// segment的滑动代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [_videoInfoView.segmentControl setSelectedSegmentIndex:page animated:YES];
}


/* 文本输入框取消响应*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
   
    
//    [IFView.TextViewInput resignFirstResponder];
    [self.view endEditing:YES];
    
    
    
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
- (void)emojiKeyboardShow:(UIButton *)sender
{
    
    
    
    if (sender.superview == IFView) {
        
        IFView.TextViewInput.text = @"" ;
        
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

// 自定义表情键盘弹出会调用
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    
    
    //获取键盘高度
    
    NSDictionary *info = [note userInfo];
    
    //获取动画时间
    
    float duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //获取动画开始状态的frame
    
    CGRect beginRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    //获取动画结束状态的frame
    
    CGRect endRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    //计算高度差
    
    CGFloat offsety =  endRect.origin.y - beginRect.origin.y ;
    
    NSLog(@"键盘高度:%f 高度差:%f\n",beginRect.origin.y,offsety);

    
    
    // 约束动画
    [UIView animateWithDuration:duration animations:^{
        
        
            NSLog(@"%@",[NSThread currentThread]);
            _chatTableView.sd_layout
            .topEqualToView(_videoInfoView.view2)
            .leftEqualToView(_videoInfoView.view2)
            .rightEqualToView(_videoInfoView.view2)
            .bottomSpaceToView(_videoInfoView.view2,-offsety+46);
        
            IFView.sd_layout
            .bottomSpaceToView(_videoInfoView.view2,-offsety);
        
        
            [_chatTableView updateLayout];
            [IFView updateLayout];
        [self tableViewScrollToBottom];
        
        
    
    }];
    
    
    
}


#pragma mark- 查询播放状态功能的方法实现 --播放器初始化状态
- (void)checkVideoStatus{
    
    /* 向后台发送请求,请求视频直播状态*/
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_remember_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/live_studio/courses/%@/live_status",_classID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dataDic= [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
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
        
        
        if ([dataDic[@"status"] isEqual:[NSNumber numberWithInteger:1]]) {
            
            /* 获取数据成功,执行下一步操作*/
            
            _statusDic = [NSDictionary dictionaryWithDictionary:dataDic[@"data"]];
            
            [self switchStatuseWithDictionary:dataDic[@"data"]];
            
            
        }else{
            /* 获取数据失败*/
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}



#pragma mark- 封装一下直播状态和操作的方法
- (void)switchStatuseWithDictionary:(NSDictionary *)statusDic{
    
    UIAlertController *alertController = NULL;
    UIAlertAction *action = NULL;
    
    /* 如果有一个播放器是直播状态*/
    if ([statusDic[@"board"] isEqual:[NSNumber numberWithInteger:1]]||[statusDic[@"camera"]isEqual:[NSNumber numberWithInteger:1]]) {
        if ([statusDic[@"board"] isEqual:[NSNumber numberWithInteger:1]]) {
            [_liveplayerBoard play];
            
        }
        if ([statusDic[@"camera"]isEqual:[NSNumber numberWithInteger:1]]) {
            
            [_liveplayerTeacher play];
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
    
    
    /* 状态都是1  都是正在直播中的时候*/
    if ([statusDic[@"board"] isEqual:[NSNumber numberWithInteger:1]]&&[statusDic[@"camera"]isEqual:[NSNumber numberWithInteger:1]]) {
        
        if ([_liveplayerBoard isPlaying]) {
            
        }else{
            
            [_liveplayerBoard play];
        }
        
        if ([_liveplayerTeacher isPlaying]) {
            
        }else{
            
            [_liveplayerTeacher play];
        }

        
        
        
        
        /* 不用再向服务器发送查询请求*/
        
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



#pragma mark- 每隔30秒发送一次状态请求

//- (void)requestPullStatus{
//    
////    NSLog(@"向服务器请求视频直播状态,%@",[NSDate date]);
////    
////    NSDate *scheduledTime = [NSDate dateWithTimeIntervalSinceNow:0.0];
////    
////    NSString *customUserObject = @"向服务器请求视频直播状态";
////    
////    NSTimer *timer = [[NSTimer alloc] initWithFireDate:scheduledTime
////                                              interval:5
////                                                target:self
////                                              selector:@selector(checkVideoStatus)
////                                              userInfo:customUserObject
////                                               repeats:YES];
////    
////    _runLoop = [NSRunLoop currentRunLoop];
////    [_runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
////    
////    dispatch_queue_t request = dispatch_queue_create("request", DISPATCH_QUEUE_SERIAL);
////    dispatch_async(request, ^{
////        
//////        [_runLoop run];
////    });
//    
//}

    
    
    




-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [IFView.inputView resignFirstResponder];
    
    [self.view endEditing:YES];
    
}

-(void)dealloc{
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
