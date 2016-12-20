//
//  ChatViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/19.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ChatViewController.h"
#import "MJRefresh.h"
#import "ChatModel.h"
#import "YZEmotionKeyboard.h"
#import "UUMessageCell.h"
#import "NavigationBar.h"
#import "YZEmotionKeyboard.h"
#import "YYTextView+YZEmotion.h"
#import "UITextView+YZEmotion.h"
#import "UITextField+YZEmotion.h"
#import "RDVTabBarController.h"
#import "NIMSDK.h"
#import "NSAttributedString+YYText.h"

#import "NSBundle+YYAdd.h"
#import "UIViewController+HUD.h"
#import "Chat_Account.h"
#import "YYImage.h"
#import "YYModel.h"
#import "NSAttributedString+EmojiExtension.h"
#import "YYTextAttribute.h"
#import "YZTextAttachment.h"

@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,UUMessageCellDelegate,UUInputFunctionViewDelegate,NIMChatManagerDelegate,NIMLoginManagerDelegate>{
    
    NavigationBar *_navigationBar;
    
    /* 聊天室的信息*/
    TutoriumListInfo *_tutoriumInfo;
    
    /* 会话*/
    NIMSession *_session;
    
    /* 个人信息*/
    Chat_Account *_chat_Account;
    
    
    
    /* 临时变量  保存所有的用户信息 */
    
    NSMutableArray <Chat_Account *>*_userList;
    
}

/* 刷新聊天记录*/
@property (strong, nonatomic) MJRefreshHeader *head;
/* 聊天信息*/
@property (strong, nonatomic) ChatModel *chatModel;


/* 与web端同步的表情专用的键盘*/
@property (strong, nonatomic) YZEmotionKeyboard *emotionKeyboard;


@end

@implementation ChatViewController

-(instancetype)initWithClass:(TutoriumListInfo *)tutorium{
    
    self = [super init];
    if (self) {
        
        
        _tutoriumInfo = tutorium;
        
    }
    return self;
}



- (void)loadView{
    
    [super loadView ];
    
    _navigationBar = ({
        NavigationBar *_=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
        _.titleLabel.text = _tutoriumInfo.name;
        [_.leftButton setImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_];
        _;
        
    });
    
    
    _inputView = ({
        
        UUInputFunctionView *_=[[UUInputFunctionView alloc]initWithSuperVC:self];
        
        [_.btnChangeVoiceState addTarget:self action:@selector(emojiKeyboardShow:) forControlEvents:UIControlEventTouchUpInside];
        
        _.delegate= self;
        
        [self.view addSubview:_];
        _.sd_layout
        .leftEqualToView(self.view)
        .bottomEqualToView(self.view)
        .rightEqualToView(self.view)
        .heightIs(50);
        _;
    });
    
    _chatTableView = ({
        UITableView *_=[[UITableView alloc]init];
        _.separatorStyle = UITableViewCellSeparatorStyleNone;
        _.delegate = self;
        _.dataSource = self;
        [self.view addSubview:_];
        
        _.sd_layout
        .topSpaceToView(_navigationBar,0)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomSpaceToView(_inputView,0);
        _;
    });
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    
    [self loadingHUDStartLoadingWithTitle:@"正在加载聊天记录"];
    
    
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
        
         [self requestChatHitstory];
        
    }else{
        
        /* 强制自动登录一次*/
        [[NIMSDK sharedSDK].loginManager addDelegate:self];
        NIMAutoLoginData *loginData = [[NIMAutoLoginData alloc]init];
        loginData.account = [[NSUserDefaults standardUserDefaults]objectForKey:@"chat_account"][@"accid"];
        loginData.token =[[NSUserDefaults standardUserDefaults]objectForKey:@"chat_account"][@"token"];
        [[NIMSDK sharedSDK].loginManager autoLogin:loginData];
        [self requestChatHitstory];
        
    }
    
}

/* 再次强制登录后的回调*/
-(void)onLogin:(NIMLoginStep)step{
    
    if (NIMLoginStepLoginOK) {
        
    
    }
    
}


/* 加载本地数据*/
- (void)requestChatHitstory{
    
    NIMMessageSearchOption *option = [[NIMMessageSearchOption alloc]init];
    option.limit = 100;
    option.order = NIMMessageSearchOrderAsc;
//    option.messageType = NIMMessageTypeText||NIMMessageTypeImage;
    
    [[[NIMSDK sharedSDK]conversationManager]searchMessages:_session option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
        
        /* 如果本地没有数据,请求服务器数据,并保存到本地*/
        if (messages.count<=2) {
            
            [self requestServerHistory];
            
        }else{
            
            NSLog(@"本地消息数量%ld",messages.count);
            [self loadingHUDStopLoadingWithTitle:@""];
            
            [self makeMessages:messages];
        }
        
    }];
    
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

