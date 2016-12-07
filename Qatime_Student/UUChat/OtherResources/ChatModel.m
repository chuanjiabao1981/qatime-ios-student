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

// 添加自己的item
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
- (NSDictionary *)getDicWithText:(NSString *)text andName:(NSString *)name andIcon:(NSString *)URLString
{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    int randomNum = UUMessageTypeText;
        /* 消息类型是文字 */
        randomNum = UUMessageTypeText;
        [dictionary setObject:text forKey:@"strContent"];
    
    if (text == nil) {
        
    }
    
    
    NSDate *date = [[NSDate date]dateByAddingTimeInterval:arc4random()%1000*(dateNum++) ];
    [dictionary setObject:@(UUMessageFromOther) forKey:@"from"];
    [dictionary setObject:@(randomNum) forKey:@"type"];
    [dictionary setObject:[date description] forKey:@"strTime"];
    if (name == nil) {
        name = @"";
    }
    [dictionary setObject:name forKey:@"strName"];
    
    NSLog(@"%@",URLString);
    [dictionary setObject:URLString forKey:@"strIcon"];
    

    
    return dictionary;
}

//- (NSString *)getRandomString {
//    
//    NSString *lorumIpsum = @"";
//    
//    NSArray *lorumIpsumArray = [lorumIpsum componentsSeparatedByString:@" "];
//    
//    int r = arc4random() % [lorumIpsumArray count];
//    r = MAX(6, r); // no less than 6 words
//    NSArray *lorumIpsumRandom = [lorumIpsumArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, r)]];
//    
//    return [NSString stringWithFormat:@"%@!!", [lorumIpsumRandom componentsJoinedByString:@" "]];
//}

//- (NSString *)getImageStr:(NSInteger)index{
//    NSArray *array = @[];
//    return array[index];
//}
//
//- (NSString *)getName:(NSInteger)index{
//    NSArray *array = @[];
//    return array[index];
//}
@end
