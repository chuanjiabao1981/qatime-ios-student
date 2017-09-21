//
//  UUMessageCell.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUMessageCell.h"
#import "UUMessage.h"
#import "UUMessageFrame.h"

#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "UUImageAvatarBrowser.h"

#import "NSString+FindFace.h"
#import "NSMutableAttributedString+Extention.h"
#import "YYTextView.h"
#import "YYLabel.h"
#import "YYImage.h"
#import "NSObject+YYAdd.h"
#import "NSBundle+YYAdd.h"
#import "NSAttributedString+YYtext.h"
#import "UIImageView+WebCache.h"
//#import "XHImageViewer.h"
//#import "UIImageView+XHURLDownload.h"
#import "UUAVAudioPlayer.h"
#import "NSString+TimeStamp.h"
#import "NSDate+ChangeUTC.h"
#import "NSString+Date.h"
#import "NSDate+Utils.h"



//#import "YYPhotoBrowseView.h"

@interface UUMessageCell ()<UUAVAudioPlayerDelegate>
{
    
    AVAudioPlayer *player;
    UUAVAudioPlayer *audio;
    NSString *voiceURL;
    NSData *songData;
    
    UIView *headImageBackView;
    BOOL contentVoiceIsPlaying;
}
@end

@implementation UUMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 1、创建时间
        self.labelTime = [[UILabel alloc] init];
        self.labelTime.textAlignment = NSTextAlignmentCenter;
        self.labelTime.textColor = [UIColor grayColor];
        self.labelTime.font = ChatTimeFont;
        [self.contentView addSubview:self.labelTime];
        
        // 2、创建头像
        headImageBackView = [[UIView alloc]init];
        
        headImageBackView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
        [self.contentView addSubview:headImageBackView];
        self.btnHeadImage = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.btnHeadImage addTarget:self action:@selector(btnHeadImageClick:)  forControlEvents:UIControlEventTouchUpInside];
        [headImageBackView addSubview:self.btnHeadImage];
        
        // 3、创建头像下标
        self.labelNum = [[UILabel alloc] init];
        self.labelNum.textColor = [UIColor grayColor];
        self.labelNum.textAlignment = NSTextAlignmentCenter;
        self.labelNum.font = ChatTimeFont;
        [self.contentView addSubview:self.labelNum];
        
        // 4、创建内容
        self.btnContent = [UUMessageContentButton buttonWithType:UIButtonTypeCustom];
        /* 用yytextview改写*/
        
        self.btnContent.contentTextView.textColor = [UIColor blackColor];
        self.btnContent.contentTextView.font = ChatContentFont;
        self.btnContent.contentTextView.textAlignment = NSTextAlignmentCenter;
        [self.btnContent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btnContent.titleLabel.font = ChatContentFont;
        self.btnContent.titleLabel.numberOfLines = 0;
        [self.btnContent addTarget:self action:@selector(btnContentClick)  forControlEvents:UIControlEventTouchUpInside];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [self.btnContent addGestureRecognizer:longPress];
        
        [self.contentView addSubview:self.btnContent];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UUAVAudioPlayerDidFinishPlay) name:@"VoicePlayHasInterrupt" object:nil];
        
        
        //查询本地保存的播放设备信息,如果没有,默认使用扬声器播放
        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"AVAudioSession"]) {
            
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"AVAudioSession"]isEqualToString:@"loudspeaker"]) {
                
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                //扬声器播放情况下,增加红外线感应监听
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:)  name:UIDeviceProximityStateDidChangeNotification object:nil];
//                [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];  //可以关闭掉红外感应

            }else if([[[NSUserDefaults standardUserDefaults]valueForKey:@"AVAudioSession"]isEqualToString:@"earphone"]){
                
                
                [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];  //可以关闭掉红外感应
                [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
                
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
            }
        }else{
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
            
            //扬声器播放情况下,增加红外线感应监听
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
//                [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];  //可以关闭掉红外感应
            
        }
        
        
        contentVoiceIsPlaying = NO;
        
        /* 创建支持自定义表情的YYLabel类型的label*/
        self.title = [[YYTextView alloc]init];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.textColor  = [UIColor blackColor];
        self.title.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        self.title.editable = NO;
        self.title.scrollEnabled = NO;
        
        [self.contentView addSubview:self.title];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnContentClick)];
        self.title.userInteractionEnabled = YES;
        [self.title addGestureRecognizer:tap];
        
        
        /* 5.真正的时间label*/
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.font =ChatTimeFont;
        [self.contentView addSubview:_timeLabel];
        
        
        /* 发送失败标示图*/
        _sendfaild = [[UIButton alloc]init];
        [_sendfaild setImage:[UIImage imageNamed:@"发送失败"]  forState:UIControlStateNormal];
        [self.contentView addSubview:_sendfaild];
        [_sendfaild setEnlargeEdge:20]; //扩大点击区域
        _sendfaild.hidden = YES;
        
        
        //系统消息背景图
        _noticeContentView = [[UIView alloc]init];
        _noticeContentView.backgroundColor =SEPERATELINECOLOR;
        [self.contentView addSubview:_noticeContentView];
        
        //系统消息label
        _noticeLabel = [[UILabel alloc]init];
        _noticeLabel.textColor = [UIColor grayColor];
        _noticeLabel.font =ChatTimeFont;
        [_noticeContentView addSubview:_noticeLabel];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UUAVAudioPlayerDidFinishPlay) name:@"StopPlayVoice" object:nil];
        
        /** 作业/问答部分 */
        //底部
        _noticeTipsContentView = [[UIView alloc]init];
        _noticeTipsContentView.backgroundColor = SEPERATELINECOLOR_2;
        [self.contentView addSubview:_noticeTipsContentView];
        _noticeTipsContentView.layer.borderColor = TITLECOLOR.CGColor;
        _noticeTipsContentView.layer.borderWidth = 0.5;
        
        //左侧标签
        _noticeTipsCategoryContent = [[UIView alloc]init];
        _noticeTipsCategoryContent.backgroundColor = [UIColor blueColor];
        [_noticeTipsContentView addSubview:_noticeTipsCategoryContent];
        
        //标题
        _noticeTipsTitle = [[UILabel alloc]init];
        [_noticeTipsContentView addSubview:_noticeTipsTitle];
        
        
    }
    return self;
}

