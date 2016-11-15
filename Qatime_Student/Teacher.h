//
//  Teacher.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/15.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Chat_Account.h"

@interface Teacher : NSObject

//"id": 584,
//"name": "马燕兆",
//"nick_name": "马老师1",
//"avatar_url":
//"ex_big_avatar_url":
//"login_mobile":
//"email":
//"chat_account": {
//    "user_id": 584,
//    "accid": "8b8dac47fc743ebc7d163bd360caaafb",
//    "token": "d5559c6a388e2a0b91684223711f4c1e",
//    "name": "马老师1",
//    "icon": "http://qatime-testing.oss-cn-beijing.aliyuncs.com/avatars/small_14c4a876183d7886ca8684a1650fa785.png"
//},
//"teaching_years": "within_twenty_years",
//"category": "初中",
//"subject": "数学",
//"grade_range": ["初一","初二","初三",],
//"gender": "female",
//"birthday": null,
//"province": 1,
//"city": 1,
//"school": 9,
//"desc": ""
//}
@property(nonatomic,strong) NSString *teacherID ;
@property(nonatomic,strong) NSString *name ;
@property(nonatomic,strong) NSString *nick_name ;
@property(nonatomic,strong) NSString *avatar_url ;
@property(nonatomic,strong) NSString *login_mobile ;
@property(nonatomic,strong) NSString *email ;
@property(nonatomic,strong) NSDictionary *chat_account ;
@property(nonatomic,strong) NSString * teaching_years;
@property(nonatomic,strong) NSString *category ;
@property(nonatomic,strong) NSString *subject ;
@property(nonatomic,strong) NSMutableArray *grade_range ;
@property(nonatomic,strong) NSString *gender ;
@property(nonatomic,strong) NSString *birthday ;
@property(nonatomic,strong) NSString *province ;
@property(nonatomic,strong) NSString *city ;
@property(nonatomic,strong) NSString *school ;
@property(nonatomic,strong) NSString *desc ;




@end
