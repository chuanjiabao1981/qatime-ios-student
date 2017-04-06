//
//  InteractionViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/28.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "InteractionViewController.h"
#import "TutoriumList.h"
#import "InteractionInfoView.h"
#import "MemberListTableViewCell.h"
#import "NoticeTableViewCell.h"
#import "ClassesListTableViewCell.h"

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
#import <AVFoundation/AVFoundation.h>
#import "UIAlertController+Blocks.h"
//#import <AVFoundation/AVAudioSettings.h>
//#import <AVFoundation/AVAudioRecorder.h>
#import "UUMessageFrame.h"
#import "TranslateViewController.h"
//#import <iflyMSC/iflyMSC.h>
#import "NSString+YYAdd.h"
#import "UIViewController+TimeInterval.h"
#import "InteractionTeacherListTableViewCell.h"
#import "TeachersPublicViewController.h"



@interface InteractionViewController ()<UITableViewDelegate,UITableViewDataSource,InteractionControlDelegate,InteractionOverlayDelegate,TTGTextTagCollectionViewDelegate,UUInputFunctionViewDelegate,NIMChatManagerDelegate,NIMLoginManagerDelegate,UUMessageCellDelegate,NTESColorSelectViewDelegate, NTESMeetingRTSManagerDelegate, NTESWhiteboardCmdHandlerDelegate,NIMChatroomManager,NTESActorSelectViewDelegate,NTESMeetingNetCallManagerDelegate,NIMChatroomManager,NTESMeetingRolesManagerDelegate,NIMChatroomManagerDelegate>{
    
    //详细信息的头视图
    InteractionInfoView *_infoView ;
    
    ///////
    //聊天部分 变量
    NSString *_token;
    NSString *_idNumber;
    
    /* 聊天室的信息*/
    TutoriumListInfo *_tutoriumInfo;
    
    /* 会话*/
    NIMSession *_session;
    
    /* 个人信息*/
    Chat_Account *_chat_Account;
    
    /* 临时变量  保存所有的用户信息 */
    NSMutableArray <Chat_Account *>*_userList;
    
    /* 录音部分*/
    AVAudioRecorder *recorder;
    NSTimer *levelTimer;
    
    /**是否要显示全部教师信息*/
    BOOL showAllTeachers;
    
}

/**
 所在课程信息
 */
@property(nonatomic,strong) TutoriumListInfo *classInfo;

/**
 课程通知的数组
 */
@property(nonatomic,strong) NSArray <Notice *>*noticeArray;

/**
 教师组信息
 */
@property(nonatomic,strong) NSArray <Teacher *>*teachersArray;

/**
 在线成员
 */
@property(nonatomic,strong) NSArray <Members *>*membersArray;

/**
 课程列表
 */
@property(nonatomic,strong) NSArray <Classes *>*classesArray;
////////////////////////////////////////////////////////////////////////////////

//会话部分专用属性


/**
 视频视图
 */
@property (nonatomic, strong) NTESMeetingActorsView *actorsView;

@property (nonatomic, assign) BOOL keyboradIsShown;

/**
 用户互动权限
 */
@property (nonatomic, strong) UIAlertView *actorEnabledAlert;

/**
 互动栏,摄像头麦克风按钮选择
 */
@property (nonatomic, strong) NTESActorSelectView *actorSelectView;

@property (nonatomic, assign) BOOL isPoped;

@property (nonatomic, assign) BOOL isRemainStdNav;

@property (nonatomic, assign) BOOL readyForFullScreen;

////////////////////////////////////////////////////////////////////////////////

//白板部分专用属性
@property (nonatomic, strong) NTESWhiteboardDrawView *drawView;

@property (nonatomic, strong) UIView *controlPannel;

@property (nonatomic, strong) UIButton *clearAllButton;

@property (nonatomic, strong) UIButton *cancelLineButton;

/**选择颜色按钮*/
@property (nonatomic, strong) UIButton *colorSelectButton;

@property (nonatomic, strong) UIButton *openDocumentButton;

@property (nonatomic, strong) NTESColorSelectView *colorSelectView;

@property (nonatomic, strong) UILabel *hintLabel;

@property (nonatomic, strong) NTESWhiteboardCmdHandler *cmdHander;

//@property (nonatomic, strong) NTESDocumentHandler *docHander;

@property (nonatomic, strong) NTESWhiteboardLines *lines;

@property (nonatomic, strong) NSArray *colors;

@property (nonatomic, strong) NSString *myUid;

@property (nonatomic, strong) UIView *laserView;

@property (nonatomic, strong) UIImageView *docView;

@property (nonatomic, strong) NIMDocTranscodingInfo *docInfo;

@property (nonatomic, strong) UIButton *previousButton;

@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) UILabel *pageNumLabel;

@property (nonatomic, strong) UILabel *imgloadLabel;

@property (nonatomic, strong) UIButton *closeDocButton;

@property (nonatomic) int currentPage;

@property (nonatomic, strong) NSMutableDictionary *docInfoDic;

@property (nonatomic, assign) BOOL isManager ;

@property (nonatomic, strong) NSString *name ;

@property (nonatomic, strong) NSString *managerUid ;

@property (nonatomic) int myDrawColorRGB ;

@property (nonatomic, assign) BOOL isJoined ;





////////////////////////////////////////////////////////////////////////////////

//聊天部分专用属性

/* 刷新聊天记录*/
@property (strong, nonatomic) MJRefreshHeader *head;
/* 聊天信息*/
@property (strong, nonatomic) ChatModel *chatModel;

/* 与web端同步的表情专用的键盘*/
@property (strong, nonatomic) YZEmotionKeyboard *emotionKeyboard;



@end

@implementation InteractionViewController

//初始化聊天室信息
-(instancetype)initWithChatroom:(NIMChatroom *)chatroom andNotice:(NSArray<Notice *> *)notices andTutorium:(TutoriumListInfo *)classInfo andTeacher:(NSArray<Teacher *> *)teachers andClasses:(NSArray<Classes *> *)classes andOnlineMembers:(NSArray<Members *> *)members{
    self = [super init];
    if (self) {
        
        _chatroom = chatroom;
        _classInfo = classInfo;
        _noticeArray = notices.mutableCopy;
        _teachersArray = teachers.mutableCopy;
        _membersArray = members.mutableCopy;
        _classesArray = classes.mutableCopy;
        
    }
    return self;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    
    [self checkPermission];
    self.actorsView.isFullScreen = NO;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化数据
    [self makeData];
    //加载视图
    [self setupViews];
    //加载完成后5s,隐藏控制栏
    [self performSelector:@selector(hideControlerOnAlpha) withObject:nil afterDelay:5];
    
    //加载会话功能
    [self setupChatRoomFunc];
    
    //加载白板功能
    [self setupWhiteBoard];
    
    //聊天功能初始化
    [self setupChatFunc];
    
}


/**
 初始化数据
 */
- (void)makeData{
    
    showAllTeachers = NO;
    
}

/**
 加载视图
 */
- (void)setupViews{
    
    //主视图
    _interactionView = [[InteractionView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_interactionView];
    
    
    //segment切换
    [self.interactionView.scrollView updateLayout];
    typeof(self) __weak weakSelf = self;
    [weakSelf.interactionView.segmentControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.interactionView.scrollView scrollRectToVisible:CGRectMake(weakSelf.view.width_sd * index, 0, weakSelf.view.width_sd,weakSelf.interactionView.scrollView.frame.size.height ) animated:NO];
    }];
    
    //指定代理
    _interactionView.chatTableView.delegate = self;
    _interactionView.chatTableView.dataSource = self;
    _interactionView.chatTableView.tag = 1;
    
    _interactionView.noticeTableView.delegate = self;
    _interactionView.noticeTableView.dataSource = self;
    _interactionView.noticeTableView.tag = 2;
    
    _interactionView.classListTableView.delegate = self;
    _interactionView.classListTableView.dataSource = self;
    _interactionView.classListTableView.tag = 3;
    
    _interactionView.membersTableView.delegate = self;
    _interactionView.membersTableView.dataSource = self;
    _interactionView.membersTableView.tag = 4;
    
    _interactionView.topControl.delegate = self;
    _interactionView.delegate = self;
    
    
    //指定header
    _infoView = [[InteractionInfoView alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 400)];
    
    //视图赋值
    _infoView.classModel = _classInfo;
//    _infoView.teacherModel = _teacher;
    
    _infoView.classTagsView.delegate = self;
    
    [_infoView.layoutLine updateLayout];
    _interactionView.classListTableView.tableHeaderView  = _infoView;
    _interactionView.classListTableView.tableHeaderView.size = CGSizeMake(self.view.width_sd, _infoView.height_sd);
    
}

#pragma mark- 互动功能
- (void)setupChatRoomFunc{
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.interactionView.teacherCameraView addSubview:self.actorsView];
    //加载互动控制栏
    [self setupControl];
    [[NIMSDK sharedSDK].chatroomManager addDelegate:self];
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    [[NTESMeetingRolesManager sharedInstance] setDelegate:self];
    [[NTESMeetingNetCallManager sharedInstance] joinMeeting:_chatroom.roomId delegate:self];
    
}

- (CGFloat)meetingActorsViewHeight
{
    return NIMKit_UIScreenWidth /16*9 ;
}

- (NTESMeetingActorsView *)actorsView{
    if (!self.isViewLoaded) {
        return nil;
    }
    if (!_actorsView) {
        _actorsView = [[NTESMeetingActorsView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,self.meetingActorsViewHeight)];
        _actorsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _actorsView;
}

#pragma mark - NIMInputDelegate
- (void)showInputView
{
    self.keyboradIsShown = YES;
}

- (void)hideInputView
{
    self.keyboradIsShown = NO;
}

#pragma mark - NIMChatroomManagerDelegate
- (void)chatroom:(NSString *)roomId beKicked:(NIMChatroomKickReason)reason
{
    if ([roomId isEqualToString:self.chatroom.roomId]) {
        
        NSString *toast;
        
        if ([_chatroom.creator isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
            toast = @"教学已结束";
        }
        else {
            switch (reason) {
                case NIMChatroomKickReasonByManager:
                    toast = @"你已被老师请出房间";
                    break;
                case NIMChatroomKickReasonInvalidRoom:
                    toast = @"老师已经结束了教学";
                    break;
                case NIMChatroomKickReasonByConflictLogin:
                    toast = @"你已被自己踢出了房间";
                    break;
                default:
                    toast = @"你已被踢出了房间";
                    break;
            }
        }
        
        //        DDLogInfo(@"chatroom be kicked, roomId:%@  rease:%zd",roomId,reason);
        
        //判断 当前页面是document列表的情况
        if ([self.navigationController.visibleViewController isKindOfClass:[NTESDocumentViewController class]]) {
            [self.navigationController.visibleViewController.view.window makeToast:toast duration:2.0 position:CSToastPositionCenter];
            NSUInteger index = [self.navigationController.viewControllers indexOfObject:self.navigationController.visibleViewController]-2;
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index] animated:YES];
        }
        else if(self.actorsView.isFullScreen)//正在全屏 先退出全屏
        {
            [self.presentedViewController.view.window makeToast:toast duration:2.0 position:CSToastPositionCenter];
            self.actorsView.showFullScreenBtn = NO;
            [self pop];
        }
        else{
            [self.view.window makeToast:toast duration:2.0 position:CSToastPositionCenter];
            [self pop];
        }
    }
}

