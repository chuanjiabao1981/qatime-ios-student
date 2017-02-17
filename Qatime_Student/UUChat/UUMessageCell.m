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
#import "XHImageViewer.h"
#import "UIImageView+XHURLDownload.h"
#import "UUAVAudioPlayer.h"



//#import "YYPhotoBrowseView.h"

@interface UUMessageCell ()<XHImageViewerDelegate,UUAVAudioPlayerDelegate>
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
//        [self.contentView addSubview:self.labelTime];
        
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
        
        //红外线感应监听
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sensorStateChange:)
                                                     name:UIDeviceProximityStateDidChangeNotification
                                                   object:nil];
        contentVoiceIsPlaying = NO;
        
        /* 创建支持自定义表情的YYLabel类型的label*/
        self.title = [[YYLabel alloc]init];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.textColor  = [UIColor blackColor];
        self.title.numberOfLines = 0;
        [self.contentView addSubview:self.title];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnContentClick)];
        self.title.userInteractionEnabled = YES;
        [self.title addGestureRecognizer:tap];
        
        
        /* 5.真正的时间label*/
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.font =ChatTimeFont;
        [self.contentView addSubview:_timeLabel];
        
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
        XHImageViewer *viewer = [[XHImageViewer alloc]init];
        viewer.delegate = self;
        
        /* 展示用的图片*/
        UIImage *image;
        /* 图片查看器的背景view*/
        UIImageView *btnImageView;
        if (self.messageFrame.message.from == UUMessageFromMe) {
            /* 自己发送的消息*/
            if (self.messageFrame.message.thumbPath) {
                
                image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",_messageFrame.message.thumbPath]];
                btnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,10,500,500)];
                [btnImageView loadWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_messageFrame.message.imagePath]] placeholer:image showActivityIndicatorView:YES];
            }else{
                
                image = self.btnContent.backImageView.image;
                btnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,10,500,500)];
                btnImageView.image = image;
                [btnImageView load];
            }
            [viewer showWithImageViews:@[btnImageView] selectedView:btnImageView];
            
            
        }else{
           /* 对方发送的消息*/
            
            image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",_messageFrame.message.thumbPath]];
            btnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,10,500,500)];
            [btnImageView loadWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_messageFrame.message.imagePath]] placeholer:image showActivityIndicatorView:YES];
            [viewer showWithImageViews:@[btnImageView] selectedView:btnImageView];
        }
        
    }else if (self.messageFrame.message.type == UUMessageTypeVoice){
        if(!contentVoiceIsPlaying){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VoicePlayHasInterrupt" object:nil];
            contentVoiceIsPlaying = YES;
            audio = [UUAVAudioPlayer sharedInstance];
            audio.delegate = self;
            //        [audio playSongWithUrl:voiceURL];
            [audio playSongWithData:songData];
            
        }else{
            [self UUAVAudioPlayerDidFinishPlay];
        }
        
    }
    
}

/* 气泡长按点击事件*/
- (void)longPress:(UILongPressGestureRecognizer *)longPress{
    
    [_delegate cellContentLongPress:self voice:self.messageFrame.message.voice];
    
}

/* 语音转换成文字*/
- (void)changeVoiceToText{
    
    
    
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}


