//
//  TeachersPublic_Classes.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/10.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeachersPublic_Classes : NSObject

/* 教室公开页的教师课程*/

//"id": 20,
//"name": "小学数学",
//"grade": "六年级",
//"price": "0.0",
//"subject": "数学",
//"buy_tickets_count": 1,
//"publicize": "http://qatime-testing.oss-cn-beijing.aliyuncs.com/courses/publicize/list_57ba566b6e28f8c276b2a26423f929f4.jpg"

@property(nonatomic,strong) NSString *classID ;
@property(nonatomic,strong) NSString *name ;
@property(nonatomic,strong) NSString *grade ;
@property(nonatomic,strong) NSString *price ;
@property(nonatomic,strong) NSString *subject ;
@property(nonatomic,strong) NSString *buy_tickets_count ;
@property(nonatomic,strong) NSString *publicize ;





@end
