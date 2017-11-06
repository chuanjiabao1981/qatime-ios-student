//
//  ChatModel.m
//  UUChatTableView
//
//  Created by shake on 15/1/6.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "ChatModel.h"

#import "UUMessage.h"
#import "UUMessageFrame.h"
#import "NSString+Date.h"
#import "NSString+TimeStamp.h"
#import "NSDate+Utils.h"

@implementation ChatModel


- (void)populateRandomDataSource {
    self.dataSource = [NSMutableArray array];
    
}

- (void)addRandomItemsToDataSource:(NSInteger)number{
    
}

#pragma mark- 文本消息
// 添加自己的文本类型的item
- (void)addSpecifiedItem:(NSDictionary *)dic andIconURL:(NSString *)iconURL andName:(NSString *)name andMessage:(NIMMessage *)textMessage
{
    if (name ==nil) {
        name =@"";
    }
    
    if (iconURL==nil) {
        iconURL = @"";
    }
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
    UUMessage *message = [[UUMessage alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSString *URLStr = iconURL;
    [dataDic setObject:@(UUMessageFromMe) forKey:@"from"];
    //        [dataDic setObject:[[NSDate date] description] forKey:@"strTime"];
    
    [dataDic setObject:name forKey:@"strName"];
    
    [dataDic setObject:URLStr==nil?@"":URLStr forKey:@"strIcon"];
    [dataDic setObject:textMessage forKey:@"message"];
    
    [message setWithDict:dataDic];
    [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
    messageFrame.showTime = message.showDateLabel;
    
    
    /* 用message制作出messageframe对象*/
    [messageFrame setMessage:message];
    
    if (message.showDateLabel) {
        previousTime = dataDic[@"strTime"];
    }
    /* messageframe对象 添加到数据源里
     
     * 发送消息过程结束。
     */
    [self.dataSource addObject:messageFrame];
    
}
/* 创建对方发来的文本消息*/
- (NSDictionary *)getDicWithText:(NSString *)text andName:(NSString *)name andIcon:(NSString *)URLString type:(MessageType)type andTime:(NSString *)time andMessage:(NIMMessage *)message{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    int randomNum =type;
    
    if (randomNum == UUMessageTypePicture){
        //        [dictionary setObject:@"" forKey:@"picture"];
    }else{
        /* 消息类型是文字 */
        randomNum = UUMessageTypeText;
        if (text == nil) {
            text = @"";
        }
        if (URLString==nil) {
            URLString = @"";
        }
        [dictionary setObject:text forKey:@"strContent"];
        
    }
    
    //    NSDate *date = [[NSDate date]dateByAddingTimeInterval:arc4random()%1000*(dateNum++) ];
    [dictionary setObject:@(UUMessageFromOther) forKey:@"from"];
    [dictionary setObject:@(randomNum) forKey:@"type"];
    [dictionary setObject:time forKey:@"strTime"];
    if (name == nil) {
        name = @"";
    }
    [dictionary setObject:name forKey:@"strName"];
    [dictionary setObject:URLString==nil?@"":URLString forKey:@"strIcon"];
    [dictionary setObject:message forKey:@"message"];
    
    
    
    
    return dictionary;
}

#pragma mark- 时间戳/系统消息类型
// 添加聊天item（一个cell内容） 时间戳/系统其他消息类型
static NSString *previousTime = nil;
- (NSArray *)additems:(NSInteger)number withDictionary:(NSDictionary *)dictionary
{
    NSMutableArray *result = [NSMutableArray array];
    
    
    for (int i=0; i<number; i++) {
        
        //        NSDictionary *dataDic = [self getDic];
        UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
        UUMessage *message = [[UUMessage alloc] init];
        [message setWithDict:dictionary];
        [message minuteOffSetStart:previousTime end:dictionary[@"strTime"]];
        messageFrame.showTime = message.showDateLabel;
        [messageFrame setMessage:message];
        
        if (message.showDateLabel) {
            previousTime = dictionary[@"strTime"];
        }
        [result addObject:messageFrame];
    }
    
    return result;
}

#pragma mark- 图片类型消息

/* 创建并发送自己的图片类型的item*/
- (void)addSpecifiedImageItem:(NSDictionary *)dic andIconURL:(NSString *)iconURL andName:(NSString *)name andMessage:(NIMMessage *)imageMessage{
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
    UUMessage *message = [[UUMessage alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSString *URLStr = iconURL;
    [dataDic setObject:@(UUMessageFromMe) forKey:@"from"];
    [dataDic setObject:dic[@"strTime"] forKey:@"strTime"];
    
    
    if (name ==nil) {
        name =@"";
    }
    if (iconURL==nil) {
        iconURL = @"";
    }
    
    if (dic[@"picture"]==nil) {
        
    }else{
        [dataDic setObject:dic[@"picture"] forKey:@"picture"];
    }
    
    [dataDic setObject:name forKey:@"strName"];
    [dataDic setObject:URLStr==nil?@"":URLStr forKey:@"strIcon"];
    
    
    //    [dataDic setObject:imagePath forKey:@"imagePath"];
    //    [dataDic setObject:thumbImagePath forKey:@"thumbImagePath"];
    
    [dataDic setObject:imageMessage forKey:@"message"];
    
    [message setWithDict:dataDic];
    [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    
    if (message.showDateLabel) {
        previousTime = dataDic[@"strTime"];
    }
    [self.dataSource addObject:messageFrame];
    
    
}


/* 创建别人发来的图片消息*/
- (NSDictionary *)getDicWithImage:(UIImage *)image andName:(NSString *)name andIcon:(NSString *)URLString type:(MessageType)type andImagePath:(NSString *)imagePath andThumbImagePath:(NSString *)thumbImagePath andTime:(NSString *)time andMessage:(NIMMessage *)message{
    
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    int randomNum =type;
    
    
    if (randomNum == UUMessageTypePicture){
        
        if ([dictionary[@"from"]isEqual:@(UUMessageFromMe)]) {
            
            [dictionary setObject:@(UUMessageFromMe) forKey:@"from"];
        }else{
            [dictionary setObject:@(UUMessageFromOther) forKey:@"from"];
        }
        [dictionary setObject:@(randomNum) forKey:@"type"];
        [dictionary setObject:time forKey:@"strTime"];
        
        
        if (image==nil) {
            
        }else{
            [dictionary setObject:image forKey:@"picture"];
        }
        if (name == nil) {
            name = @"";
        }
        [dictionary setObject:name forKey:@"strName"];
        
        NSLog(@"%@",URLString);
        [dictionary setObject:URLString==nil?@"":URLString forKey:@"strIcon"];
        [dictionary setObject:imagePath==nil?@"":imagePath forKey:@"imagePath"];
        [dictionary setObject:thumbImagePath==nil?@"":thumbImagePath forKey:@"thumbImagePath"];
        [dictionary setObject:message forKey:@"message"];
    }
    
    return dictionary;
}


#pragma mark- 语音类型消息

// 自己发送语音聊天信息
- (void)addSpecifiedVoiceItem:(NSDictionary *)dic andIconURL:(NSString *)iconURL andName:(NSString *)name andMessage:(NIMMessage *)voiceMessage{
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
    UUMessage *message = [[UUMessage alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSString *URLStr = iconURL;
    [dataDic setObject:@(UUMessageFromMe) forKey:@"from"];
    [dataDic setObject:dic[@"strTime"] forKey:@"strTime"];
    
    if (name ==nil) {
        name =@"";
    }
    if (iconURL==nil) {
        iconURL = @"";
    }
  
    [dataDic setObject:name forKey:@"strName"];
    [dataDic setObject:URLStr==nil?@"":URLStr forKey:@"strIcon"];
    [dataDic setObject:voiceMessage forKey:@"message"];
    
    [message setWithDict:dataDic];
    [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    
    if (message.showDateLabel) {
        previousTime = dataDic[@"strTime"];
    }
    [self.dataSource addObject:messageFrame];
}


//别人发送语音消息
- (NSDictionary *)getDicWithName:(NSString *)name andIcon:(NSString *)URLString type:(MessageType)type andVoicePath:(NSString *)voicePath andTime:(NSString *)time andMessage:(NIMMessage *)message{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    int randomNum =type;
    
    if (randomNum == UUMessageTypeVoice){
        
        if ([dictionary[@"from"]isEqual:@(UUMessageFromMe)]) {
            
            [dictionary setObject:@(UUMessageFromMe) forKey:@"from"];
        }else{
            [dictionary setObject:@(UUMessageFromOther) forKey:@"from"];
        }
        [dictionary setObject:@(randomNum) forKey:@"type"];
        [dictionary setObject:time forKey:@"strVoiceTime"];
        
        if (name == nil) {
            name = @"";
        }
        [dictionary setObject:name forKey:@"strName"];
        
        NSLog(@"%@",URLString);
        [dictionary setObject:URLString==nil?@"":URLString forKey:@"strIcon"];
        
        [dictionary setObject:[NSString changeTimeStampToDateString:[NSString stringWithFormat:@"%f",message.timestamp]] forKey:@"strTime"];
        [dictionary setObject:message forKey:@"message"];
        [dictionary setObject:voicePath forKey:@"voicePath"];
        
    }
    
    return dictionary;
    
}

/**添加公告消息*/
- (void)addSpecifiedNotificationItem:(NSString *)notification{
    
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
    UUMessage *message = [[UUMessage alloc] init];
    message.isRichText = NO;
    message.strContent = notification;
//    message.attributedStrContent = notification;
    message.type = UUMessagetypeNotice;
    message.from = UUMessageFromeSystem;
    
    [messageFrame setMessage:message];
    [self.dataSource addObject:messageFrame];

}

/** 添加作业/问答模块提醒消息 */
- (void)addSpecifiedNotificationTipsItem:(NSDictionary *)notifications{
    
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
    UUMessage *message = [[UUMessage alloc] init];
    message.isRichText = NO;
    message.strContent = notifications[@"title"];
    message.type = UUMessageTypeNotificationTips;
//    message.from = UUMessageFromOther;
    message.notificationTipsType = notifications[@"type"];
    message.notificationEvents = notifications[@"event"];
    message.taskable_id = notifications[@"taskable_id"];
    message.taskable_type = notifications[@"taskable_type"];
    message.notificationTipsContent = notifications[@"title"];
    message.strName = notifications[@"name"];
    message.strIcon = notifications[@"icon"];
    message.strTime = notifications[@"time"];
    message.notificationTipsContentDic = notifications;
    
    if ([notifications[@"from"] isEqualToString:@"FromMe"]) {
        message.from = UUMessageFromMe;
    }else{
        message.from = UUMessageFromOther;
    }
    
    [messageFrame setMessage:message];
    [self.dataSource addObject:messageFrame];
    
}

@end