- (void)chatroom:(NSString *)roomId connectionStateChanged:(NIMChatroomConnectionState)state;
{
    //    DDLogInfo(@"chatroom connectionStateChanged roomId : %@  state:%zd",roomId,state);
    if(state==NIMChatroomConnectionStateEnterOK)
    {
        [self requestChatRoomInfo];
    }
}

#pragma mark - NTESMeetingNetCallManagerDelegate
- (void)onJoinMeetingFailed:(NSString *)name error:(NSError *)error
{
    [self.view.window makeToast:@"无法加入视频，退出房间" duration:3.0 position:CSToastPositionCenter];
    
    if ([[[NTESMeetingRolesManager sharedInstance] myRole] isManager]) {
        [self requestCloseChatRoom];
    }
    
    __weak typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wself pop];
    });
}

- (void)onMeetingConntectStatus:(BOOL)connected
{
    //    DDLogInfo(@"Meeting %@ ...", connected ? @"connected" : @"disconnected");
    if (connected) {
    }
    else {
        [self.view.window makeToast:@"音视频服务连接异常" duration:2.0 position:CSToastPositionCenter];
        [self.actorsView stopLocalPreview];
    }
}

- (void)onSetBypassStreamingEnabled:(BOOL)enabled error:(NSUInteger)code
{
    //    DDLogError(@"Set bypass enabled %d error %zd", enabled, code);
    NSString *toast = [NSString stringWithFormat:@"%@互动直播失败 (%zd)", enabled ? @"开启" : @"关闭", code];
    [self.view.window makeToast:toast duration:3.0 position:CSToastPositionCenter];
}

#pragma mark - NTESMeetingRolesManagerDelegate

- (void)meetingRolesUpdate
{
    [self.actorsView updateActors];
    
    [self checkPermission];
    
}

- (void)meetingVolumesUpdate
{
    
}

- (void)chatroomMembersUpdated:(NSArray *)members entered:(BOOL)entered
{
    
}

- (void)meetingMemberRaiseHand
{
    
}

- (void)meetingActorBeenEnabled
{
    if (!self.actorSelectView) {
        _isRemainStdNav = YES;
        self.actorSelectView = [[NTESActorSelectView alloc] initWithFrame:self.view.bounds];
        self.actorSelectView.delegate = self;
        [self.actorSelectView setUserInteractionEnabled:YES];
        [self.view addSubview:self.actorSelectView];
    }
}

- (void)meetingActorBeenDisabled
{
    [self removeActorSelectView];
    
    BOOL accepted = [[NTESMeetingNetCallManager sharedInstance] setBypassLiveStreaming:NO];
    
    if (!accepted) {
        [self.view.window makeToast:@"关闭互动直播被拒绝" duration:3.0 position:CSToastPositionTop];
    }
    
    [self.view.window makeToast:@"你已被老师取消互动" duration:2.0 position:CSToastPositionCenter];
}

- (void)meetingActorsNumberExceedMax
{
    [self.view makeToast:@"互动人数已满" duration:1 position:CSToastPositionCenter];
}

-(void)meetingRolesShowFullScreen:(NSString*)notifyExt
{
    if ([self showFullScreenBtn:notifyExt]) {
        self.actorsView.showFullScreenBtn = YES;
    }
    else
    {
        self.actorsView.showFullScreenBtn = NO;
    }
}
#pragma mark - NTESActorSelectViewDelegate
- (void)onSelectedAudio:(BOOL)audioOn video:(BOOL)videoOn whiteboard:(BOOL)whiteboardOn
{
    [self removeActorSelectView];
    _isRemainStdNav = NO;
    
    if (audioOn) {
        [[NTESMeetingRolesManager sharedInstance] setMyAudio:YES];
    }
    
    if (videoOn) {
        [[NTESMeetingRolesManager sharedInstance] setMyVideo:YES];
    }
    
    if (whiteboardOn) {
        [[NTESMeetingRolesManager sharedInstance] setMyWhiteBoard:YES];
    }
    
    BOOL accepted = [[NTESMeetingNetCallManager sharedInstance] setBypassLiveStreaming:YES];
    
    if (!accepted) {
        [self.view.window makeToast:@"开启互动直播被拒绝" duration:3.0 position:CSToastPositionTop];
    }
}
-(BOOL)showFullScreenBtn:(NSString * )jsonString
{
    if(jsonString)
    {
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *err;
        
        NSDictionary *dic = [NSJSONSerialization  JSONObjectWithData:jsonData
                             
                                                             options:NSJSONReadingAllowFragments
                             
                                                               error:&err];
        
        if ([dic objectForKey:@"fullScreenType"])
        {
            if([[dic objectForKey:@"fullScreenType"]integerValue] == 1)
            {
                return YES;
            }
        }
        return NO;
    }
    
    return NO;
}
//加载自定义的控制栏
- (void)setupControl{
    //    [self refreshStdNavBar];
    
    [self.interactionView.teacherCameraView bringSubviewToFront:self.interactionView.cameraOverlay];
    //刷新控制栏
    [self refreshControl];
    
}
/**刷新控制栏*/
- (void)refreshControl{
    
    NTESMeetingRole *myRole = [[NTESMeetingRolesManager sharedInstance] myRole];
}


-(void)refreshStdNavBar
{
    NTESMeetingRole *myRole = [[NTESMeetingRolesManager sharedInstance] myRole];
    NSString *audioImage = myRole.audioOn ? @"chatroom_audio_on" : @"chatroom_audio_off";
    NSString *videoImage = myRole.videoOn ? @"chatroom_video_on" : @"chatroom_video_off";
    NSString *audioImageSelected = myRole.audioOn ? @"chatroom_audio_selected" : @"chatroom_audio_off_selected";
    NSString *videoImageSelected = myRole.audioOn ? @"chatroom_video_selected" : @"chatroom_video_off_selected";
    CGFloat btnWidth = 30;
    CGFloat btnHeight = 30;
    CGFloat btnMargin = 7;
    if (myRole.isActor&&!_isRemainStdNav) {  //有发言权限，变成3个按钮
        UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,4*(btnWidth+btnMargin), btnHeight)];
        //视频按钮
        UIButton *videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        videoButton.frame = CGRectMake(2*btnMargin+btnWidth, 0, btnWidth, btnHeight);
        [videoButton setImage:[UIImage imageNamed:videoImage] forState:UIControlStateNormal];
        [videoButton setImage:[UIImage imageNamed:videoImageSelected] forState:UIControlStateHighlighted];
        [videoButton addTarget:self action:@selector(onSelfVideoPressed:) forControlEvents:UIControlEventTouchUpInside];
        //音频按钮
        UIButton *audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        audioButton.frame = CGRectMake(3*btnMargin+2*btnWidth, 0, btnWidth, btnHeight);
        [audioButton setImage:[UIImage imageNamed:audioImage] forState:UIControlStateNormal];
        [audioButton setImage:[UIImage imageNamed:audioImageSelected] forState:UIControlStateHighlighted];
        [audioButton addTarget:self action:@selector(onSelfAudioPressed:) forControlEvents:UIControlEventTouchUpInside];
        //结束按钮
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(4*btnMargin+3*btnWidth, 0, btnWidth, btnHeight);
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"chatroom_interaction_bottom"] forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"chatroom_interaction_bottom_selected"] forState:UIControlStateHighlighted];
        
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [cancelButton setTitle:@"结束" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(onCancelInteraction:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.tag = 10001;
        
        [rightView addSubview:audioButton];
        [rightView addSubview:videoButton];
        [rightView addSubview:cancelButton];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        NSMutableArray *arrayItems=[NSMutableArray array];
        [arrayItems addObject:negativeSpacer];
        [arrayItems addObject:rightItem];
        negativeSpacer.width = -btnMargin;
        self.navigationItem.rightBarButtonItems = arrayItems;
        
    }
    else
    {
        UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 2*(btnWidth+btnMargin), btnHeight)];
        //互动按钮
        UIButton *raiseHandButton = [UIButton buttonWithType:UIButtonTypeCustom];
        raiseHandButton.frame = CGRectMake(btnWidth+2*btnMargin, 0, btnWidth, btnHeight);
        
        if (!myRole.isRaisingHand) {
            [raiseHandButton setImage:[UIImage imageNamed:@"chatroom_interaction"] forState:UIControlStateNormal];
            [raiseHandButton setImage:[UIImage imageNamed:@"chatroom_interaction_selected"] forState:UIControlStateHighlighted];
        }
        else{
            [raiseHandButton setBackgroundImage:[UIImage imageNamed:@"chatroom_interaction_bottom"] forState:UIControlStateNormal];
            [raiseHandButton setBackgroundImage:[UIImage imageNamed:@"chatroom_interaction_bottom_selected"] forState:UIControlStateHighlighted];
            raiseHandButton.titleLabel.font = [UIFont systemFontOfSize:11];
            [raiseHandButton setTitle:@"取消" forState:UIControlStateNormal];
        }
        
        [raiseHandButton addTarget:self action:@selector(onRaiseHandPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [rightView addSubview:raiseHandButton];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        
        NSMutableArray *arrayItems=[NSMutableArray array];
        [arrayItems addObject:negativeSpacer];
        [arrayItems addObject:rightItem];
        negativeSpacer.width = -btnMargin;
        self.navigationItem.rightBarButtonItems = arrayItems;
    }
}

////demo的返回上一页
- (void)onBack:(id)sender
{
    NTESMeetingRole *myRole = [[NTESMeetingRolesManager sharedInstance] myRole];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定退出直播吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    [alert showAlertWithCompletionHandler:^(NSInteger index) {
        switch (index) {
            case 1:{
                if (myRole.isManager ) {
                    [self requestCloseChatRoom];
                }
                [self pop];
                break;
            }
                
            default:
                break;
        }
    }];
}

////demo的结束互动按钮
-(void)onCancelInteraction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定退出互动么？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    [alert showAlertWithCompletionHandler:^(NSInteger index) {
        switch (index) {
            case 1:{
                [self onRaiseHandPressed:sender];
                break;
            }
                
            default:
                break;
        }
    }];
}
//举手按钮
- (void)onRaiseHandPressed:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NTESMeetingRole *myRole = [[NTESMeetingRolesManager sharedInstance] myRole];
    if (btn.tag == 10001) {
        [[NIMAVChatSDK sharedSDK].netCallManager setMeetingRole:NO];
        myRole.isActor = NO;
        myRole.isRaisingHand = YES;
        myRole.videoOn = NO;
        myRole.audioOn = NO;
        myRole.whiteboardOn = NO;
    }
    [[NTESMeetingRolesManager sharedInstance] changeRaiseHand];
}

- (void)onSelfVideoPressed:(id)sender
{
    BOOL videoIsOn = [NTESMeetingRolesManager sharedInstance].myRole.videoOn;
    
    [[NTESMeetingRolesManager sharedInstance] setMyVideo:!videoIsOn];
}

- (void)onSelfAudioPressed:(id)sender
{
    BOOL audioIsOn = [NTESMeetingRolesManager sharedInstance].myRole.audioOn;
    
    [[NTESMeetingRolesManager sharedInstance] setMyAudio:!audioIsOn];
}

