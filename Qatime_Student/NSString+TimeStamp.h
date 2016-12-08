//
//  NSString+TimeStamp.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/8.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TimeStamp)

- (NSString *)timeStampToDate;

- (NSString *)dateToTimeStamp:(NSDate *)date;


@end
