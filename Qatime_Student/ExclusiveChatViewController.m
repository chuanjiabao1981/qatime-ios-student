//
//  ExclusiveChatViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/7/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ExclusiveChatViewController.h"
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
#import "UUMessageFrame.h"
#import "NSString+YYAdd.h"
#import "UIViewController+TimeInterval.h"
#import "KSPhotoBrowser.h"
#import "NSNull+Json.h"
#import "TutoriumList.h"
#import "NetWorkTool.h"
#import "NSDate+Utils.h"

@interface ExclusiveChatViewController ()<UITableViewDelegate,UITableViewDataSource,UUMessageCellDelegate,UUInputFunctionViewDelegate,NIMChatManagerDelegate,UUMessageCellDelegate,NIMMediaManagerDelegate,PhotoBrowserDelegate,NIMTeamManagerDelegate,UUInputFunctionViewRecordDelegate,UUInputFunctionViewRecordDelegate,NotificationTipsDelegat>{
    
    /* 聊天室的信息*/
    //    TutoriumListInfo *_tutoriumInfo;
    
    /* 会话*/
    NIMSession *_session;
    
    /* 个人信息*/
    Chat_Account *_chat_Account;
    
    /* 临时变量  保存所有的用户信息 */
    NSMutableArray <Chat_Account *>*_userList;
    
    /* 录音部分*/
    AVAudioRecorder *recorder;
    NSTimer *levelTimer;
    
    /**聊天室id*/
    NSString *_chat_teamID;
    
    /**课程id*/
    NSString *_classID;
    
    //是否被禁言
    BOOL _shutUp;
    
}
/* 刷新聊天记录*/
@property (strong, nonatomic) MJRefreshHeader *head;
/* 聊天信息*/
@property (strong, nonatomic) ChatModel *chatModel;

/* 与web端同步的表情专用的键盘*/
@property (strong, nonatomic) YZEmotionKeyboard *emotionKeyboard;


@end

@implementation ExclusiveChatViewController

-(instancetype)initWithChatTeamID:(NSString *)chatTeamID andClassID:(NSString *)classID{
    
    self = [super init];
    if (self) {
        
        _chat_teamID  = [NSString stringWithFormat:@"%@",chatTeamID];
        
        _classID = [NSString stringWithFormat:@"%@",classID];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self HUDStartWithTitle:@"正在加载聊天记录"];
    
    /* 初始化*/
    if (_chat_teamID) {
        
        _session  = [NIMSession session:_chat_teamID type:NIMSessionTypeTeam];
    }
    
    _chat_Account = [Chat_Account yy_modelWithJSON:[[NSUserDefaults standardUserDefaults]objectForKey:@"chat_account"]];
    
    _userList = @[].mutableCopy;
    
    self.chatModel = [[ChatModel alloc]init];
    self.chatModel.isGroupChat = YES;
    [self.chatModel populateRandomDataSource];
    
    
    //千万别登录云信
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    [[NIMSDK sharedSDK].teamManager addDelegate:self];
    
    NSLog(@"聊天未读消息%ld条",[[[NIMSDK sharedSDK]conversationManager] allUnreadCount]);
    
    //基础数据加载完毕,开始加载视图
    [self setupMainView];
    
    
    /* 获取一次所有成员信息*/
    [self requestChatTeamUser];
    
    
    /* 聊天信息 加个点击手势,取消输入框响应*/
    UITapGestureRecognizer *tapSpace = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSpace)];
    [_chatTableView addGestureRecognizer:tapSpace];
    
    /* 添加录音是否开始的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recordStart) name:@"RecordStart" object:nil];
    
    /* 添加录音是否结束的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recordEnd) name:@"RecordEnd" object:nil];
    
    /* 添加录音是否取消的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recordCancel) name:@"RecordCancel" object:nil];
    [self registerForKeyboardNotifications];
    
    if (_session) {
        
        //查一下禁言状态
        [[NIMSDK sharedSDK].teamManager fetchTeamMutedMembers:_session.sessionId completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
            
            for (NIMTeamMember *member in members) {
                
                if ([member.userId isEqualToString:_chat_Account.user_id]) {
                    //这是被禁言了
                    _shutUp = YES;
                    [self shutUpTalking];
                }else{
                    _shutUp = NO;
                    [self keepOnTalking];
                }
            }
            
        }];
        //
        
        [[[NIMSDK sharedSDK]conversationManager]markAllMessagesReadInSession:_session];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MarkAllRead" object:_session];
    }
    
    
}


/**加载主视图*/
- (void)setupMainView{
    
    _chatTableView = ({
        UITableView *_=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, self.view.height_sd-50) style:UITableViewStylePlain];
        _.separatorStyle = UITableViewCellSeparatorStyleNone;
        _.delegate = self;
        _.dataSource = self;
        _;
    });
    
    [self.view addSubview:_chatTableView];
    _chatTableView.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 50);
    
    _inputView = ({
        UUInputFunctionView *_=[[UUInputFunctionView alloc]initWithSuperVC:self];
        _.btnVoiceRecord.hidden = YES;
        _.TextViewInput.sd_layout
        .leftSpaceToView(_, 10);
        [_.TextViewInput updateLayout];
        [_.btnChangeVoiceState addTarget:self action:@selector(emojiKeyboardShow:) forControlEvents:UIControlEventTouchUpInside];
        _.TextViewInput.placeholder = @"请输入要发送的信息";
        _.delegate= self;
        _.recordDelegate = self;
        _;
    });
    
    [self.view addSubview:_inputView];
    _inputView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .heightIs(50);
    
    _inputView.delegate = self;
    _inputView.recordDelegate = self;
    
}