//头像点击
- (void)btnHeadImageClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(headImageDidClick:userId:)])  {
        [self.delegate headImageDidClick:self userId:self.messageFrame.message.strId];
    }
}

//聊天气泡点击事件
- (void)btnContentClick{
    
    // 显示文字
    if (self.messageFrame.message.type == UUMessageTypeText){
        
    }
    /* 显示图片*/
    else if (self.messageFrame.message.type == UUMessageTypePicture){
        /**测试代码*/
        UIImage *image;
        UIImageView * btnImageView;
        if (self.messageFrame.message.from == UUMessageFromMe) {
            /* 自己发送的消息*/
            if (self.messageFrame.message.thumbPath) {
                image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",_messageFrame.message.thumbPath]];
                btnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,10,500,500)];
            }else{
                image = self.btnContent.backImageView.image;
                btnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,10,500,500)];
                btnImageView.image = image;
            }
            [_photoDelegate showImage:btnImageView andImage:image];
            
        }else{
            /* 对方发送的消息*/
            
            image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",_messageFrame.message.thumbPath]];
            btnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,10,500,500)];

            [_photoDelegate showImage:btnImageView andImage:image];
        }

        
    }else if (self.messageFrame.message.type == UUMessageTypeVoice){
        
        if(!contentVoiceIsPlaying){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VoicePlayHasInterrupt" object:nil];
            contentVoiceIsPlaying = YES;
//            audio = [UUAVAudioPlayer sharedInstance];
//            audio.delegate = self;
//                    [audio playSongWithUrl:voiceURL];
//            [audio playSongWithData:songData];
            [self UUAVAudioPlayerBeiginPlay];
            [[NIMSDK sharedSDK].mediaManager play:self.messageFrame.message.voicePath];
            
        }else{
            
            [self UUAVAudioPlayerDidFinishPlay];
        }
        
    }else if (self.messageFrame.message.type == UUMessageTypeNotificationTips){
        //跳转到作业或者问答 🙃
        //在这儿点击跳转啊魂淡
        
        
    }
    
}