- (void)requestCloseChatRoom
{
    [SVProgressHUD show];
    __weak typeof(self) wself = self;
    
    [[NTESDemoService sharedService] closeChatRoom:_chatroom.roomId creator:_chatroom.creator completion:^(NSError *error, NSString *roomId) {
        [SVProgressHUD dismiss];
        if (error) {
            [wself.view makeToast:@"结束房间失败" duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

- (void)requestChatRoomInfo
{
    __weak typeof(self) wself = self;
    [[NIMSDK sharedSDK].chatroomManager fetchChatroomInfo:_chatroom.roomId completion:^(NSError * _Nullable error, NIMChatroom * _Nullable chatroom) {
        if (!error) {
            if([wself showFullScreenBtn:chatroom.ext])
            {
                wself.actorsView.showFullScreenBtn = YES;
            }
        }
        else
        {
            [wself.view makeToast:@"获取聊天室信息失败" duration:2.0 position:CSToastPositionCenter];
        }
    }];
}


- (void)removeActorSelectView
{
    if (self.actorSelectView) {
        [self.actorSelectView removeFromSuperview];
        self.actorSelectView = nil;
    }
}

- (void)pop
{
    if (!self.isPoped) {
        self.isPoped = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}





#pragma mark- 白板功能

//初始化白板
- (void)setupWhiteBoard{
    
    _name = _chatroom.roomId;
    _managerUid = _chatroom.creator;
    _cmdHander = [[NTESWhiteboardCmdHandler alloc] initWithDelegate:self];
    //    _docHander = [[NTESDocumentHandler alloc]initWithDelegate:self];
    [[NTESMeetingRTSManager sharedInstance] setDataHandler:_cmdHander];
    _colors = @[@(0x000000), @(0xd1021c), @(0xfddc01), @(0x7dd21f), @(0x228bf7), @(0x9b0df5)];
    if([NTESMeetingRolesManager sharedInstance].myRole.isManager){
        _myDrawColorRGB = [_colors[0] intValue];
    }
    else
    {
        _myDrawColorRGB = [_colors[4] intValue];
    }
    _lines = [[NTESWhiteboardLines alloc] init];
    
    _myUid = [[NIMSDK sharedSDK].loginManager currentAccount];
    
    _docInfoDic = [NSMutableDictionary dictionary];
    
    
    _isManager = [NTESMeetingRolesManager sharedInstance].myRole.isManager;
    [[NTESMeetingRTSManager sharedInstance] setDelegate:self];
    
    NSError *error;
    if (_isManager) {
        error = [[NTESMeetingRTSManager sharedInstance] reserveConference:_name];
    }
    else {
        error = [[NTESMeetingRTSManager sharedInstance] joinConference:_name];
    }
    
    if (error) {
        //        DDLogError(@"Error %zd reserve/join rts conference: %@", error.code, _name);
    }
    //加载白板UI
    [self initUI];
}

//初始化白板UI
- (void)initUI
{
    self.interactionView.whiteBoardView.backgroundColor = UIColorFromRGB(0xedf1f5);
    [self.interactionView.whiteBoardView addSubview:self.docView];
    
    [self.interactionView.whiteBoardView addSubview:self.drawView];
    
    [self.interactionView.whiteBoardView addSubview:self.controlPannel];
    
    [self.interactionView.whiteBoardView addSubview:self.colorSelectView];
    [self.drawView addSubview:self.laserView];
    [self.docView setHidden:YES];
    [self.laserView setHidden:YES];
    
    [self.colorSelectView setHidden:YES];
    
    [self.controlPannel addSubview:self.cancelLineButton];
    [self.controlPannel addSubview:self.colorSelectButton];
    [self.controlPannel addSubview:self.pageNumLabel];
    [self.pageNumLabel setHidden:YES];
    
    if (_isManager) {
        [self.controlPannel addSubview:self.clearAllButton];
        [self.controlPannel addSubview:self.openDocumentButton];
        [self.controlPannel addSubview:self.previousButton];
        [self.controlPannel addSubview:self.nextButton];
        [self.drawView addSubview:self.closeDocButton];
        [self.drawView addSubview:self.imgloadLabel];
        [self.nextButton setHidden:YES];
        [self.previousButton setHidden:YES];
        [self.closeDocButton setHidden:YES];
        [self.imgloadLabel setHidden:YES];
    }
    else {
        [self.controlPannel addSubview:self.hintLabel];
    }
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat spacing = 15.f;
    
    self.controlPannel.width = self.interactionView.whiteBoardView.width_sd + 2.f;
    self.controlPannel.height = 50.f;
    self.controlPannel.left = - 1.f;
    self.controlPannel.bottom = self.interactionView.whiteBoardView.bottom_sd + 1.f;
    
    self.colorSelectButton.left = spacing;
    self.colorSelectButton.bottom = self.controlPannel.height - 7.f;
    
    
    self.cancelLineButton.left = self.colorSelectButton.right + spacing;
    self.cancelLineButton.bottom = self.colorSelectButton.bottom;
    
    self.clearAllButton.left = self.cancelLineButton.right + spacing;
    self.clearAllButton.bottom = self.cancelLineButton.bottom;
    
    self.openDocumentButton.left = self.clearAllButton.right + spacing;
    self.openDocumentButton.bottom = self.clearAllButton.bottom;
    
    
    self.colorSelectView.width = 34.f;
    self.colorSelectView.height = self.colorSelectView.width * _colors.count;
    self.colorSelectView.centerX = self.colorSelectButton.centerX;
    self.colorSelectView.bottom = self.controlPannel.top - 3.5f ;
    //小屏适配
    if (self.colorSelectView.height > self.view.height - self.controlPannel.height) {
        self.colorSelectView.height = self.view.height - self.controlPannel.height;
        self.colorSelectView.bottom = self.controlPannel.top;
    }
    
    
    self.hintLabel.left = self.cancelLineButton.right + spacing / 2.f;
    self.hintLabel.centerY = self.controlPannel.height / 2.f;
    
    
    CGFloat drawViewWidth = self.interactionView.whiteBoardView.width_sd - spacing;
    CGFloat drawViewHeight = self.interactionView.whiteBoardView.height_sd - self.controlPannel.height - spacing;
    
    if (drawViewHeight > drawViewWidth * 3.f / 4.f) {
        drawViewHeight = drawViewWidth * 3.f / 4.f;
    }
    else {
        drawViewWidth = drawViewHeight * 4.f / 3.f;
    }
    
    self.drawView.width = drawViewWidth;
    self.drawView.height = drawViewHeight;
    
    self.drawView.left = (self.interactionView.whiteBoardView.width_sd- self.drawView.width) / 2.f;
    self.drawView.top = self.interactionView.whiteBoardView.top_sd + (self.interactionView.whiteBoardView.height_sd - self.controlPannel.height - self.drawView.height) / 2.f;
    
    self.docView.width = drawViewWidth;
    self.docView.height = drawViewHeight;
    
    self.docView.left = self.drawView.left;
    self.docView.top = self.drawView.top;
    
    self.nextButton.right = self.interactionView.whiteBoardView.width_sd- 10.f;
    self.nextButton.centerY = self.colorSelectButton.centerY;
    
    if (_isManager) {
        self.pageNumLabel.right = self.nextButton.left - 5.f;
        self.pageNumLabel.centerY = self.colorSelectButton.centerY;
    }
    else
    {
        self.pageNumLabel.right = self.interactionView.whiteBoardView.width_sd - 15.f;
        self.pageNumLabel.centerY = self.colorSelectButton.centerY;
    }
    
    
    self.previousButton.right = self.pageNumLabel.left - 5.f;
    self.previousButton.centerY = self.colorSelectButton.centerY;
    
    self.closeDocButton.right = self.drawView.width - 5.f;
    self.closeDocButton.top = 5.f;
    
    self.imgloadLabel.width = drawViewWidth;
    self.imgloadLabel.height = drawViewHeight;
    self.imgloadLabel.centerX = self.drawView.width / 2.f;
    self.imgloadLabel.centerY = self.drawView.height / 2.f;
    
    
}

- (void)checkPermission
{
    if ([NTESMeetingRolesManager sharedInstance].myRole.whiteboardOn && _isJoined) {
        self.hintLabel.hidden = YES;
        [self.colorSelectButton setBackgroundColor:UIColorFromRGB(_myDrawColorRGB)];
        self.colorSelectButton.enabled = YES;
        self.cancelLineButton.enabled = YES;
        self.clearAllButton.enabled = YES;
    }
    else {
        self.hintLabel.hidden = NO;
        [self.colorSelectButton setBackgroundColor:UIColorFromRGB(_myDrawColorRGB)];
        self.colorSelectButton.enabled = YES;
        self.cancelLineButton.enabled = YES;
        self.clearAllButton.enabled = YES;
        self.colorSelectView.hidden = YES;
        
    }
}

- (UIView *)drawView
{
    if (!_drawView) {
        _drawView = [[NTESWhiteboardDrawView alloc] initWithFrame:CGRectZero];
        _drawView.backgroundColor = [UIColor whiteColor];
        _drawView.layer.borderWidth = 1;
        _drawView.layer.borderColor = UIColorFromRGB(0xd7dade).CGColor;
        
        _drawView.dataSource = _lines;
    }
    return _drawView;
}

- (UIView *)laserView
{
    if (!_laserView) {
        _laserView = [[UIView alloc]initWithFrame:CGRectZero];
        _laserView.width = 7;
        _laserView.height = 7;
        _laserView.backgroundColor = [UIColor redColor];
        _laserView.layer.cornerRadius = 3.5;
        _laserView.layer.masksToBounds = YES;
    }
    return _laserView;
}

- (UIView *)controlPannel
{
    if (!_controlPannel) {
        _controlPannel = [[UIView alloc] init];
        _controlPannel.layer.borderWidth = 1;
        _controlPannel.layer.borderColor = UIColorFromRGB(0xd7dade).CGColor;
        _controlPannel.backgroundColor = [UIColor whiteColor];
    }
    return _controlPannel;
}

- (UIButton *)clearAllButton
{
    if (!_clearAllButton) {
        _clearAllButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35.f, 35.f)];
        [_clearAllButton addTarget:self action:@selector(onClearAllPressed:)  forControlEvents:UIControlEventTouchUpInside];
        
        [_clearAllButton setBackgroundImage:[UIImage imageNamed:@"btn_whiteboard_clear_normal"] forState:UIControlStateNormal];
        [_clearAllButton setBackgroundImage:[UIImage imageNamed:@"btn_whiteboard_clear_pressed"] forState:UIControlStateHighlighted];
        [_clearAllButton setBackgroundImage:[UIImage imageNamed:@"btn_whiteboard_clear_disabled"] forState:UIControlStateDisabled];
    }
    return _clearAllButton;
}

- (UIButton *)cancelLineButton
{
    if (!_cancelLineButton) {
        
        _cancelLineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35.f, 35.f)];
        [_cancelLineButton addTarget:self action:@selector(onCancelLinePressed:)  forControlEvents:UIControlEventTouchUpInside];
        
        [_cancelLineButton setBackgroundImage:[UIImage imageNamed:@"btn_whiteboard_cancel_normal"] forState:UIControlStateNormal];
        [_cancelLineButton setBackgroundImage:[UIImage imageNamed:@"btn_whiteboard_cancel_pressed"] forState:UIControlStateHighlighted];
        [_cancelLineButton setBackgroundImage:[UIImage imageNamed:@"btn_whiteboard_cancel_disabled"] forState:UIControlStateDisabled];
        
    }
    return _cancelLineButton;
}

- (UIButton *)colorSelectButton
{
    if (!_colorSelectButton) {
        _colorSelectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35.f, 35.f)];
        _colorSelectButton.layer.cornerRadius = 35.f / 2.f;
        [_colorSelectButton setBackgroundColor:UIColorFromRGB(_myDrawColorRGB)];
        [_colorSelectButton setBackgroundImage:[UIImage imageNamed:@"btn_whiteboard_select_color_disabled"] forState:UIControlStateDisabled];
        
        [_colorSelectButton addTarget:self action:@selector(onColorSelectPressed:)  forControlEvents:UIControlEventTouchUpInside];
        
        UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(9.f, 9.f, 17.f, 17.f)];
        circle.layer.cornerRadius = 17.f / 2.f;
        circle.layer.borderColor = [UIColor whiteColor].CGColor;
        circle.layer.borderWidth = 1;
        [circle setUserInteractionEnabled:NO];
        [_colorSelectButton addSubview:circle];
    }
    return _colorSelectButton;
}

