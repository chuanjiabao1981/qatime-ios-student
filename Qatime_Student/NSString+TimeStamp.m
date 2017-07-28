//
//  NSString+TimeStamp.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/8.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "NSString+TimeStamp.h"

@implementation NSString (TimeStamp)

- (NSString *)timeStampToDate{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSzz"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:self];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString =[dateFormatter stringFromDate:dateFormatted];

    return dateString;
    
}


- (NSString *)changeTimeStampToDateString{
   
    NSTimeInterval time=[self doubleValue];//因为时差问题要加8小时 == 28800 sec
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    NSLog(@"date:%@",[detaildate description]);
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //这句话比较吊
     [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

//获取当前时间的时间戳
-(NSString*)getCurrentTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}




@end
