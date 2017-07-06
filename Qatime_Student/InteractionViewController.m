
//
//  InteractionViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/28.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "InteractionViewController.h"
#import "TutoriumList.h"
#import "InteractionInfoHeadView.h"
#import "MemberListTableViewCell.h"
#import "NoticeTableViewCell.h"
#import "ClassesListTableViewCell.h"
#import "CYLTableViewPlaceHolder.h"
#import "HaveNoClassView.h"

#import "MJRefresh.h"
#import "ChatModel.h"
#import "YZEmotionKeyboard.h"
#import "UUMessageCell.h"
#import "NavigationBar.h"
#import "YZEmotionKeyboard.h"
#import "YYTextView+YZEmotion.h"
#import "UITextView+YZEmotion.h"
#import "UITextField+YZEmotion.h"

#import <NIMSDK/NIMSDK.h>
#import "NSAttributedString+YYText.h"

#import "NSBundle+YYAdd.h"
#import "UIViewController+HUD.h"
#import "Chat_Account.h"
#import "YYImage.h"
#import "YYModel.h"
#import "NSAttributedString+EmojiExtension.h"
#import "YYTextAttribute.h"
#import "YZTextAttachment.h"
#import "NSString+TimeStamp.h"
#import "NSDate+ChangeUTC.h"
#import "UITextView_Placeholder.h"

#import "UIViewController+AFHTTP.h"

#import "LivePlayerViewController.h"
#import <NIMSDK/NIMSDK.h>
#import <NIMAVChat/NIMAVChat.h>
#import <AVFoundation/AVFoundation.h>
#import "UIAlertController+Blocks.h"
#import "UUMessageFrame.h"


#import "NSString+YYAdd.h"
#import "UIViewController+TimeInterval.h"
#import "InteractionTeacherListTableViewCell.h"
#import "TeachersPublicViewController.h"
#import "OneOnOneClass.h"
#import "UIViewController+Token.h"

#import "InteractionLesson.h"
#import "UIView+PlaceholderImage.h"

//子控制器
#import "InteractionChatViewController.h"
#import "InteractionMemberListViewController.h"
#import "InteractionClassInfoViewController.h"
#import "InteractionNoticeViewController.h"
#import "IJKFloatingView.h"
#import "UIView+PlaceholderImage.h"

#define CameraWidth [UIScreen mainScreen].bounds.size.width/4.0

typedef enum : NSUInteger {
    /**
     *  前置摄像头
     */
    FrontCamera,
    /**
     *  后置摄像头
     */
    BackCamera,
} CurrentCamera;


@interface InteractionViewController ()<NTESMeetingActionViewDataSource,NTESMeetingActionViewDelegate,NIMChatroomManagerDelegate,NTESMeetingNetCallManagerDelegate,NTESActorSelectViewDelegate,NTESMeetingRolesManagerDelegate,NIMLoginManagerDelegate,NIMNetCallManager>{
    
    //课程id
    NSString *_classID;
    
    //加入音视频会话用的roomID
    __block NSString *_roomID;
    
    //群组聊天用的chatTeamID
    NSString *_chatTeamID;
    
    __block IJKFloatingView *_floatingView ;
    
    __block IJKFloatingView *cameraView;
    
    __block IJKFloatingView *_teacherView;
    
    __block IJKFloatingView *_teacherCamera;
    
    CGFloat _cameraWidth;
    
    
    
    //本地摄像头状态,默认开启
    CurrentCamera _currentCamera;
    
    //本地摄像头,默认开始状态
    BOOL _videoON;
    
    //本地麦克风,默认开启状态
    BOOL _audioON;
    
    
    //全屏状态
    BOOL is_fullScreen;
    
    //刚进房间的时候白板是不可用的
    BOOL _whiteBoardEnable;
    
    
}

/**聊天页面子控制器*/
@property (nonatomic, strong) InteractionChatViewController *chatVC ;
/**白板子控制器*/
@property (nonatomic, strong) NTESMeetingWhiteboardViewController *whiteboardVC;
/**公告子控制器*/
@property (nonatomic, strong) InteractionNoticeViewController *noticeVC ;
/**详情子控制器*/
@property (nonatomic, strong) InteractionClassInfoViewController *infoVC ;
/**成员子控制器*/
@property (nonatomic, strong) InteractionMemberListViewController *memberVC ;