/* 开始检测麦克风声音*/
- (void)checkMicVolum{
    
    /* 必须添加这句话，否则在模拟器可以，在真机上获取始终是0 */
    //    [[AVAudioSession sharedInstance]
    //     setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
    
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
    
    [self checkMic];
    
}
//语音录制结束的方法
- (void)recordEnd{
    
    [levelTimer invalidate];
    levelTimer = nil;
    
}
//语音录制取消的方法
- (void)recordCancel{
    
    [levelTimer invalidate];
    levelTimer = nil;
    
}


/* 请求聊天用户*/
- (void)requestChatTeamUser{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:[self getToken] forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/live_studio/customized_groups/%@/play",Request_Header,_classID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        /* 检测是否登录超时*/
        [self loginStates:dic];
        
        NSMutableArray *users ;
        if ([dic[@"status"] isEqual:[NSNumber numberWithInteger:1]]) {
            if ([[dic[@"data"][@"customized_group"][@"chat_team"][@"accounts"]description] isEqualToString:@"0(NSNull)"]) {
                
                users = @[].mutableCopy;
            }else{
                
                users =[NSMutableArray arrayWithArray:dic[@"data"][@"customized_group"][@"chat_team"][@"accounts"]];
            }
            
            for (NSDictionary *dic in users) {
                Chat_Account *mod  = [Chat_Account yy_modelWithJSON:dic];
                
                /* 获取到的用户信息存到userlist里*/
                [_userList addObject:mod];
            }
            
            [self requestChatHitstory];
            
        }else{
            /* 获取成员信息失败*/
            
            [self HUDStopWithTitle:@"获取聊天成员信息失败!"];
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
        
        _chatTableView.hidden = NO;
        [self HUDStopWithTitle:nil];
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
        
        /**
         按理说,加载历史消息也应该判断用户account或者session.
         */
        if (![message.session.sessionId isEqualToString:_session.sessionId]) {
            
            
        }else{
            
            if (message.messageType == NIMMessageTypeText||message.messageType==NIMMessageTypeImage||message.messageType == NIMMessageTypeAudio||message.messageType == NIMMessageTypeNotification||message.messageType == NIMMessageTypeCustom) {
                
                _chatTableView.hidden = NO;
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
                    
                    
                    [_chatTableView reloadData];
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
                        NIMAudioObject *audioObject = message.messageObject;
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.chatModel getDicWithName:message.senderName andIcon:_chat_Account.icon type:UUMessageTypeVoice andVoicePath:audioObject.path andTime:[NSString stringWithFormat:@"%ld",(NSInteger)audioObject.duration/1000]andMessage:message]];
                        
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
                        
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.chatModel getDicWithName:message.senderName andIcon:_chat_Account.icon type:UUMessageTypeVoice andVoicePath:audioObject.path andTime:[NSString stringWithFormat:@"%ld",(NSInteger)audioObject.duration/1000]andMessage:message]];
                        
                        [self.chatModel.dataSource addObjectsFromArray:[self.chatModel additems:1 withDictionary:dic]];
                    }
                    
                }else if (message.messageType==NIMMessageTypeNotification){
                    
                    /** 收到公告消息a */
                    
                    /**
                     解析收到的message字段
                     1.有mute字段 则为设置禁言1/非禁言0
                     2.没有mute字段就是普通公告
                     */
                    
                    id object = [[message valueForKeyPath:@"messageObject"]valueForKeyPath:@"attachContent"];
                    
                    NSData *data = [object dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *msgContent = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    
                    __block NSString *messageText = @"";
                    
                    if (msgContent) {
                        if (msgContent[@"data"][@"mute"]) {
                            if ([msgContent[@"data"][@"mute"] isEqualToNumber:@1]) {
                                //禁言了
                                //通过accid和名字看看是谁被禁言
                                if ([msgContent[@"data"][@"uinfos"][1][@"1"]isEqualToString:_chat_Account.accid]) {
                                    //自己被禁言了
                                    messageText = @"您已被禁言";
                                    [self shutUpTalking];
                                }else{
                                    messageText = [NSString stringWithFormat:@"%@已被禁言",msgContent[@"data"][@"uinfos"][1][@"3"]];
                                }
                            }else{
                                //解除禁言
                                //通过accid和名字看看是谁被禁言
                                if ([msgContent[@"data"][@"uinfos"][1][@"1"]isEqualToString:_chat_Account.accid]) {
                                    //自己被禁言了
                                    messageText = @"您已解除禁言";
                                    [self keepOnTalking];
                                }else{
                                    messageText = [NSString stringWithFormat:@"%@已被禁言",msgContent[@"data"][@"uinfos"][1][@"3"]];
                                }
                            }
                        }else{
                            messageText = msgContent[@"data"][@"tinfo"][@"15"];
                        }
                    }else{
                        
                    }
                    //解析userlist,把发送者给揪出来
                    NSString *sender = @"";
                    for (Chat_Account *user in _userList) {
                        if ([message.from isEqualToString:[user valueForKeyPath:@"accid"]]) {
                            sender = [user valueForKeyPath: @"name"];
                        }
                    }
                    
                    //在这儿弄一下子 这个 富文本
                    NSString *notice =[NSString stringWithFormat:@"%@更新了公告\n公告:%@",sender,messageText==nil?@"":messageText];
                    
                    //公告就直接从聊天获取
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"NewNotice" object:@{@"notice":notice,@"time":[NSString stringWithFormat:@"%f",message.timestamp]}];
                    
                    [self.chatModel addSpecifiedNotificationItem:notice];
                    
                }else if (message.messageType == NIMMessageTypeCustom){
                    //自定义消息 改为 课程的开启关闭
                    if ([message valueForKeyPath:@"rawAttachContent"]!=nil) {
                        NSLog(@"%@",[message valueForKeyPath:@"rawAttachContent"]);
                        NSData *data = [[message valueForKeyPath:@"rawAttachContent"] dataUsingEncoding:NSUTF8StringEncoding];
                        NSError *err;
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
                        NSString *result;
                        
                        if (dic[@"event"]) {
                            if (dic[@"type"]){
                                if ([dic[@"type"]isEqualToString:@"LiveStudio::Homework"]||[dic[@"type"]isEqualToString:@"LiveStudio::Question"]||[dic[@"type"]isEqualToString:@"LiveStudio::Answer"]||[dic[@"type"]isEqualToString:@"Resource::File"]) {
                                    //这大概就是 什么作业了 什么问答了那种类型的消息了
                                    //不用加工数据,按照原数据直接写进Model就行了.改改方法
                                    //增加一个发送人吧.
                                    __block NSMutableDictionary *senders = dic.mutableCopy;
                                    
                                    for (Chat_Account *user in _userList) {
                                        if ([user.accid isEqualToString:message.from]) {
                                            [senders setValue:user.accid forKey:@"accid"];
                                            [senders setValue:user.icon forKey:@"icon"];
                                            [senders setValue:user.name forKey:@"name"];
                                        }
                                    }
                                    if ([message.from isEqualToString:_chat_Account.accid]) {
                                        [senders setValue:@"FromMe" forKey:@"from"];
                                    }else{
                                        [senders setValue:@"FromOther" forKey:@"from"];
                                    }
                                    [senders setValue:[[NSString stringWithFormat:@"%f",message.timestamp]changeTimeStampToDateString] forKey:@"time"];
                                    
                                    [self.chatModel addSpecifiedNotificationTipsItem:senders];
                                    
                                }else{
                                    if ([dic[@"event"]isEqualToString:@"close"]&&[dic[@"event"]isEqualToString:@"LiveStudio::ScheduledLesson"]) {
                                        result = @"直播关闭";
                                    }else if ([dic[@"event"]isEqualToString:@"start"]&&[dic[@"event"]isEqualToString:@"LiveStudio::ScheduledLesson"]){
                                        result = @"直播开启";
                                    }else if ([dic[@"event"]isEqualToString:@"close"]&&[dic[@"event"]isEqualToString:@"LiveStudio::InstantLesson"]){
                                        result = @"老师关闭了互动答疑";
                                    }else if ([dic[@"event"]isEqualToString:@"start"]&&[dic[@"event"]isEqualToString:@"LiveStudio::InstantLesson"]){
                                        result = @"老师开启了互动答疑";
                                    }
                                    [self.chatModel addSpecifiedNotificationItem:result];
                                    
                                }
                                
                            }else{
                                
                            }
                        }
                        
                    }else{
                        
                    }
                    
                }else{
                    
                }
                
            }
            
        }
        
    }
    
    [self HUDStopWithTitle:nil];
    [self performSelector:@selector(sendNoticeIn) withObject:nil afterDelay:1];
    
    [_chatTableView reloadData];
    [self tableViewScrollToBottom];
}


