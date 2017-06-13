
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
#import "TranslateViewController.h"

#import "NSString+YYAdd.h"
#import "UIViewController+TimeInterval.h"
#import "InteractionTeacherListTableViewCell.h"
#import "TeachersPublicViewController.h"
#import "OneOnOneClass.h"
#import "UIViewController+Token.h"

#import "InteractionLesson.h"

//子控制器
#import "InteractionChatViewController.h"
#import "InteractionMemberListViewController.h"
#import "InteractionClassInfoViewController.h"
#import "InteractionNoticeViewController.h"



@interface InteractionViewController ()<NTESMeetingActionViewDataSource,NTESMeetingActionViewDelegate,NIMInputDelegate,NIMChatroomManagerDelegate,NTESMeetingNetCallManagerDelegate,NTESActorSelectViewDelegate,NTESMeetingRolesManagerDelegate,NIMLoginManagerDelegate>{
    
    //课程id
    NSString *_classID;
    
    //加入音视频会话用的roomID
    NSString *_roomID;
    
    //群组聊天用的chatTeamID
    NSString *_chatTeamID;
    
    
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


@end

@implementation InteractionViewController

NTES_USE_CLEAR_BAR
NTES_FORBID_INTERACTIVE_POP

/**测试阶段使用这个方法 ,减少前一页的冗余 */
-(instancetype)initWithChatroom:(NIMChatroom *)chatroom andClassID:(NSString *)classID andChatTeamID:(NSString *)chatTeamID {
    self = [super init];
    if (self) {
        
        _chatroom = chatroom;
        
        _classID = [NSString stringWithFormat:@"%@",classID];
        
        _chatTeamID = [NSString stringWithFormat:@"%@",chatTeamID];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    [self.currentChildViewController beginAppearanceTransition:YES animated:animated];
    self.actorsView.isFullScreen = NO;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化数据
    [self makeData];
    
    /**
     修改视图结构.重写所有视图.
     */
    [self setupViews];
    
}


/**初始化数据*/
- (void)makeData{

}

/**加载视图*/
- (void)setupViews{
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    //加载所有子控制器
    [self setupChildViewController];
    [self.view addSubview:self.actorsView];
    [self.view addSubview:self.actionView];
    [self.actionView reloadData];
    
    //加载顶部控制栏
    [self setupControlView];
    
    [self setupBarButtonItem];
    
    
    
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    
    [[NTESMeetingRolesManager sharedInstance] setDelegate:self];
    [[NTESMeetingNetCallManager sharedInstance] joinMeeting:_chatroom.roomId delegate:self];
    
}

/**加载控制栏*/
- (void)setupControlView{
    
    _controlView = [[UIView alloc]init];
    [self.view addSubview:_controlView];
    _controlView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    
    //全屏按钮
    _fullScreenBtn = [[UIButton alloc]init];
    [_controlView addSubview:_fullScreenBtn];
    
    //切换前后摄像头按钮
    
    //视频开关
    
    //音频开关
    
    
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
    
    if ([child isKindOfClass:[NTESChatroomMemberListViewController class]]) {
        self.actionView.unreadRedTip.hidden = YES;
    }
    
    [lastChild beginAppearanceTransition:NO animated:YES];
    [child beginAppearanceTransition:YES animated:YES];
    [self.actionView.pageView scrollToPage:self.actionView.segmentedControl.selectedSegmentIndex];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.currentChildViewController = child;
        [lastChild endAppearanceTransition];
        [child endAppearanceTransition];
        //        [self revertInputView];
    });
}

