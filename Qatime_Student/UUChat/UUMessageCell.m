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

@interface UUMessageCell ()
{
    
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
        headImageBackView.layer.cornerRadius = 22;
        headImageBackView.layer.masksToBounds = YES;
        headImageBackView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
        [self.contentView addSubview:headImageBackView];
        self.btnHeadImage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnHeadImage.layer.cornerRadius = 20;
        self.btnHeadImage.layer.masksToBounds = YES;
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
        [self.btnContent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btnContent.titleLabel.font = ChatContentFont;
        self.btnContent.titleLabel.numberOfLines = 0;
        [self.btnContent addTarget:self action:@selector(btnContentClick)  forControlEvents:UIControlEventTouchUpInside];
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
        self.title.textColor  = [UIColor whiteColor];
        self.title.numberOfLines = 0;
        [self.contentView addSubview:self.title];
        
    }
    return self;
}

//头像点击
- (void)btnHeadImageClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(headImageDidClick:userId:)])  {
        [self.delegate headImageDidClick:self userId:self.messageFrame.message.strId];
    }
}


- (void)btnContentClick{
    
    // show text and gonna copy that
    if (self.messageFrame.message.type == UUMessageTypeText)
    {
        [self.btnContent becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:self.btnContent.frame inView:self.btnContent.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}


//内容及Frame设置
- (void)setMessageFrame:(UUMessageFrame *)messageFrame{
    
    _messageFrame = messageFrame;
    UUMessage *message = messageFrame.message;
    
    // 1、设置时间
    self.labelTime.text = message.strTime;
    self.labelTime.frame = messageFrame.timeF;
    
    // 2、设置头像
    headImageBackView.frame = messageFrame.iconF;
    self.btnHeadImage.frame = CGRectMake(2, 2, ChatIconWH-4, ChatIconWH-4);
    [self.btnHeadImage setBackgroundImageForState:UIControlStateNormal
                                          withURL:[NSURL URLWithString:message.strIcon]
                                 placeholderImage:[UIImage imageNamed:@"headImage.jpeg"]];
    
    // 3、设置下标
    self.labelNum.text = message.strName;
    if (messageFrame.nameF.origin.x > 160) {
        self.labelNum.frame = CGRectMake(messageFrame.nameF.origin.x - 50, messageFrame.nameF.origin.y + 3, 100, messageFrame.nameF.size.height);
        self.labelNum.textAlignment = NSTextAlignmentRight;
    }else{
        self.labelNum.frame = CGRectMake(messageFrame.nameF.origin.x, messageFrame.nameF.origin.y + 3, 80, messageFrame.nameF.size.height);
        self.labelNum.textAlignment = NSTextAlignmentLeft;
    }
    
    // 4、设置内容
    
    //prepare for reuse
    [self.btnContent setTitle:@"" forState:UIControlStateNormal];
    /* 用yytext 改写*/
    [self.btnContent.contentTextView setText:@""];
    self.btnContent.voiceBackView.hidden = YES;
    self.btnContent.backImageView.hidden = YES;
    
    self.btnContent.frame = messageFrame.contentF;
    
    if (message.from == UUMessageFromMe) {
        self.btnContent.isMyMessage = YES;
        
        
        [self.btnContent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        /* YYText改写*/
        [self.btnContent.contentTextView setTextColor:[UIColor whiteColor]];
        self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentRight, ChatContentBottom, ChatContentLeft);
    }else{
        self.btnContent.isMyMessage = NO;
        
        
        [self.btnContent setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        /* YYText改写*/
        [self.btnContent.contentTextView setTextColor:[UIColor whiteColor]];
        self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentLeft, ChatContentBottom, ChatContentRight);
    }
    
    //背景气泡图
    UIImage *normal;
    if (message.from == UUMessageFromMe) {
        normal = [UIImage imageNamed:@"chatto_bg_normal"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22)];
    }
    else{
        normal = [UIImage imageNamed:@"chatfrom_bg_normal"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10)];
    }
    [self.btnContent setBackgroundImage:normal forState:UIControlStateNormal];
    [self.btnContent setBackgroundImage:normal forState:UIControlStateHighlighted];
    
    
    
    
    if (message.from == UUMessageFromMe) {
        
        
        NSString *title = message.strContent;
        
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
        NSArray *resultArray = [re matchesInString:message.strContent options:0 range:NSMakeRange(0, message.strContent.length)];
        NSLog(@"%@",resultArray);
        
        
        
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
            
            NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.size alignToFont:[UIFont systemFontOfSize:12] alignment:YYTextVerticalAlignmentCenter];
            
            
            
            [text replaceCharactersInRange:[names [i][@"range"] rangeValue] withAttributedString:attachText];
        }
        
        
        switch (message.type) {
            case UUMessageTypeText:
                
                
                self.title.attributedText =text;
                
                [self.title setFrame:self.btnContent.frame];
                
                self.title.textContainerInset  = UIEdgeInsetsMake(0, 5, 0, 5);
                self.title.textAlignment = NSTextAlignmentLeft;
                
                break;
            case UUMessageTypePicture:
            {
            }
                break;
            case UUMessageTypeVoice:
            {
                
            }
                break;
                
            default:
                break;
        }
    }else if(message.from == UUMessageFromOther){
        
        
        NSString *title = message.strContent;
        
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
        NSArray *resultArray = [re matchesInString:message.strContent options:0 range:NSMakeRange(0, message.strContent.length)];
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
            
            NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.size alignToFont:[UIFont systemFontOfSize:12] alignment:YYTextVerticalAlignmentCenter];
            
            
            
            [text replaceCharactersInRange:[names [i][@"range"] rangeValue] withAttributedString:attachText];
        }
        
        
        switch (message.type) {
            case UUMessageTypeText:
                
                
                self.title.attributedText =text;
                
                
                [self.title setFrame:self.btnContent.frame];
                
                self.title.textContainerInset  = UIEdgeInsetsMake(0, 20, 0, 0);
                self.title.textAlignment = NSTextAlignmentLeft;
                
                break;
            case UUMessageTypePicture:
            {
            }
                break;
            case UUMessageTypeVoice:
            {
                
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



