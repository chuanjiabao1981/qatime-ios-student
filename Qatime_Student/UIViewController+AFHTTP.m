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

-(void)GETSessionURL:(NSString *)url withHeaderInfo:(NSString *)headinfo andHeaderfield:(NSString *)headerField parameters:(id)parameters completeSuccess:(successHandle)success failure:(faildHandel)faild{
    
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
        
        faild(error);
        
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

-(void)POSTSessionURL:(NSString *)url withHeaderInfo:(NSString *)headinfo andHeaderfield:(NSString *)headerField parameters:(id)parameters completeSuccess:(successHandle)success failure:(faildHandel)faild{
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
        faild(error);
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

-(void)PUTSessionURL:(NSString *)url withHeaderInfo:(NSString *)headinfo andHeaderfield:(NSString *)headerField parameters:(id)parameters completeSuccess:(successHandle)success failure:(faildHandel)faild{
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
        faild(error);
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

-(void)DELETESessionURL:(NSString *)url withHeaderInfo:(NSString *)headinfo andHeaderfield:(NSString *)headerField parameters:(id)parameters completeSuccess:(successHandle)success failure:(faildHandel)faild{
    
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
        faild(error);
    }];
}


- (void)GETSessionURL:(NSString * _Nonnull)url withHeaderInfo:(NSString * _Nullable)headinfo andHeaderfield:(NSString *_Nullable)headerField parameters:(nullable id)parameters withDownloadProgress:(progressHandle _Nullable)progress  completeSuccess:(successHandle _Nullable)success failure:(faildHandel _Nullable)faild{
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    if (headinfo!=nil&&headerField!=nil) {
        [manager.requestSerializer setValue:headinfo forHTTPHeaderField:headerField];
    }else{
        
    }
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        faild(error);
    }];
    
}
- (void)POSTSessionURL:(NSString * _Nonnull)url withHeaderInfo:(NSString * _Nullable)headinfo andHeaderfield:(NSString *_Nullable)headerField parameters:(nullable id)parameters  withUploadProgress:(progressHandle _Nullable)progress completeSuccess:(successHandle _Nullable )success failure:(faildHandel _Nullable)faild{
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    if (headinfo!=nil&&headerField!=nil) {
        [manager.requestSerializer setValue:headinfo forHTTPHeaderField:headerField];
    }else{
        
    }
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        faild(error);
    }];
}


@end
