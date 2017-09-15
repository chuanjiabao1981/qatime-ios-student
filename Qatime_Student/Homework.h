//
//  Homework.h
//  Qatime_Teacher
//
//  Created by Shin on 2017/9/11.
//  Copyright © 2017年 Shin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Homework : NSObject
@property (nonatomic, strong) NSString *homeworkID ;
@property (nonatomic, strong) NSString *title ;
@property (nonatomic, strong) NSString *parent_id ;
@property (nonatomic, strong) NSString *status ;
@property (nonatomic, strong) NSString *user_id ;
@property (nonatomic, strong) NSString *user_name ;
@property (nonatomic, strong) NSString *created_at ;
@property (nonatomic, strong) NSArray *items ;
@property (nonatomic, strong) NSString *model_name ;
@end