/* 发送您已加入聊天室的通知消息*/

- (void)sendNoticeIn{
  
    
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
    
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
    
}


#pragma mark- 云信 - 发送消息的回调
//即将发送消息回调
- (void)willSendMessage:(NIMMessage *)message{
    
    
}

//消息发送进度回调----文本消息没有这个回调
- (void)sendMessage:(NIMMessage *)message progress:(CGFloat)progress{
    
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
                    
                    [_chatTableView reloadData];
                    
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
            ///就在这儿划分消息类型然后发送弹幕,
            if (message.messageType == NIMMessageTypeText) {
                
                [self sendBarrage:message.text];
            }
            
        }
            break;
    }
    
    
}
//重新发送消息 主动方法
//- (BOOL)resendMessage:(NIMMessage *)message error:(NSError **)error



#pragma mark- 云信--接收(文本/系统)消息的回调
/* 接收消息的回调 注意控制系统消息*/
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
            }else{
                //没有的话,如果不是通知类型 ,就直接踢出去
                if (![message.session.sessionId isEqualToString:_session.sessionId]) {
                    return;
                }else{
                    
                }
            }
        }
        /* 如果收到的是文本消息*/
        if (message.messageType == NIMMessageTypeText) {
            
            /* 在本地创建对方的消息消息*/
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self.chatModel getDicWithText:message.text andName:senderName andIcon:iconURL type:UUMessageTypeText andTime:[[NSString stringWithFormat:@"%f",message.timestamp]changeTimeStampToDateString]andMessage:message]];
            
            [self.chatModel.dataSource addObjectsFromArray:[self.chatModel additems:1 withDictionary:dic]];
            
            [self sendBarrage:message.text];
        }
        
        /* 如果收到的是图片消息*/
        else if (message.messageType == NIMMessageTypeImage){
            
        }else if (message.messageType == NIMMessageTypeAudio){
            /* 如果收到的是音频消息*/
            
        }else if (message.messageType == NIMMessageTypeNotification){
            /** 收到公告消息a */
            
            /**
             解析收到的message字段
             1.有mute字段 则为设置禁言1/非禁言0
             2.没有mute字段就是普通公告
             */
            
            id object = [[message valueForKeyPath:@"messageObject"]valueForKeyPath:@"attachContent"];
            
            NSData *data = [object dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *msgContent = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            __block NSString *messageText = @"";
            
            if (msgContent) {
                if (msgContent[@"data"][@"mute"]) {
                    if ([msgContent[@"data"][@"mute"] isEqualToNumber:@1]) {
                        //禁言了
                        //通过accid和名字看看是谁被禁言
                        if ([msgContent[@"data"][@"uinfos"][1][@"1"]isEqualToString:_chat_Account.accid]) {
                            //自己被禁言了
                            messageText = @"您已被禁言";
                            [self shutUpTalking];
                        }else{
                            messageText = [NSString stringWithFormat:@"%@已被禁言",msgContent[@"data"][@"uinfos"][1][@"3"]];
                        }
                        
                    }else{
                        //解除禁言
                        //通过accid和名字看看是谁被禁言
                        if ([msgContent[@"data"][@"uinfos"][1][@"1"]isEqualToString:_chat_Account.accid]) {
                            //自己被禁言了
                            messageText = @"您已解除禁言";
                            [self keepOnTalking];
                        }else{
                            messageText = [NSString stringWithFormat:@"%@已被禁言",msgContent[@"data"][@"uinfos"][1][@"3"]];
                        }
                    }
                }else{
                    messageText = msgContent[@"data"][@"tinfo"][@"15"];
                }
            }else{
                
            }
            //解析userlist,把发送者给揪出来
            NSString *sender = @"";
            for (Chat_Account *user in _userList) {
                if ([message.from isEqualToString:[user valueForKeyPath:@"accid"]]) {
                    sender = [user valueForKeyPath: @"name"];
                }
            }
            //在这儿弄一下子 这个 富文本
            NSString *notice =[NSString stringWithFormat:@"%@更新了公告\n公告:%@",sender,messageText==nil?@"":messageText];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"NewChatNotice" object:nil];
            [self.chatModel addSpecifiedNotificationItem:notice];
        }else if (message.messageType == NIMMessageTypeCustom){
            //自定义消息 改为 课程的开启关闭
            if ([message valueForKeyPath:@"rawAttachContent"]!=nil) {
                NSLog(@"%@",[message valueForKeyPath:@"rawAttachContent"]);
                NSData *data = [[message valueForKeyPath:@"rawAttachContent"] dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
                NSString *result;
                
                if (dic[@"event"]) {
                    if (dic[@"type"]){
                        if ([dic[@"type"]isEqualToString:@"LiveStudio::Homework"]||[dic[@"type"]isEqualToString:@"LiveStudio::Question"]||[dic[@"type"]isEqualToString:@"LiveStudio::Answer"]||[dic[@"type"]isEqualToString:@"Resource::File"]) {
                            
                            
                            //这大概就是 什么作业了 什么问答了那种类型的消息了
                            //不用加工数据,按照原数据直接写进Model就行了.改改方法
                            //增加一个发送人吧.
                            __block NSMutableDictionary *senders = dic.mutableCopy;
                            
                            for (Chat_Account *user in _userList) {
                                if ([user.accid isEqualToString:message.from]) {
                                    [senders setValue:user.accid forKey:@"accid"];
                                    [senders setValue:user.icon forKey:@"icon"];
                                    [senders setValue:user.name forKey:@"name"];
                                }
                            }
                            if ([message.from isEqualToString:_chat_Account.accid]) {
                                [senders setValue:@"FromMe" forKey:@"from"];
                            }else{
                                [senders setValue:@"FromOther" forKey:@"from"];
                            }
                            [senders setValue:[[NSString stringWithFormat:@"%f",message.timestamp]changeTimeStampToDateString] forKey:@"time"];
                            
                            [self.chatModel addSpecifiedNotificationTipsItem:senders];
                        }else{
                            if ([dic[@"event"]isEqualToString:@"close"]&&[dic[@"type"]isEqualToString:@"LiveStudio::ScheduledLesson"]) {
                                result = @"直播关闭";
                            }else if ([dic[@"event"]isEqualToString:@"start"]&&[dic[@"type"]isEqualToString:@"LiveStudio::ScheduledLesson"]){
                                result = @"直播开启";
                            }else if ([dic[@"event"]isEqualToString:@"close"]&&[dic[@"type"]isEqualToString:@"LiveStudio::InstantLesson"]){
                                result = @"老师关闭了互动答疑";
                            }else if ([dic[@"event"]isEqualToString:@"start"]&&[dic[@"type"]isEqualToString:@"LiveStudio::InstantLesson"]){
                                result = @"老师开启了互动答疑";
                            }
                            if (result) {
                                
                                [self.chatModel addSpecifiedNotificationItem:result];
                                [self.chatTableView reloadData];
                                [self tableViewScrollToBottom];
                            }
                        }
                        
                    }else{
                        if ([dic[@"event"]isEqualToString:@"close"]&&[dic[@"event"]isEqualToString:@"LiveStudio::ScheduledLesson"]) {
                            result = @"直播关闭";
                        }else if ([dic[@"event"]isEqualToString:@"start"]&&[dic[@"event"]isEqualToString:@"LiveStudio::ScheduledLesson"]){
                            result = @"直播开启";
                        }else if ([dic[@"event"]isEqualToString:@"close"]&&[dic[@"event"]isEqualToString:@"LiveStudio::InstantLesson"]){
                            result = @"老师关闭了互动答疑";
                        }else if ([dic[@"event"]isEqualToString:@"start"]&&[dic[@"event"]isEqualToString:@"LiveStudio::InstantLesson"]){
                            result = @"老师开启了互动答疑";
                        }
                        [self.chatModel addSpecifiedNotificationItem:result];
                    }
                
                }
                
            }else{
                
            }
            
        }else{
            
        }
        
    }
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
    
}

