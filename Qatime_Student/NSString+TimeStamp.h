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
 时间戳转化

 @return
 */
- (NSString *)timeStampToDate;

- (NSString *)dateToTimeStamp:(NSDate *)date;


/**
 时间戳转成dateString

 @return 
 */
- (NSString *)changeTimeStampToDateString;





@end
