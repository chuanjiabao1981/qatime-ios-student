//
//  Video.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject
//"id": 7767,
//"token": "1492157139451",
//"video_type": "mp4",
//"duration": 2,
//"tmp_duration": 2,
//"format_tmp_duration": "00:00:02",
//"capture": "http://qatime-te

@property (nonatomic, strong) NSString *classID ;
@property (nonatomic, strong) NSString *token ;
@property (nonatomic, strong) NSString *video_type ;
@property (nonatomic, strong) NSString *duration ;
@property (nonatomic, strong) NSString *tmp_duration ;
@property (nonatomic, strong) NSString *format_tmp_duration ;
@property (nonatomic, strong) NSString *capture ;

@end