/** 禁言 */
- (void)shutUpTalking{
    _inputView.TextViewInput.placeholder = @"您已被禁言";
}

/** 可以继续发送消息 */
- (void) keepOnTalking{
    _inputView.TextViewInput.placeholder = @"请输入要发送的信息";
}

//如果收到的是图片，视频等需要下载附件的消息，在回调的处理中还需要调用
//（SDK 默认会在第一次收到消息时自动调用）
- (BOOL)fetchMessageAttachment:(NIMMessage *)message  error:(NSError **)error{
    
    return YES;
}


/* 接收图片的进度回调*/
- (void)fetchMessageAttachment:(NIMMessage *)message progress:(CGFloat)progress{
    
    NSLog(@"接收进度:----- %f",progress);
    
}

/* 接收到 语音/图片消息 完成后的回调*/
- (void)fetchMessageAttachment:(NIMMessage *)message didCompleteWithError:(NSError *)error{
    
    if (message.messageType == NIMMessageTypeImage) {
        /* 收到图片*/
        NSLog(@"收到图片");
        
        /* 筛选用户信息,拿到用户名*/
        NSString *iconURL = @"".mutableCopy;
        NSString *senderName = @"".mutableCopy;
        for (Chat_Account *mod in _userList) {
            if ([message.from isEqualToString:mod.accid]) {
                iconURL = mod.icon;
                senderName = mod.name;
            }else{
                //没有的话,如果不是通知类型 ,就直接踢出去
                if (![message.session.sessionId isEqualToString:_session.sessionId]) {
                    return;
                }else{
                    
                }
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
            }else{
                //没有的话,如果不是通知类型 ,就直接踢出去
                if (![message.session.sessionId isEqualToString:_session.sessionId]) {
                    return;
                }else{
                    
                }
            }
        }
        
        NIMAudioObject *audioObject = message.messageObject;
        //audioObject.path 本地音频地址
        NSLog(@"%@",audioObject.path);
        
        //创建消息字典
        NSDictionary *dic = [self.chatModel getDicWithName:senderName andIcon:iconURL type:UUMessageTypeVoice andVoicePath:audioObject.path andTime:[NSString stringWithFormat:@"%ld",(NSInteger)audioObject.duration/1000]andMessage:message];
        
        [self.chatModel.dataSource addObjectsFromArray:[self.chatModel additems:1 withDictionary:dic]];
        
    }
    
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
    
    
}




