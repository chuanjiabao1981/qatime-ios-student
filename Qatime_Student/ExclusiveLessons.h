//
//  ExclusiveLessons.h
//  Qatime_Student
//
//  Created by Shin on 2017/7/26.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExclusiveLessons : NSObject
//"id": 478,
//"name": "课程一",
//"status": "completed",
//"course_id": 138,
//"real_time": 2494,
//"pos": 0,
//"class_date": "2017-07-07",
//"live_time": "19:00-19:30",
//"replayable": true,
//"left_replay_times": 10

@property (nonatomic, strong) NSString *lessonID ;
@property (nonatomic, strong) NSString *name ;
@property (nonatomic, strong) NSString *status ;
@property (nonatomic, strong) NSString *course_id ;
@property (nonatomic, strong) NSString *real_time ;
@property (nonatomic, strong) NSString *pos ;
@property (nonatomic, strong) NSString *class_date ;
@property (nonatomic, strong) NSString *live_time ;
@property (nonatomic, assign) BOOL replayable ;
@property (nonatomic, strong) NSString *left_replay_times ;



@end
