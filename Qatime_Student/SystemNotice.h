//
//  SystemNotice.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/20.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemNotice : NSObject

//"id": 32302,
//"read": false,
//"action_name": "start_for_student",
//"notice_content": "您的课程 \"第四节\" 将于12:00开始上课，请准时参加学习",
//"type": "live_studio/lesson",
//"created_at": "12月09日 01:00"
//"notificationable_id": 76,
//"link": "live_studio/course:76",


@property(nonatomic,strong) NSString *noticeID ;
@property(nonatomic,assign) BOOL read ;
@property(nonatomic,strong) NSString *action_name ;
@property(nonatomic,strong) NSMutableString *notice_content ;
@property(nonatomic,strong) NSString *notificationable_type ;
@property(nonatomic,strong) NSString *created_at ;

@property(nonatomic,strong) NSString *notificationable_id ;
@property(nonatomic,strong) NSString *link;

@end
