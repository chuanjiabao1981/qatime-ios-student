//
//  MyTutoriumModel.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTutoriumModel : NSObject

//
//"id": 61,
//"name": "再来一个辅导班",
//"subject": "化学",
//"grade": "高二",
//"teacher_name": "王志成",
//"price": 10,
//"chat_team_id": "12355338",
//"buy_tickets_count": 0,
//"status": "published",
//"preset_lesson_count": 1,
//"completed_lesson_count": 0,
//"live_start_time": "2016-11-22 09:00",
//"live_end_time": "2016-11-22 10:00",
//"publicize": "http://qatime-testing.oss-cn-beijing.aliyuncs.com/courses/publicize/list_b876ab65a61aaa1ae47597ef144b9f45.png",
//"pull_address": "rtmp://va0a19f55.live.126.net/live/2794c854398f4d05934157e05e2fe419",
//"board_pull_stream": "rtmp://va0a19f55.live.126.net/live/2794c854398f4d05934157e05e2fe419",
//"camera_pull_stream": "rtmp://va0a19f55.live.126.net/live/0ca7943afaa340c9a7c1a8baa5afac97",
//"preview_time": "2016-11-22 09:00",
//"is_tasting": true,
//"is_bought": false

/* model所包含的内容 及项目*/

@property(nonatomic,strong) NSString *classID ;
@property(nonatomic,strong) NSString *name ;
@property(nonatomic,strong) NSString *subject ;
@property(nonatomic,strong) NSString *grade ;
@property(nonatomic,strong) NSString *teacher_name ;
@property(nonatomic,strong) NSString *price ;
@property(nonatomic,strong) NSString *chat_team_id ;
@property(nonatomic,strong) NSString * buy_tickets_count ;
@property(nonatomic,strong) NSString *status ;
@property(nonatomic,strong) NSString * preset_lesson_count ;
@property(nonatomic,strong) NSString * completed_lesson_count ;
@property(nonatomic,strong) NSString * live_start_time ;
@property(nonatomic,strong) NSString * live_end_time ;
@property(nonatomic,strong) NSString * publicize ;
@property(nonatomic,strong) NSString * pull_address ;
@property(nonatomic,strong) NSString * board_pull_stream ;
@property(nonatomic,strong) NSString * camera_pull_stream ;
@property(nonatomic,strong) NSString * preview_time ;
@property(nonatomic,assign) BOOL is_tasting ;
@property(nonatomic,assign) BOOL is_bought ;

@property(nonatomic,strong) NSString *taste_count ;

@end
