//
//  ReplayLessonInfo.h
//  Qatime_Student
//
//  Created by Shin on 2017/6/23.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReplayLesson.h"
#import "Teacher.h"

@interface ReplayLessonInfo : NSObject

@property (nonatomic, strong) NSString *classID ;
@property (nonatomic, strong) NSString *title ;
@property (nonatomic, strong) NSString *index ;
@property (nonatomic, strong) NSString *type ;
@property (nonatomic, strong) NSString *logo_url ;
@property (nonatomic, assign) BOOL top ;
@property (nonatomic, strong) NSString *replay_times ;
@property (nonatomic, strong) NSString *updated_at ;
@property (nonatomic, strong) NSString *target_type ;
@property (nonatomic, strong) NSString *target_id ;
@property (nonatomic, strong) Live_studio_lesson *live_studio_lesson ;
@property (nonatomic, strong) NSString *grade ;
@property (nonatomic, strong) NSString *subject ;
@property (nonatomic, strong) NSString *teacher_name ;
@property (nonatomic, strong) Teacher *teacher ;
@property (nonatomic, strong) NSString *video_duration ;
@property (nonatomic, strong) NSString *video_url ;

@end
