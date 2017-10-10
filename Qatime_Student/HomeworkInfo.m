//
//  HomeworkInfo.m
//  Qatime_Student
//
//  Created by Shin on 2017/9/12.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "HomeworkInfo.h"
@implementation HomeworkInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        _homeworkPhotos = @[].mutableCopy;
        _myAnswerPhotos = @[].mutableCopy;
        _correctionPhotos = @[].mutableCopy;
    }
    return self;
}

@end
