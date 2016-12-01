//
//  NSString+StatusSwitch.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/28.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "NSString+StatusSwitch.h"

@implementation NSString (StatusSwitch)


//missed, /*已错过*/
//init, /*初始化*/
//ready, /*等待上课*/
//teaching,  /*上课中*/
//paused, /*暂停中 意外中断可以继续直播*/
//closed, /*直播结束 可以继续直播*/
//finished, /*已完成 不可继续直播*/
//billing, /*结算中*/
//completed, /*已结算*/
+ (NSString *)statusSwitchWithStatus:(NSString *)status{
    
    if ([status isEqualToString:@"missed"]) {
        
        status =  @"待补课";
        
    }else if([status isEqualToString:@"init"]){
        status = @"未开始";
        
    }else if([status isEqualToString:@"ready"]){
        status = @"待上课";
        
    }else if([status isEqualToString:@"teaching"]){
        status = @"直播中";
        
    }else if([status isEqualToString:@"paused"]){
        status = @"直播中";
    }else if([status isEqualToString:@"closed"]){
        status = @"已直播";
    }else if([status isEqualToString:@"finished"]){
        status = @"已结束";
    }else if([status isEqualToString:@"billing"]){
        status = @"已结束";
    }else if([status isEqualToString:@"completed"]){
        status = @"已结束";
    }



    return status;

    
    
    
}


@end
