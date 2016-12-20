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

@property(nonatomic,strong) NSString *noticeID ;
@property(nonatomic,assign) BOOL read ;
@property(nonatomic,strong) NSString *action_name ;
@property(nonatomic,strong) NSString *notice_content ;
@property(nonatomic,strong) NSString *type ;
@property(nonatomic,strong) NSString *created_at ;

@end
