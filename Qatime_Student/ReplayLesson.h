//
//  ReplayLesson.h
//  Qatime_Student
//
//  Created by Shin on 2017/6/21.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Live_studio_lesson : NSObject

@property (nonatomic, strong) NSString *classID ;
@property (nonatomic, strong) NSString *name ;
@property (nonatomic, strong) NSString *status ;
@property (nonatomic, strong) NSString *class_date ;
@property (nonatomic, strong) NSString *live_time ;
@property (nonatomic, strong) NSString *board_pull_stream;
@property (nonatomic, strong) NSString *camera_pull_stream ;
@property (nonatomic, assign) BOOL replayable ;
@property (nonatomic, strong) NSString *left_replay_times ;
@property (nonatomic, strong) NSString *modal_type ;




@end

@interface ReplayLesson : NSObject

@property (nonatomic, strong) NSString *classID ;
@property (nonatomic, strong) NSString *title ;
@property (nonatomic, strong) NSString *index ;
@property (nonatomic, strong) NSString *type ;
@property (nonatomic, strong) NSURL *logo_url ;
@property (nonatomic, assign) BOOL top ;
@property (nonatomic, strong) NSString *replay_times ;
@property (nonatomic, strong) NSString *updated_at ;
@property (nonatomic, strong) NSString *target_type ;
@property (nonatomic, strong) NSString *target_id ;
@property (nonatomic, strong) Live_studio_lesson *live_studio_lesson;
@property (nonatomic, strong) NSString *grade ;
@property (nonatomic, strong) NSString *subject ;
@property (nonatomic, strong) NSString *teacher_name ;
@property (nonatomic, strong) NSString *video_duration ;
@property (nonatomic, strong) NSString *video_url ;

@end