/* 接收到消息后 ，在本地创建消息*/
- (void)makeOthersMessageWith:(NSInteger)msgNum andMessage:(UUMessage *)message{
    
    [self.chatModel.dataSource addObject:message];
    
}

//接收群公告的
- (void)onTeamUpdated:(NIMTeam *)team{
    
    //公告就直接从聊天获取
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"NewNotice" object:@{@"notice":team.announcement,@"time":[NSString stringWithFormat:@"%f",[[team valueForKeyPath:@"time"] floatValue] ]}];
    
}


#pragma mark- tableview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows = 0;
    if (self.chatModel.dataSource.count!=0) {
        
        rows = self.chatModel.dataSource.count;
    }else{
        
        rows = 0;
    }
    
    return rows;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    UUMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (!cell) {
        cell=[[UUMessageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
    }

    if (self.chatModel.dataSource.count>indexPath.row) {
        
        cell.delegate = self;
        cell.photoDelegate = self;
        cell.notificationTipsDelegate = self;
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
    }
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger height = 10;
    if (self.chatModel.dataSource.count>indexPath.row){
        
        height =  [self.chatModel.dataSource[indexPath.row] cellHeight];
    }else{
        
    }
    
    return height;
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
            
            //            [[[NIMSDK sharedSDK]chatManager]addDelegate:self];
            [[[NIMSDK sharedSDK]chatManager]resendMessage:reMessage error:nil];
            
            sender.hidden = YES;
            [sender removeTarget:self action:@selector(resendMessages:) forControlEvents:UIControlEventTouchUpInside];
            
            [_chatTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            
        }
    }
}