/**
 * 通过这个方法告诉UIMenuController它内部应该显示什么内容
 * 返回YES，就代表支持action这个操作
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(action));
    if (action == @selector(cut:)
        || action == @selector(copy:)
        || action == @selector(paste:)) {
        return YES; // YES ->  代表我们只监听 cut: / copy: / paste:方法
    }
    return NO; // 除了上面的操作，都不支持
    //    return YES;
}


#pragma mark- 音频播放类
- (void)UUAVAudioPlayerBeiginLoadVoice
{
    [self.btnContent benginLoadVoice];
}
- (void)UUAVAudioPlayerBeiginPlay
{
    //开启红外线感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    [self.btnContent didLoadVoice];
}
- (void)UUAVAudioPlayerDidFinishPlay
{
    //关闭红外线感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    contentVoiceIsPlaying = NO;
    [self.btnContent stopPlay];
    [[UUAVAudioPlayer sharedInstance]stopSound];
}


- (void)imageViewer:(XHImageViewer *)imageViewer  willDismissWithSelectedView:(UIImageView*)selectedView{
    
    [imageViewer removeFromSuperview];
    selectedView.hidden = YES;
    
    
}


//内容及Frame设置
/* 这是聊天内容复用中最重要的方法!!!!*/
- (void)setMessageFrame:(UUMessageFrame *)messageFrame{
    
    _messageFrame = messageFrame;
    //    UUMessage *message = messageFrame.message;
    
    // 1、设置时间
//    self.labelTime.text = messageFrame.message.strTime;
//    self.labelTime.frame = messageFrame.timeF;
    
    // 2、设置头像
    
    if (messageFrame.message.strIcon==nil) {
        messageFrame.message.strIcon = @"";
    }
    
    
    headImageBackView.frame = messageFrame.iconF;
    self.btnHeadImage.frame = CGRectMake(0, 0, ChatIconWH, ChatIconWH);
    [self.btnHeadImage setBackgroundImageForState:UIControlStateNormal
                                          withURL:[NSURL URLWithString:messageFrame.message.strIcon]
                                 placeholderImage:[UIImage imageNamed:@"headImage.jpeg"]];
    
    // 3、发送人姓名
    if (messageFrame.message.strName == nil) {
        messageFrame.message.strName = @"";
    }
    self.labelNum.text = messageFrame.message.strName;
    self.labelNum.textAlignment = NSTextAlignmentCenter;
    
    if (messageFrame.nameF.origin.x > 160) {
//        self.labelNum.frame = CGRectMake(messageFrame.nameF.origin.x - 50, messageFrame.nameF.origin.y + 3, 100, messageFrame.nameF.size.height);
        [self.labelNum sd_clearAutoLayoutSettings];
        self.labelNum.sd_layout
        .topEqualToView(headImageBackView)
        .rightSpaceToView(headImageBackView,5)
        .autoHeightRatio(0);
        [self.labelNum setSingleLineAutoResizeWithMaxWidth:200];
        [self.labelNum updateLayout];
        
    }else{
//        self.labelNum.frame = CGRectMake(messageFrame.nameF.origin.x, messageFrame.nameF.origin.y + 3, 80, messageFrame.nameF.size.height);
        
        [self.labelNum sd_clearAutoLayoutSettings];
        self.labelNum.sd_layout
        .topEqualToView(headImageBackView)
        .leftSpaceToView(_btnHeadImage,20)
        .autoHeightRatio(0);
        [self.labelNum setSingleLineAutoResizeWithMaxWidth:200];
        [self.labelNum updateLayout];
        
    }
    
    // 4、设置内容
    
    //prepare for reuse
    [self.btnContent setTitle:@"" forState:UIControlStateNormal];
    /* 用yytext 改写*/
    [self.btnContent.contentTextView setText:@""];
    self.btnContent.voiceBackView.hidden = YES;
    self.btnContent.backImageView.hidden = YES;
    
//    self.btnContent.frame = messageFrame.contentF;
    
    
    
    //判断:自己发送的消息
    if (messageFrame.message.from == UUMessageFromMe) {
        
        [self.btnContent sd_clearAutoLayoutSettings];
        
        self.btnContent.sd_layout
        .topSpaceToView(self.labelNum,10)
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
        .topSpaceToView(self.labelNum,10)
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
    
    /* 5.设置时间戳*/
    
    _timeLabel.text = messageFrame.message.strTime;
    if (messageFrame.message.from == UUMessageFromMe) {
        [_timeLabel sd_clearAutoLayoutSettings];
        _timeLabel.sd_layout
        .rightSpaceToView(_labelNum,5)
        .topEqualToView(_labelNum)
        .bottomEqualToView(_labelNum);
        [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        [_timeLabel updateLayout];
        
    }else{
        [_timeLabel sd_clearAutoLayoutSettings];
        _timeLabel.sd_layout
        .leftSpaceToView(_labelNum,5)
        .topEqualToView(_labelNum)
        .bottomEqualToView(_labelNum);
        [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        [_timeLabel updateLayout];

        
        
        
    }
    
    
    
    
    //背景气泡图
    UIImage *normal;
    if (messageFrame.message.from == UUMessageFromMe) {
        normal = [UIImage imageNamed:@"chatto_bg_normal"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22)];
    }
    else{
        normal = [UIImage imageNamed:@"chatfrom_bg_normal"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10)];
    }
    [self.btnContent setBackgroundImage:normal forState:UIControlStateNormal];
    [self.btnContent setBackgroundImage:normal forState:UIControlStateHighlighted];
    
    
    if (messageFrame.message.from == UUMessageFromMe) {
        
        switch (messageFrame.message.type) {
                
            case UUMessageTypeText:{
                
                self.title.hidden = NO;
                self.btnContent.title.hidden = YES;
                self.btnContent.contentTextView.hidden= NO;
                self.btnContent.backImageView.hidden = YES;
                self.btnContent.voiceBackView.hidden = YES;
                
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
                        
                        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.size alignToFont:[UIFont systemFontOfSize:13] alignment:YYTextVerticalAlignmentCenter];
                        
                         
                        [text replaceCharactersInRange:[names [i][@"range"] rangeValue] withAttributedString:attachText];
                        
                        
                    }
                    self.title.attributedText =text;
                    /* 富文本的title和气泡方案*/
                    
//                    [self.title setFrame:self.btnContent.frame];
                    
                    self.title.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 15);
                    self.title.textAlignment = NSTextAlignmentLeft;
                    
                    normal  = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 5, 10, 22)];
