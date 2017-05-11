//
//  MyVideoClassList.h
//  Qatime_Student
//
//  Created by Shin on 2017/5/11.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  Video_course: NSObject
@property (nonatomic, strong) NSString *classID ;
@property (nonatomic, strong) NSString *name ;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *grade ;
@property (nonatomic, strong) NSString *teacher_name ;

@end

@interface MyVideoClassList : NSObject
//{
//    "id": 686,
//    "used_count": 0,
//    "buy_count": 1,
//    "lesson_price": "50.0",
//    "video_course": {
//        "id": 11,
//        "name": "数学",
//        "subject": "数学",
//        "grade": "六年级",
//        "teacher_name": "张莉"
//    },
//    "status": "active"
//},

@property (nonatomic, strong) NSString *numID ;
@property (nonatomic, assign) NSInteger used_count ;
@property (nonatomic, assign) NSInteger buy_count ;
@property (nonatomic, strong) NSString *lesson_price ;
@property (nonatomic, strong) Video_course *video_course ;
@property (nonatomic, strong) NSString *status ;


@end
