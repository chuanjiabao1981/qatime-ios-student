//
//  ChatModel.h
//  UUChatTableView
//
//  Created by shake on 15/1/6.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UUMessage.h"

@interface ChatModel : NSObject

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic) BOOL isGroupChat;

- (void)populateRandomDataSource;

- (void)addRandomItemsToDataSource:(NSInteger)number;

#pragma mark- 文本消息
/* 组成自己发的文本消息*/
- (void)addSpecifiedItem:(NSDictionary *)dic andIconURL:(NSString *)iconURL andName:(NSString *)name;
/* 组成别人发的文本消息 */
- (NSDictionary *)getDicWithText:(NSString *)text andName:(NSString *)name andIcon:(NSString *)URLString type:(MessageType)type andTime:(NSString *)time ;

#pragma mark- 图片消息
/* 组成自己发送的图片消息*/
- (void)addSpecifiedImageItem:(NSDictionary *)dic andIconURL:(NSString *)iconURL andName:(NSString *)name ;

/* 组成别人发送的图片消息*/
- (NSDictionary *)getDicWithImage:(UIImage *)image andName:(NSString *)name andIcon:(NSString *)URLString type:(MessageType)type andImagePath:(NSString *)imagePath andThumbImagePath:(NSString *)thumbImagePath andTime:(NSString *)time;


//别人发的消息
- (NSArray *)additems:(NSInteger)number withDictionary:(NSDictionary *)dictionary;


/* 自己发的语音消息*/
- (void)addSpecifiedVoiceItem:(NSDictionary *)dic andIconURL:(NSString *)iconURL andName:(NSString *)name;


@end
