//
//  ExclusiveLesson.h
//  Qatime_Student
//
//  Created by Shin on 2017/7/27.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExclusiveLesson : NSObject

@property (nonatomic, strong) NSString *lessonId ;
@property (nonatomic, strong) NSString *name ;
@property (nonatomic, strong) NSString *class_date ;
@property (nonatomic, strong) NSString *start_time ;
@property (nonatomic, strong) NSString *end_time ;
@property (nonatomic, strong) NSString *status ;
@property (nonatomic, strong) NSString *class_address ;

@end
