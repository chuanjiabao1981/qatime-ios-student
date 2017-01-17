//
//  UIViewController+AFHTTP.h
//  Qatime_Student
//
//  Created by Shin on 2017/1/17.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^successHandle)(id _Nullable responds);

@interface UIViewController (AFHTTP)

- (void)GETSessionURL:(NSString * _Nonnull)url withHeaderInfo:(NSString * _Nullable)headinfo andHeaderfield:(NSString *_Nullable)headerField parameters:(nullable id)parameters completeSuccess:(successHandle _Nullable)success;

- (void)POSTSessionURL:(NSString * _Nonnull)url withHeaderInfo:(NSString * _Nullable)headinfo andHeaderfield:(NSString *_Nullable)headerField parameters:(nullable id)parameters completeSuccess:(successHandle)success;
- (void)PUTSessionURL:(NSString * _Nonnull)url withHeaderInfo:(NSString * _Nullable)headinfo andHeaderfield:(NSString *_Nullable)headerField parameters:(nullable id)parameters completeSuccess:(successHandle)success;
- (void)DELETESessionURL:(NSString * _Nonnull)url withHeaderInfo:(NSString * _Nullable)headinfo andHeaderfield:(NSString *_Nullable)headerField parameters:(nullable id)parameters completeSuccess:(successHandle)success;


@end
