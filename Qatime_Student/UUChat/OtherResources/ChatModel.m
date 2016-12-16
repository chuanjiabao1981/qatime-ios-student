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

@implementation ChatModel

- (void)populateRandomDataSource {
    self.dataSource = [NSMutableArray array];
//    [self.dataSource addObjectsFromArray:[self additems:0]];
}

- (void)addRandomItemsToDataSource:(NSInteger)number{
    
//    for (int i=0; i<number; i++) {
//        [self.dataSource insertObject:[[self additems:1] firstObject] atIndex:0];
//    }
}

// 添加自己的文本类型的item
- (void)addSpecifiedItem:(NSDictionary *)dic andIconURL:(NSString *)iconURL andName:(NSString *)name
{
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
    UUMessage *message = [[UUMessage alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSString *URLStr = iconURL;
    [dataDic setObject:@(UUMessageFromMe) forKey:@"from"];
    [dataDic setObject:[[NSDate date] description] forKey:@"strTime"];
    
    if (name ==nil) {
        name =@"";
    }
    [dataDic setObject:name forKey:@"strName"];
    [dataDic setObject:URLStr forKey:@"strIcon"];
    
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

/* 创建并发送自己的图片类型的item*/
- (void)addSpecifiedImageItem:(NSDictionary *)dic andIconURL:(NSString *)iconURL andName:(NSString *)name {
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
    UUMessage *message = [[UUMessage alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSString *URLStr = iconURL;
    [dataDic setObject:@(UUMessageFromMe) forKey:@"from"];
    [dataDic setObject:[[NSDate date] description] forKey:@"strTime"];
   
    
    if (name ==nil) {
        name =@"";
    }
    [dataDic setObject:name forKey:@"strName"];
    [dataDic setObject:URLStr forKey:@"strIcon"];
    
    
    [message setWithDict:dataDic];
    [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    
    if (message.showDateLabel) {
        previousTime = dataDic[@"strTime"];
    }
    [self.dataSource addObject:messageFrame];

    
}



// 添加聊天item（一个cell内容）
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

// 如下:群聊（groupChat）
static int dateNum = 10;
- (NSDictionary *)getDicWithText:(NSString *)text andName:(NSString *)name andIcon:(NSString *)URLString type:(MessageType)type
{
    
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
        [dictionary setObject:text forKey:@"strContent"];
        
    }
    
    NSDate *date = [[NSDate date]dateByAddingTimeInterval:arc4random()%1000*(dateNum++) ];
    [dictionary setObject:@(UUMessageFromOther) forKey:@"from"];
    [dictionary setObject:@(randomNum) forKey:@"type"];
    [dictionary setObject:[date description] forKey:@"strTime"];
    if (name == nil) {
        name = @"";
    }
    [dictionary setObject:name forKey:@"strName"];
    [dictionary setObject:URLString forKey:@"strIcon"];
    
    
    return dictionary;
}


/* 创建别人发来的图片消息*/
- (NSDictionary *)getDicWithImage:(UIImage *)image andName:(NSString *)name andIcon:(NSString *)URLString type:(MessageType)type andImagePath:(NSString *)imagePath andThumbImagePath:(NSString *)thumbImagePath{
    
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    int randomNum =type;
    
    if (randomNum == UUMessageTypePicture){
        
        NSDate *date = [NSDate date];
        [dictionary setObject:@(UUMessageFromOther) forKey:@"from"];
        [dictionary setObject:@(randomNum) forKey:@"type"];
        [dictionary setObject:[date description] forKey:@"strTime"];
        
        
        if (image==nil) {
            
        }else{
        [dictionary setObject:image forKey:@"picture"];
        }
        if (name == nil) {
            name = @"";
        }
        [dictionary setObject:name forKey:@"strName"];
        
        NSLog(@"%@",URLString);
        [dictionary setObject:URLString forKey:@"strIcon"];
        [dictionary setObject:imagePath forKey:@"imagePath"];
        [dictionary setObject:thumbImagePath forKey:@"thumbImagePath"];
    }
    
    
    
    return dictionary;

    
}


@end
