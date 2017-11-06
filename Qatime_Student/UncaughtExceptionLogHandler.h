//
//  UncaughtExceptionLogHandler.h
//  Qatime_Student
//
//  Created by Shin on 2017/11/2.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UncaughtExceptionLogHandler : NSObject

+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler *)getHandler;
+ (void)TakeException:(NSException *) exception;

@end