-(UIButton*)openDocumentButton
{
    if (!_openDocumentButton) {
        _openDocumentButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35.f, 35.f)];
        [_openDocumentButton addTarget:self action:@selector(onOpenDocumentPressed:)  forControlEvents:UIControlEventTouchUpInside];
        
        [_openDocumentButton setBackgroundImage:[UIImage imageNamed:@"btn_whiteboard_file_normal"] forState:UIControlStateNormal];
        [_openDocumentButton setBackgroundImage:[UIImage imageNamed:@"btn_whiteboard_file_pressed"] forState:UIControlStateHighlighted];
        
    }
    return _openDocumentButton;
}

-(UIButton*)previousButton
{
    if (!_previousButton) {
        _previousButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35.f, 35.f)];
        [_previousButton addTarget:self action:@selector(onPreviousPagePressed:)  forControlEvents:UIControlEventTouchUpInside];
        [_previousButton setImageEdgeInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
        [_previousButton setImage:[UIImage imageNamed:@"btn_whiteboard_page_previous"] forState:UIControlStateNormal];
        [_previousButton setImage:[UIImage imageNamed:@"btn_whiteboard_page_previous_pressed"] forState:UIControlStateHighlighted];
        [_previousButton setImage:[UIImage imageNamed:@"btn_whiteboard_page_previous_disable"] forState:UIControlStateDisabled];
    }
    return _previousButton;
}

-(UIButton*)nextButton
{
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35.f, 35.f)];
        [_nextButton addTarget:self action:@selector(onNextPagePressed:)  forControlEvents:UIControlEventTouchUpInside];
        [_nextButton setImageEdgeInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
        [_nextButton setImage:[UIImage imageNamed:@"btn_whiteboard_page_next"] forState:UIControlStateNormal];
        [_nextButton setImage:[UIImage imageNamed:@"btn_whiteboard_page_next_pressed"] forState:UIControlStateHighlighted];
        [_nextButton setImage:[UIImage imageNamed:@"btn_whiteboard_page_next_disable"] forState:UIControlStateDisabled];
        
    }
    return _nextButton;
}

-(UIButton*)closeDocButton
{
    if (!_closeDocButton) {
        _closeDocButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35.f, 35.f)];
        [_closeDocButton addTarget:self action:@selector(onCloseDocPressed:)  forControlEvents:UIControlEventTouchUpInside];
        _closeDocButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_closeDocButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeDocButton setBackgroundImage:[UIImage imageNamed:@"chatroom_interaction_bottom"] forState:UIControlStateNormal];
        [_closeDocButton setBackgroundImage:[UIImage imageNamed:@"chatroom_interaction_bottom_selected"] forState:UIControlStateHighlighted];
    }
    return _closeDocButton;
}

- (UIImageView*)docView
{
    if (!_docView) {
        _docView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _docView.contentMode = UIViewContentModeScaleAspectFit;
        _docView.backgroundColor = [UIColor whiteColor];
    }
    return _docView;
}
- (NTESColorSelectView *)colorSelectView
{
    if (!_colorSelectView) {
        _colorSelectView = [[NTESColorSelectView alloc] initWithFrame:CGRectZero
                                                               colors:_colors
                                                             delegate:self];
    }
    return _colorSelectView;
}

- (UILabel *)hintLabel
{
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.text = @"加入互动后可在上方涂鸦";
        _hintLabel.textColor = UIColorFromRGB(0x999999);
        _hintLabel.font = [UIFont systemFontOfSize:12.f];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        [_hintLabel sizeToFit];
    }
    return _hintLabel;
}

- (UILabel *)pageNumLabel
{
    if (!_pageNumLabel) {
        _pageNumLabel = [[UILabel alloc] init];
        _pageNumLabel.text = [NSString stringWithFormat:@"%d/%lu",_currentPage,(unsigned long)_docInfo.numberOfPages];
        _pageNumLabel.textColor = UIColorFromRGB(0x999999);
        _pageNumLabel.font = [UIFont systemFontOfSize:15.f];
        _pageNumLabel.textAlignment = NSTextAlignmentCenter;
        [_pageNumLabel sizeToFit];
    }
    return _pageNumLabel;
}

- (UILabel *)imgloadLabel
{
    if (!_imgloadLabel) {
        _imgloadLabel = [[UILabel alloc] init];
        _imgloadLabel.text = @"加载中...";
        _imgloadLabel.textColor = UIColorFromRGB(0x999999);
        _imgloadLabel.font = [UIFont systemFontOfSize:15.f];
        _imgloadLabel.textAlignment = NSTextAlignmentCenter;
        _imgloadLabel.backgroundColor = [UIColor whiteColor];
    }
    return _imgloadLabel;
}


-(void)setCurrentPage:(int)currentPage
{
    _currentPage = currentPage;
    if (self.docInfo.numberOfPages ==1) {
        self.previousButton.enabled = NO;
        self.nextButton.enabled = NO;
    }
    else
    {
        if (_currentPage == 1) {
            self.previousButton.enabled = NO;
            self.nextButton.enabled = YES;
        }
        else if (_currentPage == self.docInfo.numberOfPages) {
            self.nextButton.enabled = NO;
            self.previousButton.enabled = YES;
        }
        else
        {
            self.previousButton.enabled = YES;
            self.nextButton.enabled = YES;
        }
    }
    self.pageNumLabel.text = [NSString stringWithFormat:@"%d/%lu",_currentPage,(unsigned long)_docInfo.numberOfPages];
    [self.pageNumLabel sizeToFit];
    [self.view setNeedsLayout];
    
    if (_isManager) {
        [self onClearAllPressed:nil];
    }
}
#pragma mark - User Interactions
- (void)onClearAllPressed:(id)sender
{
    [_lines clear];
    [_cmdHander sendPureCmd:NTESWhiteBoardCmdTypeClearLines to:nil];
    
}

- (void)onCancelLinePressed:(id)sender
{
    [_lines cancelLastLine:_myUid];
    [_cmdHander sendPureCmd:NTESWhiteBoardCmdTypeCancelLine to:nil];
}

- (void)onColorSelectPressed:(id)sender
{
    [self.colorSelectView setHidden:!(self.colorSelectView.hidden)];
}

- (void)onColorSeclected:(int)rgbColor
{
    [self.colorSelectButton setBackgroundColor:UIColorFromRGB(rgbColor)];
    _myDrawColorRGB = rgbColor;
    [self.colorSelectView setHidden:YES];
}

- (void)onOpenDocumentPressed:(id)sender
{
    //    NTESDocumentViewController *docVc = [[NTESDocumentViewController alloc]init];
    //    docVc.delegate = self;
    //    [self.navigationController pushViewController:docVc animated:YES];
}

- (void)onNextPagePressed:(id)sender
{
    self.currentPage++;
    [self loadImageOnWhiteboard];
}

- (void)onPreviousPagePressed:(id)sender
{
    self.currentPage--;
    [self loadImageOnWhiteboard];
}

-(void)onCloseDocPressed:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定关闭文档，回到纯白版模式吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"关闭文档", nil];
    [alert showAlertWithCompletionHandler:^(NSInteger index) {
        switch (index) {
            case 1:{
                self.docView.hidden = YES;
                self.nextButton.hidden = YES;
                self.previousButton.hidden = YES;
                self.pageNumLabel.hidden = YES;
                self.closeDocButton.hidden = YES;
                self.drawView.backgroundColor = [UIColor whiteColor];
                self.currentPage = 0;
                [self onSendDocShareInfoToUser:nil];
                break;
            }
                
            default:
                break;
        }
    }];
}
#pragma mark  - UIResponder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.colorSelectView.hidden = YES;
    CGPoint p = [[touches anyObject] locationInView:_drawView];
    [self onPointCollected:p type:NTESWhiteboardPointTypeStart];
    
    [_inputView.TextViewInput resignFirstResponder];
    [_inputView changeSendBtnWithPhoto:YES];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInView:_drawView];
    [self onPointCollected:p type:NTESWhiteboardPointTypeMove];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInView:_drawView];
    [self onPointCollected:p type:NTESWhiteboardPointTypeEnd];
}

- (void)onPointCollected:(CGPoint)p type:(NTESWhiteboardPointType)type
{
    if (!([NTESMeetingRolesManager sharedInstance].myRole.whiteboardOn)) {
        return;
    }
    
    if (!_isJoined) {
        return;
    }
    
    //    if (p.x < 0 || p.y < 0 || p.x > _drawView.frame.size.width || p.y > _drawView.frame.size.height) {
    //        return;
    //    }
    
    NTESWhiteboardPoint *point = [[NTESWhiteboardPoint alloc] init];
    point.type = type;
    point.xScale = p.x/_drawView.frame.size.width;
    point.yScale = p.y/_drawView.frame.size.height;
    point.colorRGB = _myDrawColorRGB;
    [_cmdHander sendMyPoint:point];
    [_lines addPoint:point uid:_myUid];
}


# pragma mark - NTESMeetingRTSManagerDelegate
- (void)onReserve:(NSString *)name result:(NSError *)result
{
    if (result == nil) {
        //        NSError *result = [[NTESMeetingRTSManager sharedInstance] joinConference:_name];
        //                DDLogError(@"join rts conference: %@ result %zd", _name, result.code);
        //        DDLogError(@"join rts conference: %@ result %zd", _name, result.code);
    }
    else {
        [self.view makeToast:[NSString stringWithFormat:@"预订白板出错:%zd", result.code]];
    }
}

- (void)onJoin:(NSString *)name result:(NSError *)result
{
    if (result == nil) {
        _isJoined = YES;
        [self checkPermission];
        
        if (_isManager) {
            [_cmdHander sendPureCmd:NTESWhiteBoardCmdTypeSyncPrepare to:nil];
            if ([_lines hasLines]) {
                [_cmdHander sync:[_lines allLines] toUser:nil];
            }
            [self onSendDocShareInfoToUser:nil];
        }
        else {
            [_lines clear];
            [_cmdHander sendPureCmd:NTESWhiteBoardCmdTypeSyncRequest to:_managerUid];
        }
    }
}

- (void)onLeft:(NSString *)name error:(NSError *)error
{
    [self.view makeToast:[NSString stringWithFormat:@"已离开白板:%zd", error.code]];
    _isJoined = NO;
    
    //    NSError *result = [[NTESMeetingRTSManager sharedInstance] joinConference:_name];
    //    DDLogError(@"Rejoin rts conference: %@ result %zd", _name, result.code);
    
    [self checkPermission];
}

- (void)onUserJoined:(NSString *)uid conference:(NSString *)name
{
    
}

- (void)onUserLeft:(NSString *)uid conference:(NSString *)name
{
    
}

#pragma mark - NTESWhiteboardCmdHandlerDelegate
- (void)onReceivePoint:(NTESWhiteboardPoint *)point from:(NSString *)sender
{
    [_lines addPoint:point uid:sender];
}

