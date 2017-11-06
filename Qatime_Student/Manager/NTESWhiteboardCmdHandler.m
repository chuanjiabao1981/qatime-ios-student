//
//  NTESWhiteboardCmdHandler.m
//  NIMEducationDemo
//
//  Created by fenric on 16/10/31.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESWhiteboardCmdHandler.h"
#import "NTESTimerHolder.h"
#import "NTESMeetingRTSManager.h"
#import "NTESWhiteboardCommand.h"

#define NTESSendCmdIntervalSeconds 0.06
#define NTESSendCmdMaxSize 30000


@interface NTESWhiteboardCmdHandler()<NTESTimerHolderDelegate>

@property (nonatomic, strong) NTESTimerHolder *sendCmdsTimer;

@property (nonatomic, strong) NSMutableString *cmdsSendBuffer;

@property (nonatomic, assign) UInt64 refPacketID;

@property (nonatomic, weak) id<NTESWhiteboardCmdHandlerDelegate> delegate;

@property (nonatomic, strong) NSMutableDictionary *syncPoints;
@end

@implementation NTESWhiteboardCmdHandler

- (instancetype)initWithDelegate:(id<NTESWhiteboardCmdHandlerDelegate>)delegate
{
    if (self = [super init]) {
        _delegate = delegate;
        _sendCmdsTimer = [[NTESTimerHolder alloc] init];
        _cmdsSendBuffer = [[NSMutableString alloc] init];
        _syncPoints = [[NSMutableDictionary alloc] init];
        [_sendCmdsTimer startTimer:NTESSendCmdIntervalSeconds delegate:self repeats:YES];
    }
    return self;
}


- (void)sendMyPoint:(NTESWhiteboardPoint *)point
{
    NSString *cmd = [NTESWhiteboardCommand pointCommand:point];
    
    [_cmdsSendBuffer appendString:cmd];
    
    if (_cmdsSendBuffer.length < NTESSendCmdMaxSize) {
        [self doSendCmds];
    }
}

- (void)sendPureCmd:(NTESWhiteBoardCmdType)type to:(NSString *)uid
{
    NSString *cmd = [NTESWhiteboardCommand pureCommand:type];
    if (uid == nil) {
        [_cmdsSendBuffer appendString:cmd];
        [self doSendCmds];
    }
    else {
        NSLog(@"%@",cmd);
        [[NTESMeetingRTSManager sharedInstance] sendRTSData:[cmd dataUsingEncoding:NSUTF8StringEncoding]
                                                     toUser:uid];
    }
}

//这是专门给白板发送收到屏幕共享开启关闭的方法
- (void)sendRecieved:(NSString *)cmdString{
    
    [_cmdsSendBuffer appendString:cmdString];
    
    if (_cmdsSendBuffer.length < NTESSendCmdMaxSize) {
        [self doSendCmds];
    }

}



- (void)sync:(NSDictionary *)allLines toUser:(NSString *)targetUid
{
    for (NSString *uid in allLines.allKeys) {
        
        NSMutableString *pointsCmd = [[NSMutableString alloc] init];
        
        NSArray *lines = [allLines objectForKey:uid];
        for (NSArray *line in lines) {
            
            for (NTESWhiteboardPoint *point in line) {
                [pointsCmd appendString:[NTESWhiteboardCommand pointCommand:point]];
            }
            
            int end = [line isEqual:lines.lastObject] ? 1 : 0;

            if (pointsCmd.length > NTESSendCmdMaxSize || end) {
                
                NSString *syncHeadCmd = [NTESWhiteboardCommand syncCommand:uid end:end];
                
                NSString *syncCmds = [syncHeadCmd stringByAppendingString:pointsCmd];
                
                NSLog(@"%@",syncCmds);
                [[NTESMeetingRTSManager sharedInstance] sendRTSData:[syncCmds dataUsingEncoding:NSUTF8StringEncoding]
                                                             toUser:targetUid];
                
                [pointsCmd setString:@""];
            }
        }
    }
}


- (void)onNTESTimerFired:(NTESTimerHolder *)holder
{
    [self doSendCmds];
}

- (void)doSendCmds{
    
    if (_cmdsSendBuffer.length) {
        NSString *cmd =  [NTESWhiteboardCommand packetIdCommand:_refPacketID++];
        [_cmdsSendBuffer appendString:cmd];
        
        NSLog(@"%@",_cmdsSendBuffer);
        [[NTESMeetingRTSManager defaultManager] sendRTSData:[_cmdsSendBuffer dataUsingEncoding:NSUTF8StringEncoding] toUser:nil];
        [_cmdsSendBuffer setString:@""];
    }
}

