//
//  UIViewController+AFHTTP.h
//  Qatime_Student
//
//  Created by Shin on 2017/1/17.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^successHandle)(id _Nullable responds);

typedef void(^faildHandel)(id _Nullable erros);

typedef void(^progressHandle)(NSProgress *_Nullable progress);

@interface UIViewController (AFHTTP)

//- (void)GETSessionURL:(NSString * _Nonnull)url withHeaderInfo:(NSString * _Nullable)headinfo andHeaderfield:(NSString *_Nullable)headerField parameters:(nullable id)parameters completeSuccess:(successHandle _Nullable)success;
//- (void)POSTSessionURL:(NSString * _Nonnull)url withHeaderInfo:(NSString * _Nullable)headinfo andHeaderfield:(NSString *_Nullable)headerField parameters:(nullable id)parameters completeSuccess:(successHandle _Nullable )success;
//- (void)PUTSessionURL:(NSString * _Nonnull)url withHeaderInfo:(NSString * _Nullable)headinfo andHeaderfield:(NSString *_Nullable)headerField parameters:(nullable id)parameters completeSuccess:(successHandle _Nullable )success;
//- (void)DELETESessionURL:(NSString * _Nonnull)url withHeaderInfo:(NSString * _Nullable)headinfo andHeaderfield:(NSString *_Nullable)headerField parameters:(nullable id)parameters completeSuccess:(successHandle _Nullable )success;


- (void)GETSessionURL:(NSString * _Nonnull)url withHeaderInfo:(NSString * _Nullable)headinfo andHeaderfield:(NSString *_Nullable)headerField parameters:(nullable id)parameters completeSuccess:(successHandle _Nullable)success failure:(faildHandel _Nullable)faild DEPRECATED_ATTRIBUTE;
- (void)POSTSessionURL:(NSString * _Nonnull)url withHeaderInfo:(NSString * _Nullable)headinfo andHeaderfield:(NSString *_Nullable)headerField parameters:(nullable id)parameters completeSuccess:(successHandle _Nullable )success failure:(faildHandel _Nullable)faild DEPRECATED_ATTRIBUTE;
- (void)PUTSessionURL:(NSString * _Nonnull)url withHeaderInfo:(NSString * _Nullable)headinfo andHeaderfield:(NSString *_Nullable)headerField parameters:(nullable id)parameters completeSuccess:(successHandle _Nullable )success failure:(faildHandel _Nullable)faild;
- (void)DELETESessionURL:(NSString * _Nonnull)url withHeaderInfo:(NSString * _Nullable)headinfo andHeaderfield:(NSString *_Nullable)headerField parameters:(nullable id)parameters completeSuccess:(successHandle _Nullable )success failure:(faildHandel _Nullable)faild;

- (void)GETSessionURL:(NSString * _Nonnull)url withHeaderInfo:(NSString * _Nullable)headinfo andHeaderfield:(NSString *_Nullable)headerField parameters:(nullable id)parameters withProgress:(progressHandle _Nullable)progress completeSuccess:(successHandle _Nullable)success failure:(faildHandel _Nullable)faild;
- (void)POSTSessionURL:(NSString * _Nonnull)url withHeaderInfo:(NSString * _Nullable)headinfo andHeaderfield:(NSString *_Nullable)headerField parameters:(nullable id)parameters withProgress:(progressHandle _Nullable)progress completeSuccess:(successHandle _Nullable )success failure:(faildHandel _Nullable)faild;



@end