/**一整个活动页面,包含segment*/
@property (nonatomic, strong) NTESMeetingActionView *actionView;
/**视频页面*/
@property (nonatomic, strong) NTESMeetingActorsView *actorsView;

/**当前子控制器*/
@property (nonatomic, weak)   UIViewController *currentChildViewController;
/**允许用户的alert*/
@property (nonatomic, strong) UIAlertView *actorEnabledAlert;

@property (nonatomic, strong) NTESActorSelectView *actorSelectView;

@property (nonatomic, assign) BOOL isPoped;

@property (nonatomic, assign) BOOL isRemainStdNav;


@property (nonatomic, assign) BOOL readyForFullScreen;


////
//自己加点属性
/**控制栏*/
@property (nonatomic, strong) UIView *controlView ;
/**全屏按钮*/
@property (nonatomic, strong) UIButton *fullScreenBtn;
/**摄像头切换按钮*/
@property (nonatomic, strong) UIButton *switchCameraBtn ;
/**视频开关按钮*/
@property (nonatomic, strong) UIButton *videoSwitchBtn ;
/**音频开关按钮*/
@property (nonatomic, strong) UIButton *audioSwitchBtn ;

/**返回按钮*/
@property (nonatomic, strong) UIButton *backBtn ;



@end

@implementation InteractionViewController

NTES_USE_CLEAR_BAR
NTES_FORBID_INTERACTIVE_POP

/**测试阶段使用这个方法 ,减少前一页的冗余 */
-(instancetype)initWithChatroom:(NIMChatroom *)chatroom andClassID:(NSString *)classID andChatTeamID:(NSString *)chatTeamID {
    self = [super init];
    if (self) {
        
        _cameraWidth = CameraWidth;
        _chatroom = chatroom;
        
        _classID = [NSString stringWithFormat:@"%@",classID];
        
        _chatTeamID = [NSString stringWithFormat:@"%@",chatTeamID];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    @try {
        [[UIApplication sharedApplication] addObserver:self forKeyPath:@"statusBarHidden" options:NSKeyValueObservingOptionNew context:nil];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }

    [_currentChildViewController beginAppearanceTransition:YES animated:animated];
    self.actorsView.isFullScreen = NO;
    

}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    @try {
        [[UIApplication sharedApplication] removeObserver:self forKeyPath:@"statusBarHidden"];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    //可以发送语音
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"CanSendVoice"];
    _floatingView.hidden = YES;
    cameraView.hidden = YES;
    
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"CanSendVoice"];
    _floatingView.hidden = NO;
    cameraView.hidden = NO;
    
}




- (void)onLeft:(NSString *)name error:(NSError *)error{
    
}
- (void)onUserLeft:(NSString *)uid conference:(NSString *)name{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //不允许侧滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化数据
    [self makeData];
    
     //修改视图结构.重写所有视图.
    [self setupViews];
    
    //状态栏隐藏/显示
    [self performSelector:@selector(hideControlView) withObject:nil afterDelay:8];
    
    
    //所有的监听
    [self addNotifications];
    
    /* 全屏模式的监听-->在runtime机制下不可进行屏幕旋转的时候,强制进行屏幕旋转*/
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    /* 不支持屏幕中立旋转*/
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"SupportedLandscape"];
    //状态栏监听
    [[UIApplication sharedApplication] addObserver:self forKeyPath:@"statusBarHidden" options:NSKeyValueObservingOptionNew context:nil];

}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"statusBarHidden"]) {
        
        if ([change[@"new"]isEqualToNumber:@1]) {
            //隐藏了 没事
        }else{
            //没隐藏让他隐藏
            
            [[UIApplication sharedApplication]setStatusBarHidden:YES];
            
        }
    }
   else if ([keyPath isEqualToString:@"videoStart"]) {
        
        if ([change[@"new"]isEqualToNumber:@1]) {
            
            //视频开始了 ,直接隐藏placeholderimage
            [_teacherView makePlaceHolderImage:nil];
        }
    }
    
   else if ([keyPath isEqualToString:@"selfCamera.cameraStart"]) {
        
        if ([change[@"new"]isEqualToNumber:@1]) {
            
            //视频开始了 ,直接隐藏placeholderimage
            [_floatingView makePlaceHolderImage:nil];
        }

    }
}

