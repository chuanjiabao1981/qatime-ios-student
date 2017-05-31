//
//  Interactive.h
//  Qatime_Student
//
//  Created by Shin on 2017/5/31.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InteractiveCourse.h"

@interface Interactive : NSObject

@property (nonatomic, strong) NSString *classID ;
@property (nonatomic, strong) NSString *used_count ;
@property (nonatomic, strong) NSString *buy_count ;
@property (nonatomic, strong) NSString *lesson_price ;
@property (nonatomic, strong) NSString *status ;
@property (nonatomic, strong) InteractiveCourse *interactive_course ;


//"id": 719,
//"used_count": 0,
//"buy_count": 10,
//"lesson_price": "9.1",
//"status": "active",
//"interactive_course": {
//    "id": 18,
//    "name": "安卓测试",
//    "subject": "数学",
//    "grade": "高三",
//    "price": "91.0",
//    "status": "teaching",
//    "description": "<p>安卓测试<br></p>",
//    "lessons_count": 10,
//    "completed_lessons_count": 3,
//    "closed_lessons_count": 3,
//    "started_lessons_count": 4,
//    "live_start_time": "2017-05-19 10:50",
//    "live_end_time": "2017-05-28 15:30",
//    "objective": "安卓测试",
//    "suit_crowd": "安卓测试",
//    "teacher_percentage": 50,
//    "teachers": [
//                 {
//                     "id": 2875,
//                     "name": "解",
//                     "nick_name": "数学老师",
//                     "avatar_url": "http://qatime-testing.oss-cn-beijing.aliyuncs.com/avatars/cec5bef74f3bc73b6f307341db4938c3.jpg",
//                     "ex_big_avatar_url": "http://qatime-testing.oss-cn-beijing.aliyuncs.com/avatars/ex_big_cec5bef74f3bc73b6f307341db4938c3.jpg",
//                     "login_mobile": "18600694947",
//                     "email": null,
//                     "teaching_years": "within_three_years",
//                     "category": "高中",
//                     "subject": "数学",
//                     "grade_range": [],
//                     "gender": "male",
//                     "birthday": null,
//                     "province": null,
//                     "city": null,
//                     "school": null,
//                     "school_id": null,
//                     "desc": ""
//                 }
//                 ],
//    "publicize": {
//        "info_url": "http://testing.qatime.cn/assets/interactive_courses/info_default-78ca8de43176a587815a93e6eeb6a1d7.png",
//        "list_url": "http://testing.qatime.cn/assets/interactive_courses/list_default-a8c48d575db6899ee0af76dc21a3fddb.png"
//    },
//    "icons": {
//        "refund_any_time": true,
//        "coupon_free": true,
//        "cheap_moment": false
//    },
//    "off_shelve": true
//}
//},


@end
