//
//  TodayLive.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodayLive : NSObject

@property (nonatomic, copy) NSString *classID ;
@property (nonatomic, copy) NSString *name ;
@property (nonatomic, strong) NSString *grade ;
@property (nonatomic, strong) NSString *subject ;
@property (nonatomic, strong) NSString *status ;
@property (nonatomic, strong) NSDictionary *publicizes ;
@property (nonatomic, strong) NSString *course_id ;
@property (nonatomic, strong) NSString *course_name ;
@property (nonatomic, strong) NSString *model_name ;
@property (nonatomic, strong) NSString *live_time ;


@end