/* 气泡长按点击事件*/
- (void)longPress:(UILongPressGestureRecognizer *)longPress{
    
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:{
            
            //只有语音消息才可以有长按功能
            
            if (self.messageFrame.message.type == UUMessageTypeVoice) {
                
                [_delegate cellContentLongPress:self voice:self.messageFrame.message.voice];
            }
            
        }
            break;
            
        case UIGestureRecognizerStateChanged:{
            
        }
            break;
        case UIGestureRecognizerStateEnded:{
            
        }
            break;
    }
    
    
}

/* 语音转换成文字*/
- (void)changeVoiceToText{
    
    
    
}

-(BOOL)canBecomeFirstResponder{
    return NO;
}


/**
 * 通过这个方法告诉UIMenuController它内部应该显示什么内容
 * 返回YES，就代表支持action这个操作
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{

    return NO; // 除了上面的操作，都不支持
}


#pragma mark- 音频播放类
- (void)UUAVAudioPlayerBeiginLoadVoice
{
    [self.btnContent benginLoadVoice];
}

- (void)UUAVAudioPlayerBeiginPlay
{
    //开启红外线感应
//    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    [[NIMSDK sharedSDK].mediaManager setNeedProximityMonitor:YES];
    [self.btnContent didLoadVoice];
}
- (void)UUAVAudioPlayerDidFinishPlay
{
    [[NIMSDK sharedSDK].mediaManager stopPlay];
    //关闭红外线感应
//    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [[NIMSDK sharedSDK].mediaManager setNeedProximityMonitor:YES];
    contentVoiceIsPlaying = NO;
    [self.btnContent stopPlay];
    
}


//内容及Frame设置
/* 这是聊天内容复用中最重要的方法!!!!*/
- (void)setMessageFrame:(UUMessageFrame *)messageFrame{
    
    _messageFrame = messageFrame;
    
    if (messageFrame.message.type != UUMessagetypeNotice && messageFrame.message.type != UUMessageTypeNotificationTips) {
        
        self.labelTime.hidden = NO;
        self.labelNum.hidden = NO;
        self.btnHeadImage.hidden = NO;
        self.btnContent.hidden = NO;
        self.noticeContentView.hidden = YES;
        self.noticeLabel.hidden = YES;
        self.timeLabel.hidden = NO;
        self.title.hidden = NO;
        self.sendfaild.hidden = YES;
        headImageBackView.hidden = NO;
        self.noticeTipsContentView.hidden = YES;
        // 1、设置时间
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"MM-dd HH:mm:ss Z"];
        NSDate *date = [formatter dateFromString:messageFrame.message.strTime];
        NSString *times = [date changeUTC];
        NSLog(@"%@",times);
        
        self.labelTime.text = messageFrame.message.strTime;
//        self.labelTime.text = [times substringFromIndex:5];

        self.labelTime.frame = messageFrame.timeF;
        
        // 2、设置头像
        
        if (messageFrame.message.strIcon==nil) {
            messageFrame.message.strIcon = @"";
        }
        
        
        headImageBackView.frame = messageFrame.iconF;
        self.btnHeadImage.frame = CGRectMake(0, 0, ChatIconWH, ChatIconWH);
        [self.btnHeadImage setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:messageFrame.message.strIcon] placeholderImage:[UIImage imageNamed:@"headImage.jpeg"]];
        
        // 3、发送人姓名
        if (messageFrame.message.strName == nil) {
            messageFrame.message.strName = @"";
        }
        self.labelNum.text = messageFrame.message.strName;
        self.labelNum.textAlignment = NSTextAlignmentCenter;
        
        if (messageFrame.message.from == UUMessageFromMe) {
            self.labelNum.hidden = YES;
        }else{
            self.labelNum.hidden = NO;
            if (messageFrame.nameF.origin.x > 160) {
                [self.labelNum sd_clearAutoLayoutSettings];
                self.labelNum.sd_layout
                .topEqualToView(headImageBackView)
                .rightSpaceToView(headImageBackView,5)
                .autoHeightRatio(0);
                [self.labelNum setSingleLineAutoResizeWithMaxWidth:200];
                [self.labelNum updateLayout];
                
            }else{
                [self.labelNum sd_clearAutoLayoutSettings];
                self.labelNum.sd_layout
                .topEqualToView(headImageBackView)
                .leftSpaceToView(_btnHeadImage,20)
                .autoHeightRatio(0);
                [self.labelNum setSingleLineAutoResizeWithMaxWidth:200];
                [self.labelNum updateLayout];
                
            }
        }
        
        // 4、设置内容
        [self.btnContent setTitle:@"" forState:UIControlStateNormal];
        /* 用yytext 改写*/
        [self.btnContent.contentTextView setText:@""];
        self.btnContent.voiceBackView.hidden = YES;
        self.btnContent.backImageView.hidden = YES;
        
        //以上 , 基本控件完成 .
        //判断:自己发送的消息
        if (messageFrame.message.from == UUMessageFromMe) {
            [self.btnContent sd_clearAutoLayoutSettings];
            self.btnContent.sd_layout
            .topSpaceToView(self.timeLabel,10)
            .rightSpaceToView(headImageBackView,10)
            .widthIs(messageFrame.contentF.size.width)
            .heightIs(messageFrame.contentF.size.height);
            [self.btnContent updateLayout];
            
            self.btnContent.isMyMessage = YES;
            //判断:消息类型是文本
            if (messageFrame.message.type == UUMessageTypeText) {
                
                [self.btnContent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                /* YYText改写*/
                [self.btnContent.contentTextView setTextColor:[UIColor greenColor]];
                self.btnContent.contentTextView.textAlignment = NSTextAlignmentCenter;
                
                self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentRight, ChatContentBottom, 30);
                //            self.btnContent.title .textColor = [UIColor greenColor];
                //判断:消息类型是图片
            }else if(messageFrame.message.type == UUMessageTypePicture){
                
                [self.btnContent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentRight, ChatContentBottom, ChatContentLeft);
                
            }else if(messageFrame.message.type == UUMessageTypeVoice){
                
                
            }
            
        }else{
            //判断:别人发送的消息
            
            [self.btnContent sd_clearAutoLayoutSettings];
            
            self.btnContent.sd_layout
            .topSpaceToView(self.timeLabel,10)
            .leftSpaceToView(_btnHeadImage,10)
            .widthIs(messageFrame.contentF.size.width)
            .heightIs(messageFrame.contentF.size.height);
            [self.btnContent updateLayout];
            
            self.btnContent.isMyMessage = NO;
            //判断:消息类型是文本
            if (messageFrame.message.type == UUMessageTypeText) {
                
                [self.btnContent setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                /* YYText改写*/
                [self.btnContent.contentTextView setTextColor:[UIColor whiteColor]];
                self.btnContent.contentTextView.textAlignment = NSTextAlignmentCenter;
                self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentLeft, ChatContentBottom, ChatContentRight);
                //判断:消息类型是图片
            }else if(messageFrame.message.type == UUMessageTypePicture){
                
                [self.btnContent setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentLeft, ChatContentBottom, ChatContentRight);
            }else if(messageFrame.message.type == UUMessageTypeVoice){
                
                
            }
        }
        
        /* 5.发送设置时间戳(头像旁边)*/
        
        if (messageFrame.message.from == UUMessageFromMe) {
            [_timeLabel sd_clearAutoLayoutSettings];
            _timeLabel.sd_layout
            .topEqualToView(headImageBackView)
            .rightSpaceToView(headImageBackView,10)
            .autoHeightRatio(0);
            [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];
            
            [_timeLabel updateLayout];
            
            if (messageFrame.message.type != UUMessageTypeVoice) {
                
                NSLog(@"文本%@",messageFrame.message.strTime);
                _timeLabel.text = messageFrame.message.strTime ;
                
            }else {
                NSLog(@"非文本消息时间:%@",messageFrame.message.strTime);
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
                [formatter setDateFormat:@"MM-dd HH:mm:ss Z"];
                NSDate *date = [formatter dateFromString:messageFrame.message.strTime];
                NSString *times = [date changeUTC];
                NSLog(@"%@",times);
                _timeLabel.text = [times substringFromIndex:5];
            }
            
        }else if(messageFrame.message.from == UUMessageFromOther){
            [_timeLabel sd_clearAutoLayoutSettings];
            _timeLabel.sd_layout
            .leftSpaceToView(_labelNum,5)
            .topEqualToView(_labelNum)
            .bottomEqualToView(_labelNum);
            [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];
            [_timeLabel updateLayout];
            
            if (messageFrame.message.type != UUMessageTypeVoice) {
                NSLog(@"文本%@",messageFrame.message.strTime);
                _timeLabel.text = messageFrame.message.strTime ;
                
            }else {
                NSLog(@"非文本消息时间:%@",messageFrame.message.strTime);
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
                [formatter setDateFormat:@"MM-dd HH:mm:ss Z"];
                NSDate *date = [formatter dateFromString:messageFrame.message.strTime];
                NSString *times = [date changeUTC];
                NSLog(@"%@",times);
                _timeLabel.text = [times substringFromIndex:5];
            }
        }
        
        /* 发送失败提示*///单独写出来这部分
        if (messageFrame.message.from == UUMessageFromMe) {
            if (messageFrame.message.type == UUMessageTypeText) {
                
                [_sendfaild sd_clearAutoLayoutSettings];
                
                _sendfaild.sd_layout
                .centerYEqualToView(self.title)
                .rightSpaceToView(self.title,10)
                .widthIs(20)
                .heightEqualToWidth();
                [_sendfaild updateLayout];
            }else if(messageFrame.message.type == UUMessageTypePicture){
                
                [_sendfaild sd_clearAutoLayoutSettings];
                _sendfaild.sd_layout
                .centerYEqualToView(self.btnContent)
                .rightSpaceToView(self.btnContent,10)
                .widthIs(20)
                .heightEqualToWidth();
                [_sendfaild updateLayout];
                
                
            }else if(messageFrame.message.type == UUMessageTypeVoice){
                
                [_sendfaild sd_clearAutoLayoutSettings];
                _sendfaild.sd_layout
                .centerYEqualToView(self.btnContent)
                .rightSpaceToView(self.btnContent,10)
                .widthIs(20)
                .heightEqualToWidth();
                [_sendfaild updateLayout];
            }
        }else{
            if (messageFrame.message.type == UUMessageTypeText) {
                [_sendfaild sd_clearAutoLayoutSettings];
                _sendfaild.sd_layout
                .centerYEqualToView(self.title)
                .leftSpaceToView(self.btnContent,10)
                .widthIs(20)
                .heightEqualToWidth();
                [_sendfaild updateLayout];
            }else if(messageFrame.message.type == UUMessageTypePicture){
                [_sendfaild sd_clearAutoLayoutSettings];
                _sendfaild.sd_layout
                .centerYEqualToView(self.btnContent)
                .leftSpaceToView(self.btnContent,10)
                .widthIs(20)
                .heightEqualToWidth();
                [_sendfaild updateLayout];
            }else if(messageFrame.message.type == UUMessageTypeVoice){
                [_sendfaild sd_clearAutoLayoutSettings];
                _sendfaild.sd_layout
                .centerYEqualToView(self.btnContent)
                .leftSpaceToView(self.btnContent,10)
                .widthIs(20)
                .heightEqualToWidth();
                [_sendfaild updateLayout];
            }
        }
        
        
        //背景气泡图
        UIImage *normal;
        if (messageFrame.message.from == UUMessageFromMe) {
            normal = [UIImage imageNamed:@"chatto_bg_normal"];
            normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22)];
        }
        else if(messageFrame.message.from == UUMessageFromOther){
            normal = [UIImage imageNamed:@"chatfrom_bg_normal"];
            normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10)];
        }
        [self.btnContent setBackgroundImage:normal forState:UIControlStateNormal];
        [self.btnContent setBackgroundImage:normal forState:UIControlStateHighlighted];
        
        //气泡内部的文字/图片/音频 布局
        if (messageFrame.message.from == UUMessageFromMe) {
            
            switch (messageFrame.message.type) {
                    
                case UUMessageTypeText:{
                    
                    self.title.hidden = NO;
                    self.btnContent.title.hidden = YES;
                    self.btnContent.contentTextView.hidden= NO;
                    self.btnContent.backImageView.hidden = YES;
                    self.btnContent.voiceBackView.hidden = YES;
                    self.noticeTipsContentView.hidden = YES;
                    
                    NSString *title = messageFrame.message.strContent;
                    if (title ==nil) {
                        title =@"";
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
                    NSArray *resultArray = [re matchesInString:messageFrame.message.strContent options:0 range:NSMakeRange(0, messageFrame.message.strContent.length)];
                    NSLog(@"%@",resultArray);
                    
                    //判断是不是富文本 ->在这里判断是最合适的,不会冲掉手动发送的文本
                    if (resultArray.count!=0) {
                        /* 包含富文本*/
                        /* 先取出来表情*/
                        
                        NSMutableArray *names = @[].mutableCopy;
                        
                        //根据匹配范围来用图片进行相应的替换
                        for(NSTextCheckingResult *match in resultArray){
                            //获取数组元素中得到range
                            NSRange range = [match range];
                            
                            //获取原字符串中对应的值
                            NSString *subStr = [title substringWithRange:range];
                            NSMutableString *subName = [NSMutableString stringWithFormat:@"%@",[subStr substringWithRange:NSMakeRange(1, subStr.length-2)]];
                            NSMutableString *faceName = @"".mutableCopy;
                            faceName = [NSMutableString stringWithFormat:@"em_%ld",subName.integerValue+1];
                            NSDictionary *dicc= @{@"name":faceName,@"range":[NSValue valueWithRange:range]};
                            [names addObject:dicc];
                            
                        }
                        
                        for (NSInteger i = names.count-1; i>=0; i--) {
                            
                            NSString *path = [[NSBundle mainBundle] pathForScaledResource:names[i][@"name"] ofType:@"gif" inDirectory:@"Emotions.bundle"];
                            NSData *data = [NSData dataWithContentsOfFile:path];
                            YYImage *image = [YYImage imageWithData:data scale:2.5];
                            image.preloadAllAnimatedImageFrames = YES;
                            YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
                            
                            NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.size alignToFont:[UIFont systemFontOfSize:13*ScrenScale] alignment:YYTextVerticalAlignmentCenter];
                            
                            
                            [text replaceCharactersInRange:[names [i][@"range"] rangeValue] withAttributedString:attachText];
                            
                            
                        }
                        self.title.attributedText =text;
                        /* 富文本的title和气泡方案*/
                        
                        self.title.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 15);
                        self.title.textAlignment = NSTextAlignmentLeft;
                        
                        normal  = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 5, 10, 22)];
                        
                        
                        [self.btnContent updateLayout];
                        
                        [self.title sd_clearAutoLayoutSettings];
                        self.title.sd_layout
                        .leftEqualToView(self.btnContent)
                        .rightEqualToView(self.btnContent)
                        .topEqualToView(self.btnContent)
                        .bottomEqualToView(self.btnContent);
                        [self.title updateLayout];
                        
                    }else{
                        /* 不包含富文本*/
                        self.title.attributedText = text;
                        
                        
                        self.title.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 15);
                        self.title.textAlignment = NSTextAlignmentLeft;
                        //                    self.btnContent.frame = messageFrame.contentF;
                        
                        [self.btnContent updateLayout];
                        [self.title sd_clearAutoLayoutSettings];
                        self.title.sd_layout
                        .leftEqualToView(self.btnContent)
                        .rightEqualToView(self.btnContent)
                        .topEqualToView(self.btnContent)
                        .bottomEqualToView(self.btnContent);
                        [self.title updateLayout];
                        
                    }
                    
                    //                [self.title setFrame:self.btnContent.frame];
                    //
                    //                self.title.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 15);
                    //                self.title.textAlignment = NSTextAlignmentLeft;
                }
                    
                    break;
                case UUMessageTypePicture:{
                    
                    self.title.hidden = YES;
                    self.btnContent.title.hidden = YES;
                    self.btnContent.contentTextView.hidden= YES;
                    self.btnContent.voiceBackView.hidden = YES;
                    self.btnContent.backImageView.hidden = NO;
                    self.noticeTipsContentView.hidden = YES;
                    self.btnContent.backImageView.image = messageFrame.message.picture;
                    self.btnContent.backImageView.frame = CGRectMake(0, 0, self.btnContent.frame.size.width, self.btnContent.frame.size.height);
                    [self makeMaskView:self.btnContent.backImageView withImage:normal];
                    
                }
                    
                    break;
                case UUMessageTypeVoice:{
                    
                    self.title.hidden = YES;
                    self.btnContent.title.hidden = YES;
                    self.btnContent.contentTextView.hidden= YES;
                    self.btnContent.backImageView.hidden = YES;
                    self.btnContent.titleLabel.hidden=YES;
                    self.btnContent.voiceBackView.hidden = NO;
                    self.noticeTipsContentView.hidden = YES;
                    self.btnContent.voiceBackView.transform = CGAffineTransformMakeScale(1, 1);
                    self.btnContent.second.transform = CGAffineTransformMakeScale(1, 1);
                    self.btnContent.second.textAlignment = NSTextAlignmentLeft;
                    self.btnContent.second.textColor= [UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1.00];;
                    self.btnContent.second.text = [NSString stringWithFormat:@"%@''",messageFrame.message.strVoiceTime];
                    songData = messageFrame.message.voice;
                    
                }
                    break;
                    
                default:
                    break;
            }
        }else if(messageFrame.message.from == UUMessageFromOther){
            
            switch (messageFrame.message.type) {
                case UUMessageTypeText:{
                    
                    self.title.hidden = NO;
                    self.btnContent.title.hidden = NO;
                    self.btnContent.contentTextView.hidden= NO;
                    self.btnContent.titleLabel.hidden=NO;
                    self.btnContent.voiceBackView.hidden = YES;
                    self.noticeTipsContentView.hidden = YES;
                    NSString *title = messageFrame.message.strContent;
                    if (title ==nil) {
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
                    NSArray *resultArray = [re matchesInString:title options:0 range:NSMakeRange(0, messageFrame.message.strContent.length)];
                    NSLog(@"%@",resultArray);
                    
                    
                    if (resultArray.count!=0) {
                        //有富文本
                        
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
                            
                            faceName = [NSMutableString stringWithFormat:@"%@",[subStr substringWithRange:NSMakeRange(1, subStr.length-2)]];
                            
                            NSDictionary *dicc= @{@"name":faceName,@"range":[NSValue valueWithRange:range]};
                            [names addObject:dicc];
                            
                        }
                        for (NSInteger i = names.count-1; i>=0; i--) {
                            
                            NSString *path = [[NSBundle mainBundle] pathForScaledResource:names[i][@"name"] ofType:@"gif" inDirectory:@"Emotions.bundle"];
                            NSData *data = [NSData dataWithContentsOfFile:path];
                            YYImage *image = [YYImage imageWithData:data scale:2.5];
                            image.preloadAllAnimatedImageFrames = YES;
                            YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
                            
                            NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.size alignToFont:[UIFont systemFontOfSize:12*ScrenScale] alignment:YYTextVerticalAlignmentCenter];
                            
                            [text replaceCharactersInRange:[names [i][@"range"] rangeValue] withAttributedString:attachText];
                        }
                        
                        
                        self.title.attributedText =text;
                        
                        [self.btnContent updateLayout];
                        
                        [self.title sd_clearAutoLayoutSettings];
                        self.title.sd_layout
                        .leftEqualToView(self.btnContent)
                        .rightEqualToView(self.btnContent)
                        .topEqualToView(self.btnContent)
                        .bottomEqualToView(self.btnContent);
                        [self.title updateLayout];
                        
                        
                        self.title.textContainerInset  = UIEdgeInsetsMake(10, 20, 0, 0);
                        self.title.textAlignment = NSTextAlignmentLeft;
                        
                    }else{
                        //没有富文本
                        self.title.attributedText =text;
                        
                        [self.title setFrame:self.btnContent.frame];
                        
                        self.title.textContainerInset  = UIEdgeInsetsMake(10, 20, 0, 0);
                        self.title.textAlignment = NSTextAlignmentLeft;
                        
                        [self.btnContent updateLayout];
                        [self.title sd_clearAutoLayoutSettings];
                        self.title.sd_layout
                        .leftEqualToView(self.btnContent)
                        .rightEqualToView(self.btnContent)
                        .topEqualToView(self.btnContent)
                        .bottomEqualToView(self.btnContent);
                        [self.title updateLayout];
                        
                    }
                    
                }
                    
                    break;
                case UUMessageTypePicture:
                {
                    self.title.hidden = YES;
                    self.btnContent.title.hidden = YES;
                    self.btnContent.contentTextView.hidden= YES;
                    self.btnContent.backImageView.hidden = NO;
                    self.btnContent.voiceBackView.hidden = YES;
                    self.btnContent.titleLabel.hidden=YES;
                    self.noticeTipsContentView.hidden = YES;
                    [self.btnContent.backImageView setImage:messageFrame.message.picture];
                    self.btnContent.backImageView.frame = CGRectMake(0, 0, self.btnContent.frame.size.width, self.btnContent.frame.size.height);
                    
                    [self makeMaskView:self.btnContent.backImageView withImage:normal];
                    
                }
                    break;
                case UUMessageTypeVoice:{
                    
                    self.title.hidden = YES;
                    self.btnContent.title.hidden = YES;
                    self.btnContent.contentTextView.hidden= YES;
                    self.btnContent.backImageView.hidden = YES;
                    self.btnContent.titleLabel.hidden=YES;
                    self.btnContent.voiceBackView.hidden = NO;
                    self.noticeTipsContentView.hidden = YES;
                    
                    self.btnContent.voiceBackView.transform = CGAffineTransformMakeScale(-1, 1);
                    self.btnContent.second.transform = CGAffineTransformMakeScale(-1, 1);
                    self.btnContent.second.textAlignment = NSTextAlignmentRight;
                    self.btnContent.second.text = [NSString stringWithFormat:@"%@''",messageFrame.message.strVoiceTime];
                    songData = messageFrame.message.voice;
                    
                }
                    break;
                    
                default:
                    break;
                    
            }
        }

    }
    
    if(messageFrame.message.type == UUMessagetypeNotice){
       //系统公告类消息
        
        self.labelTime.hidden = YES;
        self.labelNum.hidden = YES;
        self.btnHeadImage.hidden = YES;
        self.btnContent.hidden = YES;
        self.noticeContentView.hidden = NO;
        self.noticeLabel.hidden = NO;
        headImageBackView.hidden = YES;
        self.timeLabel.hidden = YES;
        self.title.hidden = YES;
        self.sendfaild.hidden = YES;
        self.noticeTipsContentView.hidden = YES;
        
        self.noticeLabel.textAlignment = NSTextAlignmentLeft;
        
        if (messageFrame.message.strContent==nil) {
            self.noticeLabel.text = messageFrame.message.strContent;
            self.noticeLabel.textAlignment = NSTextAlignmentCenter;
            
        }else{
            self.noticeLabel.text = messageFrame.message.strContent;
            self.noticeLabel.textAlignment = NSTextAlignmentCenter;
            
        }
        self.noticeContentView.sd_layout
        .centerYEqualToView(self.contentView)
        .centerXEqualToView(self.contentView);
        self.noticeContentView.sd_cornerRadius =@6;
        
        self.noticeLabel.sd_layout
        .centerXEqualToView(_noticeContentView)
        .centerYEqualToView(_noticeContentView)
        .autoHeightRatio(0);
        [self.noticeLabel setSd_maxWidth:@([UIScreen mainScreen].bounds.size.width/2.f)];
        [self.noticeLabel setMaxNumberOfLinesToShow:0];
        self.noticeLabel.sd_cornerRadius = @6;
        [self.noticeLabel updateLayout];
        
        self.noticeContentView.sd_layout
        .heightIs(self.noticeLabel.height_sd+20)
        .widthIs(self.noticeLabel.width_sd+20);
        [self.noticeContentView updateLayout];
        
    }else if (messageFrame.message.type == UUMessageTypeNotificationTips){
        
        self.labelTime.hidden = YES;
        self.labelNum.hidden = YES;
        self.btnHeadImage.hidden = YES;
        self.btnContent.hidden = YES;
        self.noticeContentView.hidden = YES;
        self.noticeLabel.hidden = YES;
        headImageBackView.hidden = YES;
        self.timeLabel.hidden = YES;
        self.title.hidden = YES;
        self.sendfaild.hidden = YES;
        self.noticeTipsContentView.hidden = NO;
        
        
    }
}


- (void)makeMaskView:(UIView *)view withImage:(UIImage *)image
{
    UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:image];
    imageViewMask.frame = CGRectInset(view.frame, 0.0f, 0.0f);
    view.layer.mask = imageViewMask.layer;
}

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    if ([[UIDevice currentDevice] proximityState] == YES){
        NSLog(@"靠近耳朵,使用听筒播放");
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [[NIMSDK sharedSDK].mediaManager switchAudioOutputDevice:NIMAudioOutputDeviceReceiver];
        
    }
    else{
        NSLog(@"远离耳朵,使用扬声器播放");
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[NIMSDK sharedSDK].mediaManager switchAudioOutputDevice:NIMAudioOutputDeviceSpeaker];
    }
}

@end



