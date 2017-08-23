//
//  InteractionReplayLesson.h
//  Qatime_Student
//
//  Created by Shin on 2017/8/23.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InteractionReplayLesson : NSObject

//"id": "11676885",
//"duration": 0,
//"format": "mp4",
//"url": "http://voda3anduia.vod.126.net/voda3anduia/Z3vBvnM6_11676885_sd.mp4",
//"hd_url": "http://voda3anduia.vod.126.net/voda3anduia/qcoolXIO_11676885_hd.mp4",
//"shd_url": "http://voda3anduia.vod.126.net/voda3anduia/Hos7wqIM_11676885_shd.mp4",
//"orig_url": "http://voda3anduia.vod.126.net/voda3anduia/0-192389814744961-mix.flv"

@property (nonatomic, copy) NSString *videoID ;
@property (nonatomic, copy) NSString *duration ;
@property (nonatomic, copy) NSString *format ;
@property (nonatomic, copy) NSString *url ;
@property (nonatomic, copy) NSString *hd_url ;
@property (nonatomic, copy) NSString *shd_url ;
@property (nonatomic, copy) NSString *orig_url ;

@property (nonatomic, copy) NSString *name ;

@property (nonatomic, assign) BOOL isSelected ;


@end
