//
//  UIViewController+AFHTTP.m
//  Qatime_Student
//
//  Created by Shin on 2017/1/17.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "UIViewController+AFHTTP.h"
#import "AFNetworking.h"

@implementation UIViewController (AFHTTP)

- (void)GETSessionURL:(NSString * _Nonnull)url withHeaderInfo:(NSString * _Nullable)headinfo andHeaderfield:(NSString *_Nullable)headerField parameters:(nullable id)parameters completeSuccess:(successHandle _Nullable)success{
    
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    if (headinfo!=nil&&headerField!=nil) {
        [manager.requestSerializer setValue:headinfo forHTTPHeaderField:headerField];
    }else{
        
    }
    
   [manager GET:url parameters:parameters==nil?nil:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
       success(responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}

- (void)POSTSessionURL:(NSString * _Nonnull)url withHeaderInfo:(NSString * _Nullable)headinfo andHeaderfield:(NSString *_Nullable)headerField parameters:(nullable id)parameters completeSuccess:(successHandle)success{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    if (headinfo!=nil&&headerField!=nil) {
        [manager.requestSerializer setValue:headinfo forHTTPHeaderField:headerField];
    }else{
        
    }

    [manager POST:url parameters:parameters==nil?nil:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    
}
- (void)PUTSessionURL:(NSString * _Nonnull)url withHeaderInfo:(NSString * _Nullable)headinfo andHeaderfield:(NSString *_Nullable)headerField parameters:(nullable id)parameters completeSuccess:(successHandle)success{
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    if (headinfo!=nil&&headerField!=nil) {
        [manager.requestSerializer setValue:headinfo forHTTPHeaderField:headerField];
    }else{
        
    }
    [manager PUT:url parameters:parameters==nil?nil:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}
- (void)DELETESessionURL:(NSString * _Nonnull)url withHeaderInfo:(NSString * _Nullable)headinfo andHeaderfield:(NSString *_Nullable)headerField parameters:(nullable id)parameters completeSuccess:(successHandle)success{
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    if (headinfo!=nil&&headerField!=nil) {
        [manager.requestSerializer setValue:headinfo forHTTPHeaderField:headerField];
    }else{
        
    }
    [manager DELETE:url parameters:parameters==nil?nil:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}

@end
