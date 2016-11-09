//
//  ClassesInfo_Time.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/9.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ClassesInfo_Time.h"

@implementation ClassesInfo_Time
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _classID = @"".mutableCopy;
        _name = @"".mutableCopy;
        _status = @"".mutableCopy;
        _class_date = @"".mutableCopy;
        _live_time = @"".mutableCopy;
        
        
        
    }
    return self;
}

@end
