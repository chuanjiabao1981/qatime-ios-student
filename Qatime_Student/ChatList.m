//
//  ChatList.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/20.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ChatList.h"

@implementation ChatList

-(instancetype)init{
    self = [super init];
    if (self) {
        _name = @"".mutableCopy;
        
        _tutorium = [[TutoriumListInfo alloc]init];
        
        
    }
    return self;
    
}


@end