- (void)onReceiveCmd:(NTESWhiteBoardCmdType)type from:(NSString *)sender
{
    if (type == NTESWhiteBoardCmdTypeCancelLine) {
        [_lines cancelLastLine:sender];
    }
    else if (type == NTESWhiteBoardCmdTypeClearLines) {
        [_lines clear];
        [_cmdHander sendPureCmd:NTESWhiteBoardCmdTypeClearLinesAck to:nil];
    }
    else if (type == NTESWhiteBoardCmdTypeClearLinesAck) {
        [_lines clearUser:sender];
    }
    else if (type == NTESWhiteBoardCmdTypeSyncPrepare) {
        [_lines clear];
        [_cmdHander sendPureCmd:NTESWhiteBoardCmdTypeSyncPrepareAck to:sender];
    }
}

- (void)onReceiveSyncRequestFrom:(NSString *)sender
{
    if (_isManager) {
        [_cmdHander sync:[_lines allLines] toUser:sender];
        if (!self.docView.hidden) {
            [self onSendDocShareInfoToUser:sender];
        }
    }
}

- (void)onReceiveSyncPoints:(NSMutableArray *)points owner:(NSString *)owner
{
    [_lines clearUser:owner];
    
    for (NTESWhiteboardPoint *point in points) {
        [_lines addPoint:point uid:owner];
    }
}

- (void)onReceiveLaserPoint:(NTESWhiteboardPoint *)point from:(NSString *)sender
{
    [self.laserView setHidden:NO];
    CGPoint p = CGPointMake(point.xScale * self.drawView.frame.size.width , point.yScale * self.drawView.frame.size.height);
    self.laserView.center = p;
}

-(void)onReceiveHiddenLaserfrom:(NSString *)sender
{
    [self.laserView setHidden:YES];
}

-(void)onReceiveDocShareInfo:(NTESDocumentShareInfo *)shareInfo from:(NSString *)sender
{
    self.currentPage = shareInfo.currentPage;
    if (shareInfo.currentPage == 0) {
        self.drawView.backgroundColor = [UIColor whiteColor];
        [self.pageNumLabel setHidden:YES];
        return;
    }
    if (![self.docInfoDic objectForKey:shareInfo.docId])
    {
        //        [_docHander inquireDocInfo:shareInfo.docId];
    }
    else
    {
        self.docInfo = [self.docInfoDic objectForKey:shareInfo.docId];
        [self showDocOnStdWhiteboard];
    }
}

#pragma mark - NTESDocumentHandlerDelegate
-(void)notifyGetDocInfo:(NIMDocTranscodingInfo *)docInfo
{
    self.docInfo = docInfo;
    self.pageNumLabel.text = [NSString stringWithFormat:@"%d/%lu",_currentPage,(unsigned long)_docInfo.numberOfPages];
    [self.pageNumLabel sizeToFit];
    [self.docInfoDic setObject:docInfo forKey:docInfo.docId];
    [self showDocOnStdWhiteboard];
}

#pragma mark - NTESDocumentViewControllerDelegate
-(void)showDocOnWhiteboard:(NIMDocTranscodingInfo *)info
{
    self.docInfo = info;
    self.docView.hidden = NO;
    self.currentPage = 1;
    [self loadImageOnWhiteboard];
    
    self.pageNumLabel.hidden = NO;
    self.nextButton.hidden = NO;
    self.previousButton.hidden = NO;
    self.closeDocButton.hidden = NO;
    self.drawView.backgroundColor = [UIColor clearColor];
}

- (void)showDocOnStdWhiteboard
{
    NSString * url= [self.docInfo transcodedUrl:_currentPage ofQuality:NIMDocTranscodingQualityMedium];
    [self.docView sd_setImageWithURL:[NSURL URLWithString:url]];
    [self.docView setHidden:NO];
    [self.pageNumLabel setHidden:NO];
    self.drawView.backgroundColor = [UIColor clearColor];
}

- (void)onSendDocShareInfoToUser:(NSString*)sender{
    
    NTESDocumentShareInfo *shareInfo = [[NTESDocumentShareInfo alloc]init];
    shareInfo.docId = self.docInfo.docId;
    shareInfo.currentPage = _currentPage;
    shareInfo.pageCount = (int)self.docInfo.numberOfPages;
    shareInfo.type = NTESDocShareTypeTurnThePage;
    
    [_cmdHander sendDocShareInfo:shareInfo toUser:sender];
}

#pragma mark - NIMLoginManagerDelegate
- (void)onLogin:(NIMLoginStep)step
{
    if (step == NIMLoginStepLoginOK) {
        if (!_isJoined) {
            //            NSError *result = [[NTESMeetingRTSManager sharedInstance] joinConference:_name];
            //            DDLogError(@"Rejoin rts conference: %@ result %zd", _name, result.code);
        }
    }
    
    if (step == NIMLoginStepLoginOK) {
        if (![[NTESMeetingNetCallManager sharedInstance] isInMeeting]) {
            [self.view makeToast:@"登录成功，重新进入房间"];
            [[NTESMeetingNetCallManager sharedInstance] joinMeeting:_chatroom.roomId delegate:self];
        }
    }
}

#pragma mark - private method
-(void)loadImageOnWhiteboard
{
    NSString *filePath = [self getFilePathWithPage:_currentPage];
    UIImage* image = [self loadImage:filePath];
    //重新下载
    if (!image) {
        [self.imgloadLabel setHidden:NO];
        __weak typeof(self) weakself = self;
        [[NTESDocDownloadManager sharedManager]downLoadDoc:self.docInfo page:_currentPage completeBlock:^(NSError *error) {
            if (!error) {
                UIImage *image = [weakself loadImage:filePath];
                [weakself.imgloadLabel setHidden:YES];
                [weakself.docView setImage:image];
            }
            else
            {
                //加载失败
                [weakself.imgloadLabel setText:@"加载失败"];
                [weakself.imgloadLabel setHidden:NO];
            }
        }];
    }
    else
    {
        [self.imgloadLabel setHidden:YES];
        [self.docView setImage:image];
    }
    [self onSendDocShareInfoToUser:nil];
}

-(NSString *)getFilePathWithPage:(NSInteger)pageNum
{
    NSString *filePath = [[NTESDocumentHandler getFilePathPrefix:self.docInfo.docId]stringByAppendingString:[NSString stringWithFormat:@"%@_%zd.png",self.docInfo.docName,pageNum]];
    
    return filePath;
}

-(UIImage *)loadImage:(NSString*)filePath{
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        NSData * data = [NSData dataWithContentsOfFile:filePath];
        UIImage *image = [UIImage imageWithData:data];
        return image;
    }
    return nil;
}



#pragma mark- 聊天部分

//初始化聊天功能
- (void)setupChatFunc{
    
    
    //聊天输入框
    _inputView = ({
        
        UUInputFunctionView *_=[[UUInputFunctionView alloc]initWithSuperVC:self];
        
        _.frame = CGRectMake(0, _interactionView.chatView.height_sd-50,_interactionView.chatView.width_sd, TabBar_Height);
        [_.btnChangeVoiceState addTarget:self action:@selector(emojiKeyboardShow:) forControlEvents:UIControlEventTouchUpInside];
        _.TextViewInput.placeholder = @"请输入要发送的信息";
        _.delegate= self;
        [_interactionView.chatView addSubview:_];
        [_interactionView.chatView bringSubviewToFront:_];
        _;
    });
    
    /* 初始化*/
    if (_tutoriumInfo) {
        
        _session  = [NIMSession session:_tutoriumInfo.chat_team_id type:NIMSessionTypeTeam];
    }
    
    _chat_Account = [Chat_Account yy_modelWithJSON:[[NSUserDefaults standardUserDefaults]objectForKey:@"chat_account"]];
    
    _userList = @[].mutableCopy;
    
    self.chatModel = [[ChatModel alloc]init];
    self.chatModel.isGroupChat = YES;
    [self.chatModel populateRandomDataSource];
    
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
    
    
    NSLog(@"%ld",[[[NIMSDK sharedSDK]conversationManager] allUnreadCount]);
    
    if (_session) {
        
        [[[NIMSDK sharedSDK]conversationManager]markAllMessagesReadInSession:_session];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MarkAllRead" object:_session];
    }
    
    
    [self registerForKeyboardNotifications];
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    /* 获取一次所有成员信息*/
    [self requestChatTeamUser];
    
    /* 加载百度语音*/
    //    [self iBaiduLoad];
    
    
    /* 聊天信息 加个点击手势,取消输入框响应*/
    UITapGestureRecognizer *tapSpace = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSpace)];
    [_interactionView.chatTableView addGestureRecognizer:tapSpace];
    
    /* 添加录音是否开始的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recordStart) name:@"RecordStart" object:nil];
    
    /* 添加录音是否结束的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recordEnd) name:@"RecordEnd" object:nil];
    
    /* 添加录音是否取消的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recordCancel) name:@"RecordCancel" object:nil];
    
    /* 翻译完成的通知*/
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(translateFinish:) name:@"TranslateFinish" object:nil];
}


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
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Volum" object:[NSString stringWithFormat:@"%f",level*120]];
        
    });
}

- (void)checkMic{
    
    [self checkMicVolum];
    
    
}

//开始录制的方法
- (void)recordStart{
    
    //    [_iFlySpeechRecognizer startListening];
    [self checkMic];
    
}
//语音录制结束的方法
- (void)recordEnd{
    
    [levelTimer invalidate];
    levelTimer = nil;
    //    [_iFlySpeechRecognizer stopListening];
}
//语音录制取消的方法
- (void)recordCancel{
    
    [levelTimer invalidate];
    levelTimer = nil;
    //    [_iFlySpeechRecognizer cancel];
    
}
/* 请求聊天用户*/
- (void)requestChatTeamUser{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/live_studio/students/%@/courses/%@",Request_Header,_idNumber,_tutoriumInfo.classID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        /* 检测是否登录超时*/
        [self loginStates:dic];
        
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            
            
            NSMutableArray *users =[NSMutableArray arrayWithArray:dic[@"data"][@"chat_team"][@"accounts"]];
            
            for (NSDictionary *dic in users) {
                
                Chat_Account *mod  = [Chat_Account yy_modelWithJSON:dic];
                
                /* 获取到的用户信息存到userlist里*/
                [_userList addObject:mod];
                
            }
            
            
            [self requestChatHitstory];
            
        }else{
            /* 获取成员信息失败*/
            
            [self loadingHUDStopLoadingWithTitle:@"获取聊天成员信息失败!"];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}


- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
}



/* 加载本地数据*/
- (void)requestChatHitstory{
    
    NSArray *messageArr = [[[NIMSDK sharedSDK]conversationManager]messagesInSession:_session message:nil limit:100];
    /* 如果本地没有数据,请求服务器数据,并保存到本地*/
    if (messageArr.count<=2) {
        [self requestServerHistory];
        //        _chatTableView.hidden = NO;
    }else{
        
        _interactionView.chatTableView.hidden = NO;
        [self loadingHUDStopLoadingWithTitle:@""];
        [self makeMessages:messageArr];
    }
    
}


/* 请求服务器数据*/
- (void)requestServerHistory{
    
    NIMHistoryMessageSearchOption *option = [[NIMHistoryMessageSearchOption alloc]init];
    option.limit = 100;
    option.order = NIMMessageSearchOrderAsc;
    option.sync = YES;
    
    [[[NIMSDK sharedSDK]conversationManager]fetchMessageHistory:_session option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
        
        [self makeMessages:messages];
        
    }];
    
    
}