/**初始化数据*/
- (void)makeData{
    
    is_fullScreen = NO;
    
    //默认使用前置摄像头推流
    _currentCamera = FrontCamera;
    
    //默认开启摄像头和音频
    _videoON = YES;
    
    _audioON = YES;
    
    _whiteBoardEnable = NO;
    
}

/**加载视图*/
- (void)setupViews{
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    //加载所有子控制器
    [self setupChildViewController];
    [self.view addSubview:self.actionView];
    [self.view addSubview:self.actorsView];
    [self.actionView reloadData];
    
    //加载顶部控制栏
    [self setupControlView];
    
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    [[NTESMeetingRolesManager defaultManager] setDelegate:self];
    
    _floatingView = [[IJKFloatingView alloc]initWithFrame:CGRectMake(20, 20, _cameraWidth,_cameraWidth/9*16.0)];
    [_floatingView makePlaceHolderImage:[UIImage imageNamed:@"video_ClosedCamera"]];
    _floatingView.backgroundColor = [UIColor whiteColor];
    _floatingView.canMove = YES;
    [self.view addSubview:_floatingView];
    
    _teacherView = [[IJKFloatingView alloc]init];
    [_teacherView makePlaceHolderImage:[UIImage imageNamed:@"video_Playerholder"]];
    _teacherView.canMove = NO;
    [self.actorsView addSubview:_teacherView];
    _teacherView.sd_layout
    .leftSpaceToView(self.actorsView, 0)
    .rightSpaceToView(self.actorsView, 0)
    .topSpaceToView(self.actorsView, 0)
    .bottomSpaceToView(self.actorsView, 0);
    
}


