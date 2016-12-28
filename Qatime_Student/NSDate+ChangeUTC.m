//
//  NSDate+ChangeUTC.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/28.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "NSDate+ChangeUTC.h"

@implementation NSDate (ChangeUTC)


- (NSString *)changeUTC{
    
   // 获得时间对象
    
//    NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得系统的时区
    
//    NSTimeInterval time = [zone secondsFromGMTForDate:self];// 以秒为单位返回当前时间与系统格林尼治时间的差
    
//    NSDate *dateNow = [self dateByAddingTimeInterval:time];// 然后把差的时间加上,就是当前系统准确的时间
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString =[dateFormatter stringFromDate:self];
    return dateString;

}

@end
