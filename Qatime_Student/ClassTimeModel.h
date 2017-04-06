//
//  ClassTimeModel.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/28.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ClassTimeModel : NSObject


//"id": 163,
//"name": "第三节课",
//"status": "finished",
//"class_date": "2016-11-11",
//"live_time": "10:00-11:00",
//"course_name": "超级英语辅导",
//"course_publicize": "http://qatime-testing.oss-cn-beijing.aliyuncs.com/courses/publicize/list_1c30c5ae7b3051a8f08e612dedcb707f.jpg",
//"subject": "英语",
//"grade": "高一",
//"pull_address": "",
//"board_pull_stream": "rtmp://va0a19f55.live.126.net/live/2794c854398f4d05934157e05e2fe419",
//"camera_pull_stream": "rtmp://va0a19f55.live.126.net/live/0ca7943afaa340c9a7c1a8baa5afac97",
//"chat_team_id": "10872527",
//"board": "rtmp://va0a19f55.live.126.net/live/2794c854398f4d05934157e05e2fe419",
//"camera": "rtmp://va0a19f55.live.126.net/live/0ca7943afaa340c9a7c1a8baa5afac97",
//"teacher_name": "王志成",
//"course_id": "55"

@property(nonatomic,strong) NSString *classID;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *status ;
@property(nonatomic,strong) NSString *class_date ;
@property(nonatomic,strong) NSString *live_time ;
@property(nonatomic,strong) NSString *course_name ;
@property(nonatomic,strong) NSString *course_publicize ;
@property(nonatomic,strong) NSString *subject;
@property(nonatomic,strong) NSString *grade ;
@property(nonatomic,strong) NSString *pull_address ;
@property(nonatomic,strong) NSString *board_pull_stream ;
@property(nonatomic,strong) NSString *camera_pull_stream ;
@property(nonatomic,strong) NSString *chat_team_id ;
@property(nonatomic,strong) NSString *board ;
@property(nonatomic,strong) NSString *camera ;
@property(nonatomic,strong) NSString *teacher_name ;
@property(nonatomic,strong) NSString *course_id ;

@property (nonatomic, assign) BOOL replayable;
@property (nonatomic, assign) NSInteger left_replay_times ;



@property (nonatomic, strong) NSString  *modal_type;
@property (nonatomic, strong) NSString *lesson_name ;




@end
