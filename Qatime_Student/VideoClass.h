//
//  VideoClass.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Video.h"

@interface VideoClass : NSObject
//{
//"id": 2,
//"name": "超人1号课程",
//"status": "init",
//"video_course_id": 2,
//"real_time": 0,
//"pos": 1,
//"tastable": null,
//    "video": {
//        "id": 7767,
//        "token": "1492157139451",
//        "video_type": "mp4",
//        "duration": 2,
//        "tmp_duration": 2,
//        "format_tmp_duration": "00:00:02",
//        "capture": "http://qatime-testing.oss-cn-beijing.aliyuncs.com/videos/capture/96fcf0349390a9ddccd8871c868d070a.jpg"
//    }
//},

@property (nonatomic, strong) NSString *classID ;
@property (nonatomic, strong) NSString *name ;
@property (nonatomic, strong) NSString *status ;
@property (nonatomic, strong) NSString *video_course_id ;
@property (nonatomic, strong) NSString *real_time;
@property (nonatomic, strong) NSString *pos ;
@property (nonatomic, assign) BOOL tastable ;
@property (nonatomic, strong) Video *video ;
@end
