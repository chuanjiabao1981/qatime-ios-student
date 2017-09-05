//
//  CourseFile.h
//  Qatime_Student
//
//  Created by Shin on 2017/9/5.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseFile : NSObject

//"id": 23,
//"name": "video.mp4",
//"type": "Resource::VideoFile",
//"file_size": "427320.0",
//"ext_name": "mp4",
//"file_url": "http://qatime-testing.oss-cn-beijing.aliyuncs.com/upload/resource/attach/file/28/video.mp4",
//"created_at": 1504259052


@property (nonatomic, copy) NSString *fileID ;
@property (nonatomic, copy) NSString *name ;
@property (nonatomic, copy) NSString *type ;
@property (nonatomic, copy) NSString *file_size ;
@property (nonatomic, copy) NSString *ext_name ;
@property (nonatomic, copy) NSString *file_url ;
@property (nonatomic, copy) NSString *created_at ;



@end
