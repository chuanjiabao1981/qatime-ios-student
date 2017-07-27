//
//  MyTutoriumModel.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyTutoriumModel : NSObject

/* model所包含的内容 及项目*/

@property(nonatomic,strong) NSString *classID ;
@property(nonatomic,strong) NSString *name ;
@property(nonatomic,strong) NSString *subject ;
@property(nonatomic,strong) NSString *grade ;
@property(nonatomic,strong) NSString *teacher_name ;
@property(nonatomic,strong) NSString *price ;
@property(nonatomic,strong) NSString *chat_team_id ;
@property(nonatomic,strong) NSString * buy_tickets_count ;
@property(nonatomic,strong) NSString *status ;
@property(nonatomic,strong) NSString * preset_lesson_count ;
@property(nonatomic,strong) NSString * completed_lesson_count ;
@property (nonatomic, strong) NSString *completed_lessons_count ;
@property (nonatomic, strong) NSString *closed_lessons_count ;
@property (nonatomic, strong) NSString *started_lessons_count ;
@property(nonatomic,strong) NSString * live_start_time ;
@property(nonatomic,strong) NSString * live_end_time ;
@property(nonatomic,strong) NSString * publicize ;
@property(nonatomic,strong) NSString * pull_address ;
@property(nonatomic,strong) NSString * board_pull_stream ;
@property(nonatomic,strong) NSString * camera_pull_stream ;
@property(nonatomic,strong) NSString * preview_time ;
@property(nonatomic,assign) BOOL is_tasting ;
@property(nonatomic,assign) BOOL is_bought ;
@property(nonatomic,assign) BOOL tasted ;

@property(nonatomic,strong) NSString *taste_count ;

@end
