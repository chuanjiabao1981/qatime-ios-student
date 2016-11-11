//
//  Notice.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/11.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "Notice.h"

@implementation Notice

- (instancetype)init
{
    self = [super init];
    if (self) {
        _announcement = @"".mutableCopy;
        _edit_at = @"".mutableCopy;
    }
    return self;
}
@end
