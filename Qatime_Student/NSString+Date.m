//
//  NSString+Date.m
//  Qatime_Student
//
//  Created by Shin on 2017/7/12.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)
//将字符串转换为date
+ (NSDate *)stringToDate:(NSString *)strdate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    NSDate *retdate = [dateFormatter dateFromString:strdate];
    
    return retdate;
}

//将date转换为字符串
+ (NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

@end