/* 创建消息 - 加载历史消息*/
- (void)makeMessages:(NSArray<NIMMessage *> * ) messages{
    
    for (NIMMessage *message in messages) {
        if (message.messageType == NIMMessageTypeText||message.messageType==NIMMessageTypeImage||message.messageType == NIMMessageTypeAudio) {
            
            _interactionView.chatTableView.hidden = NO;
            /* 如果是文本消息*/
            
            if (message.messageType ==NIMMessageTypeText) {
                
                NSLog(@"\n\n获取到的消息文本是:::%@\n\n",message.text);
                /* 如果消息是自己发的*/
                if ([message.from isEqualToString:_chat_Account.accid]) {
                    /* 在本地创建自己的消息*/
                    
                    NSString *title = message.text;
                    if (title==nil) {
                        title =@"";
                    }
                    /* 使用YYText*/
                    
                    /*
                     *
                     *
                     *
                     *
                     */
                    
                    
                    NSDictionary *dic;
                    
                    //创建一个可变的属性字符串
                    NSMutableAttributedString *text = [NSMutableAttributedString new];
                    [text appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:nil]];
                    
                    /* 正则匹配*/
                    NSString * pattern = @"\\[em_\\d{1,2}\\]";
                    NSError *error = nil;
                    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
                    
                    //通过正则表达式来匹配字符串,加载表情的同时判断是否存在富文本
                    NSArray *resultArray = [re matchesInString:title options:0 range:NSMakeRange(0, title.length)];
                    
                    if (resultArray.count != 0) {
                        /* 有表情富文本*/
                        
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
                            
                            NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeTopLeft attachmentSize:imageView.size alignToFont:[UIFont systemFontOfSize:13*ScrenScale] alignment:YYTextVerticalAlignmentTop];
                            
                            [text replaceCharactersInRange:[names [i][@"range"] rangeValue] withAttributedString:attachText];
                            
                            title = [title stringByReplacingCharactersInRange:[names [i][@"range"] rangeValue] withString:[names[i]valueForKey:@"name"]];
                            
                            dic = @{@"strContent": title,
                                    @"type": @(UUMessageTypeText),
                                    @"frome":@(UUMessageFromMe),
                                    @"strTime":[[NSString stringWithFormat:@"%ld",(NSInteger)message.timestamp]changeTimeStampToDateString],
                                    @"isRichText":@YES,
                                    @"richNum":[NSString stringWithFormat:@"%ld",resultArray.count],
                                    @"message":message};
                        }
                    }else{
                        /* 没有有表情的普通文本*/
                        dic = @{@"strContent": title,
                                @"type": @(UUMessageTypeText),
                                @"frome":@(UUMessageFromMe),
                                @"strTime":[[NSString stringWithFormat:@"%ld",(NSInteger)message.timestamp]changeTimeStampToDateString],
                                @"isRichText":@NO,
                                @"richNum":@"0",
                                @"message":message};
                        
                    }
                    
                    /* 判断和调整制作完毕后,使用dic字典制作消息*/
                    if (dic) {
                        [self dealTheFunctionData:dic andMessage:message];
                    }
                    
                }
                
                /* 如果消息是别人发的 */
                else {
                    
                    /* 在本地创建对方的消息消息*/
                    NSString *iconURL = @"".mutableCopy;
                    NSString *senderName = @"".mutableCopy;
                    for (Chat_Account *mod in _userList) {
                        if ([message.from isEqualToString:mod.accid]) {
                            iconURL = mod.icon;
                            senderName = mod.name;
                        }
                    }
                    
                    
                    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self.chatModel getDicWithText:message.text andName:senderName andIcon:iconURL type:UUMessageTypeText andTime:[[NSString stringWithFormat:@"%f",message.timestamp]changeTimeStampToDateString]andMessage:message]];
                    
                    [self.chatModel.dataSource addObjectsFromArray:[self.chatModel additems:1 withDictionary:dic]];
                    
                }
                
                
                [_interactionView.chatTableView reloadData];
                [self tableViewScrollToBottom];
                
            }else if (message.messageType ==NIMMessageTypeImage){
                /* 如果收到的消息类型是图片的话 */
                
                
                /* 如果消息是自己发的*/
                if ([message.from isEqualToString:_chat_Account.accid]){
                    
                    // NSLog(@"收到对方发来的图片");
                    
                    NIMImageObject *imageObject = message.messageObject;
                    
                    UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",imageObject.thumbPath]];
                    
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.chatModel getDicWithImage:image andName:message.senderName andIcon:_chat_Account.icon type:UUMessageTypePicture andImagePath:imageObject.url andThumbImagePath:imageObject.thumbPath andTime:[[NSString stringWithFormat:@"%f",message.timestamp]changeTimeStampToDateString]andMessage:message]];
                    
                    [dic setObject:@(UUMessageFromMe) forKey:@"from"];
                    
                    [self.chatModel.dataSource addObjectsFromArray:[self.chatModel additems:1 withDictionary:dic]];
                    
                }
                /* 如果消息是别人发的 */
                else{
                    /* 本地创建对方的图片消息*/
                    
                    //                    NSLog(@"收到对方发来的图片");
                    
                    /* 在本地创建对方的消息消息*/
                    NSString *iconURL = @"".mutableCopy;
                    NSString *senderName = @"".mutableCopy;
                    for (Chat_Account *mod in _userList) {
                        if ([message.from isEqualToString:mod.accid]) {
                            iconURL = mod.icon;
                            senderName = mod.name;
                        }
                    }
                    
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
                    
                    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self.chatModel getDicWithImage:image andName:senderName andIcon:iconURL type:UUMessageTypePicture andImagePath:imageObject.url andThumbImagePath:imageObject.thumbPath andTime:[[NSString stringWithFormat:@"%f",message.timestamp]changeTimeStampToDateString]andMessage:message]];
                    
                    [self.chatModel.dataSource addObjectsFromArray:[self.chatModel additems:1 withDictionary:dic]];
                    
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
                    /* 本地创建对方的图片消息*/
                    
                    /* 在本地创建对方的消息消息*/
                    NSString *iconURL = @"".mutableCopy;
                    NSString *senderName = @"".mutableCopy;
                    for (Chat_Account *mod in _userList) {
                        if ([message.from isEqualToString:mod.accid]) {
                            iconURL = mod.icon;
                            senderName = mod.name;
                        }
                    }
                    
                    NIMAudioObject *audioObject = message.messageObject;
                    
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.chatModel getDicWithVoice:[NSData dataWithContentsOfFile:audioObject.path] andName:message.senderName andIcon:_chat_Account.icon type:UUMessageTypeVoice andVoicePath:audioObject.path andTime:[NSString stringWithFormat:@"%ld",(NSInteger)audioObject.duration/1000]andMessage:message]];
                    
                    [self.chatModel.dataSource addObjectsFromArray:[self.chatModel additems:1 withDictionary:dic]];
                    
                }
                
            }
            
        }
        
    }
    
    [self loadingHUDStopLoadingWithTitle:@"加载完成!"];
    [self performSelector:@selector(sendNoticeIn) withObject:nil afterDelay:1];
    
    [_interactionView.chatTableView reloadData];
    [self tableViewScrollToBottom];
}



/* 发送您已加入聊天室的通知消息*/

- (void)sendNoticeIn{
    
    //    //构造消息
    //    NIMTipObject *tipObject = [NIMTipObject alloc];
    //    NIMMessage *message     = [[NIMMessage alloc] init];
    //    message.messageObject   = tipObject;
    //    //发送消息
    //    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:_session error:nil];
    
}

/* 制作消息内容*/
- (void)dealTheFunctionData:(NSDictionary *)dic andMessage:(NIMMessage *)message{
    
    /* 文字类型消息*/
    if ([dic[@"type"]isEqual:[NSNumber numberWithInteger:0]]) {
        /* 重写了UUMolde的添加自己的item方法 */
        [self.chatModel addSpecifiedItem:dic andIconURL:_chat_Account.icon andName:_chat_Account.name andMessage:message];
    }else if ([dic[@"type"]isEqual:[NSNumber numberWithInteger:1]]){
        /* 图片类型消息*/
        [self.chatModel addSpecifiedImageItem:dic andIconURL:_chat_Account.icon andName:_chat_Account.name andMessage:message];
        
    }else if ([dic[@"type"]isEqualToNumber:@2]){
        /* 语音类型消息*/
        [self.chatModel addSpecifiedVoiceItem:dic andIconURL:_chat_Account.icon andName:_chat_Account.name andMessage:message];
    }
    
    [_interactionView.chatTableView reloadData];
    [self tableViewScrollToBottom];
    
    
}



//即将发送消息回调
- (void)willSendMessage:(NIMMessage *)message{
    
    
}

//消息发送进度回调----文本消息没有这个回调
- (void)sendMessage:(NIMMessage *)message progress:(float)progress{
    
    NSLog(@"发送进度::%f",progress);
    
}


//消息发送完毕回调
- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(NSError *)error{
    
    switch (message.deliveryState) {
            //消息发送失败
        case NIMMessageDeliveryStateFailed:{
            
            for (UUMessageFrame *messageFrame in _chatModel.dataSource) {
                
                if ([messageFrame.message.messageID isEqualToString:message.messageId]) {
                    //找到发送失败的消息
                    messageFrame.message.sendFaild =YES;
                    
                    [_interactionView.chatTableView reloadData];
                    
                    return;
                    
                }
                
                
            }
            
            
        }
            break;
            //消息发送中
        case NIMMessageDeliveryStateDelivering:{
            
            
        }
            break;
            //消息发送成功
        case NIMMessageDeliveryStateDeliveried:{
            
            
            
        }
            break;
    }
    
    
}
//重新发送消息 主动方法
//- (BOOL)resendMessage:(NIMMessage *)message error:(NSError **)error



/* 接收消息的回调*/
- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages{
    
    for (int i = 0; i<messages.count; i++) {
        
        NIMMessage *message =messages[i];
        
        /* 筛选用户信息,拿到用户名*/
        
        NSString *iconURL = @"".mutableCopy;
        NSString *senderName = @"".mutableCopy;
        for (Chat_Account *mod in _userList) {
            if ([message.from isEqualToString:mod.accid]) {
                iconURL = mod.icon;
                senderName = mod.name;
            }
        }
        /* 如果收到的是文本消息*/
        if (message.messageType == NIMMessageTypeText) {
            
            /* 在本地创建对方的消息消息*/
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self.chatModel getDicWithText:message.text andName:senderName andIcon:iconURL type:UUMessageTypeText andTime:[[NSString stringWithFormat:@"%f",message.timestamp]changeTimeStampToDateString]andMessage:message]];
            
            [self.chatModel.dataSource addObjectsFromArray:[self.chatModel additems:1 withDictionary:dic]];
            
            [_interactionView.chatTableView reloadData];
            [self tableViewScrollToBottom];
            
        }
        
        /* 如果收到的是图片消息*/
        else if (message.messageType == NIMMessageTypeImage){
            
        }else if (message.messageType == NIMMessageTypeAudio){
            /* 如果收到的是音频消息*/
            
            
        }
        
    }
    
}
//如果收到的是图片，视频等需要下载附件的消息，在回调的处理中还需要调用
//（SDK 默认会在第一次收到消息时自动调用）
- (BOOL)fetchMessageAttachment:(NIMMessage *)message  error:(NSError **)error{
    
    return YES;
}


/* 接收图片的进度回调*/
- (void)fetchMessageAttachment:(NIMMessage *)message progress:(float)progress{
    
    NSLog(@"接收进度:----- %f",progress);
    
}

