//
//  NTESChatroomManager.h
//  NIM
//
//  Created by chris on 16/1/15.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESService.h"
#import <NIMSDK/NIMSDK.h>

@interface NTESMeetingManager : NTESService

@property (nonatomic,assign) BOOL isMute;

- (NIMChatroomMember *)myInfo:(NSString *)roomId;

- (void)cacheMyInfo:(NIMChatroomMember *)info roomId:(NSString *)roomId;

@end
