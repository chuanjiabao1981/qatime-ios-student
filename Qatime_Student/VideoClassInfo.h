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
@property (nonatomic, strong) NSString *descriptions ;
@property (nonatomic, strong) NSArray *tag_list ;
@property (nonatomic, strong) NSString *lesson_count ;
@property (nonatomic, strong) NSString *video_lessons_count ;
@property (nonatomic, strong) NSString *preset_lesson_count ;
@property (nonatomic, strong) NSString *completed_lesson_count ;
@property (nonatomic, strong) NSString *taste_count ;
@property (nonatomic, strong) NSString *completed_lessons_count ;
@property (nonatomic, strong) NSString *closed_lessons_count ;
@property (nonatomic, strong) NSString *objective ;
@property (nonatomic, strong) NSString *suit_crowd ;
@property (nonatomic, strong) NSString *publicize ;
@property (nonatomic, strong) NSArray *video_lessons ;
@property (nonatomic, strong) NSDictionary *chat_team ;
@property (nonatomic, strong) NSDictionary *teacher ;

@property (nonatomic, strong) NSString *sell_type ;
@property (nonatomic, strong) NSString *total_duration ;
@property (nonatomic, assign) BOOL is_tasting ;
@property (nonatomic, assign) BOOL is_bought ;
@property (nonatomic, assign) BOOL tastes ;

@property (nonatomic, strong) NSString *product_type ;


@end
