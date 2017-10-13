//
//  Answers.h
//  Qatime_Student
//
//  Created by Shin on 2017/9/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Answers : NSObject

@property (nonatomic, strong) NSString *answerID ;
@property (nonatomic, strong) NSString *parent_id ;
@property (nonatomic, strong) NSString *status ;
@property (nonatomic, strong) NSString *user_id ;
@property (nonatomic, strong) NSString *user_name ;
@property (nonatomic, strong) NSString *course_id ;
@property (nonatomic, strong) NSString *course_name ;
@property (nonatomic, strong) NSString *course_model_name ;
@property (nonatomic, strong) NSString *created_at ;
@property (nonatomic, strong) NSString *model_name ;
@property (nonatomic, strong) NSString *body ;
@property (nonatomic, strong) NSDictionary *attachments ;

@end