//                    self.btnContent.frame = CGRectMake(messageFrame.contentF.origin.x-20, messageFrame.contentF.origin.y, messageFrame.contentF.size.width+20, messageFrame.contentF.size.height);
//                    self.title.frame = self.btnContent.frame;
                    
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
                
                self.btnContent.voiceBackView.transform = CGAffineTransformMakeScale(1, 1);
                self.btnContent.second.transform = CGAffineTransformMakeScale(1, 1);
                self.btnContent.second.textAlignment = NSTextAlignmentLeft;
                self.btnContent.second.textColor= [UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1.00];;
                self.btnContent.second.text = [NSString stringWithFormat:@"%@''",messageFrame.message.strVoiceTime];
                songData = messageFrame.message.voice;
                //            voiceURL = [NSString stringWithFormat:@"%@%@",RESOURCE_URL_HOST,message.strVoice];
                
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
                
                [self.title setFrame:self.btnContent.frame];
                
                self.title.textContainerInset  = UIEdgeInsetsMake(0, 20, 0, 0);
                self.title.textAlignment = NSTextAlignmentLeft;
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
                
                self.btnContent.voiceBackView.transform = CGAffineTransformMakeScale(-1, 1);
                self.btnContent.second.transform = CGAffineTransformMakeScale(-1, 1);
                self.btnContent.second.textAlignment = NSTextAlignmentRight;
                self.btnContent.second.text = [NSString stringWithFormat:@"%@''",messageFrame.message.strVoiceTime];
                songData = messageFrame.message.voice;
                //            voiceURL = [NSString stringWithFormat:@"%@%@",RESOURCE_URL_HOST,message.strVoice];
                
                
            }
                break;
                
            default:
                break;
                
                
        }
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
        NSLog(@"Device is close to user");
        //        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else{
        NSLog(@"Device is not close to user");
        //        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

@end



