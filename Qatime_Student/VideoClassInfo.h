//
//  VideoClassInfo.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/11.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoClassInfo : NSObject




//"id": 25,
//"name": "初中数学",
//"subject": "数学",
//"grade": "初一",
//"teacher_name": "马燕兆",
//"price": 0,
//"chat_team_id": "7962752",
//"buy_tickets_count": 0,
//"status": "preview",
//"description": "      大家好，很高兴能和大家通过网络直播互动探讨初中数学知识，希望我们能沟通的开心！",
//"lesson_count": 0,
//"preset_lesson_count": 2,
//"completed_lesson_count": 0,
//"live_start_time": "2016-09-25 10:00",
//"live_end_time": "2016-09-25 22:00",
//"publicize": "http://qatime-testing.oss-cn-beijing.aliyuncs.com/courses/publicize/app_info_2d71a0cb8c07f529009ce51bb8cd3dbf.jpg",
//"pull_address": "rtmp://va0a19f55.live.126.net/live/2794c854398f4d05934157e05e2fe419",
//"board_pull_stream": "rtmp://va0a19f55.live.126.net/live/2794c854398f4d05934157e05e2fe419",
//"camera_pull_stream": null,
//"preview_time": "2016-09-25 10:00",

/* model所包含的内容 及项目*/
@property(nonatomic,strong) NSString *classID ;
@property(nonatomic,strong) NSString *name ;
@property(nonatomic,strong) NSString *subject ;
@property(nonatomic,strong) NSString *grade ;
@property(nonatomic,strong) NSString *teacher_name ;
@property(nonatomic,strong) NSString *price ;
@property(nonatomic,strong) NSString *chat_team_id ;
@property(nonatomic,strong) NSString *buy_tickets_count ;
@property(nonatomic,strong) NSString *status ;
@property(nonatomic,strong) NSString *classDescription ;
@property(nonatomic,strong) NSString *lesson_count ;
@property(nonatomic,strong) NSString *preset_lesson_count ;
@property(nonatomic,strong) NSString *completed_lesson_count ;
@property(nonatomic,strong) NSString * live_start_time ;
@property(nonatomic,strong) NSString * live_end_time ;
@property(nonatomic,strong) NSString * publicize ;
@property(nonatomic,strong) NSString * pull_address ;
@property(nonatomic,strong) NSString * board_pull_stream ;
@property(nonatomic,strong) NSString * camera_pull_stream ;
@property(nonatomic,strong) NSString * preview_time ;




@end