/* 接收到 语音/图片消息 完成后的回调*/
- (void)fetchMessageAttachment:(NIMMessage *)message didCompleteWithError:(NSError *)error{
    
    if (message.messageType == NIMMessageTypeImage) {
        /* 收到图片*/
        NSLog(@"收到图片");
        
        /* 在本地创建对方的消息消息*/
        NSString *iconURL = @"".mutableCopy;
        NSString *senderName = @"".mutableCopy;
        for (Chat_Account *mod in _userList) {
            if ([message.from isEqualToString:mod.accid]) {
                iconURL = mod.icon;
                senderName = mod.name;
            }
        }
        
        NIMImageObject *imageObject = message.messageObject;
        
        NSLog(@"%@",imageObject.thumbPath);
        NSLog(@"%@",imageObject.path);
        
        UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",imageObject.thumbPath]];
        
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self.chatModel getDicWithImage:image andName:senderName andIcon:iconURL type:UUMessageTypePicture andImagePath:imageObject.url andThumbImagePath:imageObject.thumbPath andTime:[[NSString stringWithFormat:@"%f",message.timestamp]changeTimeStampToDateString]andMessage:message]];
        
        [self.chatModel.dataSource addObjectsFromArray:[self.chatModel additems:1 withDictionary:dic]];
        
    }else if (message.messageType == NIMMessageTypeAudio){
        /* 收到语音消息*/
        NSLog(@"收到语音");
        
        /* 在本地创建对方的消息消息*/
        NSString *iconURL = @"".mutableCopy;
        NSString *senderName = @"".mutableCopy;
        for (Chat_Account *mod in _userList) {
            if ([message.from isEqualToString:mod.accid]) {
                iconURL = mod.icon;
                senderName = mod.name;
            }
        }
        
        NIMAudioObject *audioObject = message.messageObject;
        //audioObject.path 本地音频地址
        NSLog(@"%@",audioObject.path);
        
        //创建消息字典
        
        NSDictionary *dic = [self.chatModel getDicWithVoice:[NSData dataWithContentsOfFile:audioObject.path] andName:senderName andIcon:iconURL type:UUMessageTypeVoice andVoicePath:audioObject.path andTime:[NSString stringWithFormat:@"%ld",(NSInteger)audioObject.duration/1000]andMessage:message];
        
        [self.chatModel.dataSource addObjectsFromArray:[self.chatModel additems:1 withDictionary:dic]];
        
    }
    
    
    [_interactionView.chatTableView reloadData];
    [self tableViewScrollToBottom];
    
    
}



/* 接收到消息后 ，在本地创建消息*/
- (void)makeOthersMessageWith:(NSInteger)msgNum andMessage:(UUMessage *)message{
    
    [self.chatModel.dataSource addObject:message];
    
}
//重新发送消息方法
- (void)resendMessages:(UIButton *)sender{
    
    UUMessageFrame *failMsg = _chatModel.dataSource[sender.tag];
    
    if (failMsg.message.sendFaild==YES) {
        if (failMsg.message.from == UUMessageFromMe) {
            
            //制作成NIM消息
            NIMMessage * reMessage = [[NIMMessage alloc] init];
            switch (failMsg.message.type) {
                case UUMessageTypeText:{
                    reMessage.text = failMsg.message.strContent;
                    reMessage.messageObject = NIMMessageTypeText;
                    reMessage.apnsContent = @"发来了一条消息";
                    [[NIMSDK sharedSDK].chatManager addDelegate:self];
                    
                }
                    break;
                    
                case UUMessageTypePicture:{
                    
                    NIMImageObject * imageObject = [[NIMImageObject alloc] initWithImage:failMsg.message.picture];
                    
                    reMessage.messageObject= imageObject;
                    
                    
                }
                    break;
                case UUMessageTypeVoice:{
                    //读取音频源
                    NIMAudioObject *audioObject = [[NIMAudioObject alloc]initWithData:failMsg.message.voice extension:@".amr"];
                    
                    reMessage.messageObject = audioObject;
                    
                }
                    break;
            }
            
            [[[NIMSDK sharedSDK]chatManager]addDelegate:self];
            [[[NIMSDK sharedSDK]chatManager]resendMessage:reMessage error:nil];
            
            sender.hidden = YES;
            [sender removeTarget:self action:@selector(resendMessages:) forControlEvents:UIControlEventTouchUpInside];
            
            [_interactionView.chatTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            
        }
    }
}



- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message{
    
    if ([funcView.TextViewInput.text isEqualToString:@""]||funcView.TextViewInput.text==nil) {
        
        [self loadingHUDStopLoadingWithTitle:@"请输入聊天内容!"];
        
    }else{
        
        //这是最终要向云信发送的消息,放在这里是为了使用messageID来识别消息
        NIMMessage * text_message = [[NIMMessage alloc] init];
        
        /* 解析发送的字符串*/
        //解析和云信发送
        //        NSLog(@"%@", [funcView.TextViewInput.attributedText getPlainString]);
        
        NSDictionary *dic;
        
        NSString *title = [funcView.TextViewInput.attributedText getPlainString];
        
        
        if (title == nil) {
            title = @"";
        }
        
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
        
        if (resultArray.count!=0) {
            //如果是包含富文本
            
            //本地转转换发送
            
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
                        @"richNum":[NSString stringWithFormat:@"%ld",resultArray.count],
                        @"messageID":text_message.messageId};
                
            }
            
        }else{
            //如果不含富文本
            
            dic = @{@"strContent": [funcView.TextViewInput.attributedText getPlainString],
                    @"type": @(UUMessageTypeText),
                    @"frome":@(UUMessageFromMe),
                    @"strTime":[NSString stringWithFormat:@"%@",[[NSDate date]changeUTC]],
                    @"isRichText":@NO,
                    @"richNum":@"0",
                    @"messageID":text_message.messageId};
            
        }
        
        
        //发送消息
        
        text_message.text = title;
        text_message.messageObject = NIMMessageTypeText;
        text_message.apnsContent = @"发来了一条消息";
        
        [[NIMSDK sharedSDK].chatManager addDelegate:self];
        [[NIMSDK sharedSDK].chatManager sendMessage:text_message toSession:_session error:nil];
        
        //发送完消息后,再在本地制作一条消息,用来保存这个消息的id
        
        [self dealTheFunctionData:dic andMessage:text_message];
        
        
        [_inputView.TextViewInput setText:@""];
        [_inputView.TextViewInput resignFirstResponder];
        
    }
    
    [_interactionView.chatTableView reloadData];
    [self tableViewScrollToBottom];
    
    [funcView changeSendBtnWithPhoto:YES];
    
    
    
    
}

//发送图片聊天信息
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image{
    //创建一条云信消息
    NIMImageObject * imageObject = [[NIMImageObject alloc] initWithImage:image];
    NIMMessage *message = [[NIMMessage alloc] init];
    message.messageObject= imageObject;
    
    //创建一条本地消息
    NSDictionary *dic = @{@"picture": image,
                          @"type": @(UUMessageTypePicture),
                          @"frome":@(UUMessageFromMe),
                          @"strTime":[NSString stringWithFormat:@"%@",[[NSDate date]changeUTC]],
                          @"strTime":[NSString stringWithFormat:@"%@",[[NSDate date]changeUTC]],
                          @"messageID":message.messageId};
    
    
    [self dealTheFunctionData:dic andMessage:message];
    
    
    
    //发送消息
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:_session error:nil];
    
    
}
//发送语音消息
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second{
    
    //创建一条云信消息
    //    声音文件只支持 aac 和 amr 类型
    NSMutableString *tmpDir = [NSMutableString stringWithString:NSTemporaryDirectory()];
    [tmpDir appendString:@"mp3.amr"];
    
    //构造消息
    NIMAudioObject *audioObject = [[NIMAudioObject alloc] initWithSourcePath:tmpDir];
    NIMMessage *message = [[NIMMessage alloc] init];
    message.messageObject     = audioObject;
    
    
    //创建一条本地消息
    NSDictionary *dic = @{@"voice": voice,
                          @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)second],
                          @"type": @(UUMessageTypeVoice),
                          @"messageID":message.messageId};
    
    [self dealTheFunctionData:dic andMessage:message];
    
    /* 发送一条语音消息*/
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:_session error:nil];
    
    
    
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


//聊天页面tableView 滚动到底部
- (void)tableViewScrollToBottom{
    if (self.chatModel.dataSource.count==0)
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-1 inSection:0];
    [_interactionView.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}



//懒加载表情键盘
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
        
        [_inputView.TextViewInput becomeFirstResponder];
    }
    return _emotionKeyboard;
}



//点击表情按钮的点击事件
- (void)emojiKeyboardShow:(UIButton *)sender{
    
    if (sender.superview == _inputView) {
        
        if (_inputView.TextViewInput.inputView == nil) {
            _inputView.TextViewInput.yz_emotionKeyboard = self.emotionKeyboard;
            [sender setBackgroundImage:[UIImage imageNamed:@"toolbar-text"] forState:UIControlStateNormal];
            
        } else {
            _inputView.TextViewInput.inputView = nil;
            [sender setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
            [_inputView.TextViewInput reloadInputViews];
            
        }
        
    }
}



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
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        [_inputView setFrame:CGRectMake(0, _interactionView.chatView.height_sd -TabBar_Height-keyboardRect.size.height , self.view.width_sd, 50)];
        
        [_interactionView.chatTableView setFrame:CGRectMake(0, 64 , self.view.width_sd, _interactionView.chatView.height_sd-TabBar_Height-keyboardRect.size.height)];
        
    }];
    
    [self tableViewScrollToBottom];
    
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    // 获取通知信息字典
    NSDictionary* userInfo = [notification userInfo];
    
    // 获取键盘隐藏动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        [_inputView setFrame:CGRectMake(0, _interactionView.chatView.height_sd -TabBar_Height, self.view.width_sd, 50)];
        
        [_interactionView.chatTableView setFrame:CGRectMake(0, 0, self.view.width_sd, _interactionView.chatView.height_sd-TabBar_Height)];
        
    }];
    
    [self tableViewScrollToBottom];
}





- (void)tapSpace{
    [_inputView.TextViewInput resignFirstResponder];
    [_inputView changeSendBtnWithPhoto:YES];
    
    
}

/* 加载图片表情*/
- (UIImage *)imageWithName:(NSString *)name {
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"EmoticonQQ" ofType:@"bundle"]];
    NSString *path = [bundle pathForScaledResource:name ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    YYImage *image = [YYImage imageWithData:data scale:2];
    image.preloadAllAnimatedImageFrames = YES;
    return image;
}


