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
    
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:self];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:self];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:self];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    
//    NSLog(@"%@",[dateFormatter dateFromString:dateStr]);
    
    return [dateFormatter stringFromDate:destinationDateNow];

}

@end
