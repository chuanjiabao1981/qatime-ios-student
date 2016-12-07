//
//  UserInfoModel.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/5.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _content = @"".mutableCopy;
    }
    return self;
}

@end