#pragma mark - 聊天页面 发送文字聊天信息的回调
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message{
    
    if (_shutUp==YES) {
        
        [self HUDStopWithTitle:@"您已被禁言"];
        
    }else{
        if ([funcView.TextViewInput.text isEqualToString:@""]||funcView.TextViewInput.text==nil) {
            
            [self HUDStopWithTitle:@"请输入聊天内容!"];
            
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
                    
                    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.size alignToFont:[UIFont systemFontOfSize:13] alignment:YYTextVerticalAlignmentCenter];
                    
                    [text replaceCharactersInRange:[names [i][@"range"] rangeValue] withAttributedString:attachText];
                    
                    
                    title  = [title stringByReplacingCharactersInRange:[names [i][@"range"] rangeValue] withString:[names[i] valueForKey:@"name"]];
                    
                    
                    dic = @{@"strContent": [funcView.TextViewInput.attributedText getPlainString],
                            @"type": @(UUMessageTypeText),
                            @"frome":@(UUMessageFromMe),
                           @"strTime":[NSString stringWithFormat:@"%@",[[NSDate date]stringYearMonthDayHourMinuteSecond]],
                            @"isRichText":@YES,
                            @"richNum":[NSString stringWithFormat:@"%ld",resultArray.count],
                            @"messageID":text_message.messageId};
                    
                }
                
            }else{
                //如果不含富文本
                
                dic = @{@"strContent": [funcView.TextViewInput.attributedText getPlainString],
                        @"type": @(UUMessageTypeText),
                        @"frome":@(UUMessageFromMe),
                         @"strTime":[NSString stringWithFormat:@"%@",[[NSDate date]stringYearMonthDayHourMinuteSecond]],
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
            //            [_inputView.TextViewInput resignFirstResponder];
            
        }
        
//        [self.chatTableView reloadData];
//        [self tableViewScrollToBottom];
        
        [funcView changeSendBtnWithPhoto:YES];
    }
    
}