/* 创建消息*/
- (void)makeMessages:(NSArray<NIMMessage *> * ) messages{
    
    for (NIMMessage *message in messages) {
        if (message.messageType == NIMMessageTypeText||message.messageType==NIMMessageTypeImage) {
            
            /* 如果是文本消息*/
            
            if (message.messageType ==NIMMessageTypeText) {
                
                NSLog(@"\n\n获取到的消息文本是:::%@\n\n",message.text);
                
                dispatch_queue_t mytext = dispatch_queue_create("mytext", DISPATCH_QUEUE_SERIAL);
                dispatch_sync(mytext, ^{
                    
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
                        
                        if (re) {
                            /* 包含富文本的情况*/
                            
                        }else{
                            /* 不包含富文本的情况*/
                            
                        }
                        
                        //通过正则表达式来匹配字符串
                        NSArray *resultArray = [re matchesInString:title options:0 range:NSMakeRange(0, title.length)];
                        
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
                        
                        [self dealTheFunctionData:dic];
                        
                    }
                    
                    /* 如果消息是别人发的 */
                    else {
                        
                        /* 在本地创建对方的消息消息*/
                        NSString *iconURL = @"".mutableCopy;
                        
                        if (_userList.count!=0) {
                            for (int p = 0; p < _userList.count; p++) {
                                Chat_Account *temp = [Chat_Account yy_modelWithJSON:_userList[p]];
                                if ([temp.name isEqualToString:message.senderName]) {
                                    iconURL = temp.icon;
                                    
                                }
                            }
                            
                        }
                        
                        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self.chatModel getDicWithText:message.text andName:message.senderName andIcon:@"www.baidu.com" type:UUMessageTypeText]];
                        
                        [self.chatModel.dataSource addObjectsFromArray:[self.chatModel additems:1 withDictionary:dic]];
                        
                    }
                });
                
                [_chatTableView reloadData];
                [self tableViewScrollToBottom];
                
            }else if (message.messageType ==NIMMessageTypeImage){
                /* 如果收到的消息类型是图片的话 */
                /* 如果消息是自己发的*/
                if ([message.from isEqualToString:_chat_Account.accid]){
                    
//                    NSLog(@"收到对方发来的图片");
                    
                    NIMImageObject *imageObject = message.messageObject;
                    
                    UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",imageObject.thumbPath]];
                    
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.chatModel getDicWithImage:image andName:message.senderName andIcon:@"www.baidu.com" type:UUMessageTypePicture andImagePath:imageObject.url andThumbImagePath:imageObject.thumbPath]];
                    
                    [dic setObject:@(UUMessageFromMe) forKey:@"from"];
                    
                    [self.chatModel.dataSource addObjectsFromArray:[self.chatModel additems:1 withDictionary:dic]];
                    
                }
                /* 如果消息是别人发的 */
                else{
                    /* 本地创建对方的图片消息*/
                    
//                    NSLog(@"收到对方发来的图片");
                    
                    NIMImageObject *imageObject = message.messageObject;
                    
                    
                    UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",imageObject.thumbPath]];
                    
                    
                    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self.chatModel getDicWithImage:image andName:message.senderName andIcon:@"www.baidu.com" type:UUMessageTypePicture andImagePath:imageObject.url andThumbImagePath:imageObject.thumbPath]];
                    
                    
                    [self.chatModel.dataSource addObjectsFromArray:[self.chatModel additems:1 withDictionary:dic]];
                    
                }
                
            }
            
        }
        
    }
    
    [self loadingHUDStopLoadingWithTitle:@"加载完成!"];
    [self performSelector:@selector(sendNoticeIn) withObject:nil afterDelay:1];
    [_chatTableView reloadData];
    
    [self tableViewScrollToBottom];
}