/**加载控制栏*/
- (void)setupControlView{
    
    _controlView = [[UIView alloc]init];
    [self.view addSubview:_controlView];
    _controlView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    _controlView.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(40);
    
    
    ///顺序从右往左
    //全屏按钮
    _fullScreenBtn = [[UIButton alloc]init];
    [_controlView addSubview:_fullScreenBtn];
    [_fullScreenBtn setImage:[UIImage imageNamed:@"btn_player_scale01"] forState:UIControlStateNormal];
    [_fullScreenBtn addTarget:self action:@selector(scaleAction:) forControlEvents:UIControlEventTouchUpInside];
    _fullScreenBtn.sd_layout
    .rightSpaceToView(_controlView, 20*ScrenScale)
    .topSpaceToView(_controlView, 10*ScrenScale)
    .bottomSpaceToView(_controlView, 10*ScrenScale)
    .widthEqualToHeight();
    [_fullScreenBtn setEnlargeEdge:20];
    
    //切换前后摄像头按钮
    _switchCameraBtn  = [[UIButton alloc]init];
    [_controlView addSubview:_switchCameraBtn];
    [_switchCameraBtn setImage:[UIImage imageNamed:@"switch_camera"] forState:UIControlStateNormal];
    _switchCameraBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_switchCameraBtn addTarget:self action:@selector(switchCameraAction:) forControlEvents:UIControlEventTouchUpInside];
    _switchCameraBtn.sd_layout
    .rightSpaceToView(_fullScreenBtn, 20*ScrenScale)
    .topEqualToView(_fullScreenBtn)
    .bottomEqualToView(_fullScreenBtn)
    .widthEqualToHeight();
    [_switchCameraBtn setEnlargeEdge:20];
    
    //视频开关
    _videoSwitchBtn  = [[UIButton alloc]init];
    [_controlView addSubview:_videoSwitchBtn];
    [_videoSwitchBtn setImage:[UIImage imageNamed:@"camera_on"] forState:UIControlStateNormal];
    [_videoSwitchBtn addTarget:self action:@selector(videoSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
    _videoSwitchBtn.sd_layout
    .rightSpaceToView(_switchCameraBtn, 20*ScrenScale)
    .topEqualToView(_fullScreenBtn)
    .bottomEqualToView(_fullScreenBtn)
    .widthEqualToHeight();
    [_videoSwitchBtn setEnlargeEdge:20];
    
    
    //音频开关
    _audioSwitchBtn = [[UIButton alloc]init];
    [_controlView addSubview:_audioSwitchBtn];
    [_audioSwitchBtn setImage:[UIImage imageNamed:@"mic_on"] forState:UIControlStateNormal];
    [_audioSwitchBtn addTarget:self action:@selector(audioSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
    _audioSwitchBtn.sd_layout
    .rightSpaceToView(_videoSwitchBtn, 20*ScrenScale)
    .topEqualToView(_fullScreenBtn)
    .bottomEqualToView(_fullScreenBtn)
    .widthEqualToHeight();
    [_audioSwitchBtn setEnlargeEdge:20];
    
    
    //返回按钮
    _backBtn = [[UIButton alloc]init];
    [_controlView addSubview:_backBtn];
    [_backBtn setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(exitInteraction) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.sd_layout
    .leftSpaceToView(_controlView, 10*ScrenScale)
    .centerYEqualToView(_controlView)
    .widthIs(30*ScrenScale)
    .heightEqualToWidth();
    [_backBtn setEnlargeEdge:20];
    
}

#pragma mark- Notifications

/** 所有的监听 */
- (void)addNotifications{
    
    //接受子控制器传来的roomID
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(joinMeeting:) name:@"RoomID" object:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(madeCameraView:) name:@"SelfCameraReady" object:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(desktopSharedOn:) name:@"DesktopSharedOn" object:nil];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(desktopSharedOff:) name:@"DesktopSharedOff" object:nil];
    
    //增加视频开始播放的监听(移除placeholder)
    [self.actorsView addObserver:self forKeyPath:@"videoStart" options:NSKeyValueObservingOptionNew context:nil];
//    [self.actorsView.selfCamera addObserver:self forKeyPath:@"cameraStart" options:NSKeyValueObservingOptionNew context:nil];
    
}



/** 拿到roomid后加入会话的方法  同时,视频播放器和摄像头播放器都变成加载中的提示图片*/
- (void)joinMeeting:(NSNotification *)note{
    
    _roomID = [note object];
    [_floatingView makePlaceHolderImage:[UIImage imageNamed:@"video_LoadingHolder_Portrait"]];
    [_teacherView makePlaceHolderImage:[UIImage imageNamed:@"video_LoadingHolder_Landscape"]];
    
    [[NTESMeetingNetCallManager defaultManager] joinMeeting:_roomID delegate:self];

}

/** 本地摄像头预览 */
- (void)madeCameraView:(NSNotification *)note{
    
    //加个互斥锁
    @synchronized (self) {
        
        cameraView = self.actorsView.selfCamera.copy;
        
        [_floatingView addSubview:cameraView];
        cameraView.sd_layout
        .leftSpaceToView(_floatingView, 0)
        .rightSpaceToView(_floatingView, 0)
        .topSpaceToView(_floatingView, 0)
        .bottomSpaceToView(_floatingView, 0);
        [cameraView updateLayout];
    }

}
- (void)whiteBoardEnabled{
    
    [[NTESMeetingRolesManager defaultManager]setMyWhiteBoard:YES];
    
}

- (void)desktopSharedOn:(NSNotification *)note{
    //教师端开启屏幕共享
    //直接全屏
    if (is_fullScreen == YES) {
        
    }else{
        
        [self performSelector:@selector(scaleAction:) withObject:_fullScreenBtn afterDelay:0.5];
        
    }

}

- (void)desktopSharedOff:(NSNotification *)note{
    //教师端关闭屏幕共享
    //自动恢复竖屏
    if (is_fullScreen == YES) {
        
        [self performSelector:@selector(scaleAction:) withObject:_fullScreenBtn afterDelay:0.5];
    }else{
        
    }

}



#pragma mark - NTESMeetingActionViewDataSource

- (NSInteger)numberOfPages{
    return self.childViewControllers.count;
}

- (UIView *)viewInPage:(NSInteger)index{
    UIView *view = self.childViewControllers[index].view;
    return view;
}

- (CGFloat)actorsViewHeight{
    return self.actorsView.height;
}

#pragma mark - NTESMeetingActionViewDelegate

- (void)onSegmentControlChanged:(NTESChatroomSegmentedControl *)control{
    UIViewController *lastChild = self.currentChildViewController;
    UIViewController *child = self.childViewControllers[self.actionView.segmentedControl.selectedSegmentIndex];
    
//    if ([child isKindOfClass:[NTESChatroomMemberListViewController class]]) {
//        _actionView.unreadRedTip.hidden = YES;
//    }
    
    [lastChild beginAppearanceTransition:NO animated:YES];
    [child beginAppearanceTransition:YES animated:YES];
    [_actionView.pageView scrollToPage:self.actionView.segmentedControl.selectedSegmentIndex];
    
    typeof(self) __weak weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.currentChildViewController = child;
        [lastChild endAppearanceTransition];
        [child endAppearanceTransition];
    });
}

