//
//  UUMessage.h
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-26.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMSDK.h"

typedef NS_ENUM(NSInteger, MessageType) {
    UUMessageTypeText     = 0 , // 文字
    UUMessageTypePicture  = 1 , // 图片
    UUMessageTypeVoice    = 2   // 语音
};


typedef NS_ENUM(NSInteger, MessageFrom) {
    UUMessageFromMe    = 0,   // 自己发的
    UUMessageFromOther = 1    // 别人发得
};


@interface UUMessage : NSObject



/**
 消息ID,消息的唯一标识 ->重要
 */
@property(nonatomic,strong) NSString *messageID ;



/**
 用户头像
 */
@property (nonatomic, copy) NSString *strIcon;


/**
 用户ID
 */
@property (nonatomic, copy) NSString *strId;


/**
 消息时间戳
 */
@property (nonatomic, copy) NSString *strTime;


/**
 用户名
 */
@property (nonatomic, copy) NSString *strName;


/**
 消息文字/表情内容
 */
@property (nonatomic, copy) NSString *strContent;


/**
 图片消息内容
 */
@property (nonatomic, copy) UIImage  *picture;


/**
 语音->播放时用的data类型播放
 */
@property (nonatomic, copy) NSData   *voice;


/**
 语音时长
 */
@property (nonatomic, copy) NSString *strVoiceTime;


/**
 增加一个 是否是富文本的bool值,用来加载数据(和计算尺寸)
 */
@property(nonatomic,assign) BOOL isRichText ;


/**
 增加一个 富文本字数 用来计算气泡尺寸
 */
@property(nonatomic,assign) NSInteger richNum ;


/**
 消息类型
 UUMessageTypeText     = 0 , // 文字
 UUMessageTypePicture  = 1 , // 图片
 UUMessageTypeVoice    = 2   // 语音
 */
@property (nonatomic, assign) MessageType type;


/**
 消息发送者
 UUMessageFromMe    = 0,   // 自己发的
 UUMessageFromOther = 1    // 别人发得
 */
@property (nonatomic, assign) MessageFrom from;


/**
 图片消息:增加一个高清图片本地地址
 */
@property(nonatomic,strong) NSString *imagePath ;


/**
 图片消息:增加缩略图地址
 */
@property(nonatomic,strong) NSString *thumbPath ;


/**
 是否显示时间戳(时间/通知类型消息)
 */
@property (nonatomic, assign) BOOL showDateLabel;


/**
 消息是否发送失败
 */
@property(nonatomic,assign) BOOL sendFaild ;




/* 最强大的属性->消息直接存成属性*/
@property(nonatomic,strong) NIMMessage *message ;


- (void)setWithDict:(NSDictionary *)dic;

- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end;

@end
