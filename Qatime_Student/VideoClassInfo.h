//
//  VideoClassInfo.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/11.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VideoClassInfo : NSObject

//调试数据
@property (nonatomic, strong) NSString *classID;
@property (nonatomic, strong) NSString *name ;
@property (nonatomic, strong) NSString *subject ;
@property (nonatomic, strong) NSString *grade ;
@property (nonatomic, strong) NSString *teacher_name ;
@property (nonatomic, strong) NSString *price ;
@property (nonatomic, strong) NSString *current_price ;
@property (nonatomic, strong) NSString *chat_team_id;
@property (nonatomic, strong) NSString *chat_team_owner ;
@property (nonatomic, strong) NSString *buy_tickets_count ;
@property (nonatomic, strong) NSString *status ;
@property (nonatomic, strong) NSString *description ;
@property (nonatomic, strong) NSString *tag_list ;
@property (nonatomic, strong) NSString *lesson_count ;
@property (nonatomic, strong) NSString *lessons_count ;
@property (nonatomic, strong) NSString *completed_lesson_count ;
@property (nonatomic, strong) NSString *taste_count ;
@property (nonatomic, strong) NSString *completed_lessons_count ;
@property (nonatomic, strong) NSString *closed_lessons_count ;
@property (nonatomic, strong) NSString *live_start_time ;
@property (nonatomic, strong) NSString *live_end_time ;
@property (nonatomic, strong) NSString *objective ;
@property (nonatomic, strong) NSString *suit_crowd ;
@property (nonatomic, strong) NSString *publicize ;
@property (nonatomic, strong) NSArray *lessons ;
@property (nonatomic, strong) NSString *chat_team ;
@property (nonatomic, strong) NSString *pull_address ;
@property (nonatomic, strong) NSString *board_pull_stream ;
@property (nonatomic, strong) NSString *camera_pull_stream ;
@property (nonatomic, strong) NSString *preview_time ;
@property (nonatomic, strong) NSDictionary *teacher ;
@property (nonatomic, assign) BOOL is_tasting ;
@property (nonatomic, assign) BOOL is_bought ;
@property (nonatomic, assign) BOOL tasted ;
@property (nonatomic, strong) NSString *current_lesson_name ;





@end
