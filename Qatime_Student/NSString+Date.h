//
//  NSString+Date.h
//  Qatime_Student
//
//  Created by Shin on 2017/7/12.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Date)

//将字符串转换为date
+ (NSDate *)stringToDate:(NSString *)strdate;
//将date转换为字符串
+ (NSString *)dateToString:(NSDate *)date;

@end
