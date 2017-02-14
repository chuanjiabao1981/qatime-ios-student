//
//  RecommandClasses.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/9.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "RecommandClasses.h"

@implementation RecommandClasses
- (instancetype)init
{
    self = [super init];
    if (self) {
    
        _classID = @"".mutableCopy;
        _name = @"".mutableCopy;
        _subject = @"".mutableCopy;
        _grade = @"".mutableCopy;
        _teacher_name = @"".mutableCopy;
        _price = @"".mutableCopy;
        _chat_team_id = @"".mutableCopy;
        _buy_tickets_count = @"".mutableCopy;
        _preset_lesson_count = @"".mutableCopy;
        _completed_lesson_count = @"".mutableCopy;
        _live_start_time = @"".mutableCopy;
        _live_end_time = @"".mutableCopy;
        _publicize = @"".mutableCopy;
        
        _attributedDescribe = [[NSAttributedString alloc]init];
        

        

        
        
    }
    return self;
}

@end