#pragma mark- 发送图片聊天信息的回调
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image{
    
    if (_shutUp==YES) {
        
        [self HUDStopWithTitle:@"您已被禁言"];
        
    }else{
        
        //创建一条云信消息
        NIMImageObject * imageObject = [[NIMImageObject alloc] initWithImage:image];
        NIMMessage *message = [[NIMMessage alloc] init];
        message.messageObject= imageObject;
        
        //创建一条本地消息
        NSDictionary *dic = @{@"picture": image,
                              @"type": @(UUMessageTypePicture),
                              @"frome":@(UUMessageFromMe),
                              @"strTime":[NSString stringWithFormat:@"%@",[[NSDate date]stringYearMonthDayHourMinuteSecond]],
                              @"messageID":message.messageId};
        
        
        [self dealTheFunctionData:dic andMessage:message];
        
        //发送消息
        [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:_session error:nil];
        
    }
    
}

#pragma mark- 发送语音消息的回调
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView voicePath:(NSString *)path time:(NSInteger)second{
    
    if (_shutUp==YES) {
        
        [self HUDStopWithTitle:@"您已被禁言"];
        
    }else{
        //创建一条云信消息
        // 声音文件只支持 aac 和 amr 类型
        //构造消息
        NIMAudioObject *audioObject = [[NIMAudioObject alloc] initWithSourcePath:path];
        NIMMessage *message = [[NIMMessage alloc] init];
        message.messageObject = audioObject;
        
        //创建一条本地消息
        NSDictionary *dic = @{@"voicePath" :path,
                              @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)second],
                               @"strTime":[NSString stringWithFormat:@"%@",[[NSDate date]stringYearMonthDayHourMinuteSecond]],
                              @"type": @(UUMessageTypeVoice),
                              @"messageID":message.messageId};
        
        [self dealTheFunctionData:dic andMessage:message];
        
        /* 发送一条语音消息*/
        [[NIMSDK sharedSDK].chatManager addDelegate:self];
        [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:_session error:nil];
        
    }
    
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
    
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
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
        
        [_inputView.TextViewInput becomeFirstResponder];
    }
    return _emotionKeyboard;
}