#pragma mark - NTESMeetingNetCallManagerDelegate
- (void)onJoinMeetingFailed:(NSString *)name error:(NSError *)error
{
    [self.view.window makeToast:@"无法加入视频，退出房间" duration:3.0 position:CSToastPositionCenter];
    
    //直接加入房间错误了
    [_floatingView makePlaceHolderImage:[UIImage imageNamed:@"video_LoadFaild_Portrait"]];
    [_teacherView makePlaceHolderImage:[UIImage imageNamed:@"video_LoadFaild_Landscape"]];
    
    if ([[[NTESMeetingRolesManager defaultManager] myRole] isManager]) {
    }
    
    __weak typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wself pop];
    });
}
- (void)pop
{
    if (!self.isPoped) {
        self.isPoped = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)onMeetingConntectStatus:(BOOL)connected{
    
    if (connected) {
        
        
    }else {
        //链接失败的情况
        [_floatingView makePlaceHolderImage:[UIImage imageNamed:@"video_LoadFaild_Portrait"]];
        [_teacherView makePlaceHolderImage:[UIImage imageNamed:@"video_LoadFaild_Landscape"]];
        
        [self.actorsView stopLocalPreview];
    }
}

- (void)onSetBypassStreamingEnabled:(BOOL)enabled error:(NSUInteger)code{
    
//    NSString *toast = [NSString stringWithFormat:@"%@互动直播失败 (%zd)", enabled ? @"开启" : @"关闭", code];
//    [self.view.window makeToast:toast duration:3.0 position:CSToastPositionCenter];
}

#pragma mark - NTESMeetingRolesManagerDelegate

- (void)meetingRolesUpdate
{
    [self.actorsView updateActors];
    [self.whiteboardVC checkPermission];
    if (!self.actorSelectView) {
        _isRemainStdNav = YES;
        self.actorSelectView = [[NTESActorSelectView alloc] initWithFrame:self.view.bounds];
        self.actorSelectView.delegate = self;
        [self.actorSelectView setUserInteractionEnabled:YES];
        [self.actorSelectView okPressed];
    }
    
}

- (void)meetingVolumesUpdate{
    
}

- (void)chatroomMembersUpdated:(NSArray *)members entered:(BOOL)entered{
    
}

- (void)meetingMemberRaiseHand{
    
    if (self.actionView.segmentedControl.selectedSegmentIndex != 2) {
        self.actionView.unreadRedTip.hidden = NO;
    }
}

- (void)meetingActorBeenEnabled{
    
    if (!self.actorSelectView) {
        _isRemainStdNav = YES;
        self.actorSelectView = [[NTESActorSelectView alloc] initWithFrame:self.view.bounds];
        self.actorSelectView.delegate = self;
        [self.actorSelectView setUserInteractionEnabled:YES];
        [self.view addSubview:self.actorSelectView];
    }
}

- (void)meetingActorBeenDisabled{
    
    BOOL accepted = [[NTESMeetingNetCallManager defaultManager] setBypassLiveStreaming:NO];
    
    if (!accepted) {
//        [self.view.window makeToast:@"关闭互动直播被拒绝" duration:3.0 position:CSToastPositionTop];
    }
    
    [self.view.window makeToast:@"你已被老师取消互动" duration:2.0 position:CSToastPositionCenter];
}

- (void)meetingActorsNumberExceedMax
{
    [self.view makeToast:@"互动人数已满" duration:1 position:CSToastPositionCenter];
}

-(void)meetingRolesShowFullScreen:(NSString*)notifyExt
{
    
}
#pragma mark - NTESActorSelectViewDelegate
- (void)onSelectedAudio:(BOOL)audioOn video:(BOOL)videoOn whiteboard:(BOOL)whiteboardOn{
    
    _isRemainStdNav = NO;
    
    if (audioOn) {
        [[NTESMeetingRolesManager defaultManager] setMyAudio:YES];
    }
    
    if (videoOn) {
        [[NTESMeetingRolesManager defaultManager] setMyVideo:YES];
    }
    
    if (whiteboardOn) {
        [[NTESMeetingRolesManager defaultManager] setMyWhiteBoard:NO];
    }
    
    BOOL accepted = [[NTESMeetingNetCallManager defaultManager] setBypassLiveStreaming:YES];
    
    if (!accepted) {
//        [self.view.window makeToast:@"开启互动直播被拒绝" duration:3.0 position:CSToastPositionTop];
    }
}


#pragma mark- Actions

/**全屏功能*/
- (void)scaleAction:(UIButton *)sender{
    
    if (is_fullScreen == NO) {
        //切换成全屏
        [sender setImage:[UIImage imageNamed:@"btn_player_scale02"] forState:UIControlStateNormal];
        //再捎带着切个全屏
        [self turnFullScreen];
        
    }else{
        //切回竖屏
        [sender setImage:[UIImage imageNamed:@"btn_player_scale01"] forState:UIControlStateNormal];
        //切回竖屏方法
        [self turnPortrait];
    }
    
}

/**变全屏*/
- (void)turnFullScreen{
    /** 强制转成横屏 只能往右转*/
    [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
}
/**变竖屏*/
- (void)turnPortrait{
    /**强制竖屏 */
    [self interfaceOrientation:UIInterfaceOrientationPortrait];

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
    
    /* 切换到竖屏*/
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
       //教师摄像头变小
        [self teacherCameraTurnsPortrait];
        is_fullScreen = NO;
       
        //在这儿开启白板 相对安全
        [[NTESMeetingRolesManager defaultManager] setMyWhiteBoard:YES];
        //切换成全屏
        [_fullScreenBtn setImage:[UIImage imageNamed:@"btn_player_scale01"] forState:UIControlStateNormal];
        
    }else if(toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
        
    }
    
    /* 切换到横屏*/
    else {
        //教师摄像头变大
        [self teacherCameraTurnsFullScreen];
        is_fullScreen = YES;
        _floatingView.hidden = YES;
        //自己的摄像头变小 变小
        [_floatingView updateLayout];
        [cameraView updateLayout];
        cameraView.hidden = YES;
        //在这儿关闭白班可能也安全
        [[NTESMeetingRolesManager defaultManager] setMyWhiteBoard:NO];
        
        //切换成全屏
        [_fullScreenBtn setImage:[UIImage imageNamed:@"btn_player_scale02"] forState:UIControlStateNormal];

    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RotatePageView" object:nil];
    
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RotateAnimatePageView" object:nil];
}


//为了避免摄像头尺寸变化,只能这么做,这个方法,最好只进行这一项操作.
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice]orientation];
    
    if (orientation!=UIDeviceOrientationPortrait) {
        
    }else{
        //切回了竖屏之后,在显示摄像头
        _floatingView.hidden = NO;
        [_floatingView updateLayout];
        [cameraView updateLayout];
        cameraView.hidden = NO;
        
        //为了让摄像头的尺寸正常 ,只能这么做了
        [self videoSwitchAction:_videoSwitchBtn];
        [self videoSwitchAction:_videoSwitchBtn];

    }
    
}