#pragma mark - NTESMeetingNetCallManagerDelegate
- (void)onJoinMeetingFailed:(NSString *)name error:(NSError *)error
{
    [self.view.window makeToast:@"无法加入视频，退出房间" duration:3.0 position:CSToastPositionCenter];
    
    if ([[[NTESMeetingRolesManager sharedInstance] myRole] isManager]) {
        //        [self requestCloseChatRoom];
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
    //    [self.memberListVC refresh];
    [self.whiteboardVC checkPermission];
    [self setupBarButtonItem];
}

- (void)meetingVolumesUpdate
{
    //    [self.memberListVC refresh];
}

- (void)chatroomMembersUpdated:(NSArray *)members entered:(BOOL)entered
{
    //    [self.memberListVC updateMembers:members entered:entered];
}

- (void)meetingMemberRaiseHand
{
    if (self.actionView.segmentedControl.selectedSegmentIndex != 2) {
        self.actionView.unreadRedTip.hidden = NO;
    }
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
    //    [self removeActorSelectView];
    
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
    //    if ([self showFullScreenBtn:notifyExt]) {
    //        self.actorsView.showFullScreenBtn = YES;
    //    }
    //    else
    //    {
    //        self.actorsView.showFullScreenBtn = NO;
    //    }
}
#pragma mark - NTESActorSelectViewDelegate
- (void)onSelectedAudio:(BOOL)audioOn video:(BOOL)videoOn whiteboard:(BOOL)whiteboardOn
{
    //    [self removeActorSelectView];
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








#pragma mark- Get

- (CGFloat)meetingActorsViewHeight
{
    return NIMKit_UIScreenWidth * 220.f / 320.f;
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

- (void)setupBarButtonItem
{
    //根据用户角色判断导航栏rightBarButtonItem显示 老师右边三个btn
    if ([[[NTESMeetingRolesManager sharedInstance] myRole] isManager]) {
        [self refreshTecNavBar];
    }
    //学生端 互动前2个btn 互动后4个btn
    else
    {
        [self refreshStdNavBar];
    }
    
    //显示左边leftBarButtonItem
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    //左边返回button
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"chatroom_back_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"chatroom_back_selected"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton sizeToFit];
    
    //房间号label
    NSString * string =  [NSString stringWithFormat:@"房间：%@", _chatroom.roomId];
    CGRect rectTitle = [string boundingRectWithSize:CGSizeMake(999, 30)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                            context:nil];
    
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, rectTitle.size.width+20, 30)];
    title.font = [UIFont systemFontOfSize:12];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    title.text = string;
    title.textAlignment = NSTextAlignmentCenter;
    
    title.layer.cornerRadius = 15;
    title.layer.masksToBounds = YES;
    [leftView addSubview:leftButton];
    [leftView addSubview:title];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.leftItemsSupplementBackButton = NO;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    NSMutableArray *arrayItems=[NSMutableArray array];
    [arrayItems addObject:negativeSpacer];
    [arrayItems addObject:leftItem];
    negativeSpacer.width = -7;
    
    self.navigationItem.leftBarButtonItems = arrayItems;
}

-(void)refreshTecNavBar
{
    CGFloat btnWidth = 30;
    CGFloat btnHeight = 30;
    CGFloat btnMargin = 7;
    
    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3*btnMargin+3*btnWidth, 30)];
    NTESMeetingRole *myRole = [[NTESMeetingRolesManager sharedInstance] myRole];
    NSString *audioImage = myRole.audioOn ? @"chatroom_audio_on" : @"chatroom_audio_off";
    NSString *audioImageSelected = myRole.audioOn ? @"chatroom_audio_selected" : @"chatroom_audio_off_selected";
    
    NSString *videoImage = myRole.videoOn ? @"chatroom_video_on" : @"chatroom_video_off";
    NSString *videoImageSelected = myRole.audioOn ? @"chatroom_video_selected" : @"chatroom_video_off_selected";
    
    
    //音频按钮
    UIButton *audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    audioButton.frame = CGRectMake(3*btnMargin+2*btnWidth, 0, btnWidth, btnHeight);
    [audioButton setImage:[UIImage imageNamed:audioImage] forState:UIControlStateNormal];
    [audioButton setImage:[UIImage imageNamed:audioImageSelected] forState:UIControlStateHighlighted];
    [audioButton addTarget:self action:@selector(onSelfAudioPressed:) forControlEvents:UIControlEventTouchUpInside];
    //视频按钮
    UIButton *videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    videoButton.frame = CGRectMake(2*btnMargin+btnWidth, 0, btnWidth, btnHeight);
    [videoButton setImage:[UIImage imageNamed:videoImage] forState:UIControlStateNormal];
    [videoButton setImage:[UIImage imageNamed:videoImageSelected] forState:UIControlStateHighlighted];
    [videoButton addTarget:self action:@selector(onSelfVideoPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [rightView addSubview:audioButton];
    [rightView addSubview:videoButton];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    NSMutableArray *arrayItems=[NSMutableArray array];
    [arrayItems addObject:negativeSpacer];
    [arrayItems addObject:rightItem];
    negativeSpacer.width = -btnMargin;
    self.navigationItem.rightBarButtonItems = arrayItems;
    
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



- (void)dealloc{
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:_chatroom.roomId completion:nil];
    [[NIMSDK sharedSDK].chatroomManager removeDelegate:self];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[NTESMeetingNetCallManager sharedInstance] leaveMeeting];
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
