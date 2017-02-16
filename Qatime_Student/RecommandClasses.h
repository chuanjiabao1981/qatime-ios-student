//
//  RecommandClasses.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/9.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommandClasses : NSObject

//"id": 38,
//"name": "初三化学秋季精品高分班",
//"subject": "化学",
//"grade": "初三",
//"teacher_name": "赵雪琴",
//"price": 760,
//"chat_team_id": "7965148",
//"buy_tickets_count": 0,
//"preset_lesson_count": 4,
//"completed_lesson_count": 0,
//"live_start_time": "2016-09-03 09:30",
//"live_end_time": "2016-09-11 11:00",
//"publicize": "http://qatime-testing.oss-cn-beijing.aliyuncs.com/courses/publicize/list_d67ff91843999033d8ce1d08ca13aa8b.jpg"

@property(nonatomic,strong) NSString *title ;
@property(nonatomic,assign) NSInteger index ;

@property(nonatomic,strong) NSString *classID ;
@property(nonatomic,strong) NSString *name ;
@property(nonatomic,strong) NSString *subject ;
@property(nonatomic,strong) NSString *grade ;
@property(nonatomic,strong) NSString *teacher_name ;
@property(nonatomic,strong) NSString *price ;
@property(nonatomic,strong) NSString *current_price ;
@property(nonatomic,strong) NSString *chat_team_id ;
@property(nonatomic,strong) NSString *chat_team_owner ;
@property(nonatomic,strong) NSString *buy_tickets_count ;
@property(nonatomic,strong) NSString *status;
@property(nonatomic,strong) NSString *preset_lesson_count ;
@property(nonatomic,strong) NSString *completed_lesson_count ;
@property(nonatomic,strong) NSString *completed_lessons_count ;
@property(nonatomic,strong) NSString *live_start_time ;
@property(nonatomic,strong) NSString *live_end_time ;
@property(nonatomic,strong) NSString *publicize ;

@property(nonatomic,strong) NSString *reason ;
@property(nonatomic,strong) NSString *logo_url ;

@property(nonatomic,strong) NSString *describe ;
/* 课程信息的富文本描述*/
@property(nonatomic,strong) NSMutableAttributedString *attributedDescribe ;

@property(nonatomic,strong) NSString *lesson_count ;

/* 观看回放的相关属性*/
@property(nonatomic,strong) NSString *replayable ;
@property(nonatomic,assign) NSInteger left_replay_times ;





@end