- (void)handleReceivedData:(NSData *)data sender:(NSString *)sender
{
    NSString *cmdsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSArray *cmdsArray = [cmdsString componentsSeparatedByString:@";"];
    
    for (NSString *cmdString in cmdsArray) {

        if (cmdString.length == 0) {
            continue;
        }
        
        NSArray *cmd = [cmdString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":,"]];

        NSInteger type = [cmd[0] integerValue];
        switch (type) {
            case NTESWhiteBoardCmdTypePointStart:
            case NTESWhiteBoardCmdTypePointMove:
            case NTESWhiteBoardCmdTypePointEnd:
            {
                if (cmd.count == 4) {
                    NTESWhiteboardPoint *point = [[NTESWhiteboardPoint alloc] init];
                    point.type = type;
                    point.xScale = [cmd[1] floatValue];
                    point.yScale = [cmd[2] floatValue];
                    point.colorRGB = [cmd[3] intValue];
                    if (_delegate) {
                        [_delegate onReceivePoint:point from:sender];
                    }
                }
                else {
//                    DDLogError(@"Invalid point cmd: %@", cmdString);
                }
                break;
            }
            case NTESWhiteBoardCmdTypeCancelLine:
            case NTESWhiteBoardCmdTypeClearLines:
            case NTESWhiteBoardCmdTypeClearLinesAck:
            case NTESWhiteBoardCmdTypeSyncPrepare:
            {
                if (_delegate) {
                    [_delegate onReceiveCmd:type from:sender];
                }
                break;
            }
            case NTESWhiteBoardCmdTypeSyncRequest:
            {
                if (_delegate) {
                    [_delegate onReceiveSyncRequestFrom:sender];
                }
                break;
            }
            case NTESWhiteBoardCmdTypeSync:
            {
                NSString *linesOwner = cmd[1];
                int end = [cmd[2] intValue];
                [self handleSync:cmdsArray linesOwner:linesOwner end:end sender:sender];
                return;
            }
            case NTESWhiteBoardCmdTypeLaserPenMove:
            {
                NTESWhiteboardPoint *point = [[NTESWhiteboardPoint alloc] init];
                point.type = type;
                point.xScale = [cmd[1] floatValue];
                point.yScale = [cmd[2] floatValue];
                point.colorRGB = [cmd[3] intValue];
                if (_delegate) {
                    [_delegate onReceiveLaserPoint:point from:sender];
                }
                break;
            }
            case NTESWhiteBoardCmdTypeLaserPenEnd:
            {
                if (_delegate) {
                    [_delegate onReceiveHiddenLaserfrom:sender];
                }
                break;
            }
            case NTESWhiteBoardCmdTypeDocShare:
            {
//                [self handleReceivedDocShareData:cmd sender:sender];
                break;
            }
            
            case NTESDesktopShared:{
                
            }
                
            case NTESDesktopSharedReply:{
               
                /**
                 问题来了.
                 收到屏幕共享之后,一定要给白板返回一个"我收到你的通知了"的回复.
                 不然白板会一直给你发这条消息,知道他收到了你回复的消息.
                 */
                
                //收到屏幕共享通知
                /** 
                 
                 收到的消息类似于这样的格式
                 16:1499319367402,0,InteractiveSwitch,board
                 类型:发来的时间戳,parent时间戳(用于返回数据),消息类型(InteractiveSwitch,切换全屏),"白板/屏幕 board/desktop"
                 用法:
                    * 只使用最后一个字段来判断当前屏幕是白板还是桌面
                    * 回复数据的时候,给白板回复的数据类型里,parentID使用收到的时间戳
                 */
                
                
                /**
                 2017-08-30  不再使用白板通讯进行切换 暂时保留接口 
                 */
                
                NSLog(@"%@",cmdString);
//
                if ([cmdString containsString:@"board"]) {
                    //当前是白板在直播,切换到白板,白板可用
                    //此时白板开启,恢复正常模式
                    NSLog(@"收到开启白板命令");
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"DesktopSharedOff" object:nil];
                    
                }else if([cmdString containsString:@"desktop"]){
                    //当前是屏幕共享,切换到屏幕共享,白板不可用(自动切换全屏?看需求)
                    //此时关闭白板,自动全屏模式
                    NSLog(@"收到屏幕共享命令");
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"DesktopSharedOn" object:nil];
                }
                
                //再给白板发送"我收到你开启屏幕共享了,或者我收到你关闭屏幕共享回到白板了"的消息
                //要是不回复,桌面端就一直给你发 发 发 ,一直变 变 变.
                
                //把收到的cmdstring的时间戳取出来
                NSString *timeStamp = [cmdString substringWithRange:NSMakeRange(3, 13)];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"RecivedDestopShared" object:timeStamp];
            }

            default:
                break;
        }
    }

}

- (void)handleSync:(NSArray *)cmdsArray linesOwner:(NSString *)linesOwner end:(int)end sender:(NSString*)sender
{
    NSMutableArray *points = [[NSMutableArray alloc] init];
    
    for (int i = 1; i < cmdsArray.count; i ++) {
        NSString *cmdString = cmdsArray[i];
        
        if (cmdString.length == 0) {
            continue;
        }

        NSArray *cmd = [cmdString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":,"]];
        NSInteger type = [cmd[0] integerValue];
        switch (type) {
            case NTESWhiteBoardCmdTypePointStart:
            case NTESWhiteBoardCmdTypePointMove:
            case NTESWhiteBoardCmdTypePointEnd:
            {
                if (cmd.count == 4) {
                    NTESWhiteboardPoint *point = [[NTESWhiteboardPoint alloc] init];
                    point.type = [cmd[0] integerValue];
                    point.xScale = [cmd[1] floatValue];
                    point.yScale = [cmd[2] floatValue];
                    point.colorRGB = [cmd[3] intValue];
                    [points addObject:point];
                }
                else {
//                    DDLogError(@"Invalid point cmd in sync: %@", cmdString);
                }
                break;
            }
            case NTESWhiteBoardCmdTypePacketID:
                break;
                
            case NTESWhiteBoardCmdTypeDocShare:
            {

                break;
            }

            default:

                break;
        }
    }
    
    NSMutableArray *allPoints = [_syncPoints objectForKey:linesOwner];
    
    if (!allPoints) {
        allPoints = [[NSMutableArray alloc] init];
    }

    [allPoints addObjectsFromArray:points];
    
    if (end) {
        if (_delegate) {
            [_delegate onReceiveSyncPoints:allPoints owner:linesOwner];
        }
        
        [_syncPoints removeObjectForKey:linesOwner];
    }
    else {
        [_syncPoints setObject:allPoints forKey:linesOwner];
    }
}



@end
