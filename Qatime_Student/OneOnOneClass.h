//
//  OneOnOneClass.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/31.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OneOnOneClass : NSObject
//"id": 2,
//"name": "创建10个课程要疯呀",
//"subject": "化学",
//"grade": "初二",
//"price": "500.0",
//"status": "published",
//"description": "<p>哈哈哈哈哈哈哈&nbsp;</p>",
//"lessons_count": 10,
//"completed_lessons_count": 0,
//"closed_lessons_count": 0,
//"live_start_time": "2017-04-01 18:00",
//"live_end_time": "2017-04-10 18:45",
//"objective": "漫无目的的走在大街上，哪里会有目标",
//"suit_crowd": "活到老，学到老，学习不分年龄",
//"publicize_url": "http://testing.qatime.cn/imgs/course_default.png",
//"publicize_info_url": "http://testing.qatime.cn/imgs/course_default.png",
//"publicize_list_url": "http://testing.qatime.cn/imgs/course_default.png",
//"publicize_app_url": "http://testing.qatime.cn/imgs/course_default.png",
//"chat_team": {
//    "announcement": null,
//    "team_announcements": [],
//    "accounts": []
//},
//"interactive_lessons": [
//                        {
//                            "id": 20,
//                            "name": "创建10个课程要疯呀",
//"class_date": "2017-04-02",
//"start_time": "18:00",
//"end_time": "18:45",
//                            "teacher": {
//                                "id": 541,
//                                "name": "教师",
//                                "nick_name": "春意盎然",
//                                "avatar_url": "http://qatime-testing.oss-cn-beijing.aliyuncs.com/avatars/ed8858f5ed860b8e94226f37446b89c1.jpg",
//                                "ex_big_avatar_url": "http://qatime-testing.oss-cn-beijing.aliyuncs.com/avatars/ex_big_ed8858f5ed860b8e94226f37446b89c1.jpg",
//                                "login_mobile": null,
//                                "email": "qatime@8.cn",
//                                "chat_account": {
//                                    "user_id": 541,
//                                    "accid": "cc08c626904c9bcbcb4dc2950de289f9",
//                                    "token": "f2b015303276a8afbc570f94267d546e",
//                                    "name": "春意盎然",
//                                    "icon": "http://qatime-testing.oss-cn-beijing.aliyuncs.com/avatars/small_ed8858f5ed860b8e94226f37446b89c1.jpg"
//                                },
//                                "openid": null,
//                                "teaching_years": "within_three_years",
//                                "category": "高中",
//                                "subject": "数学",
//                                "grade_range": [],
//                                "gender": null,
//                                "birthday": null,
//                                "province": 1,
//                                "city": 1,
//                                "school": 1,
//                                "desc": ""
//                            }
//                        },
//
//                        ],
//"created_at": 1490940558,
//"current_lesson_name": "创建10个课程要疯呀",
//"preview_time": 1490976000,
//"is_bought": false

@property (nonatomic, strong) NSString *classID ;
@property (nonatomic, strong) NSString *name ;
@property (nonatomic, strong) NSString *subject ;
@property (nonatomic, strong) NSString *grade ;
@property (nonatomic, strong) NSString *price ;
@property (nonatomic, strong) NSString *status ;
@property (nonatomic, strong) NSString *descriptions ;
@property (nonatomic, strong) NSMutableAttributedString *attributeDescriptions ;//多加一个的富文本属性
@property (nonatomic, strong) NSString *lessons_count ;
@property (nonatomic, strong) NSString *completed_lessons_count ;
@property (nonatomic, strong) NSString *closed_lessons_count ;
@property (nonatomic, strong) NSString *live_start_time ;
@property (nonatomic, strong) NSString *live_end_time ;
@property (nonatomic, strong) NSString *objective ;
@property (nonatomic, strong) NSString *suit_crowd ;
@property (nonatomic, strong) NSString *publicize_url ;
@property (nonatomic, strong) NSString *publicize_info_url;
@property (nonatomic, strong) NSString *publicize_list_url;
@property (nonatomic, strong) NSString *publicize_app_url ;
@property (nonatomic, strong) NSDictionary *chat_team ;
@property (nonatomic, strong) NSArray *interactive_lessons ;
@property (nonatomic, strong) NSArray *teachers ;
@property (nonatomic, strong) NSString *created_at ;
@property (nonatomic, strong) NSString *current_lesson_name ;
@property (nonatomic, strong) NSString *preview_time ;
@property (nonatomic, assign) BOOL is_bought ;

@property (nonatomic, strong) NSString *class_date ;
@property (nonatomic, strong) NSString *start_time ;
@property (nonatomic, strong) NSString *end_time ;



/**只有在一对一课程搜索时使用该属性*/
@property (nonatomic, strong) NSMutableString *teacherNameString ;

@end
