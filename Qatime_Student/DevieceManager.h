//
//  DevieceManager.h
//  Qatime_Student
//
//  Created by Shin on 2017/6/27.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>

@interface DevieceManager : NSObject

+ (DevieceManager *)defaultManager;

-(NSString *)devieceInfo;

@end
