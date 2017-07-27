//
//  ExclusiveInfo.h
//  Qatime_Student
//
//  Created by Shin on 2017/7/27.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Teacher.h"

@interface ExclusiveInfo : NSObject

@property (nonatomic, strong) NSString *classID ;
@property (nonatomic, strong) NSString *name ;
@property (nonatomic, strong) NSDictionary *publicizes_url ;
@property (nonatomic, strong) NSString *subject ;
@property (nonatomic, strong) NSString *grade ;
@property (nonatomic, strong) NSString *status ;
@property (nonatomic, strong) NSString *teacher_name ;
@property (nonatomic, strong) NSString *price ;
@property (nonatomic, strong) NSString *current_price ;
@property (nonatomic, strong) NSString *view_tickets_count ;
@property (nonatomic, strong) NSString *events_count ;
@property (nonatomic, strong) NSString *closed_events_count ;
@property (nonatomic, strong) NSString *start_at ;
@property (nonatomic, strong) NSString *end_at ;
@property (nonatomic, strong) NSString *objective ;
@property (nonatomic, strong) NSString *suit_crowd ;
@property (nonatomic, strong) NSString *descriptions ;
@property (nonatomic, strong) Teacher *teacher ;
@property (nonatomic, strong) NSDictionary *icons ;
@property (nonatomic, strong) NSDictionary *offline_lessons ;
@property (nonatomic, strong) NSDictionary *scheduled_lessons ;



@end