- (BOOL)fetchMessageAttachment:(NIMMessage *)message
                         error:(NSError **)error{
    
    return YES;
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
- (void)dealTheFunctionData:(NSDictionary *)dic{
    
    
    if ([dic[@"type"]isEqual:[NSNumber numberWithInteger:0]]) {
        
        /* 重写了UUMolde的添加自己的item方法 */
        [self.chatModel addSpecifiedItem:dic andIconURL:_chat_Account.icon andName:_chat_Account.name ];
    }else if ([dic[@"type"]isEqual:[NSNumber numberWithInteger:1]]){
        
        [self.chatModel addSpecifiedImageItem:dic andIconURL:_chat_Account.icon andName:_chat_Account.name];
        
    }
    
    [self.chatTableView reloadData];
    
    
    
}


/* 接收消息*/
- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages{
    
    for (int i = 0; i<messages.count; i++) {
        
        NSString *iconURL = @"".mutableCopy;
        NIMMessage *message =messages[i];
        
        /* 筛选用户信息,拿到用户名*/
        if (_userList.count!=0) {
            
            for (int p = 0; p < _userList.count; p++) {
                
                Chat_Account *temp = [Chat_Account yy_modelWithJSON:_userList[p]];
                
                NSLog(@"%@",temp.name);
                
                if ([temp.name isEqualToString:message.senderName]) {
                    iconURL = temp.icon;
                    
                }
            }
        }
        
        
        /* 如果收到的是文本消息*/
        if (message.messageType == NIMMessageTypeText) {
            
            /* 在本地创建对方的消息消息*/
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self.chatModel getDicWithText:message.text andName:message.senderName andIcon:iconURL type:UUMessageTypeText ]];
            
            
            [self.chatModel.dataSource addObjectsFromArray:[self.chatModel additems:1 withDictionary:dic]];
            
            [self.chatTableView reloadData];
            [self tableViewScrollToBottom];
            
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
/* 接收图片的进度回调*/
- (void)fetchMessageAttachment:(NIMMessage *)message progress:(CGFloat)progress{
    
    NSLog(@"接收进度::%f",progress);
    
}

/* 接收图片完成后的回调*/
- (void)fetchMessageAttachment:(NIMMessage *)message didCompleteWithError:(NSError *)error{
    
    NSLog(@"收到图片");
    
    NIMImageObject *imageObject = message.messageObject;
    
    NSLog(@"%@",imageObject.thumbPath);
    NSLog(@"%@",imageObject.path);
    
    
    UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",imageObject.thumbPath]];
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self.chatModel getDicWithImage:image andName:message.senderName andIcon:@"www.baidu.com" type:UUMessageTypePicture andImagePath:imageObject.url andThumbImagePath:imageObject.thumbPath]];
    
    
    [self.chatModel.dataSource addObjectsFromArray:[self.chatModel additems:1 withDictionary:dic]];
    
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
    
    
}



#pragma mark- tableview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows = 1;
    if (self.chatModel.dataSource.count!=0) {
        
        rows = self.chatModel.dataSource.count;
    }
    
    return rows;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    UUMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[UUMessageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
       
        
    }
    if (self.chatModel.dataSource.count>indexPath.row) {
        cell.delegate = self;
        
        [cell setMessageFrame:self.chatModel.dataSource[indexPath.row]];
    }
    
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



#pragma mark- tabelview delegate


#pragma mark - 聊天页面 发送文字聊天信息的回调
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message
{
    
    if ([funcView.TextViewInput.text isEqualToString:@""]||funcView.TextViewInput.text==nil) {
        
        [self loadingHUDStopLoadingWithTitle:@"请输入聊天内容!"];
        
    }else{
        
        NSLog(@"%@", [funcView.TextViewInput.attributedText getPlainString]);
        
        NSDictionary *dic = @{@"strContent": [funcView.TextViewInput.attributedText getPlainString],
                              @"type": @(UUMessageTypeText),
                              @"frome":@(UUMessageFromMe)};
        
        [self dealTheFunctionData:dic];
        
        NIMMessage * text_message = [[NIMMessage alloc] init];
        text_message.text = [funcView.TextViewInput.attributedText getPlainString];
        text_message.messageObject = NIMMessageTypeText;
        text_message.apnsContent = @"发来了一条消息";
        
        /* 解析发送的字符串*/
        
        NSString *title = text_message.text;
        
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
        
        [[NIMSDK sharedSDK].chatManager addDelegate:self];
        [[NIMSDK sharedSDK].chatManager sendMessage:text_message toSession:_session error:nil];
        
        
        [_inputView.TextViewInput setText:@""];
        [_inputView.TextViewInput resignFirstResponder];
        
    }
    
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
    
    
    
}

#pragma mark- 发送图片聊天信息的回调
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image{
    
    
    //    NSLog(@"%@", [funcView.TextViewInput.attributedText getPlainString]);
    
    
    NSDictionary *dic = @{@"picture": image,
                          @"type": @(UUMessageTypePicture),
                          @"frome":@(UUMessageFromMe)};
    
    //    [funcView changeSendBtnWithPhoto:YES];
    [self dealTheFunctionData:dic];
    
    NIMImageObject * imageObject = [[NIMImageObject alloc] initWithImage:image];
    NIMMessage *message = [[NIMMessage alloc] init];
    message.messageObject= imageObject;
    
    
    //发送消息
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:_session error:nil];
    
    
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



//聊天页面tableView 滚动到底部
- (void)tableViewScrollToBottom{
    if (self.chatModel.dataSource.count==0)
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


//点击表情按钮的点击事件
- (void)emojiKeyboardShow:(UIButton *)sender
{
    
    if (sender.superview == _inputView) {
        
        _inputView.TextViewInput.text = @"" ;
        
        if (_inputView.TextViewInput.inputView == nil) {
            _inputView.TextViewInput.yz_emotionKeyboard = self.emotionKeyboard;
            [sender setBackgroundImage:[UIImage imageNamed:@"toolbar-text"] forState:UIControlStateNormal];
            
        } else {
            _inputView.TextViewInput.inputView = nil;
            [_inputView.TextViewInput reloadInputViews];
            [sender setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
            
        }
        
        
    }
}



- (void)returnLastPage{
    
    [self.navigationController popViewControllerAnimated:YES];
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
