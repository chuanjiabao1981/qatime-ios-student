//
//  TutoriumList.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/2.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "TutoriumList.h"
#import "YYModel.h"

@implementation TutoriumList

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



- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        
        
//        /* 取出token*/
//        NSString *remember_token=[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"];
//        NSLog(@"%@",remember_token);
//        
//        /* 发请求获取课程列表*/
//        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
//        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
//        
//        [manager.requestSerializer setValue:remember_token forHTTPHeaderField:@"Remember-Token"];
//        
//        
//        [manager GET:@"http://testing.qatime.cn/api/v1/live_studio/courses" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            
//            NSDictionary *modelDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//            
//            NSLog(@"%@",modelDic);
//            
//            /* 使用YYModel解析创建model  get回来的数据是个数组内涵字典 引入tag值来确定数组下标*/
//            [self yy_modelSetWithDictionary:modelDic];
//            NSLog(@"status:%@,data:%@",_status,_data);
//            
//            /* 发送消息*/
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"DataLoaded" object:_data];
//            
//            
//            /* 使用YYModel再写turoiumListInfo的model*/
//            
//            
//            
//            
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            
//        }];
        
      
        
        
    }
    return self;
}

@end

/* TutoriumListInfo 的类实现*/

@interface TutoriumListInfo ()



@end
@implementation TutoriumListInfo
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
        
        _classID = @"".mutableCopy;
        
        
    }
    return self;
}




@end