//点击表情按钮的点击事件
- (void)emojiKeyboardShow:(UIButton *)sender{
    
    if (sender.superview == _inputView) {
        
        if (_inputView.TextViewInput.inputView == nil) {
            //弹出表情键盘,如果是在录音状态,那就改成文本输入状态
            _inputView.TextViewInput.yz_emotionKeyboard = self.emotionKeyboard;
            [sender setBackgroundImage:[UIImage imageNamed:@"toolbar-text"] forState:UIControlStateNormal];
        } else {
            //收回表情键盘,如果是在输入状态,那就改成文本输入状态
            _inputView.TextViewInput.inputView = nil;
            [sender setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
            [_inputView.TextViewInput reloadInputViews];
            
        }
        
        if (_inputView.TextViewInput.hidden == YES) {
            
            [_inputView voiceRecord:_inputView.voiceSwitchTextButton];
        }
        
    }
}


#pragma mark- 音频功能的所有回调

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
        
        //        [_inputView setFrame:CGRectMake(0, self.view.height_sd -50-keyboardRect.size.height , self.view.width_sd, 50)];
        _inputView.sd_layout
        .leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .bottomSpaceToView(self.view, keyboardRect.size.height)
        .heightIs(50);
        [_inputView updateLayout];
        //        [ _chatTableView setFrame:CGRectMake(0, -keyboardRect.size.height , self.view.width_sd, self.view.height_sd-50)];
        
        _chatTableView.sd_layout
        .leftSpaceToView(self.view, 0)
        //        .topSpaceToView(self.view, -keyboardRect.size.height)
        .rightSpaceToView(self.view, 0)
        .bottomSpaceToView(_inputView, 0)
        .heightIs(self.view.width_sd-50);
        [_chatTableView updateLayout];
        
    }];
    
    [self tableViewScrollToBottom];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    // 获取通知信息字典
    NSDictionary* userInfo = [notification userInfo];
    [self endEdit];
    // 获取键盘隐藏动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        //        [_inputView setFrame:CGRectMake(0, self.view.height_sd -50, self.view.width_sd, 50)];
        
        _inputView.sd_layout
        .leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .bottomSpaceToView(self.view, 0)
        .heightIs(50);
        [_inputView updateLayout];
        
        //        [_chatTableView setFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64-50)];
        _chatTableView.sd_layout
        .leftSpaceToView(self.view, 0)
        .topSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .heightIs(self.view.height_sd-50);
        [_chatTableView updateLayout];
    }];
    
    [self tableViewScrollToBottom];
}


- (void)returnLastPage{
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    [_inputView.TextViewInput resignFirstResponder];
    [_inputView changeSendBtnWithPhoto:YES];
    
}

- (void)tapSpace{
    [_inputView.TextViewInput resignFirstResponder];
    if (![_inputView.TextViewInput.text isEqualToString:@""]) {
        return;
    }
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


#pragma mark- 语音转换/切换扬声器和听筒
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
    
    [UIAlertController showActionSheetInViewController:self withTitle:nil message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[voiceSwitch] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
        
    } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
        if (buttonIndex == 2){
            
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

/** 发弹幕 */
- (void)sendBarrage:(NSString *)barrageString{
    if (_sendBarrage) {
        _sendBarrage(barrageString);
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    [_inputView resignFirstResponder];
    //收起键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self.view updateLayout];
    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self.view updateLayout];
    
    _inputView.hidden = NO;
    [_inputView sd_clearAutoLayoutSettings];
    _inputView.sd_layout
    .leftSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(50);
    [_inputView updateLayout];
    [_chatTableView cyl_reloadData];
    
}


/**浏览大图*/
-(void)showImage:(UIImageView *)imageView andImage:(UIImage *)image{
    
    NSMutableArray *items = @[].mutableCopy;
    KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView image:image];
    [items addObject:item];
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:0];
    [browser showFromViewController:self];
    
}

- (void)endEdit{
    [self.view endEditing:YES];
    [_inputView .TextViewInput resignFirstResponder];
    if (![_inputView.TextViewInput.text isEqualToString:@""]) {
        return;
    }
    [_inputView changeSendBtnWithPhoto:YES];
}


- (UIView *)makePlaceHolderView{
    HaveNoClassView *view = [[HaveNoClassView alloc]initWithTitle:@"暂无聊天"];
    return view;
}

- (BOOL)enableScrollWhenPlaceHolderViewShowing{
    return YES;
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
