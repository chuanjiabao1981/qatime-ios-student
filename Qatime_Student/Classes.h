//
//  Classes.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/15.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Classes : NSObject
//
//"id": 51,
//"name": "实际问题与一元一次方程",
//"status": "ready",
//"class_date": "2016-09-25",
//"live_time": "10:00~22:00",
//"board_pull_stream": "rtmp://va0a19f55.live.126.net/live/2794c854398f4d05934157e05e2fe419",
//"camera_pull_stream": null

@property(nonatomic,strong) NSString *classID;
@property(nonatomic,strong) NSString *name ;
@property(nonatomic,strong) NSString *status ;
@property(nonatomic,strong) NSString *class_date ;
@property(nonatomic,strong) NSString *live_time ;

@property(nonatomic,strong) NSString *board_pull_stream ;
@property(nonatomic,strong) NSString *camera_pull_stream ;
@property(nonatomic,assign) BOOL replayable ;
@property(nonatomic,assign) NSString *left_replay_times ;



@end
