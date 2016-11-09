//
//  RecommandTeacher.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/8.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "RecommandTeacher.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface RecommandTeacher ()<NSCoding>

@end

@implementation RecommandTeacher

- (void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned  int  count;
    Ivar * vars =   class_copyIvarList([self class], &count);
    for (int i = 0 ; i < count; i ++) {
        Ivar var = vars[i];
        char * s  =  (char*)ivar_getName(var);
        NSString * key =[NSString stringWithUTF8String:s];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
    free(vars);
    
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    unsigned int count = 0;
    Ivar * vars = class_copyIvarList([self class], &count);
    for (int i = 0 ; i < count;  i ++) {
        Ivar var = vars [i];
        const char * name = ivar_getName(var);
        NSString * key = [NSString stringWithUTF8String:name];
        id object = [aDecoder decodeObjectForKey:key];
        [self setValue:object forKey:key];
    }
    free(vars);
    return self;
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _teacherName = [NSString string];
        _teacherID = [NSString string];
        _avatar_url = [NSString string];
        _gender = @"".mutableCopy;
        
        _subject = @"".mutableCopy;
        _school =@"".mutableCopy;
        _teaching_years = @"".mutableCopy;
        _describe = @"".mutableCopy;
        
    }
    return self;
}



@end
