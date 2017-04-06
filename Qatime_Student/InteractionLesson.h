//
//  InteractionLesson.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/1.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Teacher.h"

@interface InteractionLesson : NSObject
//"id": 1,
//"name": "来个一对一",
//"class_date": "2017-04-01",
//"start_time": "18:00",
//"end_time": "18:45",
//"status": "ready",
//"teacher": {
//    "id": 541,
//    "name": "教师",
//    "nick_name": "春意盎然",
//    "avatar_url": "http://qatime-testing.oss-cn-beijing.aliyuncs.com/avatars/ed8858f5ed860b8e94226f37446b89c1.jpg",
//    "ex_big_avatar_url": "http://qatime-testing.oss-cn-beijing.aliyuncs.com/avatars/ex_big_ed8858f5ed860b8e94226f37446b89c1.jpg",
//    "login_mobile": null,
//    "email": "qatime@8.cn",
//    "teaching_years": "within_three_years",
//    "category": "高中",
//    "subject": "数学",
//    "grade_range": [],
//    "gender": null,
//    "birthday": null,
//    "province": 1,
//    "city": 1,
//    "school": 1,
//    "desc": ""
//}

@property (nonatomic, strong) NSString *classID ;
@property (nonatomic, strong) NSString *name ;
@property (nonatomic, strong) NSString *class_date ;
@property (nonatomic, strong) NSString *start_time ;
@property (nonatomic, strong) NSString *end_time ;
@property (nonatomic, strong) NSString *status ;

@property (nonatomic, strong) Teacher *teacher ;



@end
