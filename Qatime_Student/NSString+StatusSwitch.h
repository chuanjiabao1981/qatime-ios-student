//
//  NSString+StatusSwitch.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/28.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    missed, /*已错过*/
    init, /*初始化*/
    ready, /*等待上课*/
    teaching,  /*上课中*/
    paused, /*暂停中 意外中断可以继续直播*/
    closed, /*直播结束 可以继续直播*/
    finished, /*已完成 不可继续直播*/
    billing, /*结算中*/
    completed, /*已结算*/
} status;



@interface NSString (StatusSwitch)

+ (NSString *)statusSwitchWithStatus:(NSString *)status;



@end
