//
//  FreeCourse.h
//  Qatime_Student
//
//  Created by Shin on 2017/7/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//  免费课model

#import <Foundation/Foundation.h>

@interface FreeCourse : NSObject

@property (nonatomic, strong) NSString *product_type ;
@property (nonatomic, strong) NSString *classID ;
@property (nonatomic, strong) NSString *name ;
@property (nonatomic, strong) NSString *subject ;
@property (nonatomic, strong) NSString *grade ;
@property (nonatomic, strong) NSString *teacher_name ;
@property (nonatomic, strong) NSString *price ;
@property (nonatomic, strong) NSString *current_price ;
@property (nonatomic, strong) NSString *chat_team_id ;
@property (nonatomic, strong) NSString *chat_team_owner ;
@property (nonatomic, strong) NSString *buy_tickets_count ;
@property (nonatomic, strong) NSString *status ;
@property (nonatomic, strong) NSString *preset_lesson_count ;
@property (nonatomic, strong) NSString *completed_lesson_count ;
@property (nonatomic, strong) NSString *taste_count ;
@property (nonatomic, strong) NSString *completed_lessons_count ;
@property (nonatomic, strong) NSString *closed_lessons_count ;
@property (nonatomic, strong) NSString *started_lessons_count ;
@property (nonatomic, strong) NSString *live_start_time ;
@property (nonatomic, strong) NSString *live_end_time ;
@property (nonatomic, strong) NSString *objective ;
@property (nonatomic, strong) NSString *suit_crowd ;
@property (nonatomic, strong) NSString *teacher_percentage ;
@property (nonatomic, strong) NSString *publicize ;
@property (nonatomic, strong) NSDictionary *icons ;
@property (nonatomic, assign) BOOL off_shelve ;
@property (nonatomic, assign) BOOL taste_overflow ;
@property (nonatomic, assign) BOOL sell_type ;


@end
