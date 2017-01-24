//
//  ClassesInfo_Time.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/9.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassesInfo_Time : NSObject

@property(nonatomic,strong) NSString *classID ;
@property(nonatomic,strong) NSString *name ;
@property(nonatomic,strong) NSString *status ;
@property(nonatomic,strong) NSString *class_date ;
@property(nonatomic,strong) NSString *live_time ;

@property(nonatomic,strong) NSString *board_pull_stream ;
@property(nonatomic,strong) NSString *camera_pull_stream ;
@property(nonatomic,assign) BOOL replayable ;
@property(nonatomic,assign) NSString *left_replay_times ;
@property(nonatomic,strong) NSString *replay ;

@end