/**教师摄像头变全屏*/
- (void)teacherCameraTurnsFullScreen{
    
    [UIView animateWithDuration:0.3 animations:^{
       
        self.actorsView.sd_layout
        .leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .topSpaceToView(self.view, 0)
        .bottomSpaceToView(self.view, 0);
        
        [self.actorsView updateLayout];
        
    }];
    
}

/**教师摄像头变竖屏*/
- (void)teacherCameraTurnsPortrait{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.actorsView.sd_resetLayout
        .leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .topSpaceToView(self.view, 0)
        .autoHeightRatio(9/16.0);
        
        [self.actorsView updateLayout];
        
    }];
}


/**前后摄像头切换功能*/
- (void)switchCameraAction:(UIButton *)sender{
    
    if (_currentCamera == BackCamera) {
        
        [[NIMAVChatSDK sharedSDK].netCallManager switchCamera:NIMNetCallCameraFront];
        
        _currentCamera = FrontCamera;
        
    }else{
        
        [[NIMAVChatSDK sharedSDK].netCallManager switchCamera:NIMNetCallCameraBack];
        _currentCamera = BackCamera;
        
    }
    
}


/**摄像头开关*/
- (void)videoSwitchAction:(UIButton *)sender{

    if (_videoON == YES) {
        [sender setImage:[UIImage imageNamed:@"camera_off"] forState:UIControlStateNormal];
        _floatingView.hidden = YES;
        cameraView.hidden = YES;
        _videoON = NO;
    }else{
        [sender setImage:[UIImage imageNamed:@"camera_on"] forState:UIControlStateNormal];
        _floatingView.hidden = NO;
        cameraView.hidden = NO;
        _videoON = YES;
    }
    
    [[NTESMeetingRolesManager defaultManager] setMyVideo:_videoON];
    
}