//语音转换
-(void)cellContentLongPress:(UUMessageCell *)cell voice:(NSData *)voice{
    
    //    [cell becomeFirstResponder];
    //    UIMenuController *controller = [UIMenuController sharedMenuController];
    //    [controller setTargetRect:cell.btnContent.bounds inView:cell.btnContent];
    //    [controller setMenuVisible:YES animated:YES];
    
    
    NSString *voiceSwitch ;
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"AVAudioSession"]) {
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"AVAudioSession"]isEqualToString:@"loudspeaker"]) {
            
            voiceSwitch = @"使用听筒播放";
        }else if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"AVAudioSession"]isEqualToString:@"earphone"]){
            voiceSwitch = @"使用扬声器播放";
        }
    }else{
        voiceSwitch = @"使用听筒播放";
    }
    
    
    
    [UIAlertController showActionSheetInViewController:self withTitle:nil message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"文字转换",voiceSwitch] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
        
    } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex==2) {
            
            //构造消息
            //            NIMAudioObject *audioObject = [[NIMAudioObject alloc] initWithData:voice extension:@".aac"];
            
            NIMMessage *message        = cell.messageFrame.message.message;
            
            TranslateViewController *translate = [[TranslateViewController alloc]initWithMessage:message];
            [self presentViewController:translate animated:YES completion:^{
                
            }];
            
            
        }else if (buttonIndex == 3){
            
            if ([[NSUserDefaults standardUserDefaults]valueForKey:@"AVAudioSession"]) {
                
                if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"AVAudioSession"]isEqualToString:@"loudspeaker"]) {
                    
                    [[NSUserDefaults standardUserDefaults]setValue:@"earphone" forKey:@"AVAudioSession"];
                    
                }else if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"AVAudioSession"]isEqualToString:@"earphone"]){
                    
                    [[NSUserDefaults standardUserDefaults]setValue:@"loudspeaker" forKey:@"AVAudioSession"];
                    
                }
            }else{
                
                [[NSUserDefaults standardUserDefaults]setValue:@"earphone" forKey:@"AVAudioSession"];
            }
            
            
        }
        
    }];
    
    
}




#pragma mark- UITableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows = 0;
    
    switch (tableView.tag) {
        case 1:{
            
            if (self.chatModel.dataSource.count!=0) {
                
                rows = self.chatModel.dataSource.count;
            }else{
                
                rows = 0;
            }
            
        }
            break;
            
        case 2:{
            
            rows = _noticeArray.count;
            
        }
            break;
        case 3:{
            
            if (section == 0) {
//                if (showAllTeachers ==NO) {
//                    if (_teachersArray.count>=2) {
//                        rows = 2;
//                    }else{
//                        rows = _teachersArray.count;
//                    }
//                }else{
//                    
//                    rows = _teachersArray.count;
//                }
                rows = _teachersArray.count;
                
            }else if (section == 1){
                
                rows = _classesArray.count;
            }
            
        }
            break;
        case 4:{
            
            rows = _membersArray.count;
            
        }
            break;
    }
    
    
    return rows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tableCell ;
    
    switch (tableView.tag) {
        case 1:{
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            UUMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[UUMessageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            }
            
            if (self.chatModel.dataSource.count>indexPath.row) {
                
                cell.delegate = self;
                [cell setMessageFrame:self.chatModel.dataSource[indexPath.row]];
                
                /* 消息发送状态*/
                /* 如果消息是发送成功的*/
                if (cell.messageFrame.message.sendFaild == NO) {
                    cell.sendfaild.hidden =YES;
                }else{
                    cell.sendfaild.hidden = NO;
                    cell.sendfaild.tag = indexPath.row;
                    [cell.sendfaild addTarget:self action:@selector(resendMessages:) forControlEvents:UIControlEventTouchUpInside]; //让该消息可以再次发送
                }
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            }
            
            
            tableCell = cell;
            
        }
            break;
        case 2:{
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            NoticeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[NoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            }
            if (_noticeArray.count>indexPath.row) {
                cell.model = _noticeArray[indexPath.row];
            }
            
            tableCell = cell;
            
        }
            break;
        case 3:{
            
            switch (indexPath.section) {
                case 0:{
                    /* cell的重用队列*/
                    static NSString *cellIdenfier = @"cellID";
                    InteractionTeacherListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
                    if (cell==nil) {
                        cell=[[InteractionTeacherListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
                    }
                    
                    if (_teachersArray.count >indexPath.row) {
                        
                        cell.model = _teachersArray[indexPath.row];
                        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                        
                    }
                    
                    tableCell = cell;

                }
                    break;
                    
                case 1:{
                    /* cell的重用队列*/
                    static NSString *cellIdenfier = @"cell";
                    ClassesListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
                    if (cell==nil) {
                        cell=[[ClassesListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                    }
                    if (_classesArray.count>indexPath.row) {
                        
                        cell.classModel = _classesArray[indexPath.row];
                        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                        cell.replay.hidden = YES;
                        
                    }
                    
                    tableCell = cell;

                }
                    break;
            }
            
        }
            break;
        case 4:{
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            MemberListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[MemberListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            }
            
            if (_membersArray.count>indexPath.row) {
                cell.model = _membersArray[indexPath.row];
            }else{
                
            }
            
            tableCell = cell;
            
        }
            break;
            
            
    }
    return tableCell;
}

#pragma mark- UITableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    NSInteger sec = 1;
    if (tableView.tag == 3) {
        sec = 2;
    }
    
    return sec;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger height = 40;
    
    switch (tableView.tag) {
        case 1:{
            
            if (self.chatModel.dataSource.count>indexPath.row){
                
                height =  [self.chatModel.dataSource[indexPath.row] cellHeight];
            }else{
                
            }
            
            
        }
            break;
            
        case 2:{
            
            height =[tableView cellHeightForIndexPath:indexPath model:_noticeArray[indexPath.row] keyPath:@"model" cellClass:[NoticeTableViewCell class] contentViewWidth:self.view.width_sd];
            
        }
            break;
        case 3:{
            
            switch (indexPath.section) {
                case 0:
                    height = 120;
                    break;
                    
                case 1:
                    height = [tableView cellHeightForIndexPath:indexPath model:_classesArray[indexPath.row] keyPath:@"classModel" cellClass:[ClassesListTableViewCell class] contentViewWidth:self.view.width_sd];
                    break;
            }
            
        }
            break;
            
        case 4:{
            
            height = 60;
            
        }
            break;
    }
    
    return height;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view;
    if (tableView.tag == 3) {
        if (section == 0) {
            if (showAllTeachers == NO) {
                
                view = [[UIView alloc]init];
                view.size = CGSizeMake(self.view.width_sd, 40);
                view.backgroundColor = SEPERATELINECOLOR;
                UIButton *allButton = [[UIButton alloc]init];
                allButton.sd_layout
                .leftSpaceToView(view, 0)
                .rightSpaceToView(view, 0)
                .topSpaceToView(view, 0)
                .bottomSpaceToView(view, 0);
                
                [allButton setTitle:@"显示全部" forState:UIControlStateNormal];
                [allButton setTitleColor:TITLECOLOR forState:UIControlStateNormal];
                allButton.titleLabel.font = TEXT_FONTSIZE;
                [allButton addTarget:self action:@selector(showAllTeachers:) forControlEvents:UIControlEventTouchUpInside];

                
            }else{
                view = [[UIView alloc]init];
                view.size = CGSizeMake(self.view.width_sd, 10);
                view.backgroundColor = SEPERATELINECOLOR;
                
            }
            
        }
    }
    
    return  view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    CGFloat height = 0;
    if (tableView.tag == 3) {
        if (section == 0) {
            if (showAllTeachers==NO) {
                if (_teachersArray.count<=2) {
                    height =10;
                }else{
                    height= 40;
                }
                
            }else{
                height = 10;
            }
        }
    }
    
    return height;
}



//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 3) {
        
        InteractionTeacherListTableViewCell *cell = (InteractionTeacherListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        TeachersPublicViewController *controller = [[TeachersPublicViewController alloc]initWithTeacherID:cell.model.teacherID];
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

/**显示所有教师*/
- (void)showAllTeachers:(UIButton *)sender{
    
    showAllTeachers = YES;
    [sender setTitle:nil forState:UIControlStateNormal];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [sender addSubview:indicator];
    indicator.sd_layout
    .leftSpaceToView(sender, 0)
    .rightSpaceToView(sender, 0)
    .topSpaceToView(sender, 0)
    .bottomSpaceToView(sender, 0);
    
    [_interactionView.classListTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    //SDAutoLayout刷新section的方法
//    [_interactionView.classListTableView reloadDataWithInsertingDataAtTheBeginingOfSection:0 newDataCount:_teachersArray.count];
    
    
}




#pragma mark- InteractionControl delegate
//返回上一页
- (void)returnLastPage:(UIButton *)sender{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定退出互动么？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    [alert showAlertWithCompletionHandler:^(NSInteger index) {
        switch (index) {
            case 1:{
                [self onRaiseHandPressed:sender];
                
                [self pop];
                
                break;
            }
                
            default:
                break;
        }
    }];
    
}


#pragma mark- InteractionOverlay delegate

//控制栏隐藏/显示 的代理方法
- (void)controlOnOverlay:(UIControl *)sender{
    
    if (_interactionView.topControl.hidden == NO) {
        
        [self hideControlerOnAlpha];
        
        
    }else{
        
        [self showControlOnAlpha];
    }
    
}
//全屏缩放切换
- (void)scale:(UIButton *)sender{
    
    
}

//开关摄像头
- (void)turnCamera:(UIButton *)sender{
    
    BOOL videoIsOn = [NTESMeetingRolesManager sharedInstance].myRole.videoOn;
    
    
    if (videoIsOn == YES) {
        [sender setImage:[UIImage imageNamed:@"camera_off"] forState:UIControlStateNormal];
        
    }else{
        [sender setImage:[UIImage imageNamed:@"camera_on"] forState:UIControlStateNormal];
        
    }
    
    [[NTESMeetingRolesManager sharedInstance] setMyVideo:!videoIsOn];
    
}

//开关声音
- (void)turnVoice:(UIButton *)sender{
    
    BOOL audioIsOn = [NTESMeetingRolesManager sharedInstance].myRole.audioOn;
    
    if (audioIsOn == YES) {
        [sender setImage:[UIImage imageNamed:@"mic_off"] forState:UIControlStateNormal];
    }else{
        
        [sender setImage:[UIImage imageNamed:@"mic_on"] forState:UIControlStateNormal];
    }
    
    [[NTESMeetingRolesManager sharedInstance] setMyAudio:!audioIsOn];
    
}
//自动隐藏控制栏
- (void)hideControl{
    
    _interactionView.topControl.hidden = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControlerOnAlpha) object:nil];
    
}
//渐变隐藏
- (void)hideControlerOnAlpha{
    [UIView animateWithDuration:0.5 animations:^{
        
        _interactionView.topControl.alpha = 0;
        
    }];
    
    [self performSelector:@selector(hideControl) withObject:nil afterDelay:0.5];
}

//显示控制栏
- (void)showControl{
    
    _interactionView.topControl.hidden = NO;
    
}
- (void)showControlOnAlpha{
    
    [self showControl];
    [UIView animateWithDuration:0.5 animations:^{
        _interactionView.topControl.alpha = 1;
    }];
    
    [self performSelector:@selector(hideControlerOnAlpha) withObject:nil afterDelay:5];
    
}



#pragma mark- TTTextTagView delegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView updateContentSize:(CGSize)contentSize{
    
    if (textTagCollectionView == _infoView.classTagsView) {
        
        [textTagCollectionView clearAutoHeigtSettings];
        textTagCollectionView.sd_layout
        .heightIs(contentSize.height);
        [textTagCollectionView updateLayout];
        
        [_infoView updateLayout];
        _interactionView.classListTableView.tableHeaderView.size = CGSizeMake(self.view.width_sd, _infoView.height_sd);
        
        [_interactionView.classListTableView reloadData];
        
        
    }
    
}






-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    
    
}


- (void)dealloc{
    [[NTESMeetingRTSManager sharedInstance] leaveCurrentConference];
    
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:_chatroom.roomId completion:nil];
    [[NIMSDK sharedSDK].chatroomManager removeDelegate:self];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[NTESMeetingNetCallManager sharedInstance] leaveMeeting];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
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
