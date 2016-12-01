//
//  FileService.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/30.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileService : NSObject

/* 单个文件大小*/
+(float)fileSizeAtPath:(NSString *)path;

/* cache目录大小*/
+(float)folderSizeAtPath:(NSString *)path;
/* 清理cache目录*/
+(void)clearCache:(NSString *)path;

/* 获取cache目录*/
+(NSString *)getPath;

@end