/**音频开关*/
- (void)audioSwitchAction:(UIButton *)sender{
    
    
    if (_audioON == YES) {
        [sender setImage:[UIImage imageNamed:@"mic_off"] forState:UIControlStateNormal];
        _audioON = NO;
    }else{
        [sender setImage:[UIImage imageNamed:@"mic_on"] forState:UIControlStateNormal];
        _audioON = YES;
    }
    
    [[NTESMeetingRolesManager defaultManager] setMyAudio:_audioON];
    
}


#pragma mark- Get

- (CGFloat)meetingActorsViewHeight
{
    return NIMKit_UIScreenWidth * 220.f / 320.f;
}

- (NTESMeetingActorsView *)actorsView{
    
    @synchronized (self) {
        
        if (!self.isViewLoaded) {
            return nil;
        }
        if (!_actorsView) {
            _actorsView = [[NTESMeetingActorsView alloc] initWithFrame:CGRectMake(0, 0, self.view.width_sd,self.view.width_sd/16*9)];
            _actorsView.teacherCamera.frame = _actorsView.frame;
            //点击手势 ,显示控制栏
            UITapGestureRecognizer *tapControl = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(controlControlView)];
            [_actorsView addGestureRecognizer:tapControl];
            
        }
    }
    return _actorsView;
}

- (NTESMeetingActionView *)actionView
{
    if (!self.isViewLoaded) {
        return nil;
    }
    if (!_actionView) {
        _actionView = [[NTESMeetingActionView alloc] initWithDataSource:self];
        _actionView.frame = self.view.bounds;
        _actionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _actionView.delegate = self;
        _actionView.unreadRedTip.hidden = YES;
    }
    return _actionView;
}


#pragma mark - Private

/**加载所有子控制器*/
- (void)setupChildViewController
{
    NSArray *vcs = [self makeChildViewControllers];
    for (UIViewController *vc in vcs) {
        [self addChildViewController:vc];
    }
}


