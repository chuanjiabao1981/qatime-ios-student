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

//"class_date": "2017-03-22",
//"live_time": "09:00-10:00",
//"objective": null,
//"suit_crowd": null,

@property(nonatomic,copy) NSString *title ;
@property(nonatomic,assign) NSInteger index ;

@property(nonatomic,copy) NSString *classID ;
@property(nonatomic,copy) NSString *name ;
@property(nonatomic,copy) NSString *subject ;
@property(nonatomic,copy) NSString *grade ;
@property(nonatomic,copy) NSString *teacher_name ;
@property(nonatomic,copy) NSString *price ;
@property(nonatomic,copy) NSString *current_price ;
@property(nonatomic,copy) NSString *chat_team_id ;
@property(nonatomic,copy) NSString *chat_team_owner ;
@property(nonatomic,copy) NSString *buy_tickets_count ;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *preset_lesson_count ;
@property(nonatomic,copy) NSString *completed_lesson_count ;
@property(nonatomic,copy) NSString *completed_lessons_count ;
@property(nonatomic,copy) NSString *live_start_time ;
@property(nonatomic,copy) NSString *live_end_time ;
@property(nonatomic,copy) NSString *publicize ;

@property(nonatomic,copy) NSString *reason ;
@property(nonatomic,copy) NSString *logo_url ;

@property(nonatomic,copy) NSString *describe ;

/* 课程信息的富文本描述*/
@property(nonatomic,strong) NSMutableAttributedString *attributedDescribe ;

@property(nonatomic,copy) NSString *lesson_count ;

/* 观看回放的相关属性*/
@property(nonatomic,copy) NSString *replayable ;
@property(nonatomic,assign) NSInteger left_replay_times ;

//所有的标签
@property (nonatomic, strong) NSArray *tag_list ;

//两个推荐标签
@property (nonatomic, copy) NSString *tag_one ;
@property (nonatomic, copy) NSString *tag_two ;

//直播时间
@property (nonatomic, copy) NSString *class_date ;
@property (nonatomic, copy) NSString *live_time ;

//课程目标
@property (nonatomic, copy) NSString *objective ;

//适宜人群
@property (nonatomic, copy) NSString *suit_crowd ;


/**
 首页精品课程属性
 */
@property (nonatomic, copy) NSString *target_type ;


/** 课程名 */
@property (nonatomic, copy) NSString *className ;


@end
