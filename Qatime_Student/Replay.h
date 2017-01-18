//
//  Replay.h
//  Qatime_Student
//
//  Created by Shin on 2017/1/18.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Replay : NSObject
//"id": 25,
//"name": "dds",
//"duration": null,
//"replayable": false,
//"user_playable": true,
//"user_play_times": 0,
//"left_replay_times": 10,
//"replay": null

@property(nonatomic,strong) NSString *classID ;
@property(nonatomic,strong) NSString *name ;
@property(nonatomic,strong) NSString *duration ;
@property(nonatomic,strong) NSString *replayable ;

@end