//
- (NSArray *)makeChildViewControllers{
    
    self.whiteboardVC = [[NTESMeetingWhiteboardViewController alloc] initWithClassID:_classID];
    
    self.chatVC = [[InteractionChatViewController alloc] initWithChatTeamID:_chatTeamID andClassID:_classID];
    
    self.noticeVC = [[InteractionNoticeViewController alloc]initWithClassID:_classID];
    
    self.infoVC = [[InteractionClassInfoViewController alloc]initWithClassID:_classID];
    
    self.memberVC = [[InteractionMemberListViewController alloc]initWithClassID:_classID];
    
    return @[self.whiteboardVC,self.chatVC,self.noticeVC,self.infoVC,self.memberVC];
}

/**播放器的点击控制*/
- (void)controlControlView{
    
    if (_controlView.hidden == YES) {
        
        [self controlViewShow];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _controlView.alpha = 1;
            
        }];
        
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _controlView.alpha = 0;
            
        }];
        [self performSelector:@selector(controlViewHide) withObject:nil afterDelay:0.5];
    }
    
}


/**隐藏状态栏*/
- (void)hideControlView{
    
    [self animatedHideControlView];
    
    
}

/**控制栏动画隐藏*/
- (void)animatedHideControlView{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _controlView.alpha = 0;
        
    }];
    [self performSelector:@selector(controlViewHide) withObject:nil afterDelay:0.5];
    
    
}
/**无动画隐藏控制栏*/
- (void)controlViewHide{
    _controlView.hidden = YES;
}

/**控制栏动画显示*/
- (void)animatedShowControlView{
    
    [self performSelector:@selector(controlViewShow) withObject:nil afterDelay:0.5];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _controlView.alpha =1 ;
        
    }];
    
}
/**无动画隐藏控制栏*/
- (void)controlViewShow{
    _controlView.hidden = NO;
    
    [self performSelector:@selector(animatedHideControlView) withObject:nil afterDelay:10];
    
}


#pragma mark- touches
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    
}

//用户可能不小心按了一下返回键 o(╯□╰)o
- (void)exitInteraction{
    
    if (is_fullScreen == YES) {
        //返回竖屏
        [self scaleAction:_fullScreenBtn];
        
    }else{
        
        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"确定要退出互动直播吗?" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            if (buttonIndex == 0) {
                //手滑了
            }else{
                
                [self returnLastPage];
            }
            
        }];
    }
    
}

- (void)returnLastPage{

    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    @try{
        [self.actorsView removeObserver:self forKeyPath:@"videoStart"];
    } @catch (NSException *exception) {
        
        NSLog(@"%s\n%@",__FUNCTION__,exception);
        
    } @finally {
        
    }
    
    @try {
        [[UIApplication sharedApplication] removeObserver:self forKeyPath:@"statusBarHidden"];
    } @catch (NSException *exception) {
        
        NSLog(@"%s\n%@",__FUNCTION__,exception);
        
    } @finally {
        
    }

    cameraView = nil;
    _floatingView = nil;
    [_actorsView removeFromSuperview];
    //    _actorsView = nil;
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[NTESMeetingNetCallManager defaultManager]leaveMeeting];
    [[NTESMeetingRTSManager defaultManager]leaveCurrentConference];
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)dealloc{
    @try{
        [self.actorsView removeObserver:self forKeyPath:@"videoStart"];
    } @catch(NSException *exception) {
        NSLog(@"%s\n%@",__FUNCTION__,exception);
    } @finally {
        
    }

    @try {
        [[UIApplication sharedApplication] removeObserver:self forKeyPath:@"statusBarHidden"];
    } @catch (NSException *exception) {
        NSLog(@"%s\n%@",__FUNCTION__,exception);
    } @finally {
        
    }
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:_chatroom.roomId completion:nil];
    [[NIMSDK sharedSDK].chatroomManager removeDelegate:self];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[NTESMeetingNetCallManager defaultManager]leaveMeeting];
    [[NTESMeetingRTSManager defaultManager]leaveCurrentConference];
    
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
