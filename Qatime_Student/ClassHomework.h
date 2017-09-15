//
//  ClassHomework.h
//  Qatime_Teacher
//
//  Created by Shin on 2017/9/8.
//  Copyright © 2017年 Shin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassHomework : NSObject


@property (nonatomic, copy) NSString *homeworkID ;
@property (nonatomic, copy) NSString *title ;
@property (nonatomic, copy) NSString *parent_id ;
@property (nonatomic, copy) NSString *status ;
@property (nonatomic, copy) NSString *user_id ;
@property (nonatomic, copy) NSString *user_name ;
@property (nonatomic, copy) NSString *created_at ;
@property (nonatomic, copy) NSArray *items ;
@property (nonatomic, copy) NSString *model_name ;


@end
