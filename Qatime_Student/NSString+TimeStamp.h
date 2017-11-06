//
//  NSString+TimeStamp.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/8.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TimeStamp)


/**
 时区时间转换

 @return 时间str
 */
- (NSString *)timeStampToDate;

- (NSString *)dateToTimeStamp:(NSDate *)date;

+ (NSString *)dateToTimeStamp:(NSDate *)date;


/**
 时间戳转成dateString

 @return  时间str
 */
- (NSString *)changeTimeStampToDateString;

+ (NSString *)changeTimeStampToDateString:(NSString*)timeStamp;


/** 获取当前时间戳 */
-(NSString*)getCurrentTimestamp;

/** 获取当前时间 */
+ (NSString *)getCurrentTime ;

+ (NSString *)getCurrentTimeStamp ;


@end
